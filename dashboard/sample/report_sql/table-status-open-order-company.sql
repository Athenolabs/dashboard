SELECT 
    `tabOpportunity`.`company` AS `Company`,
    COUNT(1) AS `Total`,
    SUM((CASE
        WHEN (`tabOpportunity`.`status` = 'Open') THEN 1
        ELSE 0
    END)) AS `Open`,
    SUM((CASE
        WHEN (`tabOpportunity`.`status` = 'Converted') THEN 1
        ELSE 0
    END)) AS `Converted`,
    SUM((CASE
        WHEN (`tabOpportunity`.`status` = 'Completed') THEN 1
        ELSE 0
    END)) AS `Completed`,
    SUM((CASE
        WHEN (`tabOpportunity`.`status` NOT IN ('Open', 'Converted', 'Completed')) THEN 1
        ELSE 0
    END)) AS `Other`
	
FROM
    `tabOpportunity`
WHERE fiscal_year = 2016
GROUP BY `tabOpportunity`.`company`
ORDER BY Total DESC;