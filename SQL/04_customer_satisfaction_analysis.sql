USE ecommerce_business_analytics;

SELECT ROUND(AVG(review_score),2) AS avg_rev_score 
FROM order_reviews;

SELECT review_score AS Review_Score,
count(*)  AS review_count 
FROM order_reviews
GROUP BY review_score
ORDER BY review_Score;

select o.order_id  ,r.review_score , o.order_delivered_customer_date 
from orders o
inner join order_reviews r
on o.order_id=r.order_id
where o.order_status = 'delivered';

select case when 
                datediff(o.order_delivered_customer_date,o.order_estimated_delivery_date)
                >0 then 'Late orders'
				else 'On Time orders'
                end as Delivery_category
 , round(avg(r.review_score),2) as Avg_review_score 
 from orders o 
 inner join order_reviews r
 on o.order_id= r.order_id
 where o.order_status = 'delivered' and DATEDIFF(
      o.order_delivered_customer_date,
      o.order_estimated_delivery_date
  ) is not null
 group by Delivery_category;
 
 
 select 
   round(sum(case when r.review_score <=2
   then 1
   else 0
   end) * 100.0/ count(*),2) as negative_review_rate
  
  from order_reviews r 
  inner join orders o
  on r.order_id= o.order_id 
  where o.order_status = 'delivered' and 
  datediff(o.order_delivered_customer_date,o.order_estimated_delivery_date) > 0 ;
  
  
  select 
   round(sum(case when r.review_score <=2
   then 1
   else 0
   end) * 100.0/ count(*),2) as negative_review_rate
  
  from order_reviews r 
  inner join orders o
  on r.order_id= o.order_id 
  where o.order_status = 'delivered' and 
  datediff(o.order_delivered_customer_date,o.order_estimated_delivery_date) <= 0 ;
  
  
  
-- BUSINESS FINDINGS--


-- 1. Overall average review score: 4.09/5.
-- 2. On-time average rating: 4.29/5.
-- 3. Late-delivery average rating: 2.27/5.
-- 4. Negative review rate for late
--    deliveries: 62.41%.
-- 5. Negative review rate for on-time
--    deliveries: 9.28%.

-- Conclusion:
-- Late deliveries are strongly associated
-- with lower customer review scores.

-- Note: Review-level analysis.
-- Association does not prove causation.