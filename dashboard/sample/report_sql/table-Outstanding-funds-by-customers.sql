SELECT 
    customer as Customer,
    CAST(FORMAT((SUM(outstanding_amount)/1000),
            2)
        AS DECIMAL (10 , 2 )) AS Outstanding_Amount
FROM
    `tabSales Invoice`
WHERE
    docstatus = 1
        AND YEAR(posting_date) = '2016'
GROUP BY customer
