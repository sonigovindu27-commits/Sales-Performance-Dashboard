SELECT * FROM sales LIMIT 5;


CREATE TABLE sales2(
    order_id VARCHAR(50),
    order_date DATE,
    ship_date DATE,
    ship_mode VARCHAR(50),
    customer_id VARCHAR(50),
    customer_name VARCHAR(100),
    segment VARCHAR(50),
    country VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(50),
    region VARCHAR(50),
    product_id VARCHAR(50),
    category VARCHAR(50),
    sub_category VARCHAR(50),
    product_name VARCHAR(200),
    sales FLOAT,
    quantity INT,
    discount FLOAT,
    profit FLOAT
);














---Q1. Checking all the olumn names..??

SELECT column_name 
FROM information_schema.columns 
WHERE table_name = 'sales';

---Q2.Finding Total Sales and Profit..??

SELECT 
  ROUND(SUM("Sales")::numeric, 2) AS total_sales,
  ROUND(SUM("Profit")::numeric, 2) AS total_profit
FROM sales;

---Q3.Query 3 — Sales by Region:

SELECT "Region", 
  ROUND(SUM("Sales")::numeric, 2) AS total_sales
FROM sales
GROUP BY "Region"
ORDER BY total_sales DESC;



---Q4.Query 4 — YoY Growth:
SELECT 
  EXTRACT(YEAR FROM "Order Date"::date) AS year,
  ROUND(SUM("Sales")::numeric, 2) AS total_sales,
  LAG(ROUND(SUM("Sales")::numeric, 2)) 
    OVER (ORDER BY EXTRACT(YEAR FROM "Order Date"::date)) AS prev_year_sales
FROM sales
GROUP BY EXTRACT(YEAR FROM "Order Date"::date);



---Q5.Query 5 — Profit by Category:
SELECT "Category",
  ROUND(SUM("Sales")::numeric, 2) AS total_sales,
  ROUND(SUM("Profit")::numeric, 2) AS total_profit,
  ROUND((SUM("Profit")/SUM("Sales")*100)::numeric, 2) AS margin_percent
FROM sales
GROUP BY "Category"
ORDER BY margin_percent DESC;


---Q6.Query 6 — West Region Anomaly:
SELECT "Region", "Category",
  ROUND(SUM("Sales")::numeric, 2) AS total_sales,
  ROUND(SUM("Profit")::numeric, 2) AS total_profit,
  ROUND((SUM("Profit")/SUM("Sales")*100)::numeric, 2) AS margin_percent
FROM sales
WHERE "Region" = 'West'
GROUP BY "Region", "Category"
ORDER BY margin_percent ASC;



---Q7.Query 7 — CTE Example:
WITH regional_sales AS (
  SELECT 
    "Region", 
    "Category",
    SUM("Sales") AS total_sales,
    SUM("Profit") AS total_profit
  FROM sales
  GROUP BY "Region", "Category"
)
SELECT *, 
  ROUND((total_profit/total_sales*100)::numeric, 2) AS margin
FROM regional_sales
ORDER BY margin DESC;

