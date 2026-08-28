# 📖 Supply Chain & Fulfillment KPI Data Dictionary

### *Business Logic, Technical Calculations, SLA Thresholds & Financial Attribution Proxies*

**Project:** International E-Commerce Supply Chain & Fulfillment Optimization

**Data Grain:** 1 row per `order_item_id` (aggregated to `order_id` for network KPIs)

**Standardized Unit of Time:** Decimal Days (`TIMESTAMP_DIFF(..., SECOND) / 86400.0`)

**Data Warehouse:** Google BigQuery

**Production Layer:** `FACT_fulfillment_orders`

---

## 1. Operational & Lead Time Metrics

### 1.1 Warehouse Processing Time — `processing_time_days`

**Business Definition:**
Operational latency elapsed between customer order placement and physical parcel handover to the carrier by the merchant depot.

**Calculation / Formula:**

Processing Time (Days) = (order_delivered_carrier_date − order_purchase_timestamp)/86400

**SQL Logic:**

```sql
ROUND(
  TIMESTAMP_DIFF(
    order_delivered_carrier_date,
    order_purchase_timestamp,
    SECOND
  ) / 86400.0,
  4
)
```

| Attribute                          |                             Value |
| ---------------------------------- | --------------------------------: |
| **Operational SLA Target**         |                       ≤ 2.00 days |
| **Baseline Average — Intra-State** |                         3.16 days |
| **Baseline Average — Inter-State** |                         3.32 days |
| **Ownership**                      | Merchant / Marketplace Operations |

---

### 1.2 Carrier Transit Time — `transit_time_days`

**Business Definition:**
Net middle-mile and last-mile transit duration from carrier pickup to final delivery scan at the customer's shipping address.

**Calculation / Formula:**

Transit Time (Days) = (order_delivered_customer_date − order_delivered_carrier_date) / 86400

**SQL Logic:**

```sql
ROUND(
  TIMESTAMP_DIFF(
    order_delivered_customer_date,
    order_delivered_carrier_date,
    SECOND
  ) / 86400.0,
  4
)
```

| Attribute                                |                               Value |
| ---------------------------------------- | ----------------------------------: |
| **Operational SLA Target — Intra-State** |                         ≤ 4.50 days |
| **Operational SLA Target — Inter-State** |                         ≤ 6.50 days |
| **Ownership**                            | 3PL Carriers / Logistics Operations |

---

### 1.3 Total Fulfillment Lead Time — `total_lead_time_days`

**Business Definition:**
End-to-end customer wait time from initial checkout timestamp to physical parcel receipt.

**Calculation / Formula:**

$$
\text{Total Lead Time}
=
\text{Processing Time}
+
\text{Transit Time}
$$

**SQL Logic:**

```sql
ROUND(
  TIMESTAMP_DIFF(
    order_delivered_customer_date,
    order_purchase_timestamp,
    SECOND
  ) / 86400.0,
  4
)
```

| Attribute                 |      Value |
| ------------------------- | ---------: |
| **Intra-State Benchmark** |  7.88 days |
| **Inter-State Benchmark** | 15.01 days |

---

### 1.4 Promised SLA Variance / Delivery Delta — `delivery_delta_days`

**Business Definition:**
Difference between the customer-facing estimated delivery promise and the actual delivery timestamp.

> **Interpretation:** Negative values indicate delayed fulfillment (SLA breach).

**Calculation / Formula:**

$$
\text{Delivery Delta}
=
\frac{
\text{order\_estimated\_delivery\_date}
-
\text{order\_delivered\_customer\_date}
}{
86400
}
$$

**SQL Logic:**

```sql
ROUND(
  TIMESTAMP_DIFF(
    order_estimated_delivery_date,
    order_delivered_customer_date,
    SECOND
  ) / 86400.0,
  4
)
```

**SLA Breach Condition:**

```text
delivery_delta_days < 0 → SLA Breach (Late Delivery)
```

---

## 2. Fulfillment Service Level & Quality Indicators

### 2.1 On-Time Delivery Rate — `is_on_time`

**Business Definition:**
Binary flag indicating whether the parcel arrived on or before the customer-facing SLA commitment date.

**SQL Logic:**

```sql
CASE
  WHEN order_delivered_customer_date <= order_estimated_delivery_date
    THEN 1
  ELSE 0
END
```

---

### 2.2 In-Full Completion Rate — `is_in_full`

**Business Definition:**
Binary flag indicating whether the complete order parcel reached terminal delivery status without loss or transit cancellation.

**SQL Logic:**

```sql
CASE
  WHEN order_status = 'delivered'
    THEN 1
  ELSE 0
END
```

---

### 2.3 On-Time In-Full Rate — `is_otif`

### ⭐ North Star Metric

**Business Definition:**
Proportion of total customer orders successfully delivered on or before the committed delivery date with completed delivery confirmation.

**Calculation / Formula:**

$$
\text{OTIF Rate (\%)}
=
\frac{
\sum \text{OTIF Orders}
}{
\text{Total Shipped Orders}
}
\times 100
$$

**SQL Logic:**

```sql
CASE
  WHEN order_delivered_customer_date <= order_estimated_delivery_date
    AND order_status = 'delivered'
    THEN 1
  ELSE 0
END
```

**Aggregation:**

```sql
AVG(is_otif) * 100
```

| Attribute             |                  Value |
| --------------------- | ---------------------: |
| **Enterprise Target** |               ≥ 96.50% |
| **Baseline**          |                 92.15% |
| **Gap to Target**     | 4.35 percentage points |

---

## 3. Financial Impact & P&L-at-Risk Proxies

> ⚠️ **Important:** These financial metrics are attribution proxies designed to estimate the economic impact of fulfillment performance. They should not be interpreted as directly observed accounting P&L unless validated against Finance-approved cost data.

### 3.1 Gross Merchandise Value — `GMV`

**Business Definition:**
Total cumulative commercial invoice value generated by sold merchandise, excluding freight shipping charges.

**SQL Logic:**

```sql
SUM(price)
```

| Attribute                  |          Value |
| -------------------------- | -------------: |
| **Baseline Aggregate GMV** | $13,221,498.73 |
| **Completed Orders**       |         96,469 |

---

### 3.2 Freight Share Ratio — `freight_share_ratio`

**Business Definition:**
Proportion of total customer basket cost consumed by logistics shipping fees.

**Calculation / Formula:**

$$
\text{Freight Share Ratio}
=
\frac{
\text{freight\_value}
}{
\text{price} + \text{freight\_value}
}
$$

**SQL Logic:**

```sql
ROUND(
  SAFE_DIVIDE(
    freight_value,
    price + freight_value
  ),
  4
)
```

---

### 3.3 SLA Breach Penalty Cost — `sla_breach_penalty_cost`

**Business Definition:**
Direct contractual compensation cost and customer-service operational overhead incurred for every delayed delivery.

**Unit Economic Proxy:**
**$15.00** flat penalty per late order (compensatory coupon + CS support ticket labor).

**SQL Logic:**

```sql
CASE
  WHEN order_delivered_customer_date > order_estimated_delivery_date
    THEN 15.00
  ELSE 0.00
END
```

---

### 3.4 Estimated Customer Churn Cost — `estimated_churn_cost`

**Business Definition:**
Attributed customer lifetime-value erosion for buyers experiencing an SLA delivery breach combined with severe service dissatisfaction.

**Unit Economic Proxy:**
**$25.00** churn-risk proxy applied strictly to delayed orders with an associated customer review rating ≤ 2/5.

**SQL Logic:**

```sql
CASE
  WHEN order_delivered_customer_date > order_estimated_delivery_date
    AND min_review_score <= 2
    THEN 25.00
  ELSE 0.00
END
```

---

### 3.5 Total P&L Margin at Risk — `total_pnl_at_risk`

**Business Definition:**
Cumulative operational margin leakage resulting from fulfillment failure, combining direct contract penalties and high-friction churn risk.

**Calculation / Formula:**

$$
\text{Total P\&L at Risk}
=
\sum
(
\text{sla\_breach\_penalty\_cost}
+
\text{estimated\_churn\_cost}
)
$$

| Attribute                                 |        Value |
| ----------------------------------------- | -----------: |
| **Baseline Exposure**                     |  $246,350.00 |
| **Inter-State Concentration**             |        75.4% |
| **9-Month Target**                        | < $95,000.00 |
| **Net Annualized Margin Recovery Target** |    +$151,350 |

---

## 4. Dimensional Classification & Segmentation Logic

### 4.1 Shipping Corridor Type — `shipping_corridor_type`

| Field Value     | Business Classification Rule                                                       |
| --------------- | ---------------------------------------------------------------------------------- |
| **Intra-State** | Merchant state matches customer destination state: `seller_state = customer_state` |
| **Inter-State** | Parcel crosses state borders: `seller_state != customer_state`                     |

---

### 4.2 Merchant SLA Tier — `merchant_sla_tier`

| SLA Tier                 |       OTIF Threshold | Business Treatment                                     |
| ------------------------ | -------------------: | ------------------------------------------------------ |
| **Compliant**            |              ≥ 95.0% | Eligible for Buy Box boost and commission rebates      |
| **Standard / Watchlist** | 90.0% ≤ OTIF < 95.0% | Standard monitoring                                    |
| **High Risk**            |              < 90.0% | Subject to catalog throttling and remediation protocol |

---

### 4.3 Minimum Review Score — `min_review_score`

**Business Definition:**
Deduplicated minimum customer review rating assigned to the order.

**Valid Range:** `1–5`

| Score | Interpretation    |
| ----: | ----------------- |
| **1** | Very dissatisfied |
| **2** | Dissatisfied      |
| **3** | Neutral           |
| **4** | Satisfied         |
| **5** | Very satisfied    |

---

## 5. KPI Governance & Data Quality

### 5.1 Metric Ownership

| KPI Category           | Primary Owner                     |
| ---------------------- | --------------------------------- |
| **Processing Time**    | Merchant / Marketplace Operations |
| **Transit Time**       | 3PL / Carrier Operations          |
| **OTIF**               | Supply Chain / Fulfillment        |
| **SLA Breaches**       | Marketplace Operations            |
| **Penalty Cost Proxy** | Finance / Operations              |
| **Churn Cost Proxy**   | Customer Experience / Finance     |
| **Merchant SLA Tier**  | Marketplace Operations            |

---

### 5.2 Data Quality Controls

The following controls should be applied before aggregating KPIs:

* Exclude records with missing or logically inconsistent timestamps.
* Ensure `order_delivered_customer_date >= order_purchase_timestamp`.
* Ensure `order_delivered_customer_date >= order_delivered_carrier_date`.
* Deduplicate order-level metrics when aggregating from `order_item_id` to `order_id`.
* Apply consistent order-status filtering across baseline calculations.
* Distinguish **observed financial values** from **economic proxy assumptions**.
* Validate financial proxy assumptions against Finance-approved business rules before using them for accounting or P&L reporting.

---

## 📌 KPI Summary

| KPI                       | Field                     | Primary Use                        |
| ------------------------- | ------------------------- | ---------------------------------- |
| Warehouse Processing Time | `processing_time_days`    | Merchant operational efficiency    |
| Carrier Transit Time      | `transit_time_days`       | Carrier / network performance      |
| Total Lead Time           | `total_lead_time_days`    | End-to-end fulfillment performance |
| Delivery Delta            | `delivery_delta_days`     | SLA compliance                     |
| On-Time Delivery          | `is_on_time`              | Delivery reliability               |
| In-Full Completion        | `is_in_full`              | Order completion                   |
| **OTIF**                  | `is_otif`                 | **North Star fulfillment KPI**     |
| GMV                       | `GMV`                     | Commercial value                   |
| Freight Share             | `freight_share_ratio`     | Logistics cost exposure            |
| SLA Breach Cost           | `sla_breach_penalty_cost` | Financial impact proxy             |
| Churn Cost                | `estimated_churn_cost`    | Customer-value risk proxy          |
| **P&L at Risk**           | `total_pnl_at_risk`       | **Financial exposure proxy**       |
| Shipping Corridor         | `shipping_corridor_type`  | Network segmentation               |
| Merchant SLA Tier         | `merchant_sla_tier`       | Seller segmentation                |
| Review Score              | `min_review_score`        | Customer dissatisfaction signal    |


