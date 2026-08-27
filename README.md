# Brazilian E-Commerce SQL Analysis — Olist

## Project Overview

This project analyses the Brazilian Olist e-commerce dataset using **PostgreSQL** and **Power BI**. It explores sales performance, customer behaviour, seller performance, payment methods, logistics, delivery performance, and customer satisfaction.

The project demonstrates an end-to-end analytics workflow:

1. Build and validate a relational PostgreSQL database from CSV files.
2. Query the data to answer business questions.
3. Create an interactive Power BI dashboard to communicate actionable insights.

---

## Dataset

The project uses the Brazilian E-Commerce Public Dataset by Olist. It includes approximately 100,000 orders placed between 2016 and 2018, with linked data on customers, sellers, products, payments, reviews, and delivery.

## Business Questions

The analysis focuses on the following areas:

### Sales Analysis
- Which product categories generate the most revenue?
- What is the average order value?
- How did sales change over time?
- Which product categories generate more revenue than the average category?

### Customer Analysis
- Which Brazilian states have the most customers?
- What percentage of customers are repeat customers?
- What is the average number of orders per unique customer?
- How many customers placed one, two, three, or more orders?
- Which customers have spent more than the average customer?
- Which states have customers who have never placed an order?

### Seller Analysis
- Which sellers have the best reviews?
- Which sellers have never sold an order?
- Which sellers have an average delivery time longer than the overall average?

### Payment Analysis
- Which payment methods are most popular?
- What is the average amount paid for each payment method?

### Logistics & Customer Satisfaction
- Does delivery time affect review scores?
- Does delivery performance vary across product categories?
- Which Brazilian states have the longest delivery times?

### Advanced Business Analysis
- Are expensive products more likely to receive lower reviews?
- Which product categories have both above-average revenue and below-average review scores?

---

## Technologies Used

- **PostgreSQL**
- **SQL**
- **Power BI**
- **VS Code**
- **Git & GitHub**

---

## SQL Concepts Demonstrated

This project demonstrates practical use of:

- `SELECT`
- `WHERE`
- `JOIN`
- `LEFT JOIN`
- `GROUP BY`
- `HAVING`
- `ORDER BY`
- Aggregate functions (`SUM`, `AVG`, `COUNT`)
- `COUNT(DISTINCT)`
- Conditional aggregation using `FILTER`
- `CASE` statements
- Common Table Expressions (CTEs)
- Subqueries
- Date calculations
- `DATE_TRUNC`
- NULL handling
- Primary keys
- Foreign keys
- PostgreSQL `COPY` for importing CSV data

---

## Database Structure

The project uses the following main Olist tables:

- `customers`
- `orders`
- `order_items`
- `order_reviews`
- `order_payments`
- `products`
- `sellers`
- `product_category_name_translation`

The tables are connected through primary and foreign key relationships to allow analysis across customers, orders, products, sellers, payments, and reviews.

---
## Power BI Dashboard

The Power BI dashboard turns the SQL analysis into an interactive, business-focused report. It includes three pages covering marketplace performance, logistics, sellers, customers, and products.

---

## Project Structure

```text
olist-ecommerce-sql-analysis/
│
├── 01_create_tables.sql
├── 02_check_tables.sql
├── 03_import_data.sql
├── 04_database_checks.sql
├── 05_add_relationships.sql
├── 06_data__exploration.sql
├── powerbi/
│   ├── olist_powerbi.pbix
│   ├── Overview.png
│   ├── Logistics and Seller Performance.png
│   └── Customer and Product Analysis.png
└── README.md
```
