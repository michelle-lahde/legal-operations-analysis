/*
===============================================
CASE CYCLE TIME ANALYSIS BY CASE TYPE
===============================================

BUSINESS QUESTION:
How long does it take to close different case types? 
Where are the bottlenecks?

APPROACH:
- CTE 'cycle_times': Calculates days from open to close (or to today if pending)
- DATEDIFF: Computes duration in days
- Aggregation + statistics: Computes avg, min, max, and standard deviation per type
- Window function RANK(): Ranks case types by slowness

KEY INSIGHTS TO LOOK FOR:
- Case types with high variance (high stddev) = unpredictable timelines
  → May need better project management or resource allocation
- Fastest vs. slowest case types (strategic implications for pricing)
- Pending cases inflating averages (compare closed vs. pending separately)
- Correlation between case complexity and closure time

BUSINESS IMPACT:
- Informs client expectations and timeline commitments
- Identifies cases that may be stalled (long durations with no recent activity)
- Helps capacity planning (which types consume most attorney time?)

TECHNICAL NOTES:
- Handles pending matters by using CURDATE() for end_date when NULL
- STDDEV reveals consistency; high stddev = unpredictable outcomes
- Sorting by avg_days_to_close DESC shows slowest types first
===============================================
*/

WITH cycle_times AS (
    SELECT 
        matter_id,
        matter_name,
        case_type,
        practice_area,
        start_date,
        end_date,
        CASE 
            WHEN end_date IS NULL THEN DATEDIFF(CURDATE(), start_date)
            ELSE DATEDIFF(end_date, start_date)
        END as days_to_close,
        case_outcome
    FROM matters
),

case_type_stats AS (
    SELECT 
        case_type,
        COUNT(*) as num_cases,
        ROUND(AVG(days_to_close), 1) as avg_days_to_close,
        MIN(days_to_close) as min_days,
        MAX(days_to_close) as max_days,
        ROUND(STDDEV(days_to_close), 1) as stddev_days
    FROM cycle_times
    GROUP BY case_type
)

SELECT 
    case_type,
    num_cases,
    avg_days_to_close,
    min_days,
    max_days,
    stddev_days,
    RANK() OVER (ORDER BY avg_days_to_close DESC) as slowness_rank
FROM case_type_stats
ORDER BY avg_days_to_close DESC;