SELECT 
    'Sales' AS label,
    MONTH(posting_date) as period,
    CAST(FORMAT((SUM(base_grand_total) / 1000),
            2)
        AS DECIMAL (10 , 2 )) AS data
FROM
    `tabSales Invoice`
WHERE
    docstatus = 1
        AND YEAR(posting_date) = '2016'
GROUP BY MONTH(posting_date)
UNION ALL
SELECT 
    'Purchase' AS label,
    MONTH(posting_date) as period,
    CAST(FORMAT((SUM(base_grand_total) / 1000),
            2)
        AS DECIMAL (10 , 2 )) AS data
FROM
    `tabPurchase Invoice`
WHERE
    docstatus = 1
        AND YEAR(posting_date) = '2016'
GROUP BY MONTH(posting_date)
ORDER BY 2;