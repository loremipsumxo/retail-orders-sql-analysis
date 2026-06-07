# Analysis Plan

## Phase 4 — Python Analysis & Visualization

### Status

Complete

Date: 2026-06-06

---

# Purpose

This document defines the objectives, visualization strategy, notebook structure, reporting approach, and deliverables for Phase 4 of the Retail Orders SQL Analysis project.

Phase 3 successfully produced validated business findings through SQL analysis.

The objective of Phase 4 is to transform those findings into clear visualizations, business storytelling, and a portfolio-ready analytical notebook.

---

# Phase 3 Summary

The following analytical areas were completed during Phase 3:

- Executive KPI analysis
- Customer segment analysis
- Product category performance analysis
- Product category year-over-year growth analysis
- Product category profit trend analysis
- Supplier performance analysis
- Supplier revenue trend analysis
- Supplier profit trend analysis
- Supplier revenue concentration analysis
- Supplier profit concentration analysis

Total documented findings:

- Findings 001–025

Phase 3 Status:

COMPLETE

---

# Primary Business Findings

Key findings from SQL analysis include:

- Revenue and profit declined during 2020 and recovered strongly in 2021.
- Outdoors remained the highest revenue-generating product category throughout the observation period.
- Assorted Sports Articles, Shoes, and Clothes consistently ranked among the strongest-performing categories.
- Smaller categories such as Team Sports and Indoor Sports demonstrated strong growth rates despite lower revenue volume.
- Customer revenue was concentrated within the Silver and Gold customer segments.
- Eclipse Inc was the largest supplier by both revenue and profit contribution.
- Revenue and profit concentration exist within the supplier network, but business value remains distributed across a diversified supplier base.

---

# Phase 4 Objectives

The visualization phase seeks to:

- Validate SQL findings visually
- Communicate business insights clearly
- Create portfolio-quality charts
- Develop a polished analytical notebook
- Produce executive-ready reporting outputs
- Support business recommendations with visual evidence

---

# Data Sources

Data for visualization will be extracted from the validated dimensional warehouse.

### Fact Table

- fact_orders

### Dimension Tables

- dim_customer_status
- dim_product
- dim_supplier

---

# Visualization Roadmap

## Section 1 — Executive KPI Dashboard

Purpose:

Provide a high-level overview of business performance.

Visualizations:

- KPI summary table
- Revenue by year
- Profit by year
- Orders by year

Business Questions:

- How did overall business performance change over time?
- How did 2020 affect performance?
- How strong was the 2021 recovery?

---

## Section 2 — Customer Segment Analysis

Visualizations:

- Revenue by customer status
- Profit by customer status
- Order count by customer status

Business Questions:

- Which customer segments generate the most value?
- How concentrated is customer revenue?

Expected Finding:

Revenue and profit are concentrated within Silver and Gold customers.

---

## Section 3 — Product Category Performance

Visualizations:

- Revenue by product category
- Profit by product category
- Top product categories by revenue
- Top product categories by profit

Business Questions:

- Which categories drive overall business performance?
- Which categories are most profitable?

Expected Finding:

Outdoors, Assorted Sports Articles, Shoes, and Clothes dominate overall performance.

---

## Section 4 — Product Category Growth Trends

Visualizations:

- Revenue trend by category (2017–2021)
- Growth-rate comparison charts
- Product category ranking changes over time

Business Questions:

- Which categories are growing fastest?
- Which categories recovered most strongly after 2020?

Expected Finding:

Indoor Sports and Team Sports show strong growth despite smaller revenue bases.

---

## Section 5 — Supplier Performance Analysis

Visualizations:

- Top suppliers by revenue
- Top suppliers by profit
- Supplier trend analysis

Business Questions:

- Which suppliers contribute the most value?
- How dependent is the business on key suppliers?

Expected Finding:

Eclipse Inc remains the dominant supplier throughout the observation period.

---

## Section 6 — Supplier Concentration Analysis

Visualizations:

- Revenue share by supplier
- Profit share by supplier
- Top 10 supplier contribution charts

Business Questions:

- How concentrated is supplier performance?
- What operational risks exist from supplier dependency?

Expected Finding:

A relatively small number of suppliers contribute a substantial share of revenue and profit.

---

# Notebook Structure

The published notebook will follow the portfolio standard.

## 1. Objective

Project goals and business questions.

## 2. Data Loading

Load exported analytical datasets.

## 3. Data Validation

Verify dataset quality and structure.

## 4. Analysis

Review SQL findings and supporting metrics.

## 5. Visualizations

Present business findings using charts and tables.

## 6. Key Findings

Summarize major business insights.

## 7. Limitations

Document assumptions and analytical constraints.

## 8. Conclusion

Provide final business recommendations.

---

# Technical Deliverables

### Python

- Data extraction scripts
- Visualization scripts

### Notebook

- notebooks/retail_orders_analysis.ipynb

### Charts

- exports/charts/

### Reports

- findings_log.md
- analysis_notes.md

---

# Completion Criteria

Phase 4 is complete. The project has:

- All major SQL findings are visualized
- Visualizations validate SQL conclusions
- Portfolio-quality charts are created
- Analytical notebook is completed
- Findings are documented and reproducible
- Final business recommendations are supported by visual evidence

---

# Final Outputs

Final Phase 4 outputs include:

- `notebooks/retail_orders_analysis.ipynb`
- `exports/charts/`
- `exports/datasets/`
- `exports/reports/retail_orders_analysis.html`
- `exports/reports/retail_orders_analysis.pdf`

Status: PHASE 4 COMPLETE
