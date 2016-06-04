SELECT 
    inv_item.item_name as Item,
    CAST(FORMAT((SUM(inv_item.base_amount) / 1000),
            2)
        AS DECIMAL (10 , 2 )) AS Revenue
FROM
    `tabSales Invoice Item` AS inv_item
INNER JOIN `tabSales Invoice` AS inv ON (inv.name = inv_item.parent)
WHERE
    inv.docstatus = 1
AND YEAR(inv.posting_date) = '2016'
GROUP BY inv_item.item_name
ORDER BY Revenue DESC
LIMIT 10;
