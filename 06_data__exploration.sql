-- ============================================================
-- OLIST BRAZILIAN E-COMMERCE ANALYSIS
-- PostgreSQL
-- ============================================================


-- ============================================================
-- 1. SALES ANALYSIS
-- ============================================================


-- 1.1 Which product categories generate the most revenue?

SELECT
    p.product_category_name,
    SUM(oi.price) AS total_revenue
FROM order_items AS oi
JOIN products AS p
    ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY total_revenue DESC;


-- 1.2 What is the average order value?

SELECT
    ROUND(AVG(order_value), 2) AS average_order_value
FROM (
    SELECT
        oi.order_id,
        SUM(oi.price) AS order_value
    FROM order_items AS oi
    GROUP BY oi.order_id
) AS order_totals;


-- 1.3 How did sales change over time?

SELECT
    DATE_TRUNC('month', o.order_purchase_timestamp) AS order_month,
    SUM(oi.price) AS total_sales
FROM order_items AS oi
JOIN orders AS o
    ON oi.order_id = o.order_id
GROUP BY order_month
ORDER BY order_month ASC;


-- 1.4 Which product categories generate more revenue than the average product category?

WITH product_categories AS (
    SELECT
        p.product_category_name,
        SUM(oi.price) AS total_revenue
    FROM order_items AS oi
    JOIN products AS p
        ON oi.product_id = p.product_id
    GROUP BY p.product_category_name
)

SELECT
    product_category_name,
    total_revenue
FROM product_categories
WHERE total_revenue > (
    SELECT AVG(total_revenue)
    FROM product_categories
)
ORDER BY total_revenue DESC;



-- ============================================================
-- 2. CUSTOMER ANALYSIS
-- ============================================================


-- 2.1 Which states have the most customers?

SELECT
    c.customer_state,
    COUNT(DISTINCT c.customer_unique_id) AS customer_count
FROM customers AS c
GROUP BY c.customer_state
ORDER BY customer_count DESC;


-- 2.2 What percentage of customers are repeat customers?

WITH customer_order AS (
    SELECT
        c.customer_unique_id,
        COUNT(o.order_id) AS number_of_orders
    FROM customers AS c
    LEFT JOIN orders AS o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
)

SELECT
    COUNT(*) FILTER (
        WHERE number_of_orders > 1
    ) AS repeat_customers,

    COUNT(*) AS total_customers,

    ROUND(
        COUNT(*) FILTER (
            WHERE number_of_orders > 1
        ) * 100.0 / COUNT(*),
        2
    ) AS percentage_repeat_customers

FROM customer_order;


-- 2.3 Find the average number of orders per unique customer.

WITH customer_order AS (
    SELECT
        c.customer_unique_id,
        COUNT(o.order_id) AS number_of_orders
    FROM customers AS c
    LEFT JOIN orders AS o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
)

SELECT
    ROUND(AVG(number_of_orders), 2)
        AS average_orders_per_unique_customer
FROM customer_order;


-- 2.4 How many customers placed exactly one order, two orders, three orders, etc.?

WITH customer_order AS (
    SELECT
        c.customer_unique_id,
        COUNT(o.order_id) AS number_of_orders
    FROM customers AS c
    LEFT JOIN orders AS o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
)

SELECT
    number_of_orders,
    COUNT(*) AS number_of_customers
FROM customer_order
GROUP BY number_of_orders
ORDER BY number_of_orders ASC;


-- 2.5 Which customers have spent more than the average customer?

WITH spending AS (
    SELECT
        c.customer_unique_id,
        SUM(oi.price) AS total_spending
    FROM customers AS c
    JOIN orders AS o
        ON c.customer_id = o.customer_id
    JOIN order_items AS oi
        ON o.order_id = oi.order_id
    GROUP BY c.customer_unique_id
)

SELECT
    customer_unique_id,
    ROUND(total_spending, 2) AS total_spending
FROM spending
WHERE total_spending > (
    SELECT AVG(total_spending)
    FROM spending
)
ORDER BY total_spending DESC;


-- 2.6 Which Brazilian states have customers who have never placed an order?

SELECT
    c.customer_state,
    COUNT(*) AS number_of_customers_without_orders
FROM customers AS c
LEFT JOIN orders AS o
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL
GROUP BY c.customer_state
ORDER BY number_of_customers_without_orders DESC;



-- ============================================================
-- 3. SELLER ANALYSIS
-- ============================================================


-- 3.1 Which sellers have the best reviews?

-- Only sellers with at least 15 reviews are included to avoid rankings being dominated by sellers with very few reviews.

SELECT
    oi.seller_id,
    COUNT(orvs.review_score) AS number_of_reviews,
    ROUND(AVG(orvs.review_score), 2) AS average_review_score
FROM order_items AS oi
JOIN order_reviews AS orvs
    ON oi.order_id = orvs.order_id
GROUP BY oi.seller_id
HAVING COUNT(orvs.review_score) >= 15
ORDER BY average_review_score DESC;


-- 3.2 Show every seller, including sellers who have never sold an order.

SELECT
    s.seller_id,
    COUNT(oi.order_id) AS number_of_orders
FROM sellers AS s
LEFT JOIN order_items AS oi
    ON s.seller_id = oi.seller_id
GROUP BY s.seller_id
ORDER BY number_of_orders DESC;


-- 3.3 Which sellers have an average delivery time longer than the overall average delivery time?

WITH delivery_times AS (
    SELECT
        oi.seller_id,
        AVG(
            o.order_delivered_customer_date::date
            - o.order_estimated_delivery_date::date
        ) AS average_delivery_time
    FROM orders AS o
    JOIN order_items AS oi
        ON oi.order_id = o.order_id
    WHERE o.order_delivered_customer_date IS NOT NULL
      AND o.order_estimated_delivery_date IS NOT NULL
    GROUP BY oi.seller_id
)

SELECT
    seller_id,
    average_delivery_time
FROM delivery_times
WHERE average_delivery_time > (
    SELECT AVG(average_delivery_time)
    FROM delivery_times
)
ORDER BY average_delivery_time DESC;



-- ============================================================
-- 4. PAYMENT ANALYSIS
-- ============================================================


-- 4.1 What payment methods are most popular and what is the average amount paid?

SELECT
    op.payment_type,
    COUNT(*) AS payment_count,
    ROUND(AVG(op.payment_value), 2)
        AS average_payment_value
FROM order_payments AS op
GROUP BY op.payment_type
ORDER BY payment_count DESC;



-- ============================================================
-- 5. LOGISTICS & CUSTOMER SATISFACTION
-- ============================================================


-- 5.1 Does delivery time affect review scores including product category?

SELECT
    o.order_id,
    orvs.review_score,
    o.order_delivered_customer_date::date,
    o.order_estimated_delivery_date::date,

    o.order_delivered_customer_date::date
        - o.order_estimated_delivery_date::date
        AS delivery_difference_days,

    p.product_category_name

FROM orders AS o

JOIN order_reviews AS orvs
    ON o.order_id = orvs.order_id

JOIN order_items AS oi
    ON oi.order_id = o.order_id

JOIN products AS p
    ON p.product_id = oi.product_id

WHERE o.order_delivered_carrier_date IS NOT NULL
  AND o.order_delivered_customer_date IS NOT NULL
  AND o.order_estimated_delivery_date IS NOT NULL

ORDER BY delivery_difference_days DESC;


-- 5.2 Does delivery time affect review scores for different product categories?

SELECT
    p.product_category_name,
    COUNT(*) AS number_of_orders,
    ROUND(AVG(orvs.review_score), 2)
        AS average_review_score,

    ROUND(
        AVG(
            o.order_delivered_customer_date::date
            - o.order_estimated_delivery_date::date
        ),
        2
    ) AS delivery_difference_days

FROM orders AS o

JOIN order_reviews AS orvs
    ON o.order_id = orvs.order_id

JOIN order_items AS oi
    ON oi.order_id = o.order_id

JOIN products AS p
    ON p.product_id = oi.product_id

WHERE o.order_delivered_carrier_date IS NOT NULL
  AND o.order_delivered_customer_date IS NOT NULL
  AND o.order_estimated_delivery_date IS NOT NULL

GROUP BY p.product_category_name
ORDER BY delivery_difference_days DESC;


-- 5.3 Which states have the longest delivery times?

SELECT
    c.customer_state,
    COUNT(*) AS number_of_orders,

    ROUND(
        AVG(
            o.order_delivered_customer_date::date
            - o.order_estimated_delivery_date::date
        ),
        2
    ) AS average_delivery_difference_days

FROM orders AS o

JOIN customers AS c
    ON o.customer_id = c.customer_id

WHERE o.order_delivered_carrier_date IS NOT NULL
  AND o.order_delivered_customer_date IS NOT NULL
  AND o.order_estimated_delivery_date IS NOT NULL

GROUP BY c.customer_state
ORDER BY average_delivery_difference_days DESC;



-- ============================================================
-- 6. ADVANCED BUSINESS ANALYSIS
-- ============================================================


-- 6.1 Are expensive products more likely to receive lower reviews?

WITH all_products AS (
    SELECT
        oi.product_id,
        oi.price,
        orvs.review_score
    FROM order_items AS oi
    JOIN order_reviews AS orvs
        ON oi.order_id = orvs.order_id
)

SELECT
    CASE
        WHEN price < 50 THEN 'Under 50'
        WHEN price < 100 THEN '50-100'
        WHEN price < 200 THEN '100-200'
        WHEN price < 500 THEN '200-500'
        ELSE '500 and above'
    END AS price_range,

    COUNT(*) AS number_of_reviews,

    ROUND(AVG(review_score), 2)
        AS average_review_score

FROM all_products

GROUP BY price_range
ORDER BY average_review_score ASC;


-- 6.2 Which product categories have both above-average revenue AND below-average review scores?

WITH product_category AS (
    SELECT
        p.product_category_name,
        SUM(oi.price) AS revenue,
        AVG(orvs.review_score) AS average_review_score

    FROM order_items AS oi

    JOIN order_reviews AS orvs
        ON oi.order_id = orvs.order_id

    JOIN products AS p
        ON oi.product_id = p.product_id

    GROUP BY p.product_category_name
)

SELECT
    product_category_name,
    revenue,
    ROUND(average_review_score, 2)
        AS average_review_score

FROM product_category

WHERE revenue > (
    SELECT AVG(revenue)
    FROM product_category
)

AND average_review_score < (
    SELECT AVG(average_review_score)
    FROM product_category
)

ORDER BY revenue DESC;