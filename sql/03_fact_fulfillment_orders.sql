/*
===============================================================================
Model Name: fact_fulfillment_orders
Project: International E-Commerce Supply Chain & Fulfillment Optimization
Author: Elliot Levisse
Data Grain: 1 row per order_item_id
Objective: Track end-to-end fulfillment lead times, OTIF performance, 
           and monetize operational SLA failures (P&L impact).
===============================================================================
*/

WITH deduplicated_reviews AS (
    -- 1. Deduplicate reviews at order level: isolate the lowest rating to capture maximum churn risk
    SELECT 
        order_id,
        MIN(review_score) AS min_review_score
    FROM `eloquent-petal-505917-u0`.Olist.order_reviews_dataset
    GROUP BY order_id
)

SELECT
    -- Dimension Keys & Identifiers
    oi.order_id,
    oi.order_item_id,
    oi.seller_id,
    oi.product_id,
    o.customer_id,

    -- Order Lifecycle Timestamps
    o.order_purchase_timestamp,
    o.order_delivered_carrier_date,
    o.order_delivered_customer_date,
    o.order_estimated_delivery_date,

    -- Fulfillment Lead Time Decomposition (in decimal days)
    ROUND(TIMESTAMP_DIFF(o.order_delivered_carrier_date, o.order_purchase_timestamp, HOUR) / 24.0, 2) AS processing_time_days,
    ROUND(TIMESTAMP_DIFF(o.order_delivered_customer_date, o.order_delivered_carrier_date, HOUR) / 24.0, 2) AS transit_time_days,
    ROUND(TIMESTAMP_DIFF(o.order_delivered_customer_date, o.order_purchase_timestamp, HOUR) / 24.0, 2) AS total_lead_time_days,
    ROUND(TIMESTAMP_DIFF(o.order_estimated_delivery_date, o.order_delivered_customer_date, HOUR) / 24.0, 2) AS delivery_delta_days,

    -- Delivery Performance & OTIF (On-Time In-Full) Flags
    CASE 
        WHEN TIMESTAMP_DIFF(o.order_estimated_delivery_date, o.order_delivered_customer_date, HOUR) >= 0 THEN 1 
        ELSE 0 
    END AS is_on_time,
    
    CASE 
        WHEN o.order_status = 'delivered' THEN 1 
        ELSE 0 
    END AS is_in_full,
    
    CASE 
        WHEN TIMESTAMP_DIFF(o.order_estimated_delivery_date, o.order_delivered_customer_date, HOUR) >= 0 
         AND o.order_status = 'delivered' THEN 1 
        ELSE 0 
    END AS is_otif,

    -- Financial Impact Proxies (Cost of Poor Quality / P&L at Risk)
    -- SLA breach penalty: $15.00 per late order (Customer service handling + goodwill coupon)
    CASE 
        WHEN TIMESTAMP_DIFF(o.order_estimated_delivery_date, o.order_delivered_customer_date, HOUR) < 0 THEN 15.00 
        ELSE 0.00 
    END AS sla_breach_penalty_cost,
    
    -- Customer churn risk: $25.00 for orders combining delivery delay and severe rating (score <= 2)
    CASE 
        WHEN TIMESTAMP_DIFF(o.order_estimated_delivery_date, o.order_delivered_customer_date, HOUR) < 0 
         AND r.min_review_score <= 2 THEN 25.00 
        ELSE 0.00 
    END AS estimated_churn_cost,

    -- Pricing & Freight Economics
    oi.price,
    oi.freight_value,
    (oi.price + oi.freight_value) AS total_item_value,
    ROUND(SAFE_DIVIDE(oi.freight_value, (oi.price + oi.freight_value)), 4) AS freight_share_ratio,

    -- Geographic Shipping Corridors
    s.seller_state,
    c.customer_state,
    CASE 
        WHEN s.seller_state = c.customer_state THEN 'Intra-State' 
        ELSE 'Inter-State' 
    END AS shipping_corridor_type,

    -- Perceived Customer Quality
    r.min_review_score

FROM `eloquent-petal-505917-u0`.Olist.order_items AS oi
LEFT JOIN `eloquent-petal-505917-u0`.Olist.orders AS o 
    ON oi.order_id = o.order_id
LEFT JOIN `eloquent-petal-505917-u0`.Olist.seller_dataset AS s 
    ON oi.seller_id = s.seller_id
LEFT JOIN `eloquent-petal-505917-u0`.Olist.customer_database AS c 
    ON o.customer_id = c.customer_id
LEFT JOIN deduplicated_reviews AS r 
    ON oi.order_id = r.order_id

-- Scope Lockdown: Analyze fully completed orders with complete fulfillment timestamps
WHERE o.order_status = 'delivered'
  AND o.order_delivered_carrier_date IS NOT NULL
  AND o.order_delivered_customer_date IS NOT NULL;
