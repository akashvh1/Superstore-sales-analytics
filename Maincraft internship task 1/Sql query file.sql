--  superstore_queries.sql

--  SECTION 1: CREATE DATABASE & TABLE

CREATE DATABASE superstore;
USE superstore;

DROP TABLE IF EXISTS sales;

CREATE TABLE sales (
    order_id      VARCHAR(50),
    order_date    DATE,
    customer_name VARCHAR(100),
    region        VARCHAR(50),
    category      VARCHAR(50),
    product_name  VARCHAR(100),
    sales         DECIMAL(10,2),
    quantity      INT,
    profit        DECIMAL(10,2),
    discount      DECIMAL(5,2)
);


--  SECTION 2: LOAD DATA INFILE  (Option B)

-- Windows : 'C:/Users/YourName/Downloads/sales_data.csv'
-- Mac/Linux: '/home/yourname/downloads/sales_data.csv'

LOAD DATA INFILE 'C:/path/to/sales_data.csv'
INTO TABLE sales
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(order_id, order_date, customer_name, region, category,
 product_name, sales, quantity, profit, discount);

-- Confirm rows loaded
SELECT COUNT(*) AS rows_imported FROM sales;


--  SECTION 3: CORE QUERIES

--  Query 1: Total Sales by Region

SELECT
    region,
    COUNT(order_id)          AS total_orders,
    SUM(quantity)            AS total_units_sold,
    ROUND(SUM(sales), 2)     AS total_sales,
    ROUND(AVG(sales), 2)     AS avg_order_value,
    ROUND(SUM(profit), 2)    AS total_profit
FROM sales
GROUP BY region
ORDER BY total_sales DESC;

--  Query 2: Profit by Category

SELECT
    category,
    ROUND(SUM(profit), 2)                        AS total_profit,
    ROUND(SUM(sales), 2)                         AS total_sales,
    ROUND(SUM(profit) / SUM(sales) * 100, 2)    AS profit_margin_pct
FROM sales
GROUP BY category
ORDER BY total_profit DESC;

--  Query 3: Monthly Sales Trend

SELECT
    MONTH(order_date)      AS month_num,
    CASE MONTH(order_date)
        WHEN 1  THEN 'January'    WHEN 2  THEN 'February'
        WHEN 3  THEN 'March'      WHEN 4  THEN 'April'
        WHEN 5  THEN 'May'        WHEN 6  THEN 'June'
        WHEN 7  THEN 'July'       WHEN 8  THEN 'August'
        WHEN 9  THEN 'September'  WHEN 10 THEN 'October'
        WHEN 11 THEN 'November'   WHEN 12 THEN 'December'
    END                    AS month_name,
    COUNT(order_id)        AS total_orders,
    ROUND(SUM(sales), 2)   AS total_sales,
    ROUND(SUM(profit), 2)  AS total_profit
FROM sales
GROUP BY month_num, month_name
ORDER BY month_num;

--  Query 4: Impact of Discount on Average Profit

SELECT
    discount,
    COUNT(order_id)           AS order_count,
    ROUND(AVG(profit), 2)     AS avg_profit,
    ROUND(AVG(sales), 2)      AS avg_sales,
    ROUND(SUM(profit), 2)     AS total_profit
FROM sales
GROUP BY discount
ORDER BY discount ASC;

