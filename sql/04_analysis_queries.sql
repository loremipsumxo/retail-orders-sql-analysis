-- ============================================================
-- Retail Orders SQL Analysis
-- 04_analysis_queries.sql
--
-- Purpose:
-- Develop analytical SQL queries using the validated dimensional
-- warehouse model.
--
-- Phase:
-- Phase 3 — Analytical SQL Query Development
--
-- Source Tables:
-- - fact_orders
-- - dim_customer_status
-- - dim_product
-- - dim_supplier
-- ============================================================

USE retail_orders_sql_analysis;

-- ============================================================
-- Section 1: Executive Summary KPIs
-- ============================================================

-- Total Revenue
-- Business question:
-- How much total revenue did the business generate?

SELECT
    ROUND(SUM(revenue), 2) AS total_revenue
FROM fact_orders;


-- Total Estimated Profit
-- Business question:
-- How much estimated profit did the business generate?

SELECT
    ROUND(SUM(estimated_profit), 2) AS total_estimated_profit
FROM fact_orders;


-- Total Orders
-- Business question:
-- How many orders were processed?

SELECT
    COUNT(*) AS total_orders
FROM fact_orders;


-- Unique Customers
-- Business question:
-- How many unique customers placed orders?

SELECT
    COUNT(DISTINCT customer_id) AS unique_customers
FROM fact_orders;


-- Average Revenue Per Order
-- Business question:
-- How much revenue does the average order generate?

SELECT
    ROUND(AVG(revenue), 2) AS avg_revenue_per_order
FROM fact_orders;


-- Average Profit Per Order
-- Business question:
-- How much estimated profit does the average order generate?

SELECT
    ROUND(AVG(estimated_profit), 2) AS avg_profit_per_order
FROM fact_orders;


-- Overall Profit Margin
-- Business question:
-- What percentage of revenue becomes profit?

SELECT
    ROUND(
        SUM(estimated_profit) / SUM(revenue) * 100,
        2
    ) AS overall_profit_margin_pct
FROM fact_orders;


-- ============================================================
-- Section 2: Customer Status Analysis
-- ============================================================

-- Revenue by Customer Status
-- Business question:
-- Which customer segment generates the most revenue?

SELECT
    cs.customer_status,
    ROUND(SUM(f.revenue), 2) AS total_revenue
FROM fact_orders f
JOIN dim_customer_status cs
    ON f.customer_status_id = cs.customer_status_id
GROUP BY cs.customer_status
ORDER BY total_revenue DESC;


-- Orders by Customer Status
-- Business question:
-- Which customer segment generates the most orders?

SELECT
    cs.customer_status,
    COUNT(*) AS total_orders
FROM fact_orders f
JOIN dim_customer_status cs
    ON f.customer_status_id = cs.customer_status_id
GROUP BY cs.customer_status
ORDER BY total_orders DESC;


-- Profit by Customer Status
-- Business question:
-- Which customer segment generates the most profit?

SELECT
    cs.customer_status,
    ROUND(SUM(f.estimated_profit), 2) AS total_profit
FROM fact_orders f
JOIN dim_customer_status cs
    ON f.customer_status_id = cs.customer_status_id
GROUP BY cs.customer_status
ORDER BY total_profit DESC;


-- Average Revenue Per Order by Customer Status
-- Business question:
-- Do customer segments spend differently per order?

SELECT
    cs.customer_status,
    ROUND(AVG(f.revenue), 2) AS avg_revenue_per_order
FROM fact_orders f
JOIN dim_customer_status cs
    ON f.customer_status_id = cs.customer_status_id
GROUP BY cs.customer_status
ORDER BY avg_revenue_per_order DESC;


-- Average Profit Per Order by Customer Status
-- Business question:
-- Do customer segments differ in profitability per order?

SELECT
    cs.customer_status,
    ROUND(AVG(f.estimated_profit), 2) AS avg_profit_per_order
FROM fact_orders f
JOIN dim_customer_status cs
    ON f.customer_status_id = cs.customer_status_id
GROUP BY cs.customer_status
ORDER BY avg_profit_per_order DESC;


-- ============================================================
-- Section 3: Product Category Analysis
-- ============================================================

-- Revenue by Product Category

SELECT
    p.product_category,
    ROUND(SUM(f.revenue), 2) AS total_revenue
FROM fact_orders f
JOIN dim_product p
    ON f.product_id = p.product_id
GROUP BY p.product_category
ORDER BY total_revenue DESC;

SELECT
    p.product_category,
    ROUND(SUM(f.estimated_profit), 2) AS total_profit
FROM fact_orders f
JOIN dim_product p
    ON f.product_id = p.product_id
GROUP BY p.product_category
ORDER BY total_profit DESC;

SELECT
    p.product_category,
    ROUND(
        SUM(f.estimated_profit) / SUM(f.revenue) * 100,
        2
    ) AS profit_margin_pct
FROM fact_orders f
JOIN dim_product p
    ON f.product_id = p.product_id
GROUP BY p.product_category
ORDER BY profit_margin_pct DESC;

SELECT
    s.supplier_name,
    ROUND(SUM(f.revenue), 2) AS total_revenue
FROM fact_orders f
JOIN dim_product p
    ON f.product_id = p.product_id
JOIN dim_supplier s
    ON p.supplier_id = s.supplier_id
GROUP BY s.supplier_name
ORDER BY total_revenue DESC
LIMIT 10;

SELECT
    s.supplier_name,
    ROUND(SUM(f.estimated_profit), 2) AS total_profit
FROM fact_orders f
JOIN dim_product p
    ON f.product_id = p.product_id
JOIN dim_supplier s
    ON p.supplier_id = s.supplier_id
GROUP BY s.supplier_name
ORDER BY total_profit DESC
LIMIT 10;

SELECT
    s.supplier_name,
    ROUND(
        SUM(f.estimated_profit) / SUM(f.revenue) * 100,
        2
    ) AS profit_margin_pct
FROM fact_orders f
JOIN dim_product p
    ON f.product_id = p.product_id
JOIN dim_supplier s
    ON p.supplier_id = s.supplier_id
GROUP BY s.supplier_name
ORDER BY profit_margin_pct DESC
LIMIT 10;

SELECT
    YEAR(order_date) AS order_year,
    ROUND(SUM(revenue), 2) AS total_revenue
FROM fact_orders
GROUP BY YEAR(order_date)
ORDER BY order_year;

SELECT
    YEAR(f.order_date) AS order_year,
    cs.customer_status,
    ROUND(SUM(f.revenue), 2) AS total_revenue
FROM fact_orders f
JOIN dim_customer_status cs
    ON f.customer_status_id = cs.customer_status_id
GROUP BY
    YEAR(f.order_date),
    cs.customer_status
ORDER BY
    order_year,
    total_revenue DESC;
    
SELECT
    YEAR(f.order_date) AS order_year,
    p.product_category,
    ROUND(SUM(f.revenue), 2) AS total_revenue
FROM fact_orders f
JOIN dim_product p
    ON f.product_id = p.product_id
GROUP BY
    YEAR(f.order_date),
    p.product_category
ORDER BY
    order_year,
    total_revenue DESC;

SELECT
    p.product_category,
    ROUND(SUM(f.revenue), 2) AS total_revenue
FROM fact_orders f
JOIN dim_product p
    ON f.product_id = p.product_id
GROUP BY p.product_category
ORDER BY total_revenue DESC;


-- ============================================================
-- Section 5: Product Category Trend Analysis
-- ============================================================

-- Revenue by Product Category and Year

SELECT
    YEAR(f.order_date) AS order_year,
    p.product_category,
    ROUND(SUM(f.revenue), 2) AS total_revenue
FROM fact_orders f
JOIN dim_product p
    ON f.product_id = p.product_id
GROUP BY
    YEAR(f.order_date),
    p.product_category
ORDER BY
    order_year,
    total_revenue DESC;


-- Year-over-Year Revenue Growth by Product Category
-- Business question:
-- Which product categories grew or declined compared with the previous year?

WITH category_yearly_revenue AS (
    SELECT
        YEAR(f.order_date) AS order_year,
        p.product_category,
        SUM(f.revenue) AS total_revenue
    FROM fact_orders f
    JOIN dim_product p
        ON f.product_id = p.product_id
    GROUP BY
        YEAR(f.order_date),
        p.product_category
),
category_growth AS (
    SELECT
        order_year,
        product_category,
        total_revenue,
        LAG(total_revenue) OVER (
            PARTITION BY product_category
            ORDER BY order_year
        ) AS previous_year_revenue
    FROM category_yearly_revenue
)
SELECT
    order_year,
    product_category,
    ROUND(total_revenue, 2) AS total_revenue,
    ROUND(previous_year_revenue, 2) AS previous_year_revenue,
    ROUND(total_revenue - previous_year_revenue, 2) AS revenue_change,
    ROUND(
        (total_revenue - previous_year_revenue) / previous_year_revenue * 100,
        2
    ) AS revenue_growth_pct
FROM category_growth
WHERE previous_year_revenue IS NOT NULL
ORDER BY
    order_year,
    revenue_growth_pct DESC;


-- ============================================================
-- Section 5: Product Category Trend Analysis
-- ============================================================

-- ============================================================
-- Product Category Profit Trends
-- ============================================================

SELECT
    YEAR(f.order_date) AS order_year,
    p.product_category,
    ROUND(SUM(f.revenue), 2) AS total_revenue,
    ROUND(SUM(f.estimated_profit), 2) AS total_profit
FROM fact_orders f
JOIN dim_product p
    ON f.product_id = p.product_id
GROUP BY
    YEAR(f.order_date),
    p.product_category
ORDER BY
    order_year,
    total_profit DESC;


-- ==========================================================
-- Section 6: Supplier Trend Analysis
-- ==========================================================

SELECT
    YEAR(f.order_date) AS order_year,
    s.supplier_name,
    ROUND(SUM(f.revenue), 2) AS total_revenue
FROM fact_orders f
JOIN dim_product p
    ON f.product_id = p.product_id
JOIN dim_supplier s
    ON p.supplier_id = s.supplier_id
GROUP BY
    YEAR(f.order_date),
    s.supplier_name
ORDER BY
    order_year,
    total_revenue DESC;


SELECT
    YEAR(f.order_date) AS order_year,
    s.supplier_name,
    ROUND(SUM(f.estimated_profit), 2) AS total_profit
FROM fact_orders f
JOIN dim_product p
    ON f.product_id = p.product_id
JOIN dim_supplier s
    ON p.supplier_id = s.supplier_id
GROUP BY
    YEAR(f.order_date),
    s.supplier_name
ORDER BY
    order_year,
    total_profit DESC;

SELECT
    s.supplier_name,
    ROUND(SUM(f.revenue), 2) AS total_revenue,
    ROUND(
        SUM(f.revenue) /
        (SELECT SUM(revenue) FROM fact_orders) * 100,
        2
    ) AS revenue_share_pct
FROM fact_orders f
JOIN dim_product p
    ON f.product_id = p.product_id
JOIN dim_supplier s
    ON p.supplier_id = s.supplier_id
GROUP BY
    s.supplier_name
ORDER BY
    total_revenue DESC;


SELECT
    s.supplier_name,
    ROUND(SUM(f.estimated_profit), 2) AS total_profit,
    ROUND(
        SUM(f.estimated_profit) /
        (SELECT SUM(estimated_profit) FROM fact_orders) * 100,
        2
    ) AS profit_share_pct
FROM fact_orders f
JOIN dim_product p
    ON f.product_id = p.product_id
JOIN dim_supplier s
    ON p.supplier_id = s.supplier_id
GROUP BY
    s.supplier_name
ORDER BY
    total_profit DESC;