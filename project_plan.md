# Retail Orders SQL Analysis Project Plan

## Project Overview

Retail Orders SQL Analysis is a completed portfolio project that uses retail order and product-supplier data to demonstrate a reproducible SQL analytics workflow supported by Python visualization and reporting.

The project profiles raw source files, designs a dimensional warehouse in MySQL, prepares cleaned analytical tables, creates reusable SQL views, exports business-ready datasets, and presents findings through a published notebook, charts, and final reports.

## Business Context

The analysis is framed as a retail operations and sales analytics engagement. The business has order, product, supplier, customer status, cost, and delivery data and wants to understand how revenue, estimated profit, product mix, suppliers, customer segments, and delivery performance contribute to overall business results.

The project supports stakeholders such as:

- Retail operations managers
- Sales analytics teams
- Merchandising teams
- Supplier management teams
- Inventory planning teams
- Finance and profitability analysts
- Business leaders reviewing category and customer performance

## Project Objectives

The completed project was designed to answer these core objectives:

1. Measure overall revenue, estimated profit, order volume, and average order value.
2. Analyze yearly revenue and profit trends.
3. Compare revenue and order volume across customer status groups.
4. Identify the strongest product categories by revenue and estimated profit.
5. Compare high-revenue categories with high-profit categories.
6. Rank suppliers by revenue and estimated profit contribution.
7. Evaluate delivery performance by product category.
8. Build a reproducible SQL-to-Python reporting workflow.
9. Document assumptions, cleaning decisions, limitations, and final outputs clearly enough for portfolio review.

## Dataset Overview

The project uses two source datasets that are kept outside version control.

### `orders.csv`

`orders.csv` contains order-level transactional data used for revenue, cost, customer segment, quantity, product, and delivery analysis.

Key fields:

- `Customer ID`
- `Customer Status`
- `Date Order was placed`
- `Delivery Date`
- `Order ID`
- `Product ID`
- `Quantity Ordered`
- `Total Retail Price for This Order`
- `Cost Price Per Unit`

### `product-supplier.csv`

`product-supplier.csv` contains product hierarchy and supplier metadata used to enrich order records.

Key fields:

- `Product ID`
- `Product Line`
- `Product Category`
- `Product Group`
- `Product Name`
- `Supplier Country`
- `Supplier Name`
- `Supplier ID`

### Relationship

The core relationship is:

```text
orders.Product ID = product_supplier.Product ID
```

Reconnaissance validated `Product ID` as the product key in the product-supplier file and confirmed that order records could be joined to product metadata without orphan product IDs in the final workflow.

## Data Warehouse Design

The SQL workflow uses raw staging tables, dimensional tables, and a central fact table.

### Raw Staging Tables

- `orders_raw`
- `product_supplier_raw`

These tables preserve source structure after import while using SQL-friendly column names.

### Dimension Tables

- `dim_customer_status`
- `dim_supplier`
- `dim_product`

The dimensions standardize reusable descriptive attributes for customer segment, supplier, and product analysis.

### Fact Table

- `fact_orders`

The fact table grain is one row per order-product transaction. It contains order identifiers, customer and product keys, order and delivery dates, quantity, revenue, unit cost, estimated cost, estimated profit, and gross margin.

## SQL Workflow

The SQL work is organized into reproducible scripts:

- `sql/01_schema.sql`: Creates the database, staging tables, dimension tables, fact table, keys, and indexes.
- `sql/02_import_notes.md`: Documents the raw CSV import workflow.
- `sql/03_data_cleaning.sql`: Loads dimensions and fact data, standardizes values, parses dates, derives metrics, and runs validation checks.
- `sql/04_analysis_queries.sql`: Contains business analysis queries for revenue, profitability, customer, product, supplier, and delivery performance.
- `sql/05_views.sql`: Creates reusable analytical views for customer, product, supplier, and delivery summaries.
- `sql/06_phase4_exports.sql`: Produces export-ready query outputs for the final notebook and charts.

## Analytical Views

The final SQL layer includes four reusable views:

- `vw_customer_segment_summary`
- `vw_product_category_profitability`
- `vw_supplier_performance`
- `vw_delivery_performance_by_category`

These views make the most important aggregations easier to inspect and reuse without duplicating query logic.

## Derived Metrics

The warehouse and export datasets include the following derived metrics:

- `delivery_days = DATEDIFF(delivery_date, order_date)`
- `estimated_cost = quantity_ordered * cost_price_per_unit`
- `estimated_profit = revenue - estimated_cost`
- `gross_margin_pct = estimated_profit / revenue`
- `average_order_value = total_revenue / total_orders`

Profitability metrics are estimates because the source data does not include shipping, discounts, returns, tax, overhead, marketing cost, or inventory holding cost.

## Exported Datasets

The final analysis uses seven SQL-generated CSV exports stored in `exports/datasets/`:

- `01_yearly_kpis.csv`
- `02_customer_segment_summary.csv`
- `03_product_category_summary.csv`
- `04_supplier_revenue_summary.csv`
- `05_supplier_profit_summary.csv`
- `06_product_profitability_summary.csv`
- `07_delivery_performance_summary.csv`

These datasets are the bridge between the SQL analysis layer and the Python notebook.

## Notebook and Visualization Workflow

The published notebook is:

```text
notebooks/retail_orders_analysis.ipynb
```

The notebook loads the exported CSV datasets, validates the analysis inputs, creates final charts with Python, and presents the project findings in a portfolio-ready narrative.

Final chart outputs are saved in:

```text
exports/charts/
```

The final notebook also generated:

- `exports/reports/retail_orders_analysis.html`
- `exports/reports/retail_orders_analysis.pdf`

## Completed Deliverables

The project includes the following portfolio-ready deliverables:

- `README.md`
- `project_plan.md`
- `requirements.txt`
- `sql/01_schema.sql`
- `sql/02_import_notes.md`
- `sql/03_data_cleaning.sql`
- `sql/04_analysis_queries.sql`
- `sql/05_views.sql`
- `sql/06_phase4_exports.sql`
- `notebooks/retail_orders_analysis.ipynb`
- `exports/charts/*.png`
- `exports/datasets/*.csv`
- `exports/reports/analysis_notes.md`
- `exports/reports/analysis_plan.md`
- `exports/reports/cleaning_decisions.md`
- `exports/reports/data_dictionary.md`
- `exports/reports/findings_log.md`
- `exports/reports/phase4_export_plan.md`
- `exports/reports/phase4_notebook_plan.md`
- `exports/reports/reconnaissance_summary.md`
- `exports/reports/retail_orders_analysis.html`
- `exports/reports/retail_orders_analysis.pdf`
- `exports/reports/schema_design_notes.md`

## Validation Summary

The project validation workflow checked:

- Source row counts and column structure.
- Product key uniqueness in the product-supplier data.
- Join integrity between orders and product metadata.
- Date parsing for order and delivery dates.
- Delivery duration calculations.
- Revenue, estimated cost, estimated profit, and margin formulas.
- SQL export dataset names and chart input files.
- Notebook imports and reproducibility requirements.
- README links, chart links, report links, and SQL file references.
- Git hygiene rules for raw data, exploratory notebooks, local test SQL, and environment files.

## Limitations

The final analysis should be interpreted with these limitations:

- Estimated profit is calculated from available revenue, quantity, and unit cost fields only.
- The source data does not include discounts, returns, tax, shipping cost, overhead, marketing cost, or inventory holding cost.
- Customer status is available, but customer demographics and acquisition channels are not.
- Supplier analysis is limited to supplier metadata and order performance; contract terms and supplier reliability data are not available.
- Delivery analysis is based on order and delivery dates only; carrier, warehouse, and fulfillment details are not available.

## Final Status

This project is complete and portfolio-ready. The public repository contains the cleaned project documentation, SQL workflow, final notebook, exported analysis datasets, charts, and reports needed to review and reproduce the analysis.
