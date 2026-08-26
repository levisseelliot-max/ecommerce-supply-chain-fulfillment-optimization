-- =============================================================================
-- SCRIPT: 02_lead_time_transformation.sql
-- DESCRIPTION: Staging view & lead time decomposition logic for fulfillment pipeline
-- ARCHITECTURE LAYER: Staging / Intermediate Transformation Layer
-- AUTHOR: Supply Chain & Operations Analytics Practice
-- =============================================================================

CREATE OR REPLACE VIEW `supply_chain_staging.stg_order_lead_times` AS

WITH cleaned_orders AS (
  -- 1. Filter completed deliveries with valid lifecycle timestamps
  SELECT
    order_id,
    customer_id,
    order_status,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date
  FROM `supply_chain_raw.orders`
  WHERE order_status = 'delivered'
    AND order_purchase_timestamp IS NOT NULL
    AND order_delivered_carrier_date IS NOT NULL
    AND order_delivered_customer_date IS NOT NULL
    AND order_estimated_delivery_date IS NOT NULL
    -- Guardrail: ensure chronological sanity
    AND order_delivered_customer_date >= order_purchase_timestamp
),

order_geography AS (
  -- 2. Join customer and seller locations to establish freight corridors
  SELECT
    o.order_id,
    o.order_purchase_timestamp,
    o.order_delivered_carrier_date,
    o.order_delivered_customer_date,
    o.order_estimated_delivery_date,
    oi.order_item_id,
    oi.product_id,
    oi.seller_id,
    oi.shipping_limit_date,
    oi.price,
    oi.freight_value,
    s.seller_state,
    s.seller_city,
    c.customer_state,
    c.customer_city,
    -- Corridor classification logic
    CASE 
      WHEN s.seller_state = c.customer_state THEN 'Intra-State'
      ELSE 'Inter-State'
    END AS shipping_corridor_type
  FROM cleaned_orders o
  INNER JOIN `supply_chain_raw.order_items` oi
    ON o.order_id = oi.order_id
  LEFT JOIN `supply_chain_raw.sellers` s
    ON oi.seller_id = s.seller_id
  LEFT JOIN `supply_chain_raw.customers` c
    ON o.customer_id = c.customer_id
)

-- 3. Calculate operational lead time components and SLA variances
SELECT
  order_id,
  order_item_id,
  product_id,
  seller_id,
  seller_state,
  customer_state,
  shipping_corridor_type,
  order_purchase_timestamp,
  order_delivered_carrier_date,
  order_delivered_customer_date,
  order_estimated_delivery_date,
  shipping_limit_date,
  price,
  freight_value,

  -- Warehouse Handling / Dispatch Time (Order Purchase -> Carrier Handover)
  ROUND(TIMESTAMP_DIFF(order_delivered_carrier_date, order_purchase_timestamp, SECOND) / 86400.0, 4) AS processing_time_days,

  -- Middle & Last-Mile Carrier Transit Time (Carrier Handover -> Customer Delivery)
  ROUND(TIMESTAMP_DIFF(order_delivered_customer_date, order_delivered_carrier_date, SECOND) / 86400.0, 4) AS transit_time_days,

  -- End-to-End Total Fulfillment Lead Time (Order Purchase -> Customer Delivery)
  ROUND(TIMESTAMP_DIFF(order_delivered_customer_date, order_purchase_timestamp, SECOND) / 86400.0, 4) AS total_lead_time_days,

  -- Customer Promised Lead Time (Order Purchase -> Estimated Delivery SLA)
  ROUND(TIMESTAMP_DIFF(order_estimated_delivery_date, order_purchase_timestamp, SECOND) / 86400.0, 4) AS promised_lead_time_days,

  -- SLA Variance Delta (Positive value = Delayed delivery breach)
  ROUND(TIMESTAMP_DIFF(order_delivered_customer_date, order_estimated_delivery_date, SECOND) / 86400.0, 4) AS delivery_delay_days,

  -- Operational SLA Compliance Flags
  CASE 
    WHEN order_delivered_customer_date <= order_estimated_delivery_date THEN 1 
    ELSE 0 
  END AS is_delivered_on_time,

  CASE 
    WHEN order_delivered_carrier_date <= shipping_limit_date THEN 1 
    ELSE 0 
  END AS is_seller_dispatch_on_time

FROM order_geography;
