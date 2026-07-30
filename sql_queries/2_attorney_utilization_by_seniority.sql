/*
===============================================
ATTORNEY UTILIZATION & REVENUE BY SENIORITY LEVEL
===============================================

BUSINESS QUESTION:
How efficiently are attorneys billing hours at each seniority level?
Who are the top revenue generators in each bracket?

APPROACH:
- CTE 'attorney_hours': Separates billable vs. non-billable hours per attorney
- CTE 'seniority_totals': Aggregates hours and revenue by seniority level
- Window function RANK(): Ranks attorneys within their seniority bracket by revenue
- Utilization % = (Billable Hours / Total Hours) * 100

KEY INSIGHTS TO LOOK FOR:
- Are Partners generating more revenue per hour than Associates?
- Which seniority level has the highest utilization rate?
- Outliers: Partners with low utilization (client management?) vs. high performers
- Non-billable hours by level (training, admin, etc.)

TECHNICAL NOTES:
- CASE WHEN + SUM aggregates billable vs. non-billable separately
- Window function RANK OVER PARTITION BY allows comparison within groups
- Utilization % reveals efficiency, not just total revenue
===============================================
*/

WITH attorney_hours AS (
    SELECT 
        a.attorney_id,
        a.attorney_name,
        a.seniority_level,
        b.billable_status,
        SUM(b.hours_worked) as hours,
        SUM(b.amount) as revenue
    FROM attorneys a
    LEFT JOIN billing b ON a.attorney_id = b.attorney_id
    GROUP BY a.attorney_id, a.seniority_level, b.billable_status
),

seniority_totals AS (
    SELECT 
        seniority_level,
        attorney_id,
        attorney_name,
        SUM(CASE WHEN billable_status = 'Billable' THEN hours ELSE 0 END) as billable_hours,
        SUM(CASE WHEN billable_status = 'Non-Billable' THEN hours ELSE 0 END) as non_billable_hours,
        SUM(hours) as total_hours,
        SUM(CASE WHEN billable_status = 'Billable' THEN revenue ELSE 0 END) as billable_revenue
    FROM attorney_hours
    GROUP BY seniority_level, attorney_id, attorney_name
)

SELECT 
    seniority_level,
    attorney_name,
    ROUND(total_hours, 1) as total_hours,
    ROUND(billable_hours, 1) as billable_hours,
    ROUND(non_billable_hours, 1) as non_billable_hours,
    ROUND(billable_hours / NULLIF(total_hours, 0) * 100, 2) as utilization_pct,
    ROUND(billable_revenue, 2) as revenue,
    RANK() OVER (PARTITION BY seniority_level ORDER BY billable_revenue DESC) as revenue_rank_in_level
FROM seniority_totals
WHERE total_hours > 0
ORDER BY seniority_level, revenue_rank_in_level;