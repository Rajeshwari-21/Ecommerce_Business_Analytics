use ecommerce_business_analytics;

with late_delivery as(
select distinct o.order_id,
datediff(order_delivered_customer_date,order_estimated_delivery_date) as delay_days,
s.seller_id
from orders o
inner join order_items oi
on o.order_id=oi.order_id
inner join sellers s
on s.seller_id=oi.seller_id
where o.order_status='delivered'

)

select seller_id as Seller_Id , count(distinct case when delay_days>0 
then order_id end) as Late_orders,
dense_rank() over(
order by count(distinct case when delay_days>0 
then order_id end) desc
) as seller_rank
from late_delivery
where delay_days is not null
group by seller_id
order by Late_orders desc; 


-- BUSINESS FINDING:
-- The highest-ranked seller was associated
-- with 172 late delivered orders.
-- Two sellers tied at rank 4 with 96 late
-- orders each.
--
-- RECOMMENDATION:
-- Investigate high-volume sellers associated
-- with frequent delivery delays.
-- Seller association does not prove causation.
-- Late-order rates should also be considered.


with state_deliveries as(
select o.order_id,
c.customer_state,
datediff(order_delivered_customer_date,order_estimated_delivery_date) as delay_days

from orders o
inner join customers c
on o.customer_id=c.customer_id
where order_status='delivered'

),
state_rate as(
 select customer_state,
 
 count(distinct case when delay_days>0 then order_id end)*100.0/count(distinct order_id) as late_delivery_rate
 from state_deliveries
 where delay_days is not null
 group by customer_state

)

select customer_state , 
late_delivery_rate,
dense_rank() over(
 order by late_delivery_rate desc
) as state_rank
from state_rate
order by  state_rank, customer_state desc;

-- BUSINESS FINDING:
-- Alagoas ranked first in late delivery rate
-- at 21.41%, followed by Maranhao at 17.43%
-- and Sergipe at 15.22%.
--
-- RECOMMENDATION:
-- Investigate regions with unusually high
-- late delivery rates while also considering
-- order volume and the number of late orders.
--
-- NOTE:
-- Customer location does not establish
-- the underlying cause of delivery delays.



with category_deliveries as(
select ct.product_category_name_english,
o.order_id,
datediff(order_delivered_customer_date,order_estimated_delivery_date) as delay_days

from orders o
inner join order_items oi
on o.order_id=oi.order_id
inner join products p
on p.product_id=oi.product_id
inner join category_translation ct
on ct.product_category_name=p.product_category_name
where order_status= 'delivered'

),
category_rate as(
 select product_category_name_english as product_category,
 round(count(distinct case when delay_days>0 then order_id end)*100.0/count(distinct order_id),2)
 as late_delivery_rate
from category_deliveries
where delay_days is not null
group by product_category_name_english

)

select product_category ,
round(late_delivery_rate,2) as late_delivery_rate,
dense_rank() over(
order by late_delivery_rate desc
) as product_rank
from category_rate
order by product_rank, product_category
limit 10;



-- BUSINESS FINDINGS


-- 1. SELLER RANKING:
-- Highest seller-associated late-order
-- count: 172.
-- Two sellers tied at rank 4 with
-- 96 late orders each.

-- 2. STATE RANKING:
-- AL: 21.41% (Rank 1)
-- MA: 17.43% (Rank 2)
-- SE: 15.22% (Rank 3)
-- PI: 13.87% (Rank 4)
-- CE: 13.76% (Rank 5)

-- 3. PRODUCT CATEGORY RANKING:
-- Furniture, Mattress & Upholstery:
-- 13.51% (Rank 1)
-- Home Comfort 2: 12.50% (Rank 2)
-- Audio: 11.78% (Rank 3)
-- Home Comfort: 9.44% (Rank 4)
-- Fashion, Underwear & Beach:
-- 9.40% (Rank 5)

-- BUSINESS RECOMMENDATION:
-- Consider both late delivery rate and
-- number of affected orders when
-- prioritizing operational investigations.

-- LIMITATION:
-- Rankings identify associations and
-- do not establish the cause of delays.
-- Small category order volumes can
-- produce unstable percentage rankings.
