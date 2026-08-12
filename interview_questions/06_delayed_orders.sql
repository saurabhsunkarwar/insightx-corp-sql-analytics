/*
===============================================================================
Question 06: Delayed Orders by Delivery Partner
Difficulty : Easy-Medium
Category   : Operations Analytics / Aggregation & Grouping
===============================================================================
BUSINESS PROBLEM:
Identify logisitics partners failing SLAs to negotiate better contract terms or adjust shipping estimates.

THOUGHT PROCESS:
1. Join Operations.Deliveries with Operations.DeliveryPartners.
2. Filter or flag orders where ActualDeliveryDate > PromisedDeliveryDate.
3. Compute total orders, delayed orders using conditional aggregation, and the delay percentage.
===============================================================================
*/

USE InsightXDb;
GO

SELECT 
    p.PartnerID,
    p.PartnerName,
    COUNT(d.DeliveryID) AS TotalDeliveries,
    SUM(CASE WHEN d.ActualDeliveryDate > d.PromisedDeliveryDate THEN 1 ELSE 0 END) AS DelayedDeliveries,
    CAST(
        (SUM(CASE WHEN d.ActualDeliveryDate > d.PromisedDeliveryDate THEN 1.0 ELSE 0.0 END) / COUNT(d.DeliveryID)) * 100 
        AS DECIMAL(5,2)
    ) AS DelayPercentage
FROM Operations.DeliveryPartners p
INNER JOIN Operations.Deliveries d 
    ON p.PartnerID = d.PartnerID
GROUP BY 
    p.PartnerID, 
    p.PartnerName
ORDER BY DelayedDeliveries DESC, DelayPercentage DESC;
GO