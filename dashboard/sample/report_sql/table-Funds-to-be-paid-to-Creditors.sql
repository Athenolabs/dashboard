SELECT 
    supplier as Supplier,
    CAST(FORMAT((SUM(outstanding_amount)/1000),
            2)
        AS DECIMAL (10 , 2 )) AS Pending_amount
FROM
    `tabPurchase Invoice`
WHERE
    docstatus = 1
        AND YEAR(posting_date) = '2016'
GROUP BY supplier

