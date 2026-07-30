/*
===============================================
COST OVERRUN ANALYSIS - BUDGET vs. ACTUAL
===============================================

BUSINESS QUESTION:
Which matters exceeded their budget? By how much? Which case types 
tend to have estimation errors?

APPROACH:
- CTE 'matter_costs': Consolidates budgeted, billing, and expense amounts per matter
- CASE WHEN + variance_pct: Categorizes as OVERRUN, UNDER, or ON_BUDGET
- Sorts by absolute variance to surface worst offenders first

KEY INSIGHTS TO LOOK FOR:
- Cases trending toward significant overruns (flag for escalation)
- Case types with consistently high variance (improve estimates)
- Correlation between outcome (Settled vs. Won) and cost overrun
- Whether overruns correlate with practice area or attorney experience

BUSINESS IMPACT:
- Helps improve budgeting accuracy for future proposals
- Identifies cases needing cost controls mid-engagement
- Reveals process inefficiencies or scope creep patterns

TECHNICAL NOTES:
- Variance % = (Actual - Budgeted) / Budgeted * 100
- Positive = overrun, Negative = under budget
- Filters out matters with budgeted_cost = 0 to avoid division issues
===============================================
*/

WITH matter_costs AS (
    SELECT 
        m.matter_id,
        m.matter_name,
        m.practice_area,
        m.case_type,
        m.case_outcome,
        m.budgeted_cost,
        COALESCE(SUM(b.amount), 0) as billing_cost,
        COALESCE(SUM(e.amount), 0) as expense_cost
    FROM matters m
    LEFT JOIN billing b ON m.matter_id = b.matter_id
    LEFT JOIN expenses e ON m.matter_id = e.matter_id
    GROUP BY m.matter_id, m.matter_name, m.practice_area, m.case_type, m.case_outcome, m.budgeted_cost
)

SELECT 
    matter_id,
    matter_name,
    practice_area,
    case_type,
    case_outcome,
    ROUND(budgeted_cost, 2) as budgeted_cost,
    ROUND(billing_cost + expense_cost, 2) as actual_cost,
    ROUND((billing_cost + expense_cost) - budgeted_cost, 2) as cost_variance,
    ROUND(((billing_cost + expense_cost) - budgeted_cost) / NULLIF(budgeted_cost, 0) * 100, 2) as variance_pct,
    CASE 
        WHEN (billing_cost + expense_cost) > budgeted_cost THEN 'OVERRUN'
        WHEN (billing_cost + expense_cost) < budgeted_cost THEN 'UNDER'
        ELSE 'ON_BUDGET'
    END as budget_status
FROM matter_costs
WHERE budgeted_cost > 0
ORDER BY ABS(cost_variance) DESC
LIMIT 25;