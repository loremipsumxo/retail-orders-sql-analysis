/*
=========================================================
Phase 4 Export Queries
Retail Orders SQL Analysis

Purpose:
Create export-ready datasets for Python analysis
and visualization.

Phase:
Phase 4 – Python Analysis & Visualization

Author:
Zen Forest

Created:
2026-06-06
=========================================================
*/

USE retail_orders_sql_analysis;

/*
=========================================================
Export 01
Yearly KPI Summary

Purpose:
Executive KPI trend analysis for notebook charts.

Export Target:
exports/datasets/01_yearly_kpis.csv
=========================================================
*/

SELECT
    YEAR(order_date) AS order_year,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(SUM(estimated_profit), 2) AS total_profit,
    COUNT(order_id) AS total_orders,
    ROUND(SUM(revenue) / COUNT(order_id), 2) AS average_order_value
FROM fact_orders
GROUP BY YEAR(order_date)
ORDER BY order_year;


/*
=========================================================
Export 02
Customer Segment Performance

Purpose:
Customer segment revenue, profit, and order analysis.

Export Target:
exports/datasets/02_customer_segment_summary.csv
=========================================================
*/

SELECT
    c.customer_status,
    ROUND(SUM(f.revenue), 2) AS total_revenue,
    ROUND(SUM(f.estimated_profit), 2) AS total_profit,
    COUNT(f.order_id) AS total_orders,
    ROUND(SUM(f.revenue) / COUNT(f.order_id), 2) AS average_order_value
FROM fact_orders f
JOIN dim_customer_status c
    ON f.customer_status_id = c.customer_status_id
GROUP BY c.customer_status
ORDER BY total_revenue DESC;


/*
==========================================================
Export 03
Product Category Revenue Summary

Purpose:
Product category performance visualization.

Export Target:
exports/datasets/03_product_category_summary.csv
==========================================================
*/

SELECT
    p.product_category,
    ROUND(SUM(f.revenue), 2) AS total_revenue,
    ROUND(SUM(f.estimated_profit), 2) AS total_profit,
    COUNT(f.order_id) AS total_orders
FROM fact_orders f
JOIN dim_product p
    ON f.product_id = p.product_id
GROUP BY p.product_category
ORDER BY total_revenue DESC;


/*
==========================================================
Export 04
Supplier Revenue Summary

Purpose:
Supplier performance visualization.

Export Target:
exports/datasets/04_supplier_revenue_summary.csv
==========================================================
*/

SELECT
    s.supplier_name,
    ROUND(SUM(f.revenue), 2) AS total_revenue,
    ROUND(SUM(f.estimated_profit), 2) AS total_profit,
    COUNT(f.order_id) AS total_orders
FROM fact_orders f
JOIN dim_product p
    ON f.product_id = p.product_id
JOIN dim_supplier s
    ON p.supplier_id = s.supplier_id
GROUP BY s.supplier_name
ORDER BY total_revenue DESC;


/*
=========================================================
Export 05
Supplier Profit Summary

Purpose:
Supplier profitability analysis for notebook charts.

Export Target:
exports/datasets/05_supplier_profit_summary.csv
=========================================================
*/

SELECT
    s.supplier_name,
    ROUND(SUM(f.revenue), 2) AS total_revenue,
    ROUND(SUM(f.estimated_profit), 2) AS total_profit,
    COUNT(f.order_id) AS total_orders,
    ROUND(
        SUM(f.estimated_profit) /
        SUM(f.revenue) * 100,
        2
    ) AS profit_margin_pct
FROM fact_orders f
JOIN dim_product p
    ON f.product_id = p.product_id
JOIN dim_supplier s
    ON p.supplier_id = s.supplier_id
GROUP BY s.supplier_name
ORDER BY total_profit DESC;


/*
=========================================================
Export 06
Product Profitability Summary

Purpose:
Product category profitability analysis.

Export Target:
exports/datasets/06_product_profitability_summary.csv
=========================================================
*/

SELECT
    p.product_category,
    ROUND(SUM(f.revenue), 2) AS total_revenue,
    ROUND(SUM(f.estimated_profit), 2) AS total_profit,
    COUNT(f.order_id) AS total_orders,
    ROUND(
        SUM(f.estimated_profit) /
        SUM(f.revenue) * 100,
        2
    ) AS profit_margin_pct
FROM fact_orders f
JOIN dim_product p
    ON f.product_id = p.product_id
GROUP BY p.product_category
ORDER BY profit_margin_pct DESC;


/*
=========================================================
Export 07
Delivery Performance Summary

Purpose:
Delivery efficiency analysis by product category.

Export Target:
exports/datasets/07_delivery_performance_summary.csv
=========================================================
*/

SELECT
    p.product_category,
    ROUND(AVG(f.delivery_days), 2) AS avg_delivery_days,
    MIN(f.delivery_days) AS fastest_delivery_days,
    MAX(f.delivery_days) AS slowest_delivery_days,
    COUNT(f.order_id) AS total_orders
FROM fact_orders f
JOIN dim_product p
    ON f.product_id = p.product_id
GROUP BY p.product_category
ORDER BY avg_delivery_days DESC;