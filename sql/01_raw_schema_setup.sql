-- ============================================================================= 
-- SCRIPT: 01_raw_schema_setup.sql
-- DESCRIPTION: DDL initialization for raw e-commerce ingestion layer in BigQuery
-- ARCHITECTURE LAYER: Raw / Staging Zone
-- =============================================================================

-- 1. Create Dataset / Schema
CREATE SCHEMA IF NOT EXISTS `supply_chain_raw`
OPTIONS (
  location = 'US',
  description = 'Raw ingestion layer for Olist Brazilian e-commerce logistics dataset'
);

-- -----------------------------------------------------------------------------
-- 2. Orders Raw Table
-- -----------------------------------------------------------------------------
CREATE OR REPLACE TABLE `supply_chain_raw.orders` (
  order_id                      STRING OPTIONS(description="Unique identifier of the order"),
  customer_id                   STRING OPTIONS(description="Key to customer dataset"),
  order_status                  STRING OPTIONS(description="Reference to order status (delivered, shipped, etc.)"),
  order_purchase_timestamp      TIMESTAMP OPTIONS(description="Timestamp when purchase occurred"),
  order_approved_at             TIMESTAMP OPTIONS(description="Timestamp of payment approval"),
  order_delivered_carrier_date  TIMESTAMP OPTIONS(description="Timestamp when parcel was handed to carrier"),
  order_delivered_customer_date TIMESTAMP OPTIONS(description="Timestamp when parcel reached the end customer"),
  order_estimated_delivery_date TIMESTAMP OPTIONS(description="Estimated delivery SLA promised to customer")
)
PARTITION BY DATE(order_purchase_timestamp)
CLUSTER BY order_status, customer_id;

-- -----------------------------------------------------------------------------
-- 3. Order Items Raw Table
-- -----------------------------------------------------------------------------
CREATE OR REPLACE TABLE `supply_chain_raw.order_items` (
  order_id            STRING OPTIONS(description="Order unique identifier"),
  order_item_id       INT64 OPTIONS(description="Sequential number identifying items in the same order"),
  product_id          STRING OPTIONS(description="Unique product identifier"),
  seller_id           STRING OPTIONS(description="Unique seller identifier"),
  shipping_limit_date TIMESTAMP OPTIONS(description="Seller handling deadline to hand over parcel to carrier"),
  price               NUMERIC OPTIONS(description="Item selling price"),
  freight_value       NUMERIC OPTIONS(description="Item freight shipping cost")
)
CLUSTER BY seller_id, product_id;

-- -----------------------------------------------------------------------------
-- 4. Sellers Raw Table
-- -----------------------------------------------------------------------------
CREATE OR REPLACE TABLE `supply_chain_raw.sellers` (
  seller_id               STRING OPTIONS(description="Unique seller identifier"),
  seller_zip_code_prefix  STRING OPTIONS(description="First 5 digits of seller zip code"),
  seller_city             STRING OPTIONS(description="Seller city name"),
  seller_state            STRING OPTIONS(description="Two-letter seller state code")
)
CLUSTER BY seller_state;

-- -----------------------------------------------------------------------------
-- 5. Customers Raw Table
-- -----------------------------------------------------------------------------
CREATE OR REPLACE TABLE `supply_chain_raw.customers` (
  customer_id               STRING OPTIONS(description="Unique customer identifier per order"),
  customer_unique_id        STRING OPTIONS(description="Unique identifier of the actual individual client"),
  customer_zip_code_prefix  STRING OPTIONS(description="First 5 digits of customer zip code"),
  customer_city             STRING OPTIONS(description="Customer city name"),
  customer_state            STRING OPTIONS(description="Two-letter customer state code")
)
CLUSTER BY customer_state;

-- -----------------------------------------------------------------------------
-- 6. Products Raw Table
-- -----------------------------------------------------------------------------
CREATE OR REPLACE TABLE `supply_chain_raw.products` (
  product_id                  STRING OPTIONS(description="Unique product identifier"),
  product_category_name       STRING OPTIONS(description="Root category name in Portuguese"),
  product_name_lenght         INT64 OPTIONS(description="Product title character count"),
  product_description_lenght  INT64 OPTIONS(description="Product description character count"),
  product_photos_qty          INT64 OPTIONS(description="Number of published photos"),
  product_weight_g            NUMERIC OPTIONS(description="Product weight in grams"),
  product_length_cm           NUMERIC OPTIONS(description="Product length in cm"),
  product_height_cm           NUMERIC OPTIONS(description="Product height in cm"),
  product_width_cm            NUMERIC OPTIONS(description="Product width in cm")
)
CLUSTER BY product_category_name;

-- -----------------------------------------------------------------------------
-- 7. Order Payments Raw Table
-- -----------------------------------------------------------------------------
CREATE OR REPLACE TABLE `supply_chain_raw.order_payments` (
  order_id              STRING OPTIONS(description="Order unique identifier"),
  payment_sequential    INT64 OPTIONS(description="Sequence index for multi-payment transactions"),
  payment_type          STRING OPTIONS(description="Method of payment (credit_card, boleto, voucher, debit_card)"),
  payment_installments  INT64 OPTIONS(description="Number of installments chosen by customer"),
  payment_value         NUMERIC OPTIONS(description="Transaction value paid")
)
CLUSTER BY payment_type;

-- -----------------------------------------------------------------------------
-- 8. Order Reviews Raw Table
-- -----------------------------------------------------------------------------
CREATE OR REPLACE TABLE `supply_chain_raw.order_reviews` (
  review_id               STRING OPTIONS(description="Unique review identifier"),
  order_id                STRING OPTIONS(description="Order unique identifier associated with the review"),
  review_score            INT64 OPTIONS(description="Customer satisfaction rating ranging from 1 to 5"),
  review_comment_title    STRING OPTIONS(description="Title of the review comment"),
  review_comment_message  STRING OPTIONS(description="Text content of the customer review"),
  review_creation_date    TIMESTAMP OPTIONS(description="Timestamp when the review invitation survey was sent"),
  review_answer_timestamp TIMESTAMP OPTIONS(description="Timestamp when customer submitted the review answer")
)
PARTITION BY DATE(review_answer_timestamp)
CLUSTER BY review_score, order_id;
