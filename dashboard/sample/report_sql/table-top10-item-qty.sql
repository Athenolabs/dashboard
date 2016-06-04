SELECT 
    inv_item.item_name as Item,
    SUM(inv_item.qty) AS Qty
FROM
    `tabSales Invoice Item` AS inv_item 
INNER JOIN `tabSales Invoice` AS inv ON (inv.name = inv_item.parent)
WHERE
    inv.docstatus = 1
AND YEAR(inv.posting_date) = '2016'
GROUP BY inv_item.item_name
ORDER BY Qty DESC
LIMIT 10;
