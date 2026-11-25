create database if not exists sales_analysis;
use sales_analysis;
show databases;

CREATE TABLE Superstore_Cld (
    `Row ID` INT,
    `Order ID` VARCHAR(50),
    `Order Date` DATE,
    `Ship Date` DATE,
    `Ship Mode` VARCHAR(50),
    `Customer ID` VARCHAR(50),
    `Customer Name` VARCHAR(100),
    `Segment` VARCHAR(50),
    `Country` VARCHAR(100),
    `City` VARCHAR(100),
    `State` VARCHAR(100),
    `Postal Code` INT,
    `Region` VARCHAR(50),
    `Product ID` VARCHAR(50),
    `Category` VARCHAR(50),
    `Sub-Category` VARCHAR(50),
    `Product Name` VARCHAR(255),
    `Sales` DOUBLE,
    `Quantity` INT,
    `Discount` DOUBLE,
    `Profit` DOUBLE,
    `Order Month` INT
);

SET GLOBAL local_infile = 1;

SHOW VARIABLES LIKE 'secure_file_priv';

SHOW VARIABLES LIKE 'local_infile';

SELECT @@secure_file_priv;

############################################################################################################################################
LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Superstore_Cld.csv'
INTO TABLE Superstore_Cld
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


show create table Superstore_Cld;

show columns from Superstore_Cld;

SELECT
    COLUMN_NAME,
    ORDINAL_POSITION
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'sales_analysis'
AND TABLE_NAME = 'Superstore_Cld'
ORDER BY ORDINAL_POSITION;

SELECT COUNT(*) AS Total_rows,
       COUNT(DISTINCT `Order ID`) AS Unique_orders,
       COUNT(`Order ID`) AS filled_order_ids
FROM Superstore_Cld;

select distinct `Order ID`
from Superstore_Cld
limit 10;

###########################################################################################################################################################
## SQL Analysis :- Overall Business Performance

SELECT 
     ROUND(SUM(Sales), 2) AS Total_Sales,
     ROUND(SUM(Profit), 2) AS Total_Profit,
     SUM(Quantity) AS Total_Quantity,
     ROUND(
         SUM(Profit) / SUM(Sales) *
100, 2
      ) AS Total_Margin_Percentage
FROM Superstore_Cld;        

## Category-wise Performance Analysis

SELECT 
	Category,
    ROUND(SUM(SALES), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    SUM(Quantity) AS Total_Quantity
FROM Superstore_Cld
GROUP BY Category
ORDER BY Total_Sales DESC;

## Average selling prrice by category

SELECT 
	Category,
    SUM(Quantity) AS Total_Quantity,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Sales) / SUM(Quantity), 2) AS Average_Selling_Price
FROM Superstore_Cld
GROUP BY Category
ORDER  BY Average_Selling_Price DESC;    

## Sub-Category-wise Analysis

SELECT 
     Category,
     `Sub-Category`,
     ROUND(SUM(Sales), 2) AS Total_Sales,
     ROUND(SUM(Profit), 2) AS Total_Profit
FROM Superstore_Cld
GROUP BY Category, `Sub-Category`
ORDER BY Total_Sales DESC;

## Find which Sub-Category in loss

SELECT  
     `Sub-Category`,
     ROUND(SUM(Sales), 2) AS Total_Sales,
     ROUND(SUM(Profit), 2) AS  Total_Profit
FROM Superstore_Cld
GROUP BY `Sub-Category`
HAVING SUM(Profit) < 0
ORDER BY Total_Profit ASC;      
     
## Sub-Category Discount Analysis

SELECT
     `Sub-Category`,
     ROUND(AVG(Discount) * 100, 2) AS Average_Discount,
     ROUND(SUM(Sales), 2) AS Total_Sales,
     ROUND(SUM(Profit), 2) AS Total_Profit
FROM Superstore_Cld
WHERE `Sub-Category` = 'Tables'     
GROUP BY `Sub-Category`;

## Discount-wise profit 

SELECT 
     Discount,
     COUNT(*) AS Total_Orders,
     ROUND(SUM(Sales), 2) AS Total_Sales,
     ROUND(SUM(Profit), 2) AS Total_Profit
FROM Superstore_Cld
WHERE `Sub-Category` = 'Tables'
GROUP BY Discount
ORDER BY Discount;

## Region-wise Sales Analysis

SELECT 
     Region, 
     ROUND(SUM(Sales), 2) AS Total_Sales,
     ROUND(SUM(Profit), 2) AS Total_Profit,
     SUM(Quantity) AS Total_Qauntiyt
FROM Superstore_Cld
GROUP BY Region
ORDER BY Total_Sales DESC; 

## Region-wise margin calculation

SELECT
     Region,
     ROUND(SUM(Sales), 2) AS Total_Sales,
     ROUND(SUM(Profit), 2) AS Total_Profit,
     ROUND(SUM(profit) / SUM(Sales)* 100, 2) AS Profit_Margin
FROM Superstore_Cld
GROUP BY Region
ORDER BY Profit_Margin DESC;

## State-wise Sales Analysis

SELECT
     State,
     ROUND(SUM(Sales), 2) AS Total_Sales,
     ROUND(SUM(Profit), 2) AS Total_Profit,
     SUM(Quantity) AS Total_Quantity
FROM Superstore_Cld
GROUP BY State
ORDER BY Total_Sales DESC
LIMIT 10;

## Loss-making State

SELECT 
     State,
     ROUND(SUM(Sales), 2) AS Total_Sales,
     ROUND(SUM(Profit), 2) AS Total_profit
From Superstore_Cld
GROUP BY State
HAVING SUM(Profit) < 0
ORDER BY Total_Profit ASC;  

## Top-10 Year-wise Sales Perfomance   

SELECT 
    Year(`Order Date`) AS Order_Year,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    SUM(Quantity) AS Total_Quantity
From Superstore_Cld
GROUP BY YEAR(`Order Date`)
ORDER BY Order_Year DESC;

## Monthly Sales Trend

SELECT
     MONTH(`Order Date`) AS Order_Month,
     MONTHNAME(`Order Date`) AS Month_Name,
     ROUND(SUM(Sales), 2) AS Total_Sales,
     ROUND(SUM(Profit), 2) AS Total_Profit
FROM Superstore_Cld
GROUP BY MONTH(`Order Date`), MONTHNAME(`Order Date`)
ORDER BY MONTH(`Order Date`) ASC;

## Customer-wise Performance Analysis

SELECT 
    `Customer Name`,
    ROUND(SUM(Sales), 2) AS Total_Sales,
	ROUND(SUM(Profit), 2) AS Total_profit,
    COUNT(DISTINCT `Order ID`) AS Total_Orders
FROM Superstore_Cld
GROUP BY `Customer Name`
ORDER BY Total_Sales DESC
LIMIT 10;    

SELECT 
    `Customer Name`,
    ROUND(SUM(Sales), 2) AS Total_Sales,
	ROUND(SUM(Profit), 2) AS Total_profit,
    COUNT(DISTINCT `Order ID`) AS Total_Orders
FROM Superstore_Cld
GROUP BY `Customer Name`
ORDER BY Total_Profit DESC
LIMIT 10;    


SELECT 
    `Customer Name`,
    ROUND(SUM(Sales), 2) AS Total_Sales,
	ROUND(SUM(Profit), 2) AS Total_profit,
    ROUND(SUM(Profit) / SUM(Sales)* 100, 2) AS Profit_Margin
FROM Superstore_Cld
GROUP BY `Customer Name`
ORDER BY Profit_Margin ASC
LIMIT 10;    

SELECT 
     `Customer Name`,
     ROUND(SUM(Sales), 2) AS Total_Sales,
     ROUND(SUM(Profit), 2) AS Total_Profit,
     ROUND(SUM(Profit) / SUM(Sales) * 100, 2) AS Profit_Margin
FROM Superstore_Cld
WHERE `Customer Name` = 'Cindy Stewart'
GROUP BY `Customer Name`;
     
## Product-wise Performance

SELECT 
     `Product Name`,
     ROUND(SUM(Sales), 2) AS Total_Sales,
     ROUND(SUM(Profit), 2) AS Total_Profit,
     SUM(Quantity) AS Total_Quantity
FROM Superstore_cld
GROUP BY `Product Name`
ORDER by Total_Sales DESC
LIMIT 10;     

SELECT 
     `Product Name`,
     ROUND(SUM(Sales), 2) AS Total_Sales,
     ROUND(SUM(Profit), 2) AS Total_Profit,
     SUM(Quantity) AS Total_Quantity
FROM Superstore_cld
GROUP BY `Product Name`
ORDER by Total_Profit DESC
LIMIT 10;    
	
## Loss-Making Products

SELECT 
     `Product Name`,
     ROUND(SUM(Sales), 2) AS Total_Sales,
     ROUND(SUM(Profit), 2) AS Total_Profit
FROM Superstore_cld
GROUP BY `Product Name`
HAVING SUM(Profit) < 0
ORDER by Total_Profit ASC
LIMIT 10;  

## Shipping Mode Analysis

  SELECT 
     `Ship Mode`,
     ROUND(SUM(Sales), 2) AS Total_Sales,
     ROUND(SUM(Profit), 2) AS Total_Profit,
     SUM(Quantity) AS Total_Quantity,
     COUNT(DISTINCT `Order ID`) AS Total_Orders
FROM Superstore_cld
GROUP BY `Ship Mode`
ORDER by Total_Sales DESC;


SELECT 
     `Ship Mode`,
     ROUND(SUM(Sales), 2) AS Total_Sales,
     ROUND(SUM(Profit), 2) AS Total_Profit,
	 ROUND(SUM(Profit) / SUM(Sales)* 100, 2) AS Profit_Margin
FROM Superstore_cld
GROUP BY `Ship Mode`
ORDER by Profit_Margin DESC;

## 	Segment-wise Performance

SELECT 
     Segment,
     ROUND(SUM(Sales), 2) AS Total_Sales,
     ROUND(SUM(Profit), 2) AS Total_Profit,
	 SUM(Quantity) AS Total_Quantity,
     COUNT(DISTINCT `Order ID`) AS Total_Orders
FROM Superstore_cld
GROUP BY Segment
ORDER by Total_Sales DESC;

SELECT 
     Segment,
     ROUND(SUM(Sales), 2) AS Total_Sales,
     ROUND(SUM(Profit), 2) AS Total_Profit,
	 ROUND(SUM(Profit) / SUM(Sales)* 100, 2) AS Profit_Margin
FROM Superstore_cld
GROUP BY Segment
ORDER by Profit_Margin DESC;

### Final SQL Validation

SELECT 
     COUNT(*) AS Total_Records,
     COUNT(DISTINCT `Order ID`) AS Unique_Orders,
     COUNT(DISTINCT `Customer Name`) AS Unique_Customer,
     COUNT(DISTINCT `Product Name`) AS Unique_Products
     FROM Superstore_Cld;


    
     














