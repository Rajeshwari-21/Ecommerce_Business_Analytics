use ecommerce_business_analytics;

select year(order_purchase_timestamp) as year,
	month(order_purchase_timestamp) as month,
    count(*) as valid_Delivery_orders
    from orders
    where order_status='delivered' and  DATEDIFF(
    order_delivered_customer_date,
    order_estimated_delivery_date
) IS NOT NULL
    group by year(order_purchase_timestamp),month(order_purchase_timestamp)
    order by year desc , month ;
    
    
select year(order_purchase_timestamp) as year,
	month(order_purchase_timestamp) as month,
    
    round(sum(case when datediff(order_delivered_customer_date,order_estimated_delivery_date) >0
    then 1
    else 0
    end)* 100.0/count(*),2) as Late_delivery_rate_percentage
    
from orders
where order_status='delivered' and  DATEDIFF(
    order_delivered_customer_date,
    order_estimated_delivery_date
) IS NOT NULL

group by year(order_purchase_timestamp) ,
	month(order_purchase_timestamp) 
order by year desc, month;

select year(order_purchase_timestamp) as year,
	month(order_purchase_timestamp) as month,
    round(avg(datediff(order_delivered_customer_date,order_estimated_delivery_date)) ,2)as avg_delay_days
    from orders
    where order_status='delivered' and  DATEDIFF(
    order_delivered_customer_date,
    order_estimated_delivery_date
) >0
group by year(order_purchase_timestamp) ,
	month(order_purchase_timestamp) 
order by year desc, month;


-- BUSINESS FINDINGS: MONTHLY DELIVERY TRENDS

-- 1. Overall late delivery rate: 6.77%.

-- 2. March 2018 recorded 1,328 late
--    deliveries, with a late rate of 18.96%.

-- 3. February 2018 had a late delivery
--    rate of 14.13%.

-- 4. Average delay among late orders:
--    March 2018: 10.02 days.
--    February 2018: 12.58 days.

-- 5. March had more frequent delays,
--    while February had longer delays
--    on average.

-- BUSINESS RECOMMENDATION:
-- Prioritize investigation of March 2018
-- to identify locations, sellers, and
-- shipping stages associated with delays.

-- Investigate February 2018 separately
-- to understand its longer average delays.

-- NOTE:
-- Monthly rates exclude orders with
-- unclassifiable delivery dates.
-- Very small monthly samples should
-- not drive performance conclusions.