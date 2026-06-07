-- =====================================================
-- Retail Orders SQL Analysis
-- Analytical Views
-- =====================================================

USE retail_orders_sql_analysis;

-- Customer segment performance
CREATE OR REPLACE VIEW vw_customer_segment_summary AS
SELECT
    cs.customer_status,
    COUNT(*) AS total_orders,
    SUM(f.revenue) AS total_revenue,
    SUM(f.estimated_profit) AS total_profit,
    ROUND(AVG(f.revenue), 2) AS average_order_value
FROM fact_orders f
JOIN dim_customer_status cs
    ON f.customer_status_id = cs.customer_status_id
GROUP BY cs.customer_status;


-- Product category profitability
CREATE OR REPLACE VIEW vw_product_category_profitability AS
SELECT
    p.product_category,
    SUM(f.revenue) AS total_revenue,
    SUM(f.estimated_profit) AS total_profit,
    COUNT(*) AS total_orders,
    ROUND(
        SUM(f.estimated_profit) / NULLIF(SUM(f.revenue), 0) * 100,
        2
    ) AS gross_margin_pct
FROM fact_orders f
JOIN dim_product p
    ON f.product_id = p.product_id
GROUP BY p.product_category;


-- Supplier performance
CREATE OR REPLACE VIEW vw_supplier_performance AS
SELECT
    s.supplier_name,
    s.supplier_country,
    SUM(f.revenue) AS total_revenue,
    SUM(f.estimated_profit) AS total_profit,
    COUNT(*) AS total_orders,
    ROUND(
        SUM(f.estimated_profit) / NULLIF(SUM(f.revenue), 0) * 100,
        2
    ) AS gross_margin_pct
FROM fact_orders f
JOIN dim_product p
    ON f.product_id = p.product_id
JOIN dim_supplier s
    ON p.supplier_id = s.supplier_id
GROUP BY
    s.supplier_name,
    s.supplier_country;


-- Delivery performance by product category
CREATE OR REPLACE VIEW vw_delivery_performance_by_category AS
SELECT
    p.product_category,
    ROUND(AVG(f.delivery_days), 2) AS avg_delivery_days,
    MIN(f.delivery_days) AS fastest_delivery_days,
    MAX(f.delivery_days) AS slowest_delivery_days,
    COUNT(*) AS total_orders
FROM fact_orders f
JOIN dim_product p
    ON f.product_id = p.product_id
GROUP BY p.product_category;