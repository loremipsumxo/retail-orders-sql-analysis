# Schema Design Notes

## Phase 1 — Schema Design and Dimensional Modeling

### Status

Drafted and approved for SQL implementation planning.

Date: 2026-06-04

---

# Design Objective

Design a clean relational schema for SQL analysis based on validated Phase 0 reconnaissance findings.

The schema should support:

- Revenue analysis
- Profitability analysis
- Customer segmentation analysis
- Product performance analysis
- Product category analysis
- Supplier analysis
- Supplier geography analysis
- Delivery performance analysis

The design should remain simple, readable, reproducible, and appropriate for a beginner-to-intermediate SQL analytics portfolio project.

---

# Phase 1 Inputs

The following findings were validated during Phase 0 reconnaissance and are used as inputs to schema design.

## Supplier Normalization Assessment

Validation performed:

- Supplier ID unique count = 64
- Supplier Name unique count = 64

Additional validation:

Every Supplier ID maps to exactly one:

- Supplier Name
- Supplier Country

### Conclusion

Supplier attributes satisfy normalization requirements.

### Recommended Structure

dim_supplier

- supplier_id (PK)
- supplier_name
- supplier_country

dim_product

- product_id (PK)
- product_line
- product_category
- product_group
- product_name
- supplier_id (FK)

---

## Product Hierarchy Assessment

Validation performed:

- Product Line = 4 unique values
- Product Category = 13 unique values
- Product Group = 58 unique values
- Product Name = 5,504 unique products

Additional validation:

- 58 Product Groups identified
- 58 unique Product Line → Product Category → Product Group combinations identified

### Conclusion

The product hierarchy appears clean and suitable for dimensional modeling.

### Proposed Hierarchy

Product Line

→ Product Category

→ Product Group

→ Product Name

---

## Relationship Validation

Validation performed:

- Orders contains 3,124 unique products sold
- Products contains 5,504 products
- No orphan Product IDs detected

### Conclusion

Product ID successfully links products and orders.

Relationship validated:

Products (1) → Orders (Many)

---

# Phase 1 Design Decisions

## Initial Modeling Recommendation

### Fact Table

fact_orders

### Grain

One row per order-product transaction.

### Measures

- quantity_ordered
- revenue
- cost_price_per_unit
- estimated_cost
- estimated_profit
- gross_margin_pct

### Dimension Tables

- dim_product
- dim_supplier
- dim_customer_status

### Optional Future Dimension

- dim_date

A separate date dimension is not required for the current project and may be added later if calendar-based reporting requirements emerge.

---

## Date Design Decision

Dates will initially remain within fact_orders.

Fields:

- order_date
- delivery_date
- delivery_days

### Rationale

The current project can support delivery analysis, monthly reporting, and yearly reporting directly from date fields stored within fact_orders.

Introducing a separate date dimension at this stage would increase complexity without providing meaningful analytical benefit.

---

## Customer Status Design Decision

Customer Status values contain capitalization inconsistencies.

Observed values:

- Silver
- SILVER
- Gold
- GOLD
- Platinum
- PLATINUM

### Decision

Create a dedicated customer status dimension.

Expected cleaned values:

- Silver
- Gold
- Platinum

### Rationale

Supports:

- consistent reporting
- customer segmentation
- simplified joins
- standardized business definitions

---

# Approved Logical Data Model

```text
dim_supplier
      |
      |
dim_product
      |
      |
fact_orders

dim_customer_status
      |
      |
fact_orders
```

---

# Phase 1 Schema Specification

## Table 1 — dim_supplier

### Purpose

Stores supplier-level information.

### Grain

One row per supplier.

### Source

product-supplier.csv

### Columns

| Column | SQL Type | Role |
|----------|----------|----------|
| supplier_id | INT | Primary Key |
| supplier_name | VARCHAR(255) | Attribute |
| supplier_country | VARCHAR(10) | Attribute |

### Primary Key

supplier_id

---

## Table 2 — dim_product

### Purpose

Stores product-level information and product hierarchy.

### Grain

One row per product.

### Source

product-supplier.csv

### Columns

| Column | SQL Type | Role |
|----------|----------|----------|
| product_id | BIGINT | Primary Key |
| product_line | VARCHAR(100) | Attribute |
| product_category | VARCHAR(100) | Attribute |
| product_group | VARCHAR(255) | Attribute |
| product_name | VARCHAR(255) | Attribute |
| supplier_id | INT | Foreign Key |

### Primary Key

product_id

### Foreign Key

supplier_id → dim_supplier.supplier_id

---

## Table 3 — dim_customer_status

### Purpose

Stores standardized customer status categories.

### Grain

One row per customer status.

### Source

orders.csv

### Columns

| Column | SQL Type | Role |
|----------|----------|----------|
| customer_status_id | INT | Primary Key |
| customer_status | VARCHAR(50) | Attribute |

### Expected Values

- Silver
- Gold
- Platinum

### Primary Key

customer_status_id

---

## Table 4 — fact_orders

### Purpose

Stores transaction-level order activity.

### Grain

One row per order-product transaction.

### Source

orders.csv

### Columns

| Column | SQL Type | Role |
|----------|----------|----------|
| order_id | BIGINT | Order Identifier |
| customer_id | INT | Customer Identifier |
| customer_status_id | INT | Foreign Key |
| product_id | BIGINT | Foreign Key |
| order_date | DATE | Date Field |
| delivery_date | DATE | Date Field |
| delivery_days | INT | Derived Metric |
| quantity_ordered | INT | Measure |
| revenue | DECIMAL(12,2) | Measure |
| cost_price_per_unit | DECIMAL(12,2) | Measure |
| estimated_cost | DECIMAL(12,2) | Derived Measure |
| estimated_profit | DECIMAL(12,2) | Derived Measure |
| gross_margin_pct | DECIMAL(10,4) | Derived Measure |

### Foreign Keys

product_id → dim_product.product_id

customer_status_id → dim_customer_status.customer_status_id

### Derived Metrics

delivery_days

= delivery_date - order_date

estimated_cost

= quantity_ordered × cost_price_per_unit

estimated_profit

= revenue − estimated_cost

gross_margin_pct

= estimated_profit ÷ revenue

Use division-by-zero protection when calculating gross_margin_pct.

### Metric Assumptions

The dataset does not contain a total order cost field.

Therefore:

estimated_cost = quantity_ordered × cost_price_per_unit

Profitability metrics should be interpreted as estimates derived from available source data.

---

# Cleaning Requirements

## Customer Status

Standardize values to title case.

Examples:

- SILVER → Silver
- GOLD → Gold
- PLATINUM → Platinum

---

## Dates

Convert text date fields to SQL DATE format.

Examples:

- Date Order was placed → order_date
- Delivery Date → delivery_date

---

## Column Naming

Convert raw column names to SQL-friendly snake_case.

Examples:

- Customer ID → customer_id
- Date Order was placed → order_date
- Total Retail Price for This Order → revenue
- Cost Price Per Unit → cost_price_per_unit

---

# Recommended Schema Build Order

1. Create raw staging tables

- orders_raw
- product_supplier_raw

2. Import CSV files into staging tables

3. Create cleaned dimensions

- dim_supplier
- dim_product
- dim_customer_status

4. Create cleaned fact table

- fact_orders

5. Validate

- row counts
- primary keys
- foreign keys
- customer status standardization
- date conversion
- profitability calculations
- join integrity

---

# Phase 1 Conclusion

Schema design completed.

The design is supported by documented reconnaissance findings and approved for SQL implementation.

Next Step:

Create and review sql/01_schema.sql before importing data.