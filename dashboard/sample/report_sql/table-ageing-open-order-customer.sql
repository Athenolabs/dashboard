SELECT 
    so.customer AS 'Client',
    COUNT(1) AS 'Total',
    SUM(CASE
        WHEN DATEDIFF(CURDATE(), so.delivery_date) > 0 THEN 1
        ELSE 0
    END) AS 'Late',
    CONCAT(FORMAT((SUM(CASE
                    WHEN DATEDIFF(CURDATE(), so.delivery_date) > 0 THEN 1
                    ELSE 0
                END) / COUNT(1) * 100),
                2),
            '%') AS '%',
    SUM(CASE
        WHEN
            (DATEDIFF(CURDATE(), so.delivery_date) > 0
                AND DATEDIFF(CURDATE(), so.delivery_date) < 7)
        THEN
            1
        ELSE 0
    END) AS '< 7',
    SUM(CASE
        WHEN
            (DATEDIFF(CURDATE(), so.delivery_date) > 6
                AND DATEDIFF(CURDATE(), so.delivery_date) < 31)
        THEN
            1
        ELSE 0
    END) AS '7-29',
    SUM(CASE
        WHEN
            (DATEDIFF(CURDATE(), so.delivery_date) > 31
                AND DATEDIFF(CURDATE(), so.delivery_date) < 61)
        THEN
            1
        ELSE 0
    END) AS '30-59',
    SUM(CASE
        WHEN
            (DATEDIFF(CURDATE(), so.delivery_date) > 60
                AND DATEDIFF(CURDATE(), so.delivery_date) < 91)
        THEN
            1
        ELSE 0
    END) AS '60-89',
    SUM(CASE
        WHEN
            (DATEDIFF(CURDATE(), so.delivery_date) > 90
                AND DATEDIFF(CURDATE(), so.delivery_date) < 121)
        THEN
            1
        ELSE 0
    END) AS '90-119',
    SUM(CASE
        WHEN (DATEDIFF(CURDATE(), so.delivery_date) > 120) THEN 1
        ELSE 0
    END) AS '120+'
FROM
    `tabSales Order` AS so
INNER JOIN
    `tabSales Order Item` AS so_item ON (so_item.parent = so.name)
LEFT JOIN
		(SELECT 
				dn_item.item_code,
				dn_item.item_name,
				dn_item.description,
				dn_item.number,
				dn_item.against_sales_order,
				SUM(dn_item.qty) AS qty
		FROM
			`tabDelivery Note Item` AS dn_item
		WHERE
			dn_item.docstatus = 1
		GROUP BY dn_item.item_code , dn_item.item_name , dn_item.description , dn_item.number , dn_item.against_sales_order
		) AS dn_item ON (
						dn_item.against_sales_order = so_item.parent
						AND dn_item.item_code = so_item.item_code
						AND dn_item.item_name = so_item.item_name
						AND dn_item.description = so_item.description
						AND dn_item.number <=> so_item.number
					)
WHERE
so.status IN ('To Deliver and Bill' , 'To Deliver', 'Draft')
AND (dn_item.qty IS NULL
        OR dn_item.qty < so_item.qty)
AND so.fiscal_year = '2016'
GROUP BY so.customer
ORDER BY so.customer