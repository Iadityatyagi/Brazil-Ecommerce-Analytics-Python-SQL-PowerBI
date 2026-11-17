-- 1. ORDERS
CREATE TABLE orders (
    order_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50),
    order_status VARCHAR(30),
    order_purchase_timestamp TIMESTAMP,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP,
    delivery_days NUMERIC(10,2)
);

select * from public.orders

-- 2. CUSTOMERS
CREATE TABLE customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_unique_id VARCHAR(50),
    customer_zip_code_prefix VARCHAR(10),
    customer_city VARCHAR(100),
    customer_state VARCHAR(10)
);

select * from public.customers

-- 3. PRODUCTS
CREATE TABLE products (
    product_id VARCHAR(50) PRIMARY KEY,
    product_category_name VARCHAR(150),
    product_name_lenght INTEGER,
    product_description_lenght INTEGER,
    product_photos_qty INTEGER,
    product_weight_g NUMERIC(12,2),
    product_length_cm NUMERIC(12,2),
    product_height_cm NUMERIC(12,2),
    product_width_cm NUMERIC(12,2)
);

select * from public.products

-- 4. SELLERS
CREATE TABLE sellers (
    seller_id VARCHAR(50) PRIMARY KEY,
    seller_zip_code_prefix VARCHAR(10),
    seller_city VARCHAR(100),
    seller_state VARCHAR(10)
);

select * from public.sellers

-- 5. ORDER ITEMS
CREATE TABLE order_items (
    order_id VARCHAR(50),
    order_item_id INTEGER,
    product_id VARCHAR(50),
    seller_id VARCHAR(50),
    shipping_limit_date TIMESTAMP,
    price NUMERIC(12,2),
    freight_value NUMERIC(12,2),
    total_item_amount NUMERIC(12,2)
);

select * from public.order_items

-- 6. PAYMENTS
CREATE TABLE payments (
    order_id VARCHAR(50),
    payment_sequential INTEGER,
    payment_type VARCHAR(50),
    payment_installments INTEGER,
    payment_value NUMERIC(12,2)
);

select * from public.payments

-- 7. REVIEWS
CREATE TABLE reviews (
    review_id VARCHAR(50),
    order_id VARCHAR(50),
    review_score INTEGER,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date TIMESTAMP,
    review_answer_timestamp TIMESTAMP
);

select * from public.reviews

-- 8. GEOLOCATION
CREATE TABLE geolocation (
    geolocation_zip_code_prefix VARCHAR(10),
    latitude NUMERIC(12,8),
    longitude NUMERIC(12,8)
);

select * from public.geolocation

-- 9. CATEGORY TRANSLATION
CREATE TABLE category_translation (
    product_category_name VARCHAR(150),
    product_category_name_english VARCHAR(150)
);

select * from public.category_translation


SELECT COUNT(*) AS total_orders
FROM orders;

SELECT *
FROM orders
LIMIT 10;


USE ecommerce_analytics;

SELECT COUNT(*) AS total_products
FROM products;

SELECT *
FROM products
LIMIT 10;



SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT product_id) AS unique_products,
    COUNT(*) - COUNT(product_id) AS missing_product_ids
FROM products;


USE ecommerce_analytics;

SELECT COUNT(*) AS total_sellers
FROM sellers;

SELECT *
FROM sellers
LIMIT 10;

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT seller_id) AS unique_sellers,
    COUNT(*) - COUNT(seller_id) AS missing_seller_ids
FROM sellers;


USE ecommerce_analytics;

SELECT COUNT(*) AS total_order_items
FROM order_items;

SELECT *
FROM order_items
LIMIT 10;


SELECT
    COUNT(*) AS total_items,
    COUNT(DISTINCT order_id) AS unique_orders,
    COUNT(DISTINCT product_id) AS unique_products,
    ROUND(SUM(price), 2) AS total_product_revenue,
    ROUND(SUM(freight_value), 2) AS total_freight
FROM order_items;


USE ecommerce_analytics;

SELECT COUNT(*) AS total_payment_records
FROM payments;

SELECT *
FROM payments
LIMIT 10;

SELECT
    payment_type,
    COUNT(*) AS total_transactions,
    ROUND(SUM(payment_value), 2) AS total_payment_value,
    ROUND(AVG(payment_value), 2) AS average_payment_value
FROM payments
GROUP BY payment_type
ORDER BY total_payment_value DESC;


USE ecommerce_analytics;

SELECT COUNT(*) AS total_reviews
FROM reviews;

SELECT *
FROM reviews
LIMIT 10;


SELECT
    review_score,
    COUNT(*) AS total_reviews,
    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM reviews),
        2
    ) AS review_percentage
FROM reviews
GROUP BY review_score
ORDER BY review_score DESC;

SELECT
    COUNT(*) AS total_reviews,
    ROUND(AVG(review_score), 2) AS average_rating,
    SUM(CASE WHEN review_score >= 4 THEN 1 ELSE 0 END) AS positive_reviews,
    SUM(CASE WHEN review_score <= 2 THEN 1 ELSE 0 END) AS negative_reviews
FROM reviews;


SELECT COUNT(*) AS total_geolocation_records
FROM geolocation;

SELECT *
FROM geolocation
LIMIT 10;


SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT geolocation_zip_code_prefix) AS unique_zip_codes,
    COUNT(latitude) AS available_latitudes,
    COUNT(longitude) AS available_longitudes
FROM geolocation;


SELECT COUNT(*) AS total_categories
FROM category_translation;

SELECT *
FROM category_translation
LIMIT 10;



SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT product_category_name) AS unique_categories,
    COUNT(product_category_name_english) AS translated_categories
FROM category_translation;


USE ecommerce_analytics;

SELECT 'orders' AS table_name, COUNT(*) AS total_rows FROM orders
UNION ALL
SELECT 'customers', COUNT(*) FROM customers
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'sellers', COUNT(*) FROM sellers
UNION ALL
SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL
SELECT 'payments', COUNT(*) FROM payments
UNION ALL
SELECT 'reviews', COUNT(*) FROM reviews
UNION ALL
SELECT 'geolocation', COUNT(*) FROM geolocation
UNION ALL
SELECT 'category_translation', COUNT(*) FROM category_translation;


SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT order_id) AS unique_orders
FROM orders;


SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM customers;


SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT product_id) AS unique_products
FROM products;


SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT seller_id) AS unique_sellers
FROM sellers;



SELECT
    COUNT(*) FILTER (WHERE order_id IS NULL) AS missing_order_ids
FROM orders;

SELECT
    COUNT(*) FILTER (WHERE customer_id IS NULL) AS missing_customer_ids
FROM customers;

SELECT
    COUNT(*) FILTER (WHERE seller_id IS NULL) AS missing_seller_ids
FROM sellers;


-- STEP 50.1: OVERALL BUSINESS PERFORMANCE

SELECT
    (SELECT COUNT(DISTINCT order_id)
     FROM orders) AS total_orders,

    (SELECT COUNT(DISTINCT customer_unique_id)
     FROM customers) AS total_customers,

    (SELECT COUNT(DISTINCT product_id)
     FROM products) AS total_products,

    (SELECT COUNT(DISTINCT seller_id)
     FROM sellers) AS total_sellers,

    (SELECT ROUND(SUM(price::numeric), 2)
     FROM order_items) AS total_product_revenue,

    (SELECT ROUND(SUM(freight_value::numeric), 2)
     FROM order_items) AS total_freight,

    (SELECT ROUND(SUM(payment_value::numeric), 2)
     FROM payments) AS total_customer_payments,

    (SELECT ROUND(
        SUM(price::numeric) /
        NULLIF(COUNT(DISTINCT order_id), 0), 2
     )
     FROM order_items) AS average_order_value;



-- STEP 51: MONTHLY SALES AND REVENUE ANALYSIS

SELECT
    TO_CHAR(
        order_purchase_timestamp::timestamp,
        'YYYY-MM'
    ) AS sales_month,

    COUNT(DISTINCT o.order_id) AS total_orders,

    COUNT(oi.order_item_id) AS total_items_sold,

    ROUND(SUM(oi.price::numeric), 2) AS total_revenue,

    ROUND(SUM(oi.freight_value::numeric), 2) AS total_freight,

    ROUND(
        SUM(oi.price::numeric) /
        NULLIF(COUNT(DISTINCT o.order_id), 0),
        2
    ) AS average_order_value

FROM orders o

INNER JOIN order_items oi
    ON o.order_id = oi.order_id

WHERE o.order_purchase_timestamp IS NOT NULL

GROUP BY sales_month

ORDER BY sales_month;



SELECT
    TO_CHAR(
        o.order_purchase_timestamp::timestamp,
        'YYYY-MM'
    ) AS sales_month,

    ROUND(SUM(oi.price::numeric), 2) AS total_revenue

FROM orders o

JOIN order_items oi
    ON o.order_id = oi.order_id

WHERE o.order_purchase_timestamp IS NOT NULL

GROUP BY sales_month

ORDER BY total_revenue DESC

LIMIT 1;


-- STEP 52: YEARLY REVENUE ANALYSIS

SELECT
    EXTRACT(
        YEAR FROM order_purchase_timestamp::timestamp
    ) AS sales_year,

    COUNT(DISTINCT o.order_id) AS total_orders,

    COUNT(oi.order_item_id) AS total_items_sold,

    ROUND(SUM(oi.price::numeric), 2) AS yearly_revenue

FROM orders o

INNER JOIN order_items oi
    ON o.order_id = oi.order_id

WHERE o.order_purchase_timestamp IS NOT NULL

GROUP BY sales_year

ORDER BY sales_year;


-- YEAR-OVER-YEAR REVENUE GROWTH

WITH yearly_sales AS (
    SELECT
        EXTRACT(
            YEAR FROM o.order_purchase_timestamp::timestamp
        ) AS sales_year,

        SUM(oi.price::numeric) AS revenue

    FROM orders o

    JOIN order_items oi
        ON o.order_id = oi.order_id

    WHERE o.order_purchase_timestamp IS NOT NULL

    GROUP BY sales_year
),

revenue_comparison AS (
    SELECT
        sales_year,
        revenue,

        LAG(revenue) OVER (
            ORDER BY sales_year
        ) AS previous_year_revenue

    FROM yearly_sales
)

SELECT
    sales_year,

    ROUND(revenue, 2) AS current_year_revenue,

    ROUND(previous_year_revenue, 2) AS previous_year_revenue,

    ROUND(
        (revenue - previous_year_revenue)
        * 100.0 / NULLIF(previous_year_revenue, 0),
        2
    ) AS revenue_growth_percentage

FROM revenue_comparison

ORDER BY sales_year;


SELECT *
FROM category_translation
LIMIT 10;


SELECT *
FROM products
LIMIT 10;


-- STEP 53: PRODUCT CATEGORY PERFORMANCE

SELECT
    COALESCE(
        ct.product_category_name_english,
        'Unknown'
    ) AS product_category,

    COUNT(oi.order_item_id) AS total_items_sold,

    COUNT(DISTINCT oi.order_id) AS total_orders,

    ROUND(SUM(oi.price::numeric), 2) AS total_revenue,

    ROUND(AVG(oi.price::numeric), 2) AS average_product_price

FROM order_items oi

INNER JOIN products p
    ON oi.product_id = p.product_id

LEFT JOIN category_translation ct
    ON p.product_category_name = ct.product_category_name

GROUP BY product_category

ORDER BY total_revenue DESC;



SELECT
    COALESCE(ct.product_category_name_english, 'Unknown')
        AS product_category,

    ROUND(SUM(oi.price::numeric), 2) AS total_revenue

FROM order_items oi

JOIN products p
    ON oi.product_id = p.product_id

LEFT JOIN category_translation ct
    ON p.product_category_name = ct.product_category_name

GROUP BY product_category

ORDER BY total_revenue DESC

LIMIT 10;



SELECT
    COALESCE(ct.product_category_name_english, 'Unknown')
        AS product_category,

    COUNT(oi.order_item_id) AS total_items_sold

FROM order_items oi

JOIN products p
    ON oi.product_id = p.product_id

LEFT JOIN category_translation ct
    ON p.product_category_name = ct.product_category_name

GROUP BY product_category

ORDER BY total_items_sold DESC

LIMIT 10;



-- STEP 54.1: TOP 10 PRODUCTS BY REVENUE

SELECT
    oi.product_id,

    COALESCE(
        ct.product_category_name_english,
        'Unknown'
    ) AS product_category,

    COUNT(oi.order_item_id) AS total_items_sold,

    COUNT(DISTINCT oi.order_id) AS total_orders,

    ROUND(SUM(oi.price::numeric), 2) AS total_revenue,

    ROUND(AVG(oi.price::numeric), 2) AS average_price

FROM order_items oi

JOIN products p
    ON oi.product_id = p.product_id

LEFT JOIN category_translation ct
    ON p.product_category_name = ct.product_category_name

GROUP BY
    oi.product_id,
    ct.product_category_name_english

ORDER BY total_revenue DESC

LIMIT 10;


-- STEP 54.2: TOP 10 PRODUCTS BY QUANTITY

SELECT
    oi.product_id,

    COALESCE(
        ct.product_category_name_english,
        'Unknown'
    ) AS product_category,

    COUNT(oi.order_item_id) AS total_items_sold,

    ROUND(SUM(oi.price::numeric), 2) AS total_revenue

FROM order_items oi

JOIN products p
    ON oi.product_id = p.product_id

LEFT JOIN category_translation ct
    ON p.product_category_name = ct.product_category_name

GROUP BY
    oi.product_id,
    ct.product_category_name_english

ORDER BY total_items_sold DESC

LIMIT 10;


-- STEP 54.3: PRODUCT PERFORMANCE SEGMENTS

WITH product_sales AS (
    SELECT
        product_id,
        COUNT(*) AS total_items_sold,
        SUM(price::numeric) AS total_revenue,
        AVG(price::numeric) AS average_price
    FROM order_items
    GROUP BY product_id
)

SELECT
    product_id,
    total_items_sold,
    ROUND(total_revenue, 2) AS total_revenue,
    ROUND(average_price, 2) AS average_price,

    CASE
        WHEN total_revenue >= 10000 THEN 'High Revenue'
        WHEN total_revenue >= 3000 THEN 'Medium Revenue'
        ELSE 'Low Revenue'
    END AS revenue_segment

FROM product_sales

ORDER BY total_revenue DESC

LIMIT 20;


-- STEP 55.1: CUSTOMER PURCHASE FREQUENCY

SELECT
    COUNT(DISTINCT c.customer_unique_id) AS total_unique_customers,

    COUNT(DISTINCT o.order_id) AS total_orders,

    ROUND(
        COUNT(DISTINCT o.order_id)::numeric /
        NULLIF(COUNT(DISTINCT c.customer_unique_id), 0),
        2
    ) AS average_orders_per_customer

FROM orders o

JOIN customers c
    ON o.customer_id = c.customer_id;


	-- STEP 55.2: REPEAT VS ONE-TIME CUSTOMERS

WITH customer_frequency AS (

    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS total_orders

    FROM orders o

    JOIN customers c
        ON o.customer_id = c.customer_id

    GROUP BY c.customer_unique_id
)

SELECT
    CASE
        WHEN total_orders = 1 THEN 'One-Time Customer'
        ELSE 'Repeat Customer'
    END AS customer_type,

    COUNT(*) AS total_customers,

    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (),
        2
    ) AS customer_percentage

FROM customer_frequency

GROUP BY customer_type

ORDER BY total_customers DESC;

-- STEP 55.3: CUSTOMER REVENUE ANALYSIS

SELECT
    c.customer_unique_id,

    COUNT(DISTINCT o.order_id) AS total_orders,

    COUNT(oi.order_item_id) AS total_items_purchased,

    ROUND(SUM(oi.price::numeric), 2) AS total_revenue,

    ROUND(
        SUM(oi.price::numeric) /
        NULLIF(COUNT(DISTINCT o.order_id), 0),
        2
    ) AS average_order_value

FROM customers c

JOIN orders o
    ON c.customer_id = o.customer_id

JOIN order_items oi
    ON o.order_id = oi.order_id

GROUP BY c.customer_unique_id

ORDER BY total_revenue DESC

LIMIT 20;


--Calculate overall repeat customer rate
WITH customer_frequency AS (

    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS total_orders

    FROM orders o

    JOIN customers c
        ON o.customer_id = c.customer_id

    GROUP BY c.customer_unique_id
)

SELECT
    COUNT(*) AS total_customers,

    COUNT(*) FILTER (
        WHERE total_orders > 1
    ) AS repeat_customers,

    COUNT(*) FILTER (
        WHERE total_orders = 1
    ) AS one_time_customers,

    ROUND(
        COUNT(*) FILTER (WHERE total_orders > 1) * 100.0 /
        NULLIF(COUNT(*), 0),
        2
    ) AS repeat_customer_percentage

FROM customer_frequency;


-- STEP 56.1: PAYMENT METHOD PERFORMANCE

SELECT
    payment_type,

    COUNT(*) AS total_transactions,

    COUNT(DISTINCT order_id) AS total_orders,

    ROUND(SUM(payment_value::numeric), 2) AS total_payment_value,

    ROUND(AVG(payment_value::numeric), 2) AS average_payment_value

FROM payments

GROUP BY payment_type

ORDER BY total_payment_value DESC;


-- STEP 56.2: PAYMENT METHOD CONTRIBUTION

SELECT
    payment_type,

    ROUND(SUM(payment_value::numeric), 2) AS total_payment,

    ROUND(
        SUM(payment_value::numeric) * 100.0 /
        SUM(SUM(payment_value::numeric)) OVER (),
        2
    ) AS payment_percentage

FROM payments

GROUP BY payment_type

ORDER BY total_payment DESC;



-- STEP 56.3: PAYMENT INSTALLMENT ANALYSIS

SELECT
    payment_installments,

    COUNT(*) AS total_transactions,

    ROUND(SUM(payment_value::numeric), 2) AS total_payment_value,

    ROUND(AVG(payment_value::numeric), 2) AS average_payment_value

FROM payments

GROUP BY payment_installments

ORDER BY payment_installments;


-- STEP 56.4: PAYMENT METHOD ORDER RANKING

SELECT
    payment_type,

    COUNT(DISTINCT order_id) AS total_orders,

    DENSE_RANK() OVER (
        ORDER BY COUNT(DISTINCT order_id) DESC
    ) AS payment_method_rank

FROM payments

GROUP BY payment_type

ORDER BY payment_method_rank;



-- STEP 57.1: AVERAGE DELIVERY TIME

SELECT
    COUNT(*) AS total_delivered_orders,

    ROUND(
        AVG(
            EXTRACT(
                EPOCH FROM (
                    order_delivered_customer_date::timestamp
                    - order_purchase_timestamp::timestamp
                )
            ) / 86400
        )::numeric,
        2
    ) AS average_delivery_days

FROM orders

WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL
  AND order_purchase_timestamp IS NOT NULL;



  -- STEP 57.2: DELIVERY PERFORMANCE

SELECT
    CASE
        WHEN order_delivered_customer_date::timestamp
             > order_estimated_delivery_date::timestamp
        THEN 'Late Delivery'

        WHEN order_delivered_customer_date::timestamp
             <= order_estimated_delivery_date::timestamp
        THEN 'On-Time / Early Delivery'
    END AS delivery_status,

    COUNT(*) AS total_orders,

    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (),
        2
    ) AS delivery_percentage

FROM orders

WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL

GROUP BY delivery_status
ORDER BY total_orders DESC;


-- STEP 57.3: DELIVERY DELAY ANALYSIS

SELECT
    order_id,

    order_purchase_timestamp::timestamp AS purchase_date,

    order_delivered_customer_date::timestamp AS actual_delivery_date,

    order_estimated_delivery_date::timestamp AS estimated_delivery_date,

    ROUND(
        (
            EXTRACT(
                EPOCH FROM (
                    order_delivered_customer_date::timestamp
                    - order_estimated_delivery_date::timestamp
                )
            ) / 86400
        )::numeric,
        2
    ) AS delivery_delay_days

FROM orders

WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL

ORDER BY delivery_delay_days DESC

LIMIT 20;




-- STEP 57.4: YEARLY DELIVERY PERFORMANCE

SELECT
    EXTRACT(
        YEAR FROM order_purchase_timestamp::timestamp
    ) AS delivery_year,

    COUNT(*) AS delivered_orders,

    ROUND(
        AVG(
            EXTRACT(
                EPOCH FROM (
                    order_delivered_customer_date::timestamp
                    - order_purchase_timestamp::timestamp
                )
            ) / 86400
        )::numeric,
        2
    ) AS average_delivery_days

FROM orders

WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL
  AND order_purchase_timestamp IS NOT NULL

GROUP BY delivery_year

ORDER BY delivery_year;



-- STEP 58.1: OVERALL CUSTOMER SATISFACTION

SELECT
    COUNT(*) AS total_reviews,

    ROUND(AVG(review_score::numeric), 2) AS average_rating,

    COUNT(*) FILTER (
        WHERE review_score::integer >= 4
    ) AS positive_reviews,

    COUNT(*) FILTER (
        WHERE review_score::integer = 3
    ) AS neutral_reviews,

    COUNT(*) FILTER (
        WHERE review_score::integer <= 2
    ) AS negative_reviews

FROM reviews;


-- STEP 58.2: REVIEW SCORE DISTRIBUTION

SELECT
    review_score,

    COUNT(*) AS total_reviews,

    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS review_percentage

FROM reviews

GROUP BY review_score

ORDER BY review_score DESC;



-- STEP 58.3: CATEGORY-WISE CUSTOMER SATISFACTION

SELECT
    COALESCE(
        ct.product_category_name_english,
        'Unknown'
    ) AS product_category,

    COUNT(DISTINCT r.review_id) AS total_reviews,

    ROUND(
        AVG(r.review_score::numeric),
        2
    ) AS average_rating,

    COUNT(*) FILTER (
        WHERE r.review_score::integer <= 2
    ) AS negative_reviews

FROM reviews r

JOIN order_items oi
    ON r.order_id = oi.order_id

JOIN products p
    ON oi.product_id = p.product_id

LEFT JOIN category_translation ct
    ON p.product_category_name = ct.product_category_name

GROUP BY product_category

HAVING COUNT(DISTINCT r.review_id) >= 50

ORDER BY average_rating ASC;


-- STEP 58.4: LOW-RATING CUSTOMER REVIEWS

SELECT
    review_id,
    order_id,
    review_score,
    review_comment_message

FROM reviews

WHERE review_score::integer <= 2

ORDER BY review_score ASC

LIMIT 20;


--Geographic Sales Analysis
SELECT
    c.customer_state,
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(DISTINCT c.customer_unique_id) AS unique_customers,
    COUNT(oi.order_item_id) AS total_items_sold,
    ROUND(SUM(oi.price::numeric), 2) AS total_revenue,
    ROUND(
        SUM(oi.price::numeric) * 100.0 /
        SUM(SUM(oi.price::numeric)) OVER (),
        2
    ) AS revenue_percentage
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY c.customer_state
ORDER BY total_revenue DESC;


---Top 10 cities by revenue

SELECT
    c.customer_city,
    c.customer_state,
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(DISTINCT c.customer_unique_id) AS unique_customers,
    ROUND(SUM(oi.price::numeric), 2) AS total_revenue
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY
    c.customer_city,
    c.customer_state
ORDER BY total_revenue DESC
LIMIT 10;


--Build the RFM dataset
WITH customer_orders AS (
    SELECT
        c.customer_unique_id,
        o.order_id,
        o.order_purchase_timestamp::timestamp AS purchase_date,
        SUM(oi.price::numeric) AS order_revenue
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    WHERE o.order_purchase_timestamp IS NOT NULL
    GROUP BY
        c.customer_unique_id,
        o.order_id,
        o.order_purchase_timestamp
),

rfm_base AS (
    SELECT
        customer_unique_id,
        MAX(purchase_date) AS last_purchase_date,
        COUNT(DISTINCT order_id) AS frequency,
        SUM(order_revenue) AS monetary
    FROM customer_orders
    GROUP BY customer_unique_id
),

rfm_scores AS (
    SELECT
        customer_unique_id,

        EXTRACT(EPOCH FROM (
            (SELECT MAX(purchase_date) + INTERVAL '1 day'
             FROM customer_orders) - last_purchase_date
        )) / 86400 AS recency,

        frequency,
        monetary,

        6 - NTILE(5) OVER (
            ORDER BY last_purchase_date ASC
        ) AS r_score,

        NTILE(5) OVER (
            ORDER BY frequency ASC
        ) AS f_score,

        NTILE(5) OVER (
            ORDER BY monetary ASC
        ) AS m_score

    FROM rfm_base
)

SELECT
    customer_unique_id,
    ROUND(recency::numeric, 0) AS recency_days,
    frequency,
    ROUND(monetary, 2) AS monetary,
    r_score,
    f_score,
    m_score,
    (r_score + f_score + m_score) AS rfm_total_score

FROM rfm_scores
ORDER BY
    rfm_total_score DESC,
    monetary DESC;


--Final business KPI summary

	SELECT
    (SELECT COUNT(DISTINCT order_id)
     FROM orders) AS total_orders,

    (SELECT COUNT(DISTINCT customer_unique_id)
     FROM customers) AS total_customers,

    (SELECT COUNT(DISTINCT product_id)
     FROM products) AS total_products,

    (SELECT COUNT(DISTINCT seller_id)
     FROM sellers) AS total_sellers,

    (SELECT ROUND(SUM(price::numeric), 2)
     FROM order_items) AS total_revenue,

    (SELECT ROUND(AVG(price::numeric), 2)
     FROM order_items) AS average_item_price,

    (SELECT ROUND(AVG(review_score::numeric), 2)
     FROM reviews) AS average_review_score,

    (SELECT ROUND(AVG(
        EXTRACT(EPOCH FROM (
            order_delivered_customer_date::timestamp -
            order_purchase_timestamp::timestamp
        )) / 86400
     )::numeric, 2)
     FROM orders
     WHERE order_delivered_customer_date IS NOT NULL
       AND order_purchase_timestamp IS NOT NULL
    ) AS average_delivery_days;


--Export monthly sales
SELECT
    TO_CHAR(o.order_purchase_timestamp::timestamp, 'YYYY-MM') AS sales_month,
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(oi.order_item_id) AS total_items_sold,
    ROUND(SUM(oi.price::numeric), 2) AS total_revenue,
    ROUND(SUM(oi.freight_value::numeric), 2) AS total_freight
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.order_purchase_timestamp IS NOT NULL
GROUP BY sales_month
ORDER BY sales_month;

--Export product category performance
SELECT
    COALESCE(ct.product_category_name_english,
             p.product_category_name) AS category_name,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    COUNT(oi.order_item_id) AS total_items_sold,
    ROUND(SUM(oi.price::numeric), 2) AS total_revenue
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
LEFT JOIN category_translation ct
    ON p.product_category_name = ct.product_category_name
GROUP BY category_name
ORDER BY total_revenue DESC;


--Export payment performance

SELECT
    payment_type,
    COUNT(*) AS total_payment_records,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(payment_value::numeric), 2) AS total_payment_value,
    ROUND(AVG(payment_value::numeric), 2) AS average_payment_value
FROM payments
GROUP BY payment_type
ORDER BY total_payment_value DESC;


--Export customer satisfaction

SELECT
    review_score,
    COUNT(*) AS total_reviews,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS review_percentage
FROM reviews
GROUP BY review_score
ORDER BY review_score DESC;




-- ============================================================
-- PROJECT: E-COMMERCE CUSTOMER BEHAVIOUR & REVENUE INTELLIGENCE
-- DATABASE: ecommerce_analytics
-- SQL DIALECT: PostgreSQL
-- DATA SOURCE: Brazilian E-Commerce Public Dataset by Olist
-- ============================================================

-- ============================================================
-- 01. DATABASE AND TABLE VALIDATION
-- ============================================================

SELECT current_database();

SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;

-- Check row counts

SELECT 'orders' AS table_name, COUNT(*) AS total_rows FROM orders
UNION ALL
SELECT 'customers', COUNT(*) FROM customers
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'sellers', COUNT(*) FROM sellers
UNION ALL
SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL
SELECT 'payments', COUNT(*) FROM payments
UNION ALL
SELECT 'reviews', COUNT(*) FROM reviews
UNION ALL
SELECT 'geolocation', COUNT(*) FROM geolocation
UNION ALL
SELECT 'category_translation', COUNT(*) FROM category_translation;


-- ============================================================
-- 02. DATA QUALITY VALIDATION
-- ============================================================

SELECT
    COUNT(*) FILTER (WHERE order_id IS NULL) AS missing_order_ids
FROM orders;

SELECT
    COUNT(*) FILTER (WHERE customer_id IS NULL) AS missing_customer_ids
FROM customers;

SELECT
    COUNT(*) FILTER (WHERE product_id IS NULL) AS missing_product_ids
FROM products;

SELECT
    COUNT(*) FILTER (WHERE seller_id IS NULL) AS missing_seller_ids
FROM sellers;

-- Check duplicate order IDs

SELECT order_id, COUNT(*) AS duplicate_count
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;

-- Check duplicate customer records

SELECT customer_id, COUNT(*) AS duplicate_count
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;


-- ============================================================
-- 03. OVERALL BUSINESS KPI ANALYSIS
-- ============================================================

SELECT
    (SELECT COUNT(DISTINCT order_id)
     FROM orders) AS total_orders,

    (SELECT COUNT(DISTINCT customer_unique_id)
     FROM customers) AS total_customers,

    (SELECT COUNT(DISTINCT product_id)
     FROM products) AS total_products,

    (SELECT COUNT(DISTINCT seller_id)
     FROM sellers) AS total_sellers,

    (SELECT ROUND(SUM(price::numeric), 2)
     FROM order_items) AS total_product_revenue,

    (SELECT ROUND(SUM(freight_value::numeric), 2)
     FROM order_items) AS total_freight,

    (SELECT ROUND(SUM(payment_value::numeric), 2)
     FROM payments) AS total_customer_payments,

    (SELECT ROUND(
        SUM(price::numeric) /
        NULLIF(COUNT(DISTINCT order_id), 0), 2)
     FROM order_items) AS average_order_value;


-- ============================================================
-- 04. MONTHLY SALES ANALYSIS
-- ============================================================

SELECT
    TO_CHAR(
        o.order_purchase_timestamp::timestamp,
        'YYYY-MM'
    ) AS sales_month,

    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(oi.order_item_id) AS total_items_sold,
    ROUND(SUM(oi.price::numeric), 2) AS total_revenue,
    ROUND(SUM(oi.freight_value::numeric), 2) AS total_freight,

    ROUND(
        SUM(oi.price::numeric) /
        NULLIF(COUNT(DISTINCT o.order_id), 0), 2
    ) AS average_order_value

FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id

WHERE o.order_purchase_timestamp IS NOT NULL

GROUP BY sales_month
ORDER BY sales_month;


-- ============================================================
-- 05. YEARLY REVENUE AND YEAR-OVER-YEAR GROWTH
-- ============================================================

WITH yearly_sales AS (
    SELECT
        EXTRACT(
            YEAR FROM o.order_purchase_timestamp::timestamp
        ) AS sales_year,

        SUM(oi.price::numeric) AS total_revenue,
        COUNT(DISTINCT o.order_id) AS total_orders

    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id

    WHERE o.order_purchase_timestamp IS NOT NULL

    GROUP BY sales_year
),

yearly_growth AS (
    SELECT
        sales_year,
        total_revenue,
        total_orders,

        LAG(total_revenue) OVER (
            ORDER BY sales_year
        ) AS previous_year_revenue

    FROM yearly_sales
)

SELECT
    sales_year,
    ROUND(total_revenue, 2) AS total_revenue,
    total_orders,
    ROUND(previous_year_revenue, 2) AS previous_year_revenue,

    ROUND(
        (total_revenue - previous_year_revenue) * 100.0 /
        NULLIF(previous_year_revenue, 0), 2
    ) AS yoy_growth_percentage

FROM yearly_growth
ORDER BY sales_year;


-- ============================================================
-- 06. PRODUCT CATEGORY PERFORMANCE
-- ============================================================

SELECT
    COALESCE(
        ct.product_category_name_english,
        p.product_category_name
    ) AS category_name,

    COUNT(DISTINCT oi.order_id) AS total_orders,
    COUNT(oi.order_item_id) AS total_items_sold,
    ROUND(SUM(oi.price::numeric), 2) AS total_revenue,
    ROUND(AVG(oi.price::numeric), 2) AS average_product_price

FROM order_items oi

JOIN products p
    ON oi.product_id = p.product_id

LEFT JOIN category_translation ct
    ON p.product_category_name = ct.product_category_name

GROUP BY category_name
ORDER BY total_revenue DESC;


-- ============================================================
-- 07. TOP 10 PRODUCTS
-- ============================================================

SELECT
    oi.product_id,
    COALESCE(
        ct.product_category_name_english,
        p.product_category_name
    ) AS category_name,

    COUNT(DISTINCT oi.order_id) AS total_orders,
    COUNT(oi.order_item_id) AS total_items_sold,
    ROUND(SUM(oi.price::numeric), 2) AS total_revenue

FROM order_items oi

JOIN products p
    ON oi.product_id = p.product_id

LEFT JOIN category_translation ct
    ON p.product_category_name = ct.product_category_name

GROUP BY
    oi.product_id,
    category_name

ORDER BY total_revenue DESC
LIMIT 10;


-- ============================================================
-- 08. CUSTOMER PURCHASE BEHAVIOUR
-- ============================================================

WITH customer_frequency AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(oi.price::numeric) AS total_spending

    FROM customers c

    JOIN orders o
        ON c.customer_id = o.customer_id

    JOIN order_items oi
        ON o.order_id = oi.order_id

    GROUP BY c.customer_unique_id
)

SELECT
    CASE
        WHEN total_orders = 1 THEN 'One-Time Customer'
        ELSE 'Repeat Customer'
    END AS customer_type,

    COUNT(*) AS total_customers,
    SUM(total_orders) AS total_orders,
    ROUND(SUM(total_spending), 2) AS total_revenue,
    ROUND(AVG(total_spending), 2) AS average_customer_spending

FROM customer_frequency

GROUP BY customer_type
ORDER BY total_customers DESC;


-- ============================================================
-- 09. PAYMENT BEHAVIOUR ANALYSIS
-- ============================================================

SELECT
    payment_type,
    COUNT(*) AS total_payment_records,
    COUNT(DISTINCT order_id) AS total_orders,

    ROUND(SUM(payment_value::numeric), 2)
        AS total_payment_value,

    ROUND(AVG(payment_value::numeric), 2)
        AS average_payment_value

FROM payments

GROUP BY payment_type
ORDER BY total_payment_value DESC;


-- PAYMENT INSTALLMENT ANALYSIS

SELECT
    payment_installments,
    COUNT(*) AS total_payment_records,
    ROUND(SUM(payment_value::numeric), 2) AS total_payment_value

FROM payments

GROUP BY payment_installments
ORDER BY payment_installments;


-- ============================================================
-- 10. DELIVERY PERFORMANCE ANALYSIS
-- ============================================================

-- Average delivery time

SELECT
    ROUND(
        AVG(
            EXTRACT(
                EPOCH FROM (
                    order_delivered_customer_date::timestamp -
                    order_purchase_timestamp::timestamp
                )
            ) / 86400
        )::numeric, 2
    ) AS average_delivery_days

FROM orders

WHERE order_delivered_customer_date IS NOT NULL
  AND order_purchase_timestamp IS NOT NULL;


-- On-time versus late deliveries

SELECT
    CASE
        WHEN order_delivered_customer_date::timestamp >
             order_estimated_delivery_date::timestamp
        THEN 'Late Delivery'

        WHEN order_delivered_customer_date::timestamp <
             order_estimated_delivery_date::timestamp
        THEN 'Early Delivery'

        ELSE 'On-Time Delivery'
    END AS delivery_status,

    COUNT(*) AS total_orders

FROM orders

WHERE order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL

GROUP BY delivery_status
ORDER BY total_orders DESC;


-- Average delivery time by year

SELECT
    EXTRACT(
        YEAR FROM order_purchase_timestamp::timestamp
    ) AS purchase_year,

    ROUND(
        AVG(
            EXTRACT(
                EPOCH FROM (
                    order_delivered_customer_date::timestamp -
                    order_purchase_timestamp::timestamp
                )
            ) / 86400
        )::numeric, 2
    ) AS average_delivery_days

FROM orders

WHERE order_delivered_customer_date IS NOT NULL
  AND order_purchase_timestamp IS NOT NULL

GROUP BY purchase_year
ORDER BY purchase_year;


-- ============================================================
-- 11. CUSTOMER SATISFACTION AND REVIEW ANALYSIS
-- ============================================================

-- Overall customer satisfaction

SELECT
    COUNT(*) AS total_reviews,

    ROUND(AVG(review_score::numeric), 2)
        AS average_rating,

    COUNT(*) FILTER (
        WHERE review_score::integer >= 4
    ) AS positive_reviews,

    COUNT(*) FILTER (
        WHERE review_score::integer = 3
    ) AS neutral_reviews,

    COUNT(*) FILTER (
        WHERE review_score::integer <= 2
    ) AS negative_reviews

FROM reviews;


-- Review score distribution

SELECT
    review_score,
    COUNT(*) AS total_reviews,

    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (), 2
    ) AS review_percentage

FROM reviews

GROUP BY review_score
ORDER BY review_score DESC;


-- Category-wise customer satisfaction

SELECT
    COALESCE(
        ct.product_category_name_english,
        p.product_category_name
    ) AS category_name,

    COUNT(DISTINCT r.review_id) AS total_reviews,

    ROUND(AVG(r.review_score::numeric), 2)
        AS average_review_score,

    COUNT(DISTINCT r.review_id) FILTER (
        WHERE r.review_score::integer <= 2
    ) AS negative_reviews

FROM reviews r

JOIN order_items oi
    ON r.order_id = oi.order_id

JOIN products p
    ON oi.product_id = p.product_id

LEFT JOIN category_translation ct
    ON p.product_category_name = ct.product_category_name

GROUP BY category_name

HAVING COUNT(DISTINCT r.review_id) >= 50

ORDER BY average_review_score ASC;


-- Lowest-rated reviews

SELECT
    review_id,
    order_id,
    review_score,
    review_comment_title,
    review_comment_message

FROM reviews

WHERE review_score::integer <= 2

ORDER BY review_score ASC
LIMIT 20;


-- ============================================================
-- 12. GEOGRAPHIC SALES ANALYSIS
-- ============================================================

-- State-wise sales

SELECT
    c.customer_state,

    COUNT(DISTINCT o.order_id) AS total_orders,

    COUNT(DISTINCT c.customer_unique_id)
        AS unique_customers,

    COUNT(oi.order_item_id) AS total_items_sold,

    ROUND(SUM(oi.price::numeric), 2) AS total_revenue,

    ROUND(
        SUM(oi.price::numeric) * 100.0 /
        NULLIF(
            SUM(SUM(oi.price::numeric)) OVER (), 0
        ), 2
    ) AS revenue_percentage

FROM orders o

JOIN customers c
    ON o.customer_id = c.customer_id

JOIN order_items oi
    ON o.order_id = oi.order_id

GROUP BY c.customer_state

ORDER BY total_revenue DESC;


-- Top 10 cities by revenue

SELECT
    c.customer_city,
    c.customer_state,

    COUNT(DISTINCT o.order_id) AS total_orders,

    COUNT(DISTINCT c.customer_unique_id)
        AS unique_customers,

    ROUND(SUM(oi.price::numeric), 2) AS total_revenue

FROM orders o

JOIN customers c
    ON o.customer_id = c.customer_id

JOIN order_items oi
    ON o.order_id = oi.order_id

GROUP BY
    c.customer_city,
    c.customer_state

ORDER BY total_revenue DESC
LIMIT 10;


-- ============================================================
-- 13. RFM CUSTOMER SEGMENTATION
-- ============================================================

WITH customer_orders AS (
    SELECT
        c.customer_unique_id,
        o.order_id,

        o.order_purchase_timestamp::timestamp
            AS purchase_date,

        SUM(oi.price::numeric) AS order_revenue

    FROM customers c

    JOIN orders o
        ON c.customer_id = o.customer_id

    JOIN order_items oi
        ON o.order_id = oi.order_id

    WHERE o.order_purchase_timestamp IS NOT NULL

    GROUP BY
        c.customer_unique_id,
        o.order_id,
        o.order_purchase_timestamp
),

rfm_base AS (
    SELECT
        customer_unique_id,

        MAX(purchase_date) AS last_purchase_date,

        COUNT(DISTINCT order_id) AS frequency,

        SUM(order_revenue) AS monetary

    FROM customer_orders

    GROUP BY customer_unique_id
),

rfm_scores AS (
    SELECT
        customer_unique_id,

        EXTRACT(
            EPOCH FROM (
                (SELECT MAX(purchase_date) + INTERVAL '1 day'
                 FROM customer_orders) - last_purchase_date
            )
        ) / 86400 AS recency,

        frequency,
        monetary,

        6 - NTILE(5) OVER (
            ORDER BY last_purchase_date ASC
        ) AS r_score,

        NTILE(5) OVER (
            ORDER BY frequency ASC
        ) AS f_score,

        NTILE(5) OVER (
            ORDER BY monetary ASC
        ) AS m_score

    FROM rfm_base
)

SELECT
    customer_unique_id,

    ROUND(recency::numeric, 0) AS recency_days,

    frequency,

    ROUND(monetary, 2) AS monetary,

    r_score,
    f_score,
    m_score,

    r_score + f_score + m_score AS rfm_total_score,

    CASE
        WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4
            THEN 'Champions'

        WHEN r_score >= 3 AND f_score >= 3
            THEN 'Loyal Customers'

        WHEN r_score >= 4 AND f_score <= 2
            THEN 'New Customers'

        WHEN r_score <= 2 AND f_score >= 3
            THEN 'At Risk'

        ELSE 'Need Attention'
    END AS customer_segment

FROM rfm_scores

ORDER BY
    rfm_total_score DESC,
    monetary DESC;


-- ============================================================
-- 14. FINAL POWER BI EXPORT QUERIES
-- Run each query separately and export its result as CSV.
-- ============================================================

-- EXPORT 1: MONTHLY SALES

SELECT
    TO_CHAR(o.order_purchase_timestamp::timestamp, 'YYYY-MM')
        AS sales_month,

    COUNT(DISTINCT o.order_id) AS total_orders,

    COUNT(oi.order_item_id) AS total_items_sold,

    ROUND(SUM(oi.price::numeric), 2) AS total_revenue,

    ROUND(SUM(oi.freight_value::numeric), 2) AS total_freight

FROM orders o

JOIN order_items oi
    ON o.order_id = oi.order_id

WHERE o.order_purchase_timestamp IS NOT NULL

GROUP BY sales_month
ORDER BY sales_month;


-- EXPORT 2: CATEGORY PERFORMANCE

SELECT
    COALESCE(
        ct.product_category_name_english,
        p.product_category_name
    ) AS category_name,

    COUNT(DISTINCT oi.order_id) AS total_orders,

    COUNT(oi.order_item_id) AS total_items_sold,

    ROUND(SUM(oi.price::numeric), 2) AS total_revenue

FROM order_items oi

JOIN products p
    ON oi.product_id = p.product_id

LEFT JOIN category_translation ct
    ON p.product_category_name = ct.product_category_name

GROUP BY category_name
ORDER BY total_revenue DESC;


-- EXPORT 3: PAYMENT ANALYSIS

SELECT
    payment_type,

    COUNT(*) AS total_payment_records,

    COUNT(DISTINCT order_id) AS total_orders,

    ROUND(SUM(payment_value::numeric), 2)
        AS total_payment_value,

    ROUND(AVG(payment_value::numeric), 2)
        AS average_payment_value

FROM payments

GROUP BY payment_type
ORDER BY total_payment_value DESC;


-- EXPORT 4: REVIEW DISTRIBUTION

SELECT
    review_score,

    COUNT(*) AS total_reviews,

    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (), 2
    ) AS review_percentage

FROM reviews

GROUP BY review_score
ORDER BY review_score DESC;


-- EXPORT 5: STATE-WISE SALES

SELECT
    c.customer_state,

    COUNT(DISTINCT o.order_id) AS total_orders,

    COUNT(DISTINCT c.customer_unique_id)
        AS unique_customers,

    ROUND(SUM(oi.price::numeric), 2) AS total_revenue

FROM orders o

JOIN customers c
    ON o.customer_id = c.customer_id

JOIN order_items oi
    ON o.order_id = oi.order_id

GROUP BY c.customer_state
ORDER BY total_revenue DESC;


-- EXPORT 6: CUSTOMER RFM SEGMENTS

WITH customer_orders AS (
    SELECT
        c.customer_unique_id,
        o.order_id,
        o.order_purchase_timestamp::timestamp AS purchase_date,
        SUM(oi.price::numeric) AS order_revenue

    FROM customers c

    JOIN orders o
        ON c.customer_id = o.customer_id

    JOIN order_items oi
        ON o.order_id = oi.order_id

    WHERE o.order_purchase_timestamp IS NOT NULL

    GROUP BY
        c.customer_unique_id,
        o.order_id,
        o.order_purchase_timestamp
),

rfm_base AS (
    SELECT
        customer_unique_id,
        MAX(purchase_date) AS last_purchase_date,
        COUNT(DISTINCT order_id) AS frequency,
        SUM(order_revenue) AS monetary

    FROM customer_orders

    GROUP BY customer_unique_id
),

rfm_scores AS (
    SELECT
        customer_unique_id,

        EXTRACT(
            EPOCH FROM (
                (SELECT MAX(purchase_date) + INTERVAL '1 day'
                 FROM customer_orders) - last_purchase_date
            )
        ) / 86400 AS recency,

        frequency,
        monetary,

        6 - NTILE(5) OVER (
            ORDER BY last_purchase_date ASC
        ) AS r_score,

        NTILE(5) OVER (
            ORDER BY frequency ASC
        ) AS f_score,

        NTILE(5) OVER (
            ORDER BY monetary ASC
        ) AS m_score

    FROM rfm_base
)

SELECT
    customer_unique_id,
    ROUND(recency::numeric, 0) AS recency_days,
    frequency,
    ROUND(monetary, 2) AS monetary,
    r_score,
    f_score,
    m_score,
    CASE
        WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4
            THEN 'Champions'
        WHEN r_score >= 3 AND f_score >= 3
            THEN 'Loyal Customers'
        WHEN r_score >= 4 AND f_score <= 2
            THEN 'New Customers'
        WHEN r_score <= 2 AND f_score >= 3
            THEN 'At Risk'
        ELSE 'Need Attention'
    END AS customer_segment

FROM rfm_scores
ORDER BY monetary DESC;


-- ============================================================
-- END OF COMPLETE E-COMMERCE SQL ANALYSIS
-- ============================================================

