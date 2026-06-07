# Findings Log

## Phase 0 — Dataset Reconnaissance

Date: 2026-06-04

### Finding 001 — Dataset Inventory

Orders Dataset

- 185,013 rows
- 9 columns
- No missing values

Products Dataset

- 5,504 rows
- 8 columns
- No missing values

---

### Finding 002 — Dataset Relationship

Product ID exists in both datasets.

Relationship validated:

Products (1) → Orders (Many)

Additional observations:

- Orders contains 3,124 unique products sold.
- Products table contains 5,504 products.
- No orphan Product IDs detected.
- Approximately 2,380 products were not sold during the observation period.

---

### Finding 003 — Customer Status Quality Issue

Observed inconsistent capitalization:

- Silver / SILVER
- Gold / GOLD
- Platinum / PLATINUM

Impact:

Customer segmentation results may be inaccurate without standardization.

Reference:

See cleaning_decisions.md.

---

### Finding 004 — Date Field Validation

Fields validated:

- Date Order was placed
- Delivery Date

Results:

- Successfully converted to datetime format
- No parsing errors detected
- Suitable for SQL DATE columns

---

### Finding 005 — Product Hierarchy Validation

Unique values identified:

- Product Line: 4
- Product Category: 13
- Product Group: 58
- Products: 5,504

Validation results:

- 58 Product Groups identified
- 58 unique Product Line → Product Category → Product Group combinations identified

Conclusion:

The hierarchy appears suitable for dimensional modeling.

---

### Finding 006 — Supplier Hierarchy Validation

Validation results:

- 64 Supplier IDs
- 64 Supplier Names
- Each Supplier ID maps to exactly one Supplier Name
- Each Supplier ID maps to exactly one Supplier Country

Conclusion:

Supplier information satisfies normalization requirements and supports creation of a dedicated supplier dimension.

---

### Finding 007 — Preliminary Data Model

Evidence supports the following structure.

Fact Table:

- fact_orders

Dimension Tables:

- dim_product
- dim_supplier
- dim_customer_status

Potential Future Dimension:

- dim_date

---

## Phase 0 Conclusion

Reconnaissance completed successfully.

Validated:

- Dataset structure
- Dataset relationships
- Product hierarchy
- Supplier hierarchy
- Date conversion feasibility
- Missing value assessment
- Dimensional modeling suitability

Identified Risks:

- Customer Status capitalization inconsistencies

Recommended Next Phase:

Phase 1 — Schema Design and Dimensional Modeling

Status: COMPLETE

---

# Phase 2 — Data Cleaning and Dimensional Population

Date: 2026-06-05

### Finding 008 — Customer Status Dimension Created

A dedicated customer status dimension was implemented to standardize customer segmentation.

Dimension Mapping:

- 1 = Gold
- 2 = Platinum
- 3 = Silver

Validation Results:

- 3 rows loaded
- No duplicate customer statuses identified
- Fixed surrogate keys implemented

Business Impact:

Customer segmentation is now standardized and reproducible across database rebuilds.

---

### Finding 009 — Supplier Dimension Created

A supplier dimension was populated from validated supplier source data.

Validation Results:

- 64 suppliers loaded
- No duplicate supplier IDs detected
- No duplicate supplier relationships identified

Business Impact:

Supplier-level reporting and performance analysis are now supported.

---

### Finding 010 — Product Dimension Created

A product dimension was populated using the validated product hierarchy.

Validation Results:

- 5,504 products loaded
- No duplicate product IDs detected
- Supplier relationships successfully resolved

Business Impact:

Analysis can now be performed at:

- Product Line level
- Product Category level
- Product Group level
- Individual Product level

---

### Finding 011 — Fact Table Populated

The central fact table was successfully populated from the orders dataset.

Validation Results:

- 185,013 rows loaded
- All customer status relationships resolved
- All product relationships resolved

Business Impact:

The dimensional warehouse is fully operational and ready for analytical reporting.

---

### Finding 012 — Derived Metrics Implemented

Additional business metrics were calculated during ETL processing.

Derived Fields:

- delivery_days
- estimated_cost
- estimated_profit
- gross_margin_pct

Business Impact:

Analytical queries no longer need to repeatedly calculate core business metrics.

---

### Finding 013 — Date Conversion Validation

Order and delivery dates were successfully converted to SQL DATE format.

Validation Results:

- Invalid order dates: 0
- Invalid delivery dates: 0
- Null order dates: 0
- Null delivery dates: 0
- Negative delivery durations: 0

Conclusion:

Date fields are suitable for trend analysis and time-series reporting.

---

### Finding 014 — Referential Integrity Validation

Relationships between all fact and dimension tables were validated.

Validation Results:

- Missing products in fact table: 0
- Missing customer statuses in fact table: 0
- Missing supplier relationships in product dimension: 0

Conclusion:

The dimensional warehouse satisfies referential-integrity requirements.

---

### Finding 015 — Warehouse Readiness Assessment

Final Warehouse Structure:

| Table | Rows |
|---------|---------:|
| dim_customer_status | 3 |
| dim_supplier | 64 |
| dim_product | 5,504 |
| fact_orders | 185,013 |

Assessment:

The dimensional warehouse has been successfully built and validated.

The warehouse is suitable for:

- Executive KPI reporting
- Customer segmentation analysis
- Product performance analysis
- Supplier performance analysis
- Time-series analysis
- Python visualization and reporting

---

## Phase 2 Conclusion

Data cleaning, dimensional population, ETL processing, and warehouse validation completed successfully.

Validated:

- Customer status standardization
- Product hierarchy implementation
- Supplier hierarchy implementation
- Fact table population
- Derived metric calculations
- Referential integrity
- Date conversion quality
- Warehouse completeness

Recommended Next Phase:

Phase 3 — Analytical SQL Query Development

Objectives:

- Build executive KPI queries
- Analyze customer segments
- Analyze product performance
- Analyze supplier performance
- Analyze temporal trends
- Generate business findings for portfolio reporting

Status: COMPLETE

---

# Phase 3 — Analytical SQL Query Development

Date: 2026-06-06

### Finding 016 — Executive KPI Summary

Key Results:

- Total Revenue: $25,641,505.45
- Total Estimated Profit: $13,618,414.13
- Total Orders: 185,013
- Unique Customers: 56,027
- Average Revenue per Order: $138.59
- Average Profit per Order: $73.61
- Overall Profit Margin: 53.11%

Business Insight:

The business generated more than $25.6 million in revenue while maintaining a profit margin above 53%, indicating strong overall profitability.

---

### Finding 017 — Customer Status Performance Analysis

Revenue by Customer Status:

| Customer Status | Revenue |
|-----------------|---------:|
| Silver | $12,884,922.29 |
| Gold | $12,172,776.44 |
| Platinum | $583,806.72 |

Profit by Customer Status:

| Customer Status | Profit |
|-----------------|--------:|
| Silver | $6,845,616.60 |
| Gold | $6,462,353.74 |
| Platinum | $310,443.79 |

Observation:

- Silver customers generated the highest revenue.
- Gold customers closely followed Silver customers.
- Platinum customers represented a very small portion of overall sales activity.

Business Insight:

Revenue concentration is heavily dependent on Silver and Gold customers. Platinum customers contribute relatively little despite representing a premium customer segment.

---

### Finding 018 — Product Category Performance Analysis

Top Categories by Revenue:

| Category | Revenue |
|-----------|---------:|
| Outdoors | $5,688,483.11 |
| Assorted Sports Articles | $4,502,534.42 |
| Shoes | $4,132,132.90 |
| Clothes | $4,002,919.25 |
| Winter Sports | $1,641,264.50 |

Top Categories by Profit:

| Category | Profit |
|-----------|--------:|
| Outdoors | $2,999,977.81 |
| Assorted Sports Articles | $2,300,128.47 |
| Shoes | $2,131,864.00 |
| Clothes | $2,126,413.05 |
| Winter Sports | $924,165.65 |

Highest Profit Margins:

| Category | Profit Margin |
|-----------|--------------:|
| Racket Sports | 60.51% |
| Swim Sports | 58.19% |
| Winter Sports | 56.31% |
| Running - Jogging | 56.07% |
| Golf | 54.35% |

Business Insight:

Outdoors is the dominant category in both revenue and profit generation, while Racket Sports achieves the highest profitability efficiency despite lower sales volume.

---

### Finding 019 — Supplier Performance Analysis

Top Suppliers by Revenue:

| Supplier | Revenue |
|-----------|---------:|
| Eclipse Inc | $3,681,765.17 |
| Magnifico Sports | $1,701,185.40 |
| 3Top Sports | $1,696,429.39 |
| Twain Inc | $1,557,025.55 |
| Petterson AB | $1,403,886.70 |

Top Suppliers by Profit:

| Supplier | Profit |
|-----------|--------:|
| Eclipse Inc | $1,827,973.62 |
| 3Top Sports | $922,012.79 |
| Magnifico Sports | $800,598.45 |
| Twain Inc | $792,475.60 |
| Petterson AB | $745,464.35 |

Highest Supplier Profit Margins:

| Supplier | Profit Margin |
|-----------|--------------:|
| Mike Schaeffer Inc | 90.15% |
| British Sports Ltd | 63.61% |
| Dolphin Sportswear Inc | 61.48% |
| Triffy B.V. | 60.86% |
| Svensson Trading AB | 60.84% |

Business Insight:

Eclipse Inc is the company's most important supplier by both revenue and profit contribution, while several smaller suppliers generate exceptionally high profit margins.

---

### Finding 020 — Product Category Year-over-Year Growth Analysis

Business Question:

Which product categories experienced the strongest growth or decline each year?

Method:

Revenue was aggregated by Product Category and Year.

Year-over-Year growth was calculated using SQL window functions (LAG) to compare each category against its prior-year revenue.

---

2018 Growth Leaders:

| Category | Growth |
|-----------|--------:|
| Team Sports | 33.54% |
| Indoor Sports | 32.66% |
| Winter Sports | 29.33% |
| Assorted Sports Articles | 23.47% |
| Golf | 22.18% |

Observation:

All categories experienced positive growth during 2018.

---

2019 Growth Leaders:

| Category | Growth |
|-----------|--------:|
| Team Sports | 31.67% |
| Racket Sports | 30.85% |
| Golf | 28.52% |
| Running - Jogging | 27.36% |
| Clothes | 25.01% |

Observation:

2019 represented the strongest expansion year across the dataset.

All product categories achieved positive revenue growth.

---

2020 Revenue Contraction:

| Category | Growth |
|-----------|--------:|
| Indoor Sports | -37.33% |
| Racket Sports | -23.44% |
| Golf | -19.96% |
| Shoes | -18.61% |
| Clothes | -16.07% |

Observation:

Every category experienced revenue decline during 2020.

Indoor Sports experienced the largest contraction.

---

2021 Recovery:

| Category | Growth |
|-----------|--------:|
| Indoor Sports | 106.30% |
| Children Sports | 34.60% |
| Swim Sports | 33.87% |
| Team Sports | 25.22% |
| Golf | 24.46% |

Observation:

2021 showed a strong recovery across nearly all categories.

Indoor Sports more than doubled revenue relative to 2020.

---

Long-Term Trend:

- Revenue growth was broadly positive from 2017 through 2019.
- 2020 produced widespread category declines.
- 2021 produced strong category recovery.
- Indoor Sports exhibited the highest volatility across the study period.
- Outdoors remained the largest revenue-generating category throughout the dataset.

Business Insight:

Large categories such as Outdoors and Assorted Sports Articles drive overall revenue, while smaller categories such as Indoor Sports and Team Sports demonstrate the strongest growth potential.

---

## Phase 3 Status

Completed:

- Executive KPI analysis
- Customer segment analysis
- Product category performance analysis
- Supplier performance analysis
- Product category trend analysis
- Product category profit trend analysis
- Supplier revenue trend analysis
- Supplier profit trend analysis
- Supplier revenue concentration analysis
- Supplier profit concentration analysis

Current Phase Status:

COMPLETION

Next Planned Analysis:

- Supplier profit concentration analysis
- Additional temporal trend analysis
- Portfolio reporting preparation
- Python visualization phase

### Finding 021 — Product Category Profit Trend Analysis

Business Question:

How has profitability changed across product categories over time?

Method:

Estimated profit was aggregated by Product Category and Year using the validated fact table.

Revenue and profit trends were compared to evaluate whether category growth translated into increased profitability.

---

Top Profit-Generating Categories by Year

2017

| Category | Profit |
|-----------|--------:|
| Outdoors | $466,056.15 |
| Shoes | $359,958.85 |
| Assorted Sports Articles | $357,828.21 |
| Clothes | $341,985.29 |
| Winter Sports | $142,573.15 |

2018

| Category | Profit |
|-----------|--------:|
| Outdoors | $540,725.66 |
| Assorted Sports Articles | $437,353.58 |
| Shoes | $414,284.75 |
| Clothes | $400,787.51 |
| Winter Sports | $183,102.44 |

2019

| Category | Profit |
|-----------|--------:|
| Outdoors | $664,580.87 |
| Assorted Sports Articles | $526,068.93 |
| Clothes | $502,195.58 |
| Shoes | $484,280.95 |
| Winter Sports | $204,084.16 |

2020

| Category | Profit |
|-----------|--------:|
| Outdoors | $605,507.77 |
| Assorted Sports Articles | $455,418.12 |
| Clothes | $422,108.01 |
| Shoes | $393,723.75 |
| Winter Sports | $186,443.48 |

2021

| Category | Profit |
|-----------|--------:|
| Outdoors | $723,107.36 |
| Assorted Sports Articles | $523,459.63 |
| Shoes | $479,615.70 |
| Clothes | $459,336.66 |
| Winter Sports | $207,962.42 |

---

Key Observations

- Outdoors was the highest profit-generating category in every year of the dataset.
- Assorted Sports Articles, Shoes, and Clothes consistently ranked among the top four profit contributors.
- Profit growth accelerated between 2017 and 2019 across nearly all categories.
- Most categories experienced profit declines during 2020.
- Profitability recovered during 2021 and exceeded prior-year levels in most categories.

---

Category Stability Assessment

Most Stable Categories:

- Outdoors
- Assorted Sports Articles
- Shoes
- Clothes

These categories consistently generated high profit throughout the entire study period and appear to represent the core profit drivers of the business.

Highest Volatility:

- Indoor Sports
- Team Sports
- Swim Sports

These categories experienced larger percentage fluctuations from year to year due to their smaller revenue and profit bases.

---

Relationship Between Revenue and Profit

Comparison with Finding 020 shows that profit trends closely followed revenue trends across all categories.

This indicates:

- Revenue growth generally translated into profit growth.
- Revenue declines generally translated into profit declines.
- No major category exhibited strong revenue growth accompanied by deteriorating profitability.

---

Business Insight

The business appears to maintain relatively consistent profitability across product categories.

Growth in major categories such as Outdoors, Assorted Sports Articles, Shoes, and Clothes contributes directly to both revenue expansion and profit expansion.

These categories represent the strongest long-term profit engines within the product portfolio.


### Finding 022 — Supplier Revenue Trend Analysis

Supplier revenue was analyzed across the full observation period from 2017 to 2021.

Key Findings:

- Eclipse Inc was the highest-revenue supplier in every year of the analysis.
- Supplier rankings remained relatively stable across the observation period.
- Revenue generation is concentrated among a small group of major suppliers.
- Several leading suppliers experienced revenue declines during 2020.
- Most major suppliers recovered in 2021.

Top Consistent Suppliers:

- Eclipse Inc
- 3Top Sports
- Magnifico Sports
- Twain Inc
- Petterson AB
- AllSeasons Outdoor Clothing
- Top Sports
- Luna sastreria S.A.

Business Insight:

The supplier portfolio appears stable and mature, with a relatively small group of suppliers driving the majority of revenue.

Temporary declines observed during 2020 affected multiple suppliers simultaneously, suggesting broader market conditions rather than supplier-specific performance issues.

Revenue recovery in 2021 indicates resilience within the supplier network.

### Finding 023 — Supplier Profit Trend Analysis

Supplier profit was analyzed by year to determine whether the highest-revenue suppliers also remained the strongest profit contributors.

Key Findings:

- Eclipse Inc was the highest-profit supplier in every year from 2017 to 2021.
- 3Top Sports consistently ranked among the top profit contributors.
- Magnifico Sports, Twain Inc, Petterson AB, and AllSeasons Outdoor Clothing remained strong profit contributors across the observation period.
- Supplier profit declined broadly in 2020, matching the revenue slowdown observed in supplier revenue trends.
- Supplier profit recovered in 2021 for most major suppliers.

Eclipse Inc Profit by Year:

| Year | Profit |
|------|--------:|
| 2017 | $307,954.80 |
| 2018 | $357,105.57 |
| 2019 | $419,419.48 |
| 2020 | $342,919.96 |
| 2021 | $400,573.81 |

Business Insight:

Eclipse Inc is the most strategically important supplier by both revenue and profit. Its consistent top ranking suggests strong supplier dependence and potential concentration risk.

The supplier network showed broad profit recovery in 2021 after the 2020 decline, indicating resilience among the major supplier base.

### Finding 024 — Supplier Revenue Concentration Analysis

#### Objective

Evaluate revenue dependency across suppliers and identify potential concentration risk within the supplier network.

#### Key Findings

Revenue generation is concentrated among a relatively small number of suppliers.

Top Revenue-Contributing Suppliers:

| Supplier | Revenue Share (%) |
|-----------|-----------:|
| Eclipse Inc | 14.36 |
| Magnifico Sports | 6.63 |
| 3Top Sports | 6.62 |
| Twain Inc | 6.07 |
| Petterson AB | 5.48 |

Combined Revenue Share of Top Five Suppliers:

39.16%

Additional observations:

- Eclipse Inc alone contributes more than 14% of total company revenue.
- The second through fifth largest suppliers each contribute between 5% and 7%.
- Revenue distribution becomes significantly fragmented after the top supplier group.
- Most suppliers contribute less than 2% of total revenue individually.

#### Business Insight

The business demonstrates moderate supplier concentration.

While the supplier network contains 64 suppliers, nearly 40% of total revenue is associated with only five suppliers.

Eclipse Inc represents the most strategically important supplier relationship, contributing more than twice the revenue share of most other major suppliers.

This concentration creates potential operational risk if key supplier relationships are disrupted. However, the remaining 60% of revenue is distributed across a broad supplier base, indicating that supplier diversification still exists.

#### Strategic Implications

- Maintain strong relationships with top suppliers.
- Monitor supplier concentration risk regularly.
- Consider diversification initiatives for categories heavily dependent on a small supplier group.
- Develop contingency plans for critical suppliers such as Eclipse Inc.


### Finding 025 — Supplier Profit Concentration Analysis

#### Business Question

How concentrated is company profitability among suppliers, and does profit dependency mirror revenue dependency?

#### Key Findings

Profit generation is concentrated among a relatively small group of suppliers.

Top Profit-Contributing Suppliers:

| Supplier | Profit Share (%) |
|-----------|-----------:|
| Eclipse Inc | 13.42 |
| 3Top Sports | 6.77 |
| Magnifico Sports | 5.88 |
| Twain Inc | 5.82 |
| Petterson AB | 5.47 |

Combined Profit Share of Top Five Suppliers:

37.36%

Additional observations:

- Eclipse Inc remains the largest contributor to company profitability.
- Eclipse Inc generates over 13% of total profit.
- The remaining top suppliers each contribute between 5% and 7% of total profit.
- Profit contribution is distributed slightly more broadly than revenue contribution.
- Most suppliers contribute less than 2% of total profit individually.

#### Business Insight

The supplier network demonstrates moderate profit concentration.

While Eclipse Inc remains the most strategically important supplier, profit generation is slightly less concentrated than revenue generation.

The top five suppliers account for approximately 37% of total profit compared to approximately 39% of total revenue.

This suggests that profitability is distributed more evenly across the supplier base than revenue alone would indicate.

The business therefore benefits from some diversification of profit sources, reducing dependence on a single supplier for overall profitability.

#### Strategic Implications

- Maintain strong relationships with high-profit suppliers.
- Evaluate supplier performance using both revenue and profit metrics.
- Monitor suppliers that generate large revenue volumes but relatively lower profit contribution.
- Continue diversification efforts to reduce supplier concentration risk.

## Phase 3 Conclusion

Analytical SQL query development has been successfully completed.

Business areas analyzed:

- Executive KPIs
- Customer segments
- Product category performance
- Product category trends
- Product category profitability
- Supplier performance
- Supplier revenue trends
- Supplier profit trends
- Revenue concentration
- Profit concentration

Key strategic findings:

- Revenue and profit recovered strongly in 2021 following a decline in 2020.
- Outdoors remained the largest revenue-generating product category.
- Customer revenue is concentrated within the Silver and Gold segments.
- Eclipse Inc is the most strategically important supplier by both revenue and profit contribution.
- Revenue and profit concentration exist but remain distributed across a diversified supplier network.

Recommended Next Phase:

Phase 4 — Python Analysis & Visualization

Objectives:

- Create analytical visualizations
- Validate SQL findings visually
- Build portfolio-ready charts
- Develop a polished analytical notebook
- Produce final business recommendations

Status: READY FOR PHASE 4


# Phase 4 – Python Visualization Preparation

Date: 2026-06-06

### Export Validation 001 – Yearly KPI Summary

Validation Status:

APPROVED

Key Observations:

- Revenue increased from $4.05M in 2017 to $5.94M in 2021.
- Profit increased from $2.16M in 2017 to $3.15M in 2021.
- Order volume grew from 29,549 orders to 42,565 orders.
- Revenue and profit declined during 2020 before recovering strongly in 2021.

Business Insight:

The business demonstrated strong long-term growth despite a temporary downturn in 2020. Revenue, profit, and order volume all reached their highest levels in 2021.

---

### Export Validation 002 – Customer Segment Summary

Validation Status:

APPROVED

Key Observations:

- Silver customers generated the highest revenue and profit contribution.
- Gold customers performed nearly identically to Silver customers.
- Platinum customers contributed only a small portion of overall revenue.
- Average order value remained consistent across all customer segments.

Business Insight:

Business performance is primarily driven by Silver and Gold customers. Segment differences are explained by order volume rather than average order value.

---

### Export Validation 003 – Product Category Revenue Summary

Validation Status:

APPROVED

Key Observations:

- Outdoors is the largest product category by both revenue and profit.
- Clothes generates the highest order volume but trails Outdoors in revenue and profitability.
- Revenue and profit rankings are highly aligned across categories.
- The top four categories dominate overall business performance.

Business Insight:

Outdoors, Assorted Sports Articles, Shoes, and Clothes represent the core revenue and profit engines of the business and should receive priority emphasis in future visualizations.

---

## Phase 4 Status

Completed:

- Export 01 validation
- Export 02 validation
- Export 03 validation
- Export 04 validation
- Export 05 validation
- Export 06 validation

Current Focus:

- Export dataset creation
- Visualization dataset preparation
- Notebook planning

Next Planned Exports:

- None

Status: EXPORT DATASETS COMPLETE

### Export Validation 004 – Supplier Revenue Summary

Validation Status:

APPROVED

Key Observations:

- Eclipse Inc is the largest supplier by both revenue and profit contribution.
- Eclipse Inc generated approximately $3.68M in revenue and $1.83M in profit.
- The next four suppliers (Magnifico Sports, 3Top Sports, Twain Inc, and Petterson AB) form a clear second tier of strategic suppliers.
- Revenue concentration declines significantly after the top supplier group.
- Several suppliers generate relatively high profits despite lower revenue volumes.

Top Revenue-Contributing Suppliers:

| Supplier | Revenue |
|-----------|---------:|
| Eclipse Inc | $3,681,765.17 |
| Magnifico Sports | $1,701,185.40 |
| 3Top Sports | $1,696,429.39 |
| Twain Inc | $1,557,025.55 |
| Petterson AB | $1,403,886.70 |

Business Insight:

The supplier portfolio exhibits moderate concentration, with Eclipse Inc serving as the most strategically important supplier.

The top supplier group drives a substantial share of company revenue and profit, while the broader supplier network provides diversification and reduces excessive dependence on a single partner.

Visualization Recommendation:

Future supplier charts should focus on the Top 10 suppliers by revenue while grouping smaller suppliers into an "Other Suppliers" category to improve readability and highlight the most influential supplier relationships.


### Export Validation 005 – Supplier Profit Summary

Validation Status:

APPROVED

Key Observations:

- Eclipse Inc remains the largest profit-generating supplier.
- Eclipse Inc generated approximately $1.83M in total profit.
- The top five suppliers by profit are identical to the top five suppliers by revenue.
- Several smaller suppliers exhibit exceptionally high profit margins despite relatively low sales volume.
- Supplier profitability is broadly distributed across the supplier network.

Top Profit-Contributing Suppliers:

| Supplier | Profit |
|-----------|--------:|
| Eclipse Inc | $1,827,973.62 |
| 3Top Sports | $922,012.79 |
| Magnifico Sports | $800,598.45 |
| Twain Inc | $792,475.60 |
| Petterson AB | $745,464.35 |

Highest Supplier Profit Margins:

| Supplier | Profit Margin |
|-----------|--------------:|
| Mike Schaeffer Inc | 90.15% |
| British Sports Ltd | 63.61% |
| Dolphin Sportswear Inc | 61.48% |
| Triffy B.V. | 60.86% |
| Svensson Trading AB | 60.84% |

Business Insight:

Profit concentration closely mirrors revenue concentration, indicating that the company's largest suppliers are also its most profitable supplier relationships.

However, several smaller suppliers generate exceptionally high margins and may represent niche opportunities for future growth or supplier development initiatives.

Visualization Recommendation:

Create both:

- Top 10 Suppliers by Profit
- Top 10 Suppliers by Profit Margin

These charts will highlight the difference between supplier scale and supplier efficiency.


### Export Validation 006 – Product Profitability Summary

Validation Status:

APPROVED

Key Observations:

- Racket Sports has the highest product category profit margin at 60.51%.
- Swim Sports has the second-highest margin at 58.19%.
- Winter Sports, Running - Jogging, and Golf also show strong profitability efficiency.
- Outdoors remains the largest category by revenue and profit, but it does not have the highest margin.
- Assorted Sports Articles generates high total revenue but has the lowest profit margin among the listed categories.

Top Profit Margin Categories:

| Category | Profit Margin |
|-----------|--------------:|
| Racket Sports | 60.51% |
| Swim Sports | 58.19% |
| Winter Sports | 56.31% |
| Running - Jogging | 56.07% |
| Golf | 54.35% |

Business Insight:

The most profitable categories by margin are not necessarily the largest categories by revenue.

Racket Sports and Swim Sports represent high-efficiency categories, while Outdoors represents a high-scale category.

This distinction will be useful in the notebook when comparing business scale versus profitability efficiency.

Visualization Recommendation:

Create a product category profit margin bar chart to compare profitability efficiency across categories.


### Export Validation 007 – Delivery Performance Summary

Validation Status:

APPROVED

Key Observations:

- Delivery performance is highly consistent across all product categories.
- Average delivery times range from 0.93 to 1.36 days.
- Indoor Sports has the longest average delivery time at 1.36 days.
- Team Sports and Clothes have the shortest average delivery times at 0.93 days.
- All categories demonstrate relatively efficient delivery operations.
- Differences between categories are operationally small.

Delivery Performance Ranking:

| Category | Average Delivery Days |
|-----------|---------------------:|
| Indoor Sports | 1.36 |
| Racket Sports | 1.24 |
| Assorted Sports Articles | 1.20 |
| Outdoors | 1.18 |
| Winter Sports | 1.18 |
| Running - Jogging | 1.10 |
| Swim Sports | 1.07 |
| Children Sports | 0.99 |
| Shoes | 0.96 |
| Golf | 0.95 |
| Clothes | 0.93 |
| Team Sports | 0.93 |

Business Insight:

Delivery performance does not appear to be a significant differentiator between product categories.

The business demonstrates consistently fast order fulfillment across the entire product portfolio, suggesting a mature and efficient logistics process.

Visualization Recommendation:

Create a delivery performance comparison chart to visually confirm operational consistency across categories.