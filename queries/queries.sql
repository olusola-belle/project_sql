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