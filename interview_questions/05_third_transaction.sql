/*
===============================================================================
Question 05: Third Transaction Per User
Difficulty : Medium
Category   : Transaction Analytics / Window Functions / ROW_NUMBER
===============================================================================
BUSINESS PROBLEM:
Find the 3rd milestone transaction for user retention and milestone rewards.

THOUGHT PROCESS:
1. Apply ROW_NUMBER() OVER(PARTITION BY UserID ORDER BY TransactionTimestamp ASC).
2. Filter where TransactionSequence = 3.
===============================================================================
*/

USE InsightXDb;
GO

WITH SequencedTransactions AS (
    SELECT 
        TransactionID,
        UserID,
        TransactionTimestamp,
        Amount,
        ROW_NUMBER() OVER(
            PARTITION BY UserID 
            ORDER BY TransactionTimestamp ASC
        ) AS TxSequence
    FROM Mobility.Transactions
)
SELECT 
    UserID,
    TransactionID,
    TransactionTimestamp,
    Amount
FROM SequencedTransactions
WHERE TxSequence = 3
ORDER BY UserID;
GO