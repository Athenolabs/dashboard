SELECT 
    supplier as Supplier,
    CAST(FORMAT((SUM(base_grand_total) / 1000),
            2)
        AS DECIMAL (10 , 2 )) AS Revenue
FROM
    `tabPurchase Invoice`
WHERE
    docstatus = 1
        AND YEAR(posting_date) = '2016'
GROUP BY supplier
ORDER BY Revenue DESC
LIMIT 10;