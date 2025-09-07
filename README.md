### SQL Project: Customers and Product Analysis For Scale Model Cars
The database from the store cotains eight tables that will be be used for the analysis and they include productlines, products, orderdetails, orders, payments,customers, employees and offices. The following details are contained in these tables:

- **Customers**: customer data
- **Employees** : all employee information
- **Offices** : sales office information
- **Orders**: customers' sales orders
- **OrderDetails** : sales order line for each sales order
- **Payments**: customers' payment records
- **Products**: a list of scale model cars
- **ProductLines**: a list of product line categories

The tables are connected through primary and foreign keys to model relationships between entities: productlines contains categories of products and connects to products through productLine, products holds details of individual products and connects to orderdetails via productCode, orders contains sales orders and connects to customers through customerNumber and so on.
Essentially:
productlines → products → orderdetails → orders → customers → payments
customers → employees → offices, with employees possibly reporting to other employees.

### Customers and Products Analysis Using SQL
This aim of the projects was to answer the following questions: 
- Question 1: Which products should we order more of or less of?
- Question 2: How should we match marketing and communication strategies  to customer behaviors?
- Question 3: How much can we spend on acquiring new customers?

Question 1: Which products should we order more of or less of?
```sql
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

SELECT productCode, SUM(quantityOrdered * priceEach) AS product_performance
  FROM orderdetails
 GROUP BY productCode
 ORDER BY product_performance DESC
 LIMIT 10)
 
SELECT productCode, productLine, productName
  FROM products AS p
 WHERE productCode IN (SELECT productCode
                         FROM products_to_restock);
```                         

From the analysis, vintage cars and motorcycles sold more, since they sell frequently they should be prioritized for restocking.

| productCode | productLine | productName |
|---|---|---|
|S12_1099  |Classic Cars1968  |Ford Mustang  |
|S18_2248 |Vintage Cars1911  |Ford Town Car |
|S18_2795 |Vintage Cars1928 |Mercedes-Benz |
|SSKS24_2000 |Motorcycles1960 |BSA Gold Star |
|DBD34S32_1374 |Motorcycles1997 |BMW F650 |
|STS32_4289 |Vintage Cars1928 |Ford Phaeton Deluxe |
|S50_4713 |Motorcycles2002 |Yamaha YZR |
|M1S700_1938 |Ships |The Mayflower |
|S700_3167 |Planes |F/A 18 Hornet |
|1/72S72_3212 |ShipsPont | Yacht |

Question 2: How should we match marketing and communication strategies  to customer behaviors?
```sql
-- Categorize the top five VIP customers
WITH 

customers_by_revenue AS (
SELECT o.customerNumber, SUM(quantityOrdered * (priceEach - 
       buyPrice)) AS revenue
  FROM products p
  JOIN orderdetails od
    ON p.productCode = od.productCode
  JOIN orders o
    ON o.orderNumber = od.orderNumber
 GROUP BY o.customerNumber
)
 
SELECT cr.profit, c.contactLastName, c.contactFirstName,c.city,c.country
  FROM customers AS c
  JOIN customers_by_revenue AS cr
    ON c.customerNumber = cr.customerNumber
 ORDER BY cr.profit DESC
 LIMIT 5;

 -- Categorize the top five least  customers
WITH 

customers_by_revenue AS (
SELECT o.customerNumber, ROUND(SUM(quantityOrdered * (priceEach - 
       buyPrice)) ,2) AS revenue
  FROM products p
  JOIN orderdetails od
    ON p.productCode = od.productCode
  JOIN orders o
    ON o.orderNumber = od.orderNumber
 GROUP BY o.customerNumber
)
 
SELECT c.contactLastName, c.contactFirstName, c.city,c.country, cr.revenue
  FROM customers AS c
  JOIN customers_by_revenue AS cr
    ON c.customerNumber = cr.customerNumber
 ORDER BY cr.revenue 
 LIMIT 5;
 ```

To match the marketing and communication strategies to the customer behaviors, the customers were segmented into two : VIP customers and least engaged customers.

**VIP Customers**  
| contactLastName | contactFirstName | city | country | revenue
|---|---|---|---|---|
|Freyre  |Diego |Madrid  |Spain |326519.66 |
|Nelson |Susan |San Rafael |USA |236769.39 |
|Young |Jeff |NYC |USA |72370.09 |
|Ferguson |Peter |Melbourne |Australia |70311.07 |
|Labrune |Janine |Nantes |France |60875.3 |


**Least Engaged Customers**
| contactLastName | contactFirstName | city | country | revenue
|---|---|---|---|---|
|Freyre  |Diego |Madrid  |Spain |326519.66 |
|Nelson |Susan |San Rafael |USA |236769.39 |
|Young |Jeff |NYC |USA |72370.09 |
|Ferguson |Peter |Melbourne |Australia |70311.07 |
|Labrune |Janine |Nantes |France |60875.3 |

Question 3: How much can we spend on acquiring new customers?
```sql
-- Calculate the customer lifetime value
WITH 
customers_by_revenue AS (
SELECT o.customerNumber, ROUND(SUM(quantityOrdered * (priceEach - 
       buyPrice)) ,2) AS revenue
  FROM products p
  JOIN orderdetails od
    ON p.productCode = od.productCode
  JOIN orders o
    ON o.orderNumber = od.orderNumber
 GROUP BY o.customerNumber
)

SELECT AVG(revenue) AS lifetime_value
  FROM customers_by_revenue;
```
|lifetime_value |
|---|
|39039.5943877551
- When a customer's lifetime value (CLV) is 39,039.59, it means that — based on the underlying data and assumptions — a single customer is expected to generate $39,039.59 in revenue or profit for the business over the full course of their relationship. If the business has ten of such customers, the total expected value to the business would be approximately 390,395.90, highlighting the significant impact that even a small number of high-value customers can have on overall business performance.

### Conclusion: 
This analysis provided key insights to support strategic decision-making in product inventory, customer engagement, and customer acquisition spending. Based on sales data, **vintage cars and motorcycles** are top-performing products and should be prioritized for restocking. Customer segmentation revealed VIP customers who contribute significantly to revenue, suggesting that targeted marketing and personalized communication strategies should focus on retaining and nurturing these high-value clients. Lastly, with a customer lifetime value (CLV) of **39,039.59**, the business can confidently allocate substantial resources toward acquiring new customers, knowing that each one has the potential to generate significant long-term returns.



