CREATE DATABASE superstore_sales;
USE superstore_sales;

SELECT * FROM train;

-- View sample records from dataset
SELECT * 
FROM train
LIMIT 5;

-- Calculate total sales across all orders
SELECT 
    ROUND(SUM(Sales), 2) AS total_sales
FROM train;

-- Region-wise sales analysis
SELECT 
    Region,
    ROUND(SUM(Sales), 2) AS total_sales
FROM train
GROUP BY Region
ORDER BY total_sales DESC;

-- Top 10 products by total sales
SELECT 
    `Product Name`,
    ROUND(SUM(Sales), 2) AS total_sales
FROM train
GROUP BY `Product Name`
ORDER BY total_sales DESC
LIMIT 10;

-- Check NULL values
SELECT 
    COUNT(*) AS total_rows,
    COUNT(Region) AS non_null_region,
    COUNT(Sales) AS non_null_sales
FROM train;

-- DESCRIPTIVE ANALYSIS - Average Sales per Order
SELECT 
    ROUND(AVG(Sales), 2) AS avg_sales
FROM train;

-- Min & Max Sales Value
SELECT 
    MIN(Sales) AS min_sale,
    MAX(Sales) AS max_sale
FROM train;

DESCRIBE train;

SELECT `Order Date`
FROM train
LIMIT 5;

-- Added new column 
ALTER TABLE train
ADD COLUMN order_date_new DATE;

ALTER TABLE train
ADD PRIMARY KEY (`Row ID`);

UPDATE train
SET order_date_new = STR_TO_DATE(`Order Date`, '%d/%m/%Y')
WHERE `Row ID` > 0;

SELECT `Order Date`, order_date_new
FROM train
LIMIT 10;

-- TIME-BASED ANALYSIS - Extract Year from Order Date
SELECT
    YEAR(order_date_new) AS order_year,
    ROUND(SUM(Sales), 2) AS total_sales
FROM train
GROUP BY YEAR(order_date_new)
ORDER BY order_year;

-- Monthly Sales Trend 
SELECT
    YEAR(order_date_new) AS year,
    MONTH(order_date_new) AS month,
    ROUND(SUM(Sales), 2) AS total_sales
FROM train
GROUP BY YEAR(order_date_new), MONTH(order_date_new)
ORDER BY year, month;

-- Sales by Category
SELECT
    Category,
    ROUND(SUM(Sales), 2) AS total_sales
FROM train
GROUP BY Category
ORDER BY total_sales DESC;

-- Check null categories
SELECT COUNT(*) AS null_category_count
FROM train
WHERE Category IS NULL;

-- Category contribution in percentage
SELECT
    Category,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(
        (SUM(Sales) / (SELECT SUM(Sales) FROM train)) * 100,
        2
    ) AS sales_percentage
FROM train
GROUP BY Category
ORDER BY sales_percentage DESC;

-- CUSTOMER ANALYSIS -- Top 10 Customers by Sales
SELECT
    `Customer Name`,
    ROUND(SUM(Sales), 2) AS total_sales
FROM train
GROUP BY `Customer Name`
ORDER BY total_sales DESC
LIMIT 10;

-- Customer Count by Segment
SELECT 
    Segment,
    COUNT(DISTINCT `Customer ID`) AS customer_count
FROM train
GROUP BY Segment;

-- REGION & LOCATION ANALYSIS -- State-wise Sales
SELECT 
    State,
    ROUND(SUM(Sales), 2) AS total_sales
FROM train
GROUP BY State
ORDER BY total_sales DESC
LIMIT 10;

-- City-wise Sales
SELECT 
    City,
    ROUND(SUM(Sales), 2) AS total_sales
FROM train
GROUP BY City
ORDER BY total_sales DESC
LIMIT 10;

-- ADVANCED SQL
-- Window Function – Rank Products by Sales
SELECT *
FROM (
    SELECT 
        `Product Name`,
        ROUND(SUM(Sales), 2) AS total_sales,
        RANK() OVER (ORDER BY SUM(Sales) DESC) AS sales_rank
    FROM train
    GROUP BY `Product Name`
) ranked_products
WHERE sales_rank <= 10;

-- CASE Statement (Sales Classification)
SELECT 
    `Product Name`,
    Sales,
    CASE 
        WHEN Sales >= 500 THEN 'High'
        WHEN Sales >= 200 THEN 'Medium'
        ELSE 'Low'
    END AS sales_category
FROM train;

-- VALIDATION -- Cross-check Excel vs SQL
SELECT 
    Region,
    ROUND(SUM(Sales), 2) AS total_sales
FROM train
GROUP BY Region;

-- Validation: Total sales cross-check with Excel
SELECT ROUND(SUM(Sales), 2) AS total_sales_sql
FROM train;

-- Sales by Sub-Category
SELECT
    `Sub-Category`,
    ROUND(SUM(Sales), 2) AS total_sales
FROM train
GROUP BY `Sub-Category`
ORDER BY total_sales DESC;

-- Category-wise yearly sales trend
SELECT
    YEAR(order_date_new) AS year,
    Category,
    ROUND(SUM(Sales), 2) AS total_sales
FROM train
GROUP BY year, Category
ORDER BY year, total_sales DESC;

