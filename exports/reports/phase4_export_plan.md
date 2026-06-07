# Phase 4 Export Plan

## Status

Complete

Date: 2026-06-06

---

# Purpose

This document defines the datasets exported from MySQL for the Python Analysis & Visualization phase.

The objective is to create clean, reproducible analytical datasets that support notebook development, chart creation, and portfolio reporting.

---

# Export Strategy

Guiding principles:

- Export aggregated analytical datasets rather than raw warehouse tables.
- One export should support one primary visualization or business question.
- Exports should be reproducible from SQL.
- All exports should be saved as CSV files.
- Exported datasets are stored in:

```text
exports/datasets/
```

Export source script:

```text
sql/06_phase4_exports.sql
```

---

# Exported Datasets

## Dataset 001 — Yearly KPI Summary

Export file:

```text
exports/datasets/01_yearly_kpis.csv
```

Purpose:

Provide annual executive performance metrics.

Fields:

- `order_year`
- `total_revenue`
- `total_profit`
- `total_orders`
- `average_order_value`

Visualizations:

- Revenue Trend
- Profit Trend
- Average Order Value Trend

---

## Dataset 002 — Customer Segment Summary

Export file:

```text
exports/datasets/02_customer_segment_summary.csv
```

Purpose:

Compare customer status groups by revenue, profit, order count, and average order value.

Fields:

- `customer_status`
- `total_revenue`
- `total_profit`
- `total_orders`
- `average_order_value`

Visualizations:

- Revenue by Customer Status
- Order Volume by Customer Status

---

## Dataset 003 — Product Category Summary

Export file:

```text
exports/datasets/03_product_category_summary.csv
```

Purpose:

Analyze product category revenue, profit, and order volume.

Fields:

- `product_category`
- `total_revenue`
- `total_profit`
- `total_orders`

Visualizations:

- Revenue by Product Category
- Profit by Product Category
- Revenue vs Profit by Product Category

---

## Dataset 004 — Supplier Revenue Summary

Export file:

```text
exports/datasets/04_supplier_revenue_summary.csv
```

Purpose:

Identify top suppliers by revenue contribution.

Fields:

- `supplier_name`
- `total_revenue`
- `total_profit`
- `total_orders`

Visualizations:

- Revenue by Supplier

---

## Dataset 005 — Supplier Profit Summary

Export file:

```text
exports/datasets/05_supplier_profit_summary.csv
```

Purpose:

Identify top suppliers by estimated profit contribution and profit margin.

Fields:

- `supplier_name`
- `total_revenue`
- `total_profit`
- `total_orders`
- `profit_margin_pct`

Visualizations:

- Profit by Supplier

---

## Dataset 006 — Product Profitability Summary

Export file:

```text
exports/datasets/06_product_profitability_summary.csv
```

Purpose:

Compare product categories by revenue, profit, order count, and profit margin.

Fields:

- `product_category`
- `total_revenue`
- `total_profit`
- `total_orders`
- `profit_margin_pct`

Visualizations:

- Revenue vs Profit by Product Category

---

## Dataset 007 — Delivery Performance Summary

Export file:

```text
exports/datasets/07_delivery_performance_summary.csv
```

Purpose:

Evaluate delivery timing across product categories.

Fields:

- `product_category`
- `avg_delivery_days`
- `fastest_delivery_days`
- `slowest_delivery_days`
- `total_orders`

Visualizations:

- Delivery Performance by Product Category

---

# Phase 4 Export Conclusion

The Phase 4 export process produced seven validated CSV datasets for the final notebook and chart outputs.

These datasets support executive KPI analysis, customer segment analysis, product category analysis, supplier analysis, profitability analysis, and delivery performance analysis.
