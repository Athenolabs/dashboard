SELECT 
    SUBSTRING(MONTHNAME(posting_date), 1, 3) AS label,
    CAST(FORMAT((SUM(base_grand_total) / 1000), 2) AS DECIMAL (10 , 2 )) AS data
FROM
    `tabSales Invoice`
WHERE
    docstatus = 1
AND  YEAR(posting_date) = '2016'
-- YEAR(posting_date) = '2016'
GROUP BY MONTHNAME(posting_date)
ORDER BY MONTH(posting_date);
