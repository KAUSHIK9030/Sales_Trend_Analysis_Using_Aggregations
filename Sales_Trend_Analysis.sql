CREATE DATABASE sales_analysis;
USE sales_analysis;

CREATE TABLE online_sales(
	Invoice_No VARCHAR (40),
    Stock_Code VARCHAR (40),
    Description VARCHAR (40),
    Quantity INT,
    Invoice_Date VARCHAR (30),
    Unit_Price DECIMAL (10,2),
    Customer_ID VARCHAR (40),
    Country VARCHAR (40)
);


LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/data.csv"
INTO TABLE online_sales
CHARACTER SET latin1
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(Invoice_No,Stock_Code,Description,Quantity,Invoice_Date,Unit_Price,Customer_ID,Country) ;


SELECT * FROM online_sales;

## CREATING A NEW TABLE AND CLEANING OF DATA

CREATE TABLE clean_sales AS
SELECT
    Invoice_No AS order_id,
    Quantity AS quantity_ordered,
    Unit_Price AS price_each,
    STR_TO_DATE(Invoice_Date, '%m/%d/%Y %H:%i') AS order_date
FROM
    online_sales
WHERE
    Invoice_Date IS NOT NULL
    AND Quantity > 0
    AND Unit_Price > 0;
    
## Monthly Sales Trend Query

SELECT
    YEAR(order_date) AS order_year,
    MONTH(order_date) AS order_month,
    SUM(quantity_ordered * price_each) AS total_revenue,
    COUNT(DISTINCT order_id) AS total_orders
FROM
    clean_sales
GROUP BY
    YEAR(order_date), MONTH(order_date)
ORDER BY
    order_year, order_month;

