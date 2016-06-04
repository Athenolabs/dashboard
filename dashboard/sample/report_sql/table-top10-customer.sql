SELECT 
    customer as Customer,
    CAST(FORMAT((SUM(base_grand_total) / 1000),
            2)
        AS DECIMAL (10 , 2 )) AS Revenue
FROM
    `tabSales Invoice`
WHERE
    docstatus = 1
        AND YEAR(posting_date) = '2016'
GROUP BY customer
ORDER BY Revenue DESC
LIMIT 10;