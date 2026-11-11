USE ecommerce_business_analytics;
select * from orders limit 1;
SELECT COUNT(*) FROM orders
WHERE  order_status = 'delivered';

SELECT SUM(price) as product_revenue from order_items;

SELECT sum(price) as total_delivered_revenue
from order_items i
inner join orders o
on i.order_id= o.order_id
where order_status = 'delivered';

select round(sum(price)/ count(distinct o.order_id),2) as avg_order_value
from order_items i
inner join orders o
on i.order_id= o.order_id
where order_status = 'delivered';


select Year(o.order_purchase_timestamp) as sales_year,
month(o.order_purchase_timestamp) as sales_month  ,
round(sum(i.price),2) as monthly_revenue
from order_items i
inner join orders o
on i.order_id = o.order_id
where order_status = 'delivered'
group by year(o.order_purchase_timestamp) ,month(o.order_purchase_timestamp)
order by sales_year, sales_month;


select count(distinct order_id) as orders_in_aug
from orders
where order_status = 'delivered'and year(order_purchase_timestamp) = 2018 and month(order_purchase_timestamp)=8;

select round(sum(i.price)/ count(distinct o.order_id),2) as avg_aug_order_value
from order_items i
inner join orders o
on i.order_id = o.order_id
where o.order_status ='delivered' and year(o.order_purchase_timestamp) = 2018 and month(o.order_purchase_timestamp)=8;



-- BUSINESS FINDINGS


-- 1. Total product value: R$13.59 million.
-- 2. Delivered order product value:
--    R$13.22 million.
-- 3. Average delivered-order value:
--    R$137.04.
-- 4. August 2018 recorded the highest
--    monthly product value: R$838,576.64.
-- 5. August AOV was R$132.04, below
--    the overall AOV of R$137.04.
-- 6. High order volume may have
--    contributed to August's sales peak.

-- Note: Product values exclude freight.
-- Refunds and returns are not accounted for.
