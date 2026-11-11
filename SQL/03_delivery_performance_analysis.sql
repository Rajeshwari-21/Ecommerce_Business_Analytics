Use ecommerce_business_analytics;

select count(*) from orders
where order_status='delivered' ;

select COUNT(*) AS late_est_deliveries
from orders
where order_status='delivered' and datediff(order_delivered_customer_date, order_estimated_delivery_date)>0; 

select round(
avg(datediff( order_delivered_customer_date, order_purchase_timestamp)), 2) as avg_delivery_time_taken
from orders
where order_status='delivered';



SELECT
    COUNT(*) AS total_delivered,
    SUM(
        CASE
            WHEN order_delivered_customer_date IS NULL
              OR order_estimated_delivery_date IS NULL
            THEN 1
            ELSE 0
        END
    ) AS missing_delivery_dates
FROM orders
WHERE order_status = 'delivered'; 

SELECT
    COUNT(*) AS total_delivered,

    SUM(CASE
        WHEN DATEDIFF(
            order_delivered_customer_date,
            order_estimated_delivery_date
        ) <= 0 THEN 1
        ELSE 0
    END) AS on_time_orders,

    SUM(CASE
        WHEN DATEDIFF(
            order_delivered_customer_date,
            order_estimated_delivery_date
        ) > 0 THEN 1
        ELSE 0
    END) AS late_orders

FROM orders
WHERE order_status = 'delivered';

SELECT
    order_id,
    order_delivered_customer_date,
    order_estimated_delivery_date,
    DATEDIFF(
        order_delivered_customer_date,
        order_estimated_delivery_date
    ) AS delivery_difference
FROM orders
WHERE order_status = 'delivered'
  AND DATEDIFF(
      order_delivered_customer_date,
      order_estimated_delivery_date
  ) IS NULL;




select 
round(sum(case when 
            datediff(order_delivered_customer_date,order_estimated_delivery_date )
            <=0 then 1
            else 0
            end )  * 100.0 / count(*), 2) as on_time_delivery_rate 
 from orders
 where order_status='delivered' and datediff(
      order_delivered_customer_date,
      order_estimated_delivery_date
  ) is not null;
  
  
select year(order_purchase_timestamp) as sales_year ,
      month(order_purchase_timestamp) as sales_month,
 sum(case when
 datediff(order_delivered_customer_date,order_estimated_delivery_date) >0
 then 1
 else 0
 end) as late_deliveries 
 from orders
 where order_status ='delivered'
 group by year(order_purchase_timestamp) , month(order_purchase_timestamp)
 order by late_deliveries desc;
 
 

-- BUSINESS FINDINGS--


-- 1. Average delivery time: 12.50 days.
-- 2. On-time delivery rate: 93.23%.
-- 3. Late deliveries: 6,534 orders.
-- 4. March 2018 recorded the highest
--    late-delivery count: 1,328.
-- 5. Eight delivered orders could not
--    be classified due to invalid dates.

-- Recommendation:
-- Compare monthly late-delivery rates
-- before identifying the worst month.