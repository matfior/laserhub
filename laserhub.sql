-- this would be my preferred solution

SELECT  producer_id
       ,valid_at
       ,product_categories
       ,target_volume
FROM 
(
	SELECT  producer_id
	       ,valid_at
	       ,product_categories
	       ,target_volume
	       ,row_number() over (partition by producer_id ORDER BY valid_at desc) AS rn
	FROM data
) d
WHERE rn = 1; 

-- this is a possible alternative but slower since the table is scanned twice

SELECT  d1.producer_id
       ,d1.valid_at
       ,d1.product_categories
       ,d1.target_volume
FROM 
(
	SELECT  MAX(valid_at) valid_at
	       ,producer_id
	FROM data
	GROUP BY  producer_id
) d
INNER JOIN data d1
    ON d.valid_at = d1.valid_at AND d.producer_id = d1.producer_id
ORDER BY d1.producer_id