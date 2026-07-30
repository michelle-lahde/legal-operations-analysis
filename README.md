# Legal Operations Analytics Project

## Overview

This project demonstrates advanced SQL analytics applied to law firm operations data. Using a synthetic dataset of 150 legal matters spanning 2022–2024, I developed five interdependent SQL queries to uncover profitability drivers, attorney efficiency, cost management patterns, and timeline trends.

**Key Skills Demonstrated:**
- Advanced SQL (CTEs, Window Functions, Complex Joins, Date Calculations)
- Business analytics (profitability analysis, utilization metrics, variance analysis)
- Data interpretation and storytelling
- GitHub documentation and reproducibility

---

## Dataset Overview

**Source:** Synthetic law firm operations data (created with Python/Faker for portfolio demonstration)

**Tables:**
- `attorneys` (12 records) — Attorney ID, name, seniority level, hourly rate
- `matters` (150 records) — Case ID, practice area, case type, dates, budgeted vs. actual costs, settlement awards
- `billing` (5,157 records) — Monthly attorney billing by matter, hours, rates, billable status
- `expenses` (2,189 records) — Case costs (expert witnesses, court fees, research, travel, etc.)

**Date Range:** January 2022 – December 2024

---

## Queries & Business Questions

### 1. **Profitability by Practice Area**
**File:** `1_profitability_by_practice_area.sql`

**Business Question:** Which practice areas are most profitable, and where are we leaving money on the table?

**Technical Approach:**
- Two CTEs aggregate billing costs and expense costs per matter
- Joins revenue (settlement awards) with costs to calculate net profit and margin %
- Uses COALESCE and NULLIF for safe null handling

**Key Metrics:**
- Total revenue, total costs, net profit, profit margin %
- Identifies high-revenue/low-margin areas (efficiency issues) vs. hidden profit centers

---

### 2. **Attorney Utilization by Seniority Level**
**File:** `2_attorney_utilization_by_seniority.sql`

**Business Question:** How efficiently are we using attorney time at each seniority level? Who are our top revenue generators?

**Technical Approach:**
- Aggregates billable vs. non-billable hours by attorney
- Calculates utilization rate = (Billable Hours / Total Hours) × 100
- Window function ranks attorneys within their seniority bracket by revenue

**Key Metrics:**
- Billable hours, non-billable hours, utilization %, revenue, rank within seniority
- Reveals capacity planning gaps and top performers

---

### 3. **Cost Overrun Analysis**
**File:** `3_cost_overrun_analysis.sql`

**Business Question:** Which matters exceeded budget? By how much? Where are our estimation errors?

**Technical Approach:**
- Consolidates budgeted, actual billing, and expense costs per matter
- Calculates variance (actual – budgeted) and variance %
- CASE statement categorizes outcomes (OVERRUN, UNDER, ON_BUDGET)

**Key Metrics:**
- Actual vs. budgeted costs, variance amount, variance %, budget status
- Surfaces cases requiring mid-engagement cost controls

---

### 4. **Case Cycle Time Analysis**
**File:** `4_case_cycle_time_analysis.sql`

**Business Question:** How long does it take to close different case types? Where are the bottlenecks?

**Technical Approach:**
- DATEDIFF calculates days from open to close (handles pending cases with CURDATE())
- Aggregates statistics (avg, min, max, stddev) per case type
- Window function ranks case types by average closure time

**Key Metrics:**
- Days to close, variance, standard deviation, slowness rank
- Identifies unpredictable vs. consistent case types

---

### 5. **Expense Distribution**
**File:** `5_expense_distribution.sql`

**Business Question:** Which expense categories consume the most budget? Where are the cost levers?

**Technical Approach:**
- Groups all expenses by type
- Calculates totals, averages, min/max, and % of total firm expenses
- Identifies high-variance categories (pricing/scope inconsistency)

**Key Metrics:**
- Total amount, average expense, min/max, % of total, cost per instance
- Informs vendor negotiation and cost reduction strategies

---

## Technical Highlights

### SQL Techniques Used:
1. **Common Table Expressions (CTEs)** — Modular, readable query building
2. **Window Functions** — RANK(), PARTITION BY, ORDER BY for comparative analysis
3. **Complex Joins** — Multi-table aggregation (matters + billing + expenses)
4. **Date Calculations** — DATEDIFF for timeline analysis, CURDATE() for dynamic dates
5. **Conditional Aggregation** — CASE WHEN + SUM for category-specific metrics
6. **Safe Null Handling** — COALESCE and NULLIF for edge cases

### Data Integrity:
- Synthetic data ensures reproducibility and transparency
- Foreign key constraints maintain referential integrity
- All queries validated against known row counts and data ranges

---

## Key Findings

[See `findings.md` for detailed insights and business recommendations]

**Critical Insights:**

1. **Profitability Crisis**: All 5 practice areas show negative profit margins (-624% to -1,842%), indicating systemic cost overruns. IP performs best (-624%), Employment worst (-1,842%).

2. **Universal Cost Overruns**: 100% of matters exceed budget, with overruns averaging ~2,500% (actual costs are 25x budgeted). Worst case: +4,733% overrun.

3. **Healthy Utilization**: Attorneys average 67-72% billable utilization (above industry standard). Top performer: Gina Moore (Associate) generates $689K revenue, exceeding Partner average.

4. **Timeline Variability**: Case cycle times range from 288 days (Wrongful Termination) to 616 days (Commercial Lease). Opportunity to reduce slow cases by 50% through process improvements.

5. **Concentrated Expenses**: Expert Witnesses consume 32% of all firm expenses ($5.78M). A 20% reduction yields $1.16M annual savings.

**Recommended Actions:**
- Rebuild cost estimation methodology (Week 1–4)
- Implement mid-engagement cost reviews (Month 1)
- Negotiate Expert Witness rates (Month 1) → $1.16M savings
- Optimize cycle times for slow case types (Month 2–3)
- Deploy practice area reallocations (Month 3)

---

## How to Use This Project

### 1. Set Up Database
```sql
-- Create tables (schema.sql)
-- Import CSVs or use Python loader
```

### 2. Run Queries
Each `.sql` file is standalone and can be executed in MySQL Workbench or any SQL IDE. No dependencies between queries; each can run independently.

### 3. Interpret Results
Refer to the comments in each `.sql` file for:
- Business context (what question we're answering)
- Technical notes (why we wrote it this way)
- Insights to look for (what the numbers mean)

---

## Files in This Repo

```
legal-ops-analytics/
├── README.md (this file)
├── findings.md (detailed insights and recommendations)
├── schema.sql (CREATE TABLE statements)
├── /sql_queries/
│   ├── 1_profitability_by_practice_area.sql
│   ├── 2_attorney_utilization_by_seniority.sql
│   ├── 3_cost_overrun_analysis.sql
│   ├── 4_case_cycle_time_analysis.sql
│   └── 5_expense_distribution.sql
└── /data/
    ├── attorneys.csv
    ├── matters.csv
    ├── billing.csv
    └── expenses.csv
```

---

## Skills Demonstrated

- **SQL Proficiency:** Advanced queries (CTEs, window functions, multi-table joins)
- **Business Analytics:** Profitability modeling, utilization metrics, cost variance analysis
- **Data Interpretation:** Translating SQL results into actionable business insights
- **Documentation:** Clear, commented code and professional README
- **Reproducibility:** Synthetic data, schema, and queries all versioned in GitHub

---

## Notes on Synthetic Data

This dataset was generated synthetically for portfolio demonstration purposes. The data:
- Reflects realistic law firm patterns (cost distributions, case types, timelines)
- Maintains referential integrity (proper foreign key relationships)
- Allows for clear, reproducible analysis without data privacy concerns
- Is fully documented and auditable

---

## Next Steps / Future Enhancements

Potential extensions to this project:
- **Python EDA:** Jupyter notebook with statistical hypothesis testing (correlation between case type and cycle time)
- **Power BI Dashboard:** Interactive visualizations of profitability and utilization trends
- **Predictive Model:** Estimate case closure time or cost overrun risk based on case characteristics
- **Segmentation Analysis:** Cluster cases by profitability, efficiency, and risk profile

---

## Contact & Portfolio

This project is part of my data analytics portfolio. 

**Skills:** SQL, Python, Data Analysis, Business Intelligence, MySQL, Tableau, Power BI

**GitHub:** [link to your GitHub repo]
