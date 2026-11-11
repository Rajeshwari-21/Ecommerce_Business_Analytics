USE ecommerce_business_analytics;

describe orders;
SELECT * FROM orders
LIMIT 5;

DESCRIBE order_items;
SELECT * FROM order_items
LIMIT 5;

DESCRIBE products;
SELECT * FROM products
LIMIT 5;

DESCRIBE sellers;
SELECT * FROM sellers
LIMIT 5;

DESCRIBE customers;
SELECT * FROM customers
LIMIT 5;

DESCRIBE order_payments;
SELECT * FROM order_payments
LIMIT 5;

SELECT COUNT(*) AS Total_rows,
COUNT(DISTINCT order_id) AS Total_unique_orders
 FROM orders;
 
 SELECT COUNT(*) AS missing_order
 FROM orders
 WHERE order_id IS NULL OR order_id='';
 
 SELECT COUNT(*) AS missing_cus_id FROM orders
 WHERE customer_id IS NULL OR customer_id='';
 
 SELECT COUNT(*) AS missing_customer
 FROM orders o
 LEFT JOIN customers c
 ON o.customer_id= c.customer_id
 WHERE c.customer_id IS NULL;
 
 SELECT order_status, COUNT(*) AS status_count
 FROM orders
 GROUP BY order_status
 ORDER BY status_count DESC;
 
 SELECT COUNT(*) AS missing_purchase_dates
FROM orders
WHERE order_purchase_timestamp IS NULL;

SELECT
    COUNT(*) AS total_orders,
    SUM(order_approved_at IS NULL) AS missing_approved,
    SUM(order_delivered_carrier_date IS NULL) AS missing_carrier_date,
    SUM(order_delivered_customer_date IS NULL) AS missing_customer_delivery,
    SUM(order_estimated_delivery_date IS NULL) AS missing_estimated_delivery
FROM orders;

SELECT COUNT(*) FROM order_items;
SELECT COUNT(distinct order_id) AS distinct_orders ,
COUNT(*) AS order_item

from order_items
;
SELECT 
    COUNT(*) AS total_rows,
    COUNT(DISTINCT order_id, order_item_id) AS unique_order_items
FROM order_items;

SELECT COUNT(*) as Missing_order_id
FROM order_itemS i
LEFT JOIN orders o
ON i.order_id= o.order_id
WHERE o.order_id IS NULL;

SELECT COUNT(*) as Missing_product_id
FROM order_itemS i
LEFT JOIN products p
ON i.product_id= p.product_id
WHERE p.product_id IS NULL;

SELECT COUNT(*) as Missing_seller_id
FROM order_itemS i
LEFT JOIN sellers s
ON i.seller_id= s.seller_id
WHERE s.seller_id IS NULL;

SELECT COUNT(*) FROM order_items
WHERE price <=0; 

SELECT COUNT(*) FROM order_payments;
SELECT COUNT(*) FROM orders;

SELECT COUNT(*) AS missing_order_payments
FROM order_payments p
LEFT JOIN orders o
ON p.order_id= o.order_id
WHERE o.order_id IS NULL;

SELECT COUNT(order_id) AS total_order_id,
 COUNT(distinct order_id) AS distinct_order_id
 from order_payments;
 
 SELECT COUNT(*) FROM order_payments
 WHERE payment_value <=0;
 
 SELECT * FROM order_payments
 WHERE payment_value <=0;
 
 SELECT payment_type,COUNT(*) as total_count 
 FROM order_payments
 GROUP BY payment_type
 ORDER BY total_count DESC
 LIMIT 1;
 
 select count(*) from order_payments
 where payment_type is null or payment_type='';
 
 select sum(payment_value) as total_payment from order_payments;
 
 select count(*) from order_reviews;
 select count(*) from order_reviews
 where review_score is null;
 
 select count(*) from order_reviews
 where review_score not  between 1 and 5;
 
 select review_score, count(*) as total_review_score
 from order_reviews
 group by review_score
 order by total_review_score DESC
 ;
 
 select count(*) as missing_order_id
 from order_reviews r
 left join orders o
 on r.order_id= o.order_id
 where o.order_id is null;
 
 select count(*) from order_reviews
 where review_comment_message is null or review_comment_message='';
 
 select count(*) from order_reviews
 where review_id is null;
 
 select count(*) as total_products, count(distinct product_id) as unique_product_id
 from products;
 
 select count(*) from products
 where product_category_name is null;
 
  select count(*) from products
 where product_weight_g is null or product_weight_g <=0;
 
   select * from products
 where product_weight_g is null or product_weight_g <=0; 
 
 SELECT count(*) as total_products ,
 sum(product_length_cm is null ) as missing_pro_len,
  sum(product_height_cm is null ) as missing_pro_hei,
   sum(product_width_cm is null ) as missing_pro_wid
   from products;
   
 select count(*) as total_sellers, count(distinct seller_id) as unique_seller_id
 from sellers;
 
 select count(*) from sellers
 where seller_id is null or seller_id= '';
 
 select count(*) as total_customers, count(distinct customer_id) as unique_customer_id
 from customers; 
 
 select count(distinct customer_unique_id) from customers;
 select count(*) from geolocation;
 
 select sum(geolocation_lat is null) as missing_lat,
 category_translationsum(geolocation_lng is null) as missing_lon 
 from geolocation;
 
 select count(*) as total_cat_name, count(distinct product_category_name) as dis_cat_name 
 from category_translation;
 
 select count(*) as missing_cat_name
 from category_translation c 
 left join products p
 on c.product_category_name = p.product_category_name
 where p.product_category_name is null;
 
 SELECT COUNT(*) AS missing_cat_translation
FROM products p
LEFT JOIN category_translation c
    ON p.product_category_name = c.product_category_name
WHERE p.product_category_name IS NOT NULL
  AND c.product_category_name IS NULL;
  
  

-- DATA QUALITY FINDINGS


-- 1. Validated relationships across key tables.
-- 2. Found 9 payment records with
--    non-positive payment values.
-- 3. Found 6 products with missing or
--    non-positive weights.
-- 4. Found 623 product records without
--    matching category translations.
-- 5. These issues were documented rather
--    than automatically deleting records.