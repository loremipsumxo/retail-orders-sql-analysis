# Cleaning Decisions

## Customer Status Standardization

### Issue

Customer Status values are stored as text and capitalization inconsistencies were identified during dataset reconnaissance.

### Reconnaissance Findings

Initial reconnaissance identified multiple capitalization patterns, including:

- Silver
- SILVER
- Gold
- GOLD
- Platinum
- PLATINUM

### Import Validation Findings

Validation performed after importing the source data into orders_raw identified the following distinct values:

- Gold
- PLATINUM
- Silver

Validation query:

sql SELECT DISTINCT customer_status FROM orders_raw ORDER BY customer_status; 

### Note

The reconnaissance phase identified additional capitalization variants that were not present in the imported staging data.

The cleaning rule remains unchanged because the dimensional model should protect against future capitalization inconsistencies regardless of whether all capitalization variants are present in the current dataset.

### Impact

Without standardization, customer tiers could be treated as separate categories during aggregation, reporting, and visualization.

Examples:

- Silver and SILVER
- Gold and GOLD
- Platinum and PLATINUM

This would lead to inaccurate customer-segment counts and misleading analytical results.

### Cleaning Decision

Standardize Customer Status values using a title-case format during dimensional population.

Target values:

- Silver
- Gold
- Platinum

Examples:

- SILVER → Silver
- GOLD → Gold
- PLATINUM → Platinum

### Implementation Approach

Customer Status values will be standardized before insertion into dim_customer_status and again during the fact-table population process to ensure consistent joins between staging and dimensional tables.

The transformation logic will be implemented in:

text sql/03_data_cleaning.sql 

### Justification

Standardization ensures:

- Consistent customer segmentation
- Accurate aggregation and reporting
- Reliable dimensional joins
- Reproducible analytical results

### Status

Approved for implementation during Phase 2A — Data Cleaning and Dimensional Population.