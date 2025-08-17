-- Describes all tables in the database

SELECT 'customers' AS table_name, 13 AS number_of_attributes, COUNT (*) AS number_of_rows
  FROM customers 
 
UNION ALL 

SELECT 'products' AS table_name, 9 AS number_of_attributes, COUNT (*) AS number_of_rows
  FROM products
  
 UNION ALL
 
 SELECT 'productlines' AS table_name, 4 AS number_of_attributes, COUNT(*) AS number_of_rows
   FROM productlines

 UNION ALL
   
 SELECT 'orders' AS table_name, 7 AS number_of_attributes, COUNT(*) AS number_of_rows
    FROM orders
	
UNION ALL

 SELECT 'orderdetails' AS table_name, 5 AS number_of_attributes, COUNT(*) AS number_of_rows
   FROM orderdetails
   
UNION ALL 

 SELECT 'payments' AS table_name, 4 AS number_of_attributes, COUNT(*) AS number_of_rows
   FROM payments

UNION ALL

 SELECT 'employees' AS table_name, 8 AS number_of_attributes, COUNT(*) AS number_of_rows
   FROM employees  

UNION ALL

 SELECT 'offices' AS table_name, 9 AS number_of_attributes, COUNT(*) AS number_of_rows
   FROM offices;

   -- Compute the low stock for top ten products

SELECT productCode,
       ROUND(SUM(quantityOrdered * 1.0) / 
       (SELECT quantityInStock 
          FROM products AS p
         WHERE od.productCode = p.productCode), 2) AS low_stock
  FROM orderdetails AS od
 GROUP BY productCode
 ORDER BY low_stock DESC
 LIMIT 10;

 -- Compute the performance for top ten products

SELECT productCode, SUM(quantityOrdered * priceEach) AS                        product_performance
  FROM orderdetails
 GROUP BY productCode
 ORDER BY product_performance DESC
 LIMIT 10;

-- Compute priority products for restocking

WITH  low_stock_table AS (
  SELECT productCode,
       ROUND(SUM(quantityOrdered * 1.0) / 
       (SELECT quantityInStock 
          FROM products AS p
         WHERE od.productCode = p.productCode), 2) AS low_stock
  FROM orderdetails AS od
 GROUP BY productCode
 ORDER BY low_stock DESC
 LIMIT 10),
    
products_to_restock AS (

SELECT productCode, SUM(quantityOrdered * priceEach) AS                        product_performance
  FROM orderdetails
 GROUP BY productCode
 ORDER BY product_performance DESC
 LIMIT 10)
 
SELECT productCode, productLine, productName
  FROM products AS p
 WHERE productCode IN (SELECT productCode
                         FROM products_to_restock);
 
 -- Categorize customers by revenue
SELECT o.customerNumber, SUM(quantityOrdered * (priceEach -                      buyPrice)) AS profit
  FROM orders AS o
 INNER JOIN orderdetails AS od
    ON o.orderNumber = od.orderNumber
 INNER JOIN products AS p
    ON od.productCode = p.productCode
 GROUP BY o.customerNumber;                        
