/*
===============================================
PROFITABILITY ANALYSIS BY PRACTICE AREA
===============================================

BUSINESS QUESTION:
Which practice areas generate the highest profit margins? 
This helps identify which service lines are most valuable to the firm
and which may need pricing adjustments.

APPROACH:
- CTE 'practice_costs': Aggregates billing hours and expenses per matter
- CTE 'practice_revenue': Extracts settlement awards as revenue
- Final SELECT: Joins CTEs to calculate net profit and margin % by area

KEY INSIGHTS TO LOOK FOR:
- High-revenue areas with low margins (may indicate inefficiency)
- Low-revenue areas that are actually highly profitable (hidden gems)
- Which practice areas should be expanded vs. deprioritized

TECHNICAL NOTES:
- Uses LEFT JOINs to handle matters with no billing/expenses (edge case)
- COALESCE converts NULLs to 0 for accurate cost aggregation
- NULLIF prevents division by zero in margin calculation
===============================================
*/

WITH practice_costs AS (
    SELECT 
        m.practice_area,
        m.matter_id,
        COALESCE(SUM(b.amount), 0) as total_billing,
        COALESCE(SUM(e.amount), 0) as total_expenses
    FROM matters m
    LEFT JOIN billing b ON m.matter_id = b.matter_id
    LEFT JOIN expenses e ON m.matter_id = e.matter_id
    GROUP BY m.practice_area, m.matter_id
),

practice_revenue AS (
    SELECT 
        practice_area,
        matter_id,
        COALESCE(settlement_award_amount, 0) as revenue
    FROM matters
)

SELECT 
    pr.practice_area,
    COUNT(DISTINCT pr.matter_id) as num_matters,
    ROUND(SUM(pr.revenue), 2) as total_revenue,
    ROUND(SUM(pc.total_billing + pc.total_expenses), 2) as total_cost,
    ROUND(SUM(pr.revenue) - SUM(pc.total_billing + pc.total_expenses), 2) as net_profit,
    ROUND((SUM(pr.revenue) - SUM(pc.total_billing + pc.total_expenses)) / NULLIF(SUM(pr.revenue), 0) * 100, 2) as profit_margin_pct
FROM practice_revenue pr
JOIN practice_costs pc ON pr.matter_id = pc.matter_id
GROUP BY pr.practice_area
ORDER BY net_profit DESC;