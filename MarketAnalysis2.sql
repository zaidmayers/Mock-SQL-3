WITH RankedSales AS (
    SELECT 
        o.seller_id,
        o.order_date,
        i.item_brand,
        ROW_NUMBER() OVER (PARTITION BY o.seller_id ORDER BY o.order_date) AS sale_rank
    FROM Orders o
    JOIN Items i ON o.item_id = i.item_id
),
SecondSales AS (
    SELECT 
        rs.seller_id,
        rs.item_brand
    FROM RankedSales rs
    WHERE rs.sale_rank = 2
)
SELECT 
    u.user_id AS seller_id,
    CASE 
        WHEN ss.item_brand = u.favorite_brand THEN 'yes'
        ELSE 'no'
    END AS 2nd_item_fav_brand
FROM Users u
LEFT JOIN SecondSales ss ON u.user_id = ss.seller_id;
PRINT 'Ranked Sales CTE started';
WITH RankedSales AS (
    SELECT 
        o.seller_id,
        o.order_date,
        i.item_brand,
        ROW_NUMBER() OVER (PARTITION BY o.seller_id ORDER BY o.order_date) AS sale_rank
    FROM Orders o
    JOIN Items i ON o.item_id = i.item_id
)
PRINT 'Ranked Sales CTE completed';
PRINT 'Second Sales CTE started';
SecondSales AS (
    SELECT 
        rs.seller_id,
        rs.item_brand
    FROM RankedSales rs
    WHERE rs.sale_rank = 2
)
PRINT 'Second Sales CTE completed';
PRINT 'Final query started';
SELECT 
    u.user_id AS seller_id,
    CASE 
        WHEN ss.item_brand = u.favorite_brand THEN 'yes'
        ELSE 'no'
    END AS 2nd_item_fav_brand
FROM Users u
LEFT JOIN SecondSales ss ON u.user_id = ss.seller_id;
PRINT 'Final query completed';