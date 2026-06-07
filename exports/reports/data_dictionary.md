# Data Dictionary

## Project

Retail Orders SQL Analysis

## Purpose

This data dictionary documents the source datasets, warehouse tables, derived metrics, analytical views, and exported datasets used in the Retail Orders SQL Analysis project.

The project uses raw retail order and product-supplier data, loads it into MySQL staging tables, transforms it into a dimensional warehouse, and exports aggregate datasets for Python visualization and reporting.

---

# Source Datasets

## `orders.csv`

Source role:

Transactional order-level source file loaded into `orders_raw`.

Observed structure:

- 185,013 rows
- 9 columns
- No missing values identified during reconnaissance

| Field Name | Source Dataset | Data Type | Description | Business Meaning | Cleaning or Transformation Applied | Notes or Limitations |
|---|---|---:|---|---|---|---|
| Customer ID | `orders.csv` | Integer | Customer identifier from the source order file. | Supports customer-level and customer-segment order analysis. | Renamed to `customer_id` in SQL staging and fact tables. | Customer demographics were not available. |
| Customer Status | `orders.csv` | Text | Customer tier or status label. | Used to segment customers into Gold, Platinum, and Silver groups. | Standardized to title case during dimensional population and mapped to `dim_customer_status`. | Reconnaissance identified capitalization inconsistencies such as `SILVER`, `GOLD`, and `PLATINUM`. |
| Date Order was placed | `orders.csv` | Text date | Original order date field. | Supports yearly trend and order timing analysis. | Renamed to `order_date_raw` in staging, then converted to SQL `DATE` as `order_date` using `STR_TO_DATE(..., '%d-%b-%y')`. | Date parsing validation found no invalid order dates. |
| Delivery Date | `orders.csv` | Text date | Original delivery date field. | Supports delivery timing and operational performance analysis. | Renamed to `delivery_date_raw` in staging, then converted to SQL `DATE` as `delivery_date`. | Date parsing validation found no invalid delivery dates. |
| Order ID | `orders.csv` | Integer | Order identifier from the source system. | Identifies individual order records. | Renamed to `order_id` in staging and fact tables. | The fact table grain is one row per order-product transaction. |
| Product ID | `orders.csv` | Integer | Product identifier associated with each order row. | Foreign key linking orders to product and supplier metadata. | Renamed to `product_id`; validated against `product_supplier_raw` and `dim_product`. | No orphan Product IDs were found in orders. |
| Quantity Ordered | `orders.csv` | Integer | Number of units ordered. | Supports volume, estimated cost, and profitability calculations. | Renamed to `quantity_ordered`. | Used to calculate `estimated_cost`. |
| Total Retail Price for This Order | `orders.csv` | Decimal | Revenue amount for the order row. | Primary sales/revenue measure. | Renamed to `revenue` and loaded as `DECIMAL(12,2)`. | Revenue is source-provided and assumed accurate after validation. |
| Cost Price Per Unit | `orders.csv` | Decimal | Unit cost associated with the ordered product. | Used to estimate total cost and profit. | Renamed to `cost_price_per_unit` and loaded as `DECIMAL(12,2)`. | Does not include shipping, overhead, discounts, or other full-cost accounting items. |

## `product-supplier.csv`

Source role:

Product catalog and supplier metadata file loaded into `product_supplier_raw`.

Observed structure:

- 5,504 rows
- 8 columns
- No missing values identified during reconnaissance
- `Product ID` validated as the product key

| Field Name | Source Dataset | Data Type | Description | Business Meaning | Cleaning or Transformation Applied | Notes or Limitations |
|---|---|---:|---|---|---|---|
| Product ID | `product-supplier.csv` | Integer | Unique product identifier. | Primary product key used to join product metadata to orders. | Renamed to `product_id`; used as primary key in `dim_product`. | 5,504 product records; 3,124 products appeared in orders. |
| Product Line | `product-supplier.csv` | Text | Broad product hierarchy level. | Supports high-level product grouping. | Renamed to `product_line`. | Product hierarchy validated as clean during reconnaissance. |
| Product Category | `product-supplier.csv` | Text | Product category label. | Core product-analysis dimension used in charts and exports. | Renamed to `product_category`. | 13 unique product categories. |
| Product Group | `product-supplier.csv` | Text | More granular product grouping below category. | Supports deeper product hierarchy analysis. | Renamed to `product_group`. | 58 unique product groups. |
| Product Name | `product-supplier.csv` | Text | Product name or description. | Identifies individual catalog items. | Renamed to `product_name`. | 5,504 unique products in the catalog. |
| Supplier Country | `product-supplier.csv` | Text | Supplier country code. | Supports supplier geography analysis. | Renamed to `supplier_country`; stored in `dim_supplier`. | 13 supplier countries represented. |
| Supplier Name | `product-supplier.csv` | Text | Supplier/vendor name. | Used to analyze supplier contribution to revenue and profit. | Renamed to `supplier_name`; stored in `dim_supplier`. | 64 unique supplier names. |
| Supplier ID | `product-supplier.csv` | Integer | Supplier identifier. | Supplier key used to normalize product and supplier data. | Renamed to `supplier_id`; primary key in `dim_supplier` and foreign key in `dim_product`. | Each Supplier ID maps to exactly one supplier name and country. |

---

# Warehouse Tables

## `dim_customer_status`

Purpose:

Stores standardized customer status values for customer segment analysis.

Grain:

One row per customer status.

| Field Name | Table | Data Type | Description | Business Meaning | Cleaning or Transformation Applied | Notes or Limitations |
|---|---|---:|---|---|---|---|
| customer_status_id | `dim_customer_status` | INT | Surrogate key for customer status. | Supports stable joins from `fact_orders` to customer status. | Fixed mapping: `1 = Gold`, `2 = Platinum`, `3 = Silver`. | Fixed keys support reproducible rebuilds. |
| customer_status | `dim_customer_status` | VARCHAR(50) | Standardized customer status label. | Customer segment used for revenue, profit, and order analysis. | Source capitalization standardized to title case. | Valid final values are Gold, Platinum, and Silver. |

## `dim_supplier`

Purpose:

Stores supplier-level attributes.

Grain:

One row per supplier.

| Field Name | Table | Data Type | Description | Business Meaning | Cleaning or Transformation Applied | Notes or Limitations |
|---|---|---:|---|---|---|---|
| supplier_id | `dim_supplier` | INT | Supplier primary key. | Links products to supplier metadata. | Loaded from distinct supplier records in `product_supplier_raw`. | 64 suppliers loaded. |
| supplier_name | `dim_supplier` | VARCHAR(255) | Supplier/vendor name. | Used to rank supplier revenue and profit contribution. | Loaded from `product_supplier_raw`. | Supplier performance analysis is limited to available sales/profit metrics. |
| supplier_country | `dim_supplier` | VARCHAR(10) | Supplier country code. | Supports supplier geography context. | Loaded from `product_supplier_raw`. | Country codes are source-provided. |

## `dim_product`

Purpose:

Stores product catalog and product hierarchy attributes.

Grain:

One row per product.

| Field Name | Table | Data Type | Description | Business Meaning | Cleaning or Transformation Applied | Notes or Limitations |
|---|---|---:|---|---|---|---|
| product_id | `dim_product` | BIGINT | Product primary key. | Joins order facts to product details. | Loaded from distinct product records in `product_supplier_raw`. | 5,504 products loaded; some catalog products had no orders. |
| product_line | `dim_product` | VARCHAR(100) | Broad product hierarchy level. | Enables high-level product grouping. | Loaded from source product metadata. | 4 unique product lines. |
| product_category | `dim_product` | VARCHAR(100) | Product category label. | Primary product dimension for category charts and findings. | Loaded from source product metadata. | 13 unique categories. |
| product_group | `dim_product` | VARCHAR(255) | Detailed product grouping. | Enables deeper product hierarchy analysis. | Loaded from source product metadata. | 58 unique product groups. |
| product_name | `dim_product` | VARCHAR(255) | Product name. | Identifies individual products. | Loaded from source product metadata. | Product-level reporting is available but final charts focus on categories. |
| supplier_id | `dim_product` | INT | Supplier foreign key. | Links products to supplier attributes. | Loaded from source metadata and validated against `dim_supplier`. | No missing supplier relationships identified. |

## `fact_orders`

Purpose:

Central fact table for order, revenue, profitability, and delivery analysis.

Grain:

One row per order-product transaction.

| Field Name | Table | Data Type | Description | Business Meaning | Cleaning or Transformation Applied | Notes or Limitations |
|---|---|---:|---|---|---|---|
| fact_order_id | `fact_orders` | BIGINT | Auto-increment fact-table primary key. | Internal warehouse row identifier. | Created during fact table load. | Not a source business key. |
| order_id | `fact_orders` | BIGINT | Source order identifier. | Supports order counting and transaction analysis. | Loaded from `orders_raw.order_id`. | Multiple rows may exist if source grain contains order-product transactions. |
| customer_id | `fact_orders` | INT | Source customer identifier. | Supports customer-level analysis. | Loaded from `orders_raw.customer_id`. | Customer demographics are not available. |
| customer_status_id | `fact_orders` | INT | Foreign key to `dim_customer_status`. | Enables customer-segment reporting. | Derived by joining standardized source status to `dim_customer_status`. | Referential integrity validated. |
| product_id | `fact_orders` | BIGINT | Foreign key to `dim_product`. | Enables product, category, and supplier analysis. | Loaded from `orders_raw.product_id` and validated against product dimension. | No missing product relationships identified. |
| order_date | `fact_orders` | DATE | Clean order date. | Supports yearly and time-based performance analysis. | Converted from `order_date_raw` with `STR_TO_DATE`. | No null or invalid order dates identified. |
| delivery_date | `fact_orders` | DATE | Clean delivery date. | Supports delivery performance analysis. | Converted from `delivery_date_raw` with `STR_TO_DATE`. | No null or invalid delivery dates identified. |
| delivery_days | `fact_orders` | INT | Number of days between order and delivery. | Measures delivery speed and operational performance. | Calculated with `DATEDIFF(delivery_date, order_date)`. | No negative delivery durations identified. |
| quantity_ordered | `fact_orders` | INT | Units ordered. | Supports order volume and cost calculations. | Loaded from `orders_raw.quantity_ordered`. | Quantity is source-provided. |
| revenue | `fact_orders` | DECIMAL(12,2) | Total retail price for the order row. | Core revenue measure. | Loaded from source revenue field. | Does not reflect discounts or returns if absent from source data. |
| cost_price_per_unit | `fact_orders` | DECIMAL(12,2) | Unit cost for the ordered product. | Used to estimate cost and profit. | Loaded from source unit cost field. | Does not include overhead or other indirect costs. |
| estimated_cost | `fact_orders` | DECIMAL(12,2) | Estimated total cost for the order row. | Cost measure used for profitability analysis. | Calculated as `quantity_ordered * cost_price_per_unit`. | Estimate based only on available unit cost. |
| estimated_profit | `fact_orders` | DECIMAL(12,2) | Estimated profit for the order row. | Profit measure used throughout analysis. | Calculated as `revenue - estimated_cost`. | Excludes shipping, overhead, tax, discounts, returns, and other costs not present in source data. |
| gross_margin_pct | `fact_orders` | DECIMAL(10,4) | Estimated margin ratio. | Measures profitability efficiency. | Calculated as `estimated_profit / revenue`; protected from division by zero. | Stored as a decimal ratio in the warehouse; some exports express margin as a percentage. |

---

# Derived Metrics

| Metric | Created In | Data Type | Formula | Business Meaning | Notes or Limitations |
|---|---|---:|---|---|---|
| delivery_days | `fact_orders`; `07_delivery_performance_summary.csv`; `vw_delivery_performance_by_category` | Integer / Decimal aggregate | `DATEDIFF(delivery_date, order_date)` | Measures delivery speed and operational efficiency. | Same-day delivery appears as `0`; extreme delivery times are captured in `slowest_delivery_days`. |
| estimated_cost | `fact_orders` | DECIMAL(12,2) | `quantity_ordered * cost_price_per_unit` | Estimates order-row cost using available unit cost and quantity. | Does not include indirect costs. |
| estimated_profit | `fact_orders`; exports; views | DECIMAL(12,2) | `revenue - estimated_cost` | Measures estimated profitability. | Profit is an estimate, not full accounting profit. |
| gross_margin_pct | `fact_orders`; `vw_product_category_profitability`; `vw_supplier_performance` | DECIMAL | `estimated_profit / revenue` in the warehouse; multiplied by 100 in views where labeled as percent. | Measures profitability efficiency. | Uses division-by-zero protection in warehouse/views. |
| average_order_value | `01_yearly_kpis.csv`; `02_customer_segment_summary.csv`; `vw_customer_segment_summary` | DECIMAL | `SUM(revenue) / COUNT(order_id)` or `AVG(revenue)` depending on aggregation context. | Measures average revenue generated per order row. | Based on order-product transaction grain. |
| total_revenue | Exports and views | DECIMAL | `SUM(revenue)` | Aggregated sales revenue. | Rounded to two decimals in exported datasets. |
| total_profit | Exports and views | DECIMAL | `SUM(estimated_profit)` | Aggregated estimated profit. | Rounded to two decimals in exported datasets. |
| total_orders | Exports and views | Integer | `COUNT(order_id)` or `COUNT(*)` | Order-row volume. | Reflects fact table grain, one row per order-product transaction. |

---

# Analytical Views

| View Name | Fields | Description | Business Use |
|---|---|---|---|
| `vw_customer_segment_summary` | `customer_status`, `total_orders`, `total_revenue`, `total_profit`, `average_order_value` | Summarizes revenue, profit, volume, and average order value by customer segment. | Customer segment performance analysis. |
| `vw_product_category_profitability` | `product_category`, `total_revenue`, `total_profit`, `total_orders`, `gross_margin_pct` | Summarizes product category performance and margin. | Product category profitability analysis. |
| `vw_supplier_performance` | `supplier_name`, `supplier_country`, `total_revenue`, `total_profit`, `total_orders`, `gross_margin_pct` | Summarizes supplier revenue, profit, order volume, and margin. | Supplier performance and concentration analysis. |
| `vw_delivery_performance_by_category` | `product_category`, `avg_delivery_days`, `fastest_delivery_days`, `slowest_delivery_days`, `total_orders` | Summarizes delivery timing by product category. | Operational delivery performance analysis. |

---

# Export Datasets

Exported datasets are generated from `sql/06_phase4_exports.sql` and saved in `exports/datasets/` for the final Python notebook.

## `01_yearly_kpis.csv`

Purpose:

Executive KPI trend dataset.

| Field Name | Export Dataset | Data Type | Description | Business Meaning | Transformation Applied | Notes or Limitations |
|---|---|---:|---|---|---|---|
| order_year | `01_yearly_kpis.csv` | Integer | Year extracted from `fact_orders.order_date`. | Supports annual trend analysis. | `YEAR(order_date)`. | Covers available order years only. |
| total_revenue | `01_yearly_kpis.csv` | Decimal | Revenue summed by year. | Annual revenue performance. | `ROUND(SUM(revenue), 2)`. | Rounded for reporting. |
| total_profit | `01_yearly_kpis.csv` | Decimal | Estimated profit summed by year. | Annual profitability performance. | `ROUND(SUM(estimated_profit), 2)`. | Estimated profit only. |
| total_orders | `01_yearly_kpis.csv` | Integer | Count of order rows by year. | Annual order volume. | `COUNT(order_id)`. | Reflects fact-table grain. |
| average_order_value | `01_yearly_kpis.csv` | Decimal | Average revenue per order row by year. | Revenue efficiency per transaction. | `ROUND(SUM(revenue) / COUNT(order_id), 2)`. | Based on order-product transaction grain. |

## `02_customer_segment_summary.csv`

Purpose:

Customer status performance dataset.

| Field Name | Export Dataset | Data Type | Description | Business Meaning | Transformation Applied | Notes or Limitations |
|---|---|---:|---|---|---|---|
| customer_status | `02_customer_segment_summary.csv` | Text | Standardized customer status. | Customer segment dimension. | Joined from `dim_customer_status`. | Values are Gold, Platinum, and Silver. |
| total_revenue | `02_customer_segment_summary.csv` | Decimal | Revenue summed by customer status. | Segment revenue contribution. | `ROUND(SUM(f.revenue), 2)`. | Rounded for reporting. |
| total_profit | `02_customer_segment_summary.csv` | Decimal | Estimated profit summed by customer status. | Segment profitability contribution. | `ROUND(SUM(f.estimated_profit), 2)`. | Estimated profit only. |
| total_orders | `02_customer_segment_summary.csv` | Integer | Order-row count by customer status. | Segment order volume. | `COUNT(f.order_id)`. | Reflects fact-table grain. |
| average_order_value | `02_customer_segment_summary.csv` | Decimal | Average revenue per order row by status. | Segment revenue efficiency. | `ROUND(SUM(f.revenue) / COUNT(f.order_id), 2)`. | Based on order-product transaction grain. |

## `03_product_category_summary.csv`

Purpose:

Product category revenue and profit dataset.

| Field Name | Export Dataset | Data Type | Description | Business Meaning | Transformation Applied | Notes or Limitations |
|---|---|---:|---|---|---|---|
| product_category | `03_product_category_summary.csv` | Text | Product category from `dim_product`. | Category-level product dimension. | Joined from product dimension. | 13 categories in the catalog. |
| total_revenue | `03_product_category_summary.csv` | Decimal | Revenue summed by category. | Category sales contribution. | `ROUND(SUM(f.revenue), 2)`. | Rounded for reporting. |
| total_profit | `03_product_category_summary.csv` | Decimal | Estimated profit summed by category. | Category profitability contribution. | `ROUND(SUM(f.estimated_profit), 2)`. | Estimated profit only. |
| total_orders | `03_product_category_summary.csv` | Integer | Order-row count by category. | Category order volume. | `COUNT(f.order_id)`. | Used for category performance context. |

## `04_supplier_revenue_summary.csv`

Purpose:

Supplier revenue contribution dataset.

| Field Name | Export Dataset | Data Type | Description | Business Meaning | Transformation Applied | Notes or Limitations |
|---|---|---:|---|---|---|---|
| supplier_name | `04_supplier_revenue_summary.csv` | Text | Supplier name from `dim_supplier`. | Supplier performance dimension. | Joined through `dim_product` to `dim_supplier`. | Supplier country is not included in this export. |
| total_revenue | `04_supplier_revenue_summary.csv` | Decimal | Revenue summed by supplier. | Supplier revenue contribution. | `ROUND(SUM(f.revenue), 2)`. | Sorted by total revenue descending. |
| total_profit | `04_supplier_revenue_summary.csv` | Decimal | Estimated profit summed by supplier. | Supplier profit context. | `ROUND(SUM(f.estimated_profit), 2)`. | Estimated profit only. |
| total_orders | `04_supplier_revenue_summary.csv` | Integer | Order-row count by supplier. | Supplier order volume. | `COUNT(f.order_id)`. | Reflects products sold through each supplier. |

## `05_supplier_profit_summary.csv`

Purpose:

Supplier profitability dataset.

| Field Name | Export Dataset | Data Type | Description | Business Meaning | Transformation Applied | Notes or Limitations |
|---|---|---:|---|---|---|---|
| supplier_name | `05_supplier_profit_summary.csv` | Text | Supplier name. | Supplier performance dimension. | Joined through product dimension. | Used in supplier profit chart. |
| total_revenue | `05_supplier_profit_summary.csv` | Decimal | Revenue summed by supplier. | Supplier sales contribution. | `ROUND(SUM(f.revenue), 2)`. | Included for revenue-profit comparison. |
| total_profit | `05_supplier_profit_summary.csv` | Decimal | Estimated profit summed by supplier. | Supplier profitability contribution. | `ROUND(SUM(f.estimated_profit), 2)`. | Sorted by total profit descending. |
| total_orders | `05_supplier_profit_summary.csv` | Integer | Order-row count by supplier. | Supplier volume context. | `COUNT(f.order_id)`. | Reflects order-product transactions. |
| profit_margin_pct | `05_supplier_profit_summary.csv` | Decimal | Supplier profit margin percentage. | Supplier profitability efficiency. | `ROUND(SUM(f.estimated_profit) / SUM(f.revenue) * 100, 2)`. | Percentage version of margin; estimated profit only. |

## `06_product_profitability_summary.csv`

Purpose:

Product category margin dataset.

| Field Name | Export Dataset | Data Type | Description | Business Meaning | Transformation Applied | Notes or Limitations |
|---|---|---:|---|---|---|---|
| product_category | `06_product_profitability_summary.csv` | Text | Product category. | Category dimension for margin analysis. | Joined from `dim_product`. | Used in revenue vs profit and margin analysis. |
| total_revenue | `06_product_profitability_summary.csv` | Decimal | Revenue summed by category. | Category sales contribution. | `ROUND(SUM(f.revenue), 2)`. | Rounded for reporting. |
| total_profit | `06_product_profitability_summary.csv` | Decimal | Estimated profit summed by category. | Category profit contribution. | `ROUND(SUM(f.estimated_profit), 2)`. | Estimated profit only. |
| total_orders | `06_product_profitability_summary.csv` | Integer | Order-row count by category. | Category order volume. | `COUNT(f.order_id)`. | Useful for scale context. |
| profit_margin_pct | `06_product_profitability_summary.csv` | Decimal | Category estimated profit margin percentage. | Category profitability efficiency. | `ROUND(SUM(f.estimated_profit) / SUM(f.revenue) * 100, 2)`. | Sorted by margin descending. |

## `07_delivery_performance_summary.csv`

Purpose:

Delivery performance dataset by product category.

| Field Name | Export Dataset | Data Type | Description | Business Meaning | Transformation Applied | Notes or Limitations |
|---|---|---:|---|---|---|---|
| product_category | `07_delivery_performance_summary.csv` | Text | Product category. | Category dimension for delivery analysis. | Joined from `dim_product`. | Enables category-level operational comparison. |
| avg_delivery_days | `07_delivery_performance_summary.csv` | Decimal | Average delivery duration by category. | Measures typical delivery speed. | `ROUND(AVG(f.delivery_days), 2)`. | Averages can hide outliers. |
| fastest_delivery_days | `07_delivery_performance_summary.csv` | Integer | Minimum delivery duration by category. | Best observed delivery performance. | `MIN(f.delivery_days)`. | Same-day delivery appears as `0`. |
| slowest_delivery_days | `07_delivery_performance_summary.csv` | Integer | Maximum delivery duration by category. | Identifies possible delivery outliers. | `MAX(f.delivery_days)`. | Does not explain cause of delays. |
| total_orders | `07_delivery_performance_summary.csv` | Integer | Order-row count by category. | Volume context for delivery performance. | `COUNT(f.order_id)`. | High-volume categories can still have low average delivery times. |

---

# Known Data Limitations

- Profitability metrics are estimates based on revenue, quantity ordered, and unit cost only.
- The dataset does not include discounts, returns, shipping cost, tax, marketing cost, inventory holding cost, or overhead.
- Customer demographic, acquisition, and marketing-channel fields are not available.
- Supplier analysis is limited to supplier metadata and order performance; contract terms and supplier reliability metrics are not available.
- Delivery analysis is based only on order and delivery dates; carrier, warehouse, and service-level data are not available.
- Exported datasets are aggregate reporting datasets and should be regenerated from SQL if source data changes.
