use ecommerce_business_analytics;
SELECT
    s.seller_id AS sellers,
    COUNT(DISTINCT oi.order_id) AS total_orders
FROM sellers s
INNER JOIN order_items oi
    ON s.seller_id = oi.seller_id
GROUP BY s.seller_id
ORDER BY total_orders DESC;

  select s.seller_id AS sellers,
    COUNT(DISTINCT o.order_id) AS late_orders
FROM sellers s
INNER JOIN order_items oi
    ON s.seller_id = oi.seller_id
INNER JOIN orders o
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
  AND DATEDIFF(
      o.order_delivered_customer_date,
      o.order_estimated_delivery_date
  ) > 0
GROUP BY s.seller_id
ORDER BY late_orders DESC;


SELECT
    s.seller_id AS Seller_ID,
    COUNT(DISTINCT o.order_id) AS Total_valid_Delivered_orders,

    COUNT(DISTINCT CASE
        WHEN DATEDIFF(
            o.order_delivered_customer_date,
            o.order_estimated_delivery_date
        ) > 0
        THEN o.order_id
    END) AS late_orders,

    ROUND(
        COUNT(DISTINCT CASE
            WHEN DATEDIFF(
                o.order_delivered_customer_date,
                o.order_estimated_delivery_date
            ) > 0
            THEN o.order_id
        END) * 100.0
        / COUNT(DISTINCT o.order_id),
        2
    ) AS late_delivery_rate

FROM sellers s
INNER JOIN order_items oi
    ON s.seller_id = oi.seller_id
INNER JOIN orders o
    ON oi.order_id = o.order_id

WHERE o.order_status = 'delivered'
  AND DATEDIFF(
      o.order_delivered_customer_date,
      o.order_estimated_delivery_date
  ) IS NOT NULL

GROUP BY s.seller_id
ORDER BY late_delivery_rate DESC;



SELECT
    s.seller_id AS Seller_ID,
    COUNT(DISTINCT o.order_id)  AS Total_valid_Delivered_orders,

    COUNT(DISTINCT CASE
        WHEN DATEDIFF(
            o.order_delivered_customer_date,
            o.order_estimated_delivery_date
        ) > 0
        THEN o.order_id
    END) AS late_orders,

    ROUND(
        COUNT(DISTINCT CASE
            WHEN DATEDIFF(
                o.order_delivered_customer_date,
                o.order_estimated_delivery_date
            ) > 0
            THEN o.order_id
        END) * 100.0
        / COUNT(DISTINCT o.order_id),
        2
    ) AS late_delivery_rate

FROM sellers s
INNER JOIN order_items oi
    ON s.seller_id = oi.seller_id
INNER JOIN orders o
    ON oi.order_id = o.order_id

WHERE o.order_status = 'delivered'
  AND DATEDIFF(
      o.order_delivered_customer_date,
      o.order_estimated_delivery_date
  ) IS NOT NULL  

GROUP BY s.seller_id
HAVING COUNT(DISTINCT o.order_id) >= 50
ORDER BY late_delivery_rate DESC;




-- BUSINESS FINDINGS: SELLER PERFORMANCE


-- 1. The highest-volume seller was associated
--    with 1,854 distinct orders (all statuses).

-- 2. The highest seller-associated late
--    delivery count was 172 orders.

-- 3. Sellers with fewer than 50 valid delivered
--    orders were excluded from the final
--    rate-based ranking to reduce the influence
--    of very small samples.

-- 4. The highest late delivery rate among
--    qualifying sellers was 30.14%
--    (22 late orders out of 73).

-- 5. Another seller had a 19.02% late
--    delivery rate, representing 74 late
--    orders out of 389 valid delivered orders.

-- BUSINESS RECOMMENDATION:
-- Prioritize investigating the seller associated
-- with 74 late orders because of its higher
-- number of affected orders.

-- Also investigate sellers with unusually
-- high late delivery rates.

-- IMPORTANT LIMITATIONS:
-- These are seller-associated delivery delays.
-- The analysis does not establish that sellers
-- directly caused the delays.

-- Orders involving multiple sellers can appear
-- in multiple seller-level counts.

-- The 50-order threshold is a prioritization
-- choice, not a statistical guarantee.
