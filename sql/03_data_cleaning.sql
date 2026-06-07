-- ============================================================
-- Retail Orders SQL Analysis
-- 03_data_cleaning.sql
--
-- Purpose:
-- Clean staging data, populate dimension tables, populate the
-- central fact table, and validate the dimensional model.
--
-- Phase:
-- Phase 2A — Data Cleaning and Dimensional Population
--
-- Source Tables:
-- - orders_raw
-- - product_supplier_raw
--
-- Target Tables:
-- - dim_customer_status
-- - dim_supplier
-- - dim_product
-- - fact_orders
-- ============================================================

USE retail_orders_sql_analysis;

-- ============================================================
-- Step 1: Clear Existing Target Tables
-- ============================================================
-- Clear fact table first because it depends on dimension tables.

DELETE FROM fact_orders;
DELETE FROM dim_product;
DELETE FROM dim_supplier;
DELETE FROM dim_customer_status;

-- ============================================================
-- Step 2: Populate dim_customer_status
-- ============================================================
-- Use fixed customer_status_id values for reproducible rebuilds.
--
-- Mapping:
-- 1 = Gold
-- 2 = Platinum
-- 3 = Silver

INSERT INTO dim_customer_status (
    customer_status_id,
    customer_status
)
VALUES
    (1, 'Gold'),
    (2, 'Platinum'),
    (3, 'Silver');

-- Validation:
-- Expected result: 3 rows

SELECT COUNT(*) AS dim_customer_status_count
FROM dim_customer_status;

SELECT *
FROM dim_customer_status
ORDER BY customer_status_id;

-- ============================================================
-- Step 3: Populate dim_supplier
-- ============================================================

INSERT INTO dim_supplier (
    supplier_id,
    supplier_name,
    supplier_country
)
SELECT DISTINCT
    supplier_id,
    supplier_name,
    supplier_country
FROM product_supplier_raw;

-- Validation:
-- Expected result: 64 rows

SELECT COUNT(*) AS dim_supplier_count
FROM dim_supplier;

SELECT *
FROM dim_supplier
ORDER BY supplier_id
LIMIT 10;

SELECT
    supplier_id,
    COUNT(*) AS occurrences
FROM dim_supplier
GROUP BY supplier_id
HAVING COUNT(*) > 1;

-- ============================================================
-- Step 4: Populate dim_product
-- ============================================================

INSERT INTO dim_product (
    product_id,
    product_line,
    product_category,
    product_group,
    product_name,
    supplier_id
)
SELECT DISTINCT
    product_id,
    product_line,
    product_category,
    product_group,
    product_name,
    supplier_id
FROM product_supplier_raw;

-- Validation:
-- Expected result: 5,504 rows

SELECT COUNT(*) AS dim_product_count
FROM dim_product;

SELECT *
FROM dim_product
ORDER BY product_id
LIMIT 10;

SELECT
    product_id,
    COUNT(*) AS occurrences
FROM dim_product
GROUP BY product_id
HAVING COUNT(*) > 1;

-- Foreign-key validation
SELECT COUNT(*) AS missing_suppliers
FROM dim_product p
LEFT JOIN dim_supplier s
    ON p.supplier_id = s.supplier_id
WHERE s.supplier_id IS NULL;

-- ============================================================
-- Step 5: Populate fact_orders
-- ============================================================

INSERT INTO fact_orders (
    order_id,
    customer_id,
    customer_status_id,
    product_id,
    order_date,
    delivery_date,
    delivery_days,
    quantity_ordered,
    revenue,
    cost_price_per_unit,
    estimated_cost,
    estimated_profit,
    gross_margin_pct
)
SELECT
    o.order_id,
    o.customer_id,
    cs.customer_status_id,
    o.product_id,
    STR_TO_DATE(o.order_date_raw, '%d-%b-%y') AS order_date,
    STR_TO_DATE(o.delivery_date_raw, '%d-%b-%y') AS delivery_date,
    DATEDIFF(
        STR_TO_DATE(o.delivery_date_raw, '%d-%b-%y'),
        STR_TO_DATE(o.order_date_raw, '%d-%b-%y')
    ) AS delivery_days,
    o.quantity_ordered,
    o.revenue,
    o.cost_price_per_unit,
    ROUND(o.quantity_ordered * o.cost_price_per_unit, 2) AS estimated_cost,
    ROUND(o.revenue - (o.quantity_ordered * o.cost_price_per_unit), 2) AS estimated_profit,
    CASE
        WHEN o.revenue = 0 THEN NULL
        ELSE ROUND(
            (o.revenue - (o.quantity_ordered * o.cost_price_per_unit)) / o.revenue,
            4
        )
    END AS gross_margin_pct
FROM orders_raw o
JOIN dim_customer_status cs
    ON cs.customer_status =
        CONCAT(
            UPPER(LEFT(LOWER(o.customer_status), 1)),
            SUBSTRING(LOWER(o.customer_status), 2)
        )
JOIN dim_product p
    ON o.product_id = p.product_id;

-- Validation:
-- Expected result: 185,013 rows

SELECT COUNT(*) AS fact_orders_count
FROM fact_orders;

-- ============================================================
-- Final Validation Checks
-- ============================================================

-- Row counts

SELECT COUNT(*) AS fact_orders_count
FROM fact_orders;

SELECT COUNT(*) AS dim_product_count
FROM dim_product;

SELECT COUNT(*) AS dim_supplier_count
FROM dim_supplier;

SELECT COUNT(*) AS dim_customer_status_count
FROM dim_customer_status;


-- Referential integrity

SELECT COUNT(*) AS missing_products
FROM fact_orders f
LEFT JOIN dim_product p
    ON f.product_id = p.product_id
WHERE p.product_id IS NULL;

SELECT COUNT(*) AS missing_customer_statuses
FROM fact_orders f
LEFT JOIN dim_customer_status cs
    ON f.customer_status_id = cs.customer_status_id
WHERE cs.customer_status_id IS NULL;

SELECT COUNT(*) AS missing_suppliers
FROM dim_product p
LEFT JOIN dim_supplier s
    ON p.supplier_id = s.supplier_id
WHERE s.supplier_id IS NULL;


-- Date validation

SELECT COUNT(*) AS null_order_dates
FROM fact_orders
WHERE order_date IS NULL;

SELECT COUNT(*) AS null_delivery_dates
FROM fact_orders
WHERE delivery_date IS NULL;

SELECT COUNT(*) AS negative_delivery_days
FROM fact_orders
WHERE delivery_days < 0;


-- Metric validation

SELECT
    MIN(revenue) AS min_revenue,
    MAX(revenue) AS max_revenue
FROM fact_orders;

SELECT
    MIN(estimated_cost) AS min_estimated_cost,
    MAX(estimated_cost) AS max_estimated_cost
FROM fact_orders;

SELECT
    MIN(estimated_profit) AS min_estimated_profit,
    MAX(estimated_profit) AS max_estimated_profit
FROM fact_orders;

-- ============================================================
-- Phase 2 Completion Summary
-- ============================================================
--
-- Validation Results:
--
-- dim_customer_status = 3 rows
-- dim_supplier = 64 rows
-- dim_product = 5,504 rows
-- fact_orders = 185,013 rows
--
-- Referential integrity checks passed.
-- Date validation checks passed.
-- Derived metric validation checks passed.
--
-- Phase 2A–2D completed successfully.
--
-- Ready for:
-- sql/04_analysis_queries.sql
--
-- ============================================================