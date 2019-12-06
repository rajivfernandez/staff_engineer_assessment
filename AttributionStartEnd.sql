WITH Contacts1 AS
(
  SELECT *,
    MAX([ContractEndDate]) OVER(PARTITION BY PersonID
          ORDER BY [ContractStartDate], [ContractEndDate]
          ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING) AS PreviousEndDate
  FROM [dbo].[contacts]
),
Contacts2 AS
(
  SELECT *,
    SUM(StartRow) OVER(PARTITION BY PersonID
          ORDER BY [ContractStartDate], [ContractEndDate]
          ROWS UNBOUNDED PRECEDING) AS PersonRowID
  FROM Contacts1
    CROSS APPLY ( VALUES(CASE WHEN [ContractStartDate] <= PreviousEndDate THEN NULL ELSE 1 END) ) AS SR(StartRow)
)
SELECT [PersonID], MIN([ContractStartDate]) AS [AttributionStartDate], MAX([ContractEndDate]) AS [AttributionEndDate]
FROM Contacts2
GROUP BY [PersonID],PersonRowID
ORDER BY [PersonID],[AttributionStartDate]