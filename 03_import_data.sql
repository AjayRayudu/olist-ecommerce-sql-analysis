COPY customers
FROM 'C:/Ajay/MyProjects/Olist SQL Project/archive/olist_customers_dataset.csv'
DELIMITER ','
CSV HEADER;

SELECT COUNT(*)
FROM customers;

COPY orders
FROM 'C:/Ajay/MyProjects/Olist SQL Project/archive/olist_orders_dataset.csv'
DELIMITER ','
CSV HEADER;

SELECT COUNT(*)
FROM orders;

COPY order_items
FROM 'C:/Ajay/MyProjects/Olist SQL Project/archive/olist_order_items_dataset.csv'
DELIMITER ','
CSV HEADER;

SELECT COUNT(*)
FROM order_items;

COPY products
FROM 'C:/Ajay/MyProjects/Olist SQL Project/archive/olist_products_dataset.csv'
DELIMITER ','
CSV HEADER;

SELECT COUNT(*)
FROM products;

COPY sellers
FROM 'C:/Ajay/MyProjects/Olist SQL Project/archive/olist_sellers_dataset.csv'
DELIMITER ','
CSV HEADER;

SELECT COUNT(*)
FROM sellers;

COPY order_payments
FROM 'C:/Ajay/MyProjects/Olist SQL Project/archive/olist_order_payments_dataset.csv'
DELIMITER ','
CSV HEADER;

SELECT COUNT(*)
FROM order_payments;

COPY order_reviews
FROM 'C:/Ajay/MyProjects/Olist SQL Project/archive/olist_order_reviews_dataset.csv'
DELIMITER ','
CSV HEADER;

SELECT COUNT(*)
FROM order_reviews;

COPY geolocation
FROM 'C:/Ajay/MyProjects/Olist SQL Project/archive/olist_geolocation_dataset.csv'
DELIMITER ','
CSV HEADER;

SELECT COUNT(*)
FROM geolocation;

COPY product_category_name_translation
FROM 'C:/Ajay/MyProjects/Olist SQL Project/archive/product_category_name_translation.csv'
DELIMITER ','
CSV HEADER;

SELECT COUNT(*)
FROM product_category_name_translation;
