use ecommerce_business_analytics;

select c.customer_state as customer_state, 
count(distinct o.order_id) as total_orders
from orders o
inner join customers c
on o.customer_id = c.customer_id
group by c.customer_state
order by total_orders desc;

select c.customer_state as customer_state,
count(distinct o.order_id) as total_late_orders
from orders o
inner join customers c
on o.customer_id = c.customer_id
where o.order_status='delivered' and datediff(o.order_delivered_customer_date,o.order_estimated_delivery_date)>0
group by c.customer_state
order by total_late_orders desc; 

select c.customer_state as customer_state,
count( o.order_id) as total_valid_delivered_orders,
count(case when datediff(o.order_delivered_customer_date,o.order_estimated_delivery_date)>0
       then o.order_id
       end) as total_late_orders,
       
  round(count(case when datediff(o.order_delivered_customer_date,o.order_estimated_delivery_date)>0
       then o.order_id
       end)*100.0/  count( o.order_id) ,2) as Late_delivery_rate  
from orders o
inner join customers c
on o.customer_id = c.customer_id

where o.order_status='delivered' and datediff(o.order_delivered_customer_date,o.order_estimated_delivery_date) is not null 
group by c.customer_state
order by Late_delivery_rate  desc; 


select c.customer_state as customer_state,
c.customer_city as customer_city,
count(distinct o.order_id) as late_delivery
from orders o
inner join customers c
on o.customer_id = c.customer_id

where o.order_status='delivered' and datediff(o.order_delivered_customer_date,o.order_estimated_delivery_date) >0
group by c.customer_state, c.customer_city
order by late_delivery  desc; 





-- BUSINESS FINDINGS

-- 1. Customer order volume:
-- Sao Paulo (SP): 41,746 orders
-- Rio de Janeiro (RJ): 12,852 orders
-- Minas Gerais (MG): 11,635 orders
-- These counts include all order statuses.

-- 2. States with the most late deliveries:
-- SP: 1,820
-- RJ: 1,495
-- MG: 519
-- BA: 396

-- 3. High late delivery rates:
-- Alagoas (AL): 21.41% (85 / 397)
-- Maranhao (MA): 17.43% (125 / 717)
-- Sergipe (SE): 15.22% (51 / 335)

-- 4. Cities with the most late deliveries:
-- Sao Paulo: 715
-- Rio de Janeiro: 706
-- Salvador: 174
-- Belo Horizonte: 137
-- Porto Alegre: 136

-- BUSINESS RECOMMENDATION:
-- Prioritize further investigation of
-- Rio de Janeiro due to its high late-order
-- count relative to its overall order volume.

-- Examine seller associations, shipping
-- processes, delivery routes, and logistics
-- performance before proposing interventions.

-- IMPORTANT LIMITATIONS:
-- All geographic results use CUSTOMER location.
-- Late deliveries do not establish geographic
-- or seller-related causation.

-- The RJ late delivery rate still needs to be
-- calculated with valid delivered orders as
-- its denominator before making a definitive
-- rate-based comparison.

-- Multiple metrics should guide prioritization:
-- late-order count, late rate, and order volume.

