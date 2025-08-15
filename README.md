### SQL Project: Customers and Product Analysis
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