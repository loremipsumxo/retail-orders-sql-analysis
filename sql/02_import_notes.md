# Import Notes

## Phase 2 — Data Import

### Status

Complete

Date: 2026-06-04

---

# Purpose

This document records the procedures, validation steps, results, and observations associated with importing source CSV files into MySQL staging tables.

The objective is to create a repeatable, reproducible, and auditable workflow for loading source data prior to cleaning, transformation, and dimensional-model population.

---

# Reproducibility

Raw source files must remain unchanged after import.

All cleaning rules, standardization procedures, derived metrics, dimensional-model population logic, and analytical calculations will be implemented in later SQL scripts.

This approach preserves source-system fidelity and supports reproducible analysis.

The staging tables should represent the closest possible copy of the original CSV files.

---

# Source Files

## Orders Dataset

Source file:

datasets/raw/orders.csv

### Purpose

Contains transaction-level sales records.

### Phase 0 Validation

- 185,013 rows
- 9 columns
- No missing values identified during reconnaissance

### Target Table

orders_raw

---

## Product and Supplier Dataset

Source file:

datasets/raw/product-supplier.csv

### Purpose

Contains product master data and supplier information.

### Phase 0 Validation

- 5,504 rows
- 8 columns
- No missing values identified during reconnaissance

### Target Table

product_supplier_raw

---

# Target Staging Tables

## orders_raw

### Purpose

Stores imported order data exactly as received from the source file prior to cleaning, transformation, or standardization.

### Expected Row Count

185,013

---

## product_supplier_raw

### Purpose

Stores imported product and supplier data exactly as received from the source file prior to cleaning, transformation, or standardization.

### Expected Row Count

5,504

---

# Import Method

Imports were performed using MySQL Workbench and validated through SQL queries.

Because the MySQL Workbench Import Wizard generated encoding-related errors on macOS, imports were ultimately completed using SQL-based LOAD DATA LOCAL INFILE statements.

### Import Workflow

1. Execute sql/01_schema.sql
2. Create database objects
3. Enable LOCAL INFILE support
4. Import orders.csv into orders_raw
5. Import product-supplier.csv into product_supplier_raw
6. Validate row counts
7. Validate column mappings
8. Perform spot-check validation
9. Preserve imported raw data before cleaning

### Import Rule

No transformations were performed during import.

Cleaning, standardization, and dimensional-model population will be performed in:

sql/03_data_cleaning.sql

---

# Expected Row Counts

| Table | Expected Rows |
|---------|---------:|
| orders_raw | 185,013 |
| product_supplier_raw | 5,504 |

---

# Validation Procedures

## Row Count Validation

sql SELECT COUNT(*) FROM orders_raw;  SELECT COUNT(*) FROM product_supplier_raw; 

### Expected Results

text orders_raw = 185,013 product_supplier_raw = 5,504 

---

## Column Validation

### orders_raw

- customer_id
- customer_status
- order_date_raw
- delivery_date_raw
- order_id
- product_id
- quantity_ordered
- revenue
- cost_price_per_unit

### product_supplier_raw

- product_id
- product_line
- product_category
- product_group
- product_name
- supplier_country
- supplier_name
- supplier_id

---

## Spot Check Validation

sql SELECT * FROM orders_raw LIMIT 10;  SELECT * FROM product_supplier_raw LIMIT 10; 

Validation objectives:

- Confirm row integrity
- Confirm column mappings
- Confirm source values imported correctly
- Confirm staging tables reflect source CSV files

---

# Import Results

## orders_raw

### Import Status

Completed

### Validation Results

- Expected rows: 185,013
- Imported rows: 185,013

Validation completed:

- Row count verified
- Column mappings verified
- Spot-check validation successful
- Revenue range validated
- Cost range validated

Additional validation:

sql SELECT MIN(revenue), MAX(revenue) FROM orders_raw;  SELECT MIN(cost_price_per_unit),        MAX(cost_price_per_unit) FROM orders_raw; 

Observed values:

text Revenue: Min = 0.63 Max = 6382.00  Cost Price Per Unit: Min = 0.20 Max = 791.80 

### Import Warnings

MySQL reported 427 warnings during import.

Example warning:

text Data truncated for column 'revenue' 

### Investigation

Affected records were reviewed directly against the source CSV file.

Sample values inspected:

text 297.9 252 71.2 60 140.3 

All reviewed values appeared correct after import.

### Assessment

- No evidence of data loss identified
- Row counts matched expectations
- Sample values matched source records
- Revenue and cost ranges appeared reasonable

Import accepted for continuation.

---

## product_supplier_raw

### Import Status

Completed

### Validation Results

- Expected rows: 5,504
- Imported rows: 5,504

Validation completed:

- Row count verified
- Column mappings verified
- Spot-check validation successful

### Import Warnings

sql SHOW WARNINGS LIMIT 20; 

Result:

text 0 rows returned 

### Assessment

- No warnings generated
- Import completed successfully
- Product hierarchy values validated
- Source data appears intact

Import accepted for continuation.

---

# Known Data Quality Considerations

## Customer Status Inconsistencies

Observed values include:

text Silver SILVER Gold GOLD Platinum PLATINUM 

### Resolution

Standardize during:

sql/03_data_cleaning.sql

---

## Date Conversion

Source values currently exist as text.

Examples:

text 01-Jan-17 07-Jan-17 

### Resolution

Convert to SQL DATE format during cleaning.

---

## Unsold Products

Validated during Phase 0 reconnaissance.

Findings:

- Product catalog contains 5,504 products
- Orders reference 3,124 unique products

Approximately 2,380 products were not sold during the observation period.

### Assessment

Expected business condition.

Not considered a data-quality issue.

---

# Import Completion Criteria

The import phase is considered complete when:

- sql/01_schema.sql executes successfully
- orders_raw is populated
- product_supplier_raw is populated
- Expected row counts match
- Column mappings are verified
- Spot-check validation succeeds
- Raw staging data remains unchanged

---

# Final Status

Schema implementation complete.

orders_raw import complete and validated.

product_supplier_raw import complete and validated.

All staging-table imports successfully completed.

Phase 2 import objectives achieved.

---

# Next Step

Proceed to:

sql/03_data_cleaning.sql

to standardize source data, populate dimension tables, populate the fact table, and calculate derived metrics.