SELECT 
    CASE
        WHEN
            (CAST(FORMAT((SUM(base_grand_total) / 1000),
                    2)
                AS DECIMAL (10 , 2 )) < 11)
        THEN
            'Other'
        ELSE customer
    END AS label,
    CAST(FORMAT((SUM(base_grand_total) / 1000),
            2)
        AS DECIMAL (10 , 2 )) AS data
FROM
    `tabSales Invoice`
WHERE
    docstatus = 1
AND fiscal_year = '2016'
-- AND YEAR(posting_date) = '2016'
GROUP BY customer
ORDER BY data DESC;