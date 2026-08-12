/*
===============================================================================
Question 09: Weekday vs. Weekend Active Users
Difficulty : Medium
Category   : Mobility Analytics / Date Functions / Conditional Aggregation
===============================================================================
BUSINESS PROBLEM:
Segment power users who engage with the app across their entire week vs. weekday-only or weekend-only users.

THOUGHT PROCESS:
1. Extract day of week using DATEPART(dw, ActivityDate) or DATENAME(dw, ActivityDate).
2. Use SET DATEFIRST 7 (Sunday = 1, Saturday = 7) or explicit name checks to avoid server culture dependencies.
3. Use conditional aggregation with HAVING clause requiring WeekdayCount > 0 AND WeekendCount > 0.
===============================================================================
*/

USE InsightXDb;
GO

-- Standardize Datefirst setting (1 = Monday, 7 = Sunday)
SET DATEFIRST 1; 

WITH UserDayClassification AS (
    SELECT 
        UserID,
        CASE 
            WHEN DATEPART(dw, ActivityDate) IN (6, 7) THEN 'Weekend'
            ELSE 'Weekday'
        END AS DayType
    FROM Mobility.UserActivity
)
SELECT 
    UserID,
    COUNT(CASE WHEN DayType = 'Weekday' THEN 1 END) AS WeekdayActivityCount,
    COUNT(CASE WHEN DayType = 'Weekend' THEN 1 END) AS WeekendActivityCount
FROM UserDayClassification
GROUP BY UserID
HAVING 
    COUNT(CASE WHEN DayType = 'Weekday' THEN 1 END) > 0 
    AND COUNT(CASE WHEN DayType = 'Weekend' THEN 1 END) > 0;
GO