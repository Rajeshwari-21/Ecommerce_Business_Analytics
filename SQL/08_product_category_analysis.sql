use ecommerce_business_analytics;

select   ct.product_category_name_english as category_names,
count(distinct o.order_id) as total_orders
from orders o
inner join order_items oi
on o.order_id=oi.order_id
inner join products p
on p.product_id= oi.product_id
inner join category_translation ct
on ct.product_category_name=p.product_category_name

 group by   ct.product_category_name_english
 order by total_orders desc
 limit 10;
 
 
 select   ct.product_category_name_english as category_names,
count(distinct o.order_id) as total_late_orders
from orders o
inner join order_items oi
on o.order_id=oi.order_id
inner join products p
on p.product_id= oi.product_id
inner join category_translation ct
on ct.product_category_name=p.product_category_name
where order_status= 'delivered' and datediff(order_delivered_customer_date,order_estimated_delivery_date)>0
 group by   ct.product_category_name_english
 order by total_late_orders desc
 limit 10;
 
 
select   ct.product_category_name_english as category_names,
count(distinct o.order_id) as total_valid_orders,
count(distinct case when datediff(order_delivered_customer_date,order_estimated_delivery_date)>0
        then o.order_id
        end) as total_late_orders,
        
round(count(distinct case when datediff(order_delivered_customer_date,order_estimated_delivery_date)>0
        then o.order_id
        end)*100.0/count(distinct o.order_id),2) as late_delivery_rate
from orders o
inner join order_items oi
on o.order_id=oi.order_id
inner join products p
on p.product_id= oi.product_id
inner join category_translation ct
on ct.product_category_name=p.product_category_name
where order_status= 'delivered' and datediff(order_delivered_customer_date,order_estimated_delivery_date) is not null
 group by   ct.product_category_name_english
 order by late_delivery_rate desc
 limit 10;
 
 
select
    x.category_name,
    round(avg(r.review_score), 2) as avg_review_score

from (
    select distinct
        oi.order_id,
        ct.product_category_name_english as category_name
    from order_items oi
    inner join products p
        on oi.product_id = p.product_id
    inner join category_translation ct
        on p.product_category_name = ct.product_category_name
) as x

inner join order_reviews r
    on x.order_id = r.order_id

group by x.category_name
order by avg_review_score asc
limit 10;




-- DAY 7: BUSINESS FINDINGS


-- 1. Bed, Bath & Table had the highest
--    distinct order count: 9,417.

-- 2. Bed, Bath & Table was associated
--    with 689 late delivered orders.

-- 3. Furniture, Mattress & Upholstery
--    had a 13.51% late delivery rate,
--    but only 37 valid delivered orders.

-- 4. Office Furniture had:
--    1,254 valid delivered orders
--    101 late orders
--    8.05% late delivery rate
--    3.62 average review score

-- 5. Office Furniture is a reasonable
--    priority for further investigation
--    due to meaningful order volume,
--    above-average delays and low ratings.

-- RECOMMENDED INVESTIGATIONS:
-- Compare review scores for late vs
-- on-time orders within Office Furniture.
-- Examine customer review comments.
-- Investigate associated sellers and
-- geographic delivery patterns.

-- LIMITATIONS:
-- Low reviews do not prove delays caused
-- dissatisfaction.
-- Orders may contain multiple categories.
-- Review and delivery metrics may use
-- different populations.
-- Review counts should be checked.
