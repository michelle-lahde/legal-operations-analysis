/*
===============================================
EXPENSE BREAKDOWN: WHERE THE MONEY GOES
===============================================

BUSINESS QUESTION:
Which expense categories consume the most budget? 
Are there opportunities to reduce or optimize costs?

APPROACH:
- GROUP BY expense_type: Aggregates all expenses by category
- Calculates total, average, min/max amounts per category
- pct_of_total: Shows each category as a % of total firm expenses
- cost_per_instance: Average expense per transaction (efficiency metric)

KEY INSIGHTS TO LOOK FOR:
- Dominant expense categories (e.g., Expert Witness, Court Fees)
- High-variance expenses (max vs. min suggests inconsistent pricing/scope)
- Opportunities to negotiate vendor rates or reduce frequency
- Categories with few high-cost items vs. many small items (different mgmt strategies)

BUSINESS IMPACT:
- Identifies cost levers (where savings initiatives will have most impact)
- Informs pricing models (which matters should charge more to cover high expense types?)
- Vendor management (which categories need better contracts?)

TECHNICAL NOTES:
- Subquery in ROUND(...) calculates % of total for context
- cost_per_instance = total_amount / count (tracks inflation over time)
- May want to segment by case_outcome or practice_area for deeper analysis
===============================================
*/

SELECT 
    expense_type,
    COUNT(*) as num_expenses,
    ROUND(SUM(amount), 2) as total_amount,
    ROUND(AVG(amount), 2) as avg_expense,
    ROUND(MIN(amount), 2) as min_expense,
    ROUND(MAX(amount), 2) as max_expense,
    ROUND(SUM(amount) / (SELECT SUM(amount) FROM expenses) * 100, 2) as pct_of_total,
    ROUND(SUM(amount) / COUNT(*), 2) as cost_per_instance
FROM expenses
GROUP BY expense_type
ORDER BY total_amount DESC;