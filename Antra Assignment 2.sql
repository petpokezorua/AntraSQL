USE AdventureWorks2019
GO

-- 1.      How many products can you find in the Production.Product table? 

SELECT COUNT(*)
FROM Production.Product;

-- 504.

-- 2.   Write a query that retrieves the number of products in the Production.Product table that are included in a subcategory. 
--		The rows that have NULL in column ProductSubcategoryID are considered to not be a part of any subcategory.

SELECT COUNT(*)
FROM Production.Product
WHERE ProductSubcategoryID IS NOT NULL;

-- 3.      How many Products reside in each SubCategory? Write a query to display the results with the following titles.

SELECT ProductSubcategoryID, COUNT(*) as CountedProducts
FROM Production.Product
WHERE ProductSubcategoryID IS NOT NULL
GROUP BY ProductSubcategoryID;

-- 4.      How many products that do not have a product subcategory.

SELECT COUNT(*)
FROM Production.Product
WHERE ProductSubcategoryID IS NULL;

-- 209.

-- 5.      Write a query to list the sum of products quantity in the Production.ProductInventory table.

SELECT SUM(Quantity)
FROM Production.ProductInventory;

-- 335974.

-- 6. Write a query to list the sum of products in the Production.ProductInventory table and LocationID set to 40 and
--    limit the result to include just summarized quantities less than 100.

SELECT ProductID, SUM(Quantity) as TheSum
FROM Production.ProductInventory
WHERE LocationID = 40
GROUP BY ProductID
HAVING SUM(Quantity) < 100;

-- 7. Write a query to list the sum of products with the shelf information in the Production.ProductInventory table and LocationID set to 40 
-- and limit the result to include just summarized quantities less than 100

SELECT Shelf, ProductID, SUM(Quantity) as TheSum
FROM Production.ProductInventory
WHERE LocationID = 40
GROUP BY Shelf, ProductID
HAVING SUM(Quantity) < 100;

-- 8. Write the query to list the average quantity for products where column LocationID has the value of 10 from the table Production.ProductInventory table.

SELECT Avg(Quantity) 
FROM Production.ProductInventory
WHERE LocationID = 10;

-- 9. Write query  to see the average quantity  of  products by shelf  from the table Production.ProductInventory

SELECT ProductID, Shelf, AVG(Quantity) as TheAvg
FROM Production.ProductInventory
GROUP BY ProductID, Shelf;

-- 10. Write query  to see the average quantity  of  products by shelf excluding rows that has the value of N/A in the column Shelf from the table Production.ProductInventory
SELECT ProductID, Shelf, AVG(Quantity) as TheAvg
FROM Production.ProductInventory
WHERE Shelf != 'N/A'
GROUP BY ProductID, Shelf;

-- 11. List the members (rows) and average list price in the Production.Product table. This should be grouped independently over the Color and the Class column. 
--	   Exclude the rows where Color or Class are null.

SELECT Color, Class, Count(*) as TheCount, AVG(ListPrice) as AvgPrice
FROM Production.Product
WHERE Color IS NOT NULL AND Class IS NOT NULL
GROUP BY Color, Class;

-- 12. Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables. 
--	Join them and produce a result set similar to the following.

SELECT Person.CountryRegion.Name as Country, Person.StateProvince.Name as Province
FROM Person.CountryRegion JOIN Person.StateProvince ON Person.CountryRegion.CountryRegionCode = Person.StateProvince.CountryRegionCode
ORDER BY Country, Province;

-- 13. Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables and list the countries filter them by Germany and Canada. 
--	Join them and produce a result set similar to the following.

SELECT Person.CountryRegion.Name as Country, Person.StateProvince.Name as Province
FROM Person.CountryRegion JOIN Person.StateProvince ON Person.CountryRegion.CountryRegionCode = Person.StateProvince.CountryRegionCode
WHERE Person.CountryRegion.Name IN ('Germany', 'Canada')
ORDER BY Country, Province;


USE Northwind
GO

-- 14. List all Products that has been sold at least once in last 27 years.
-- Sold in last 27 years => Since 1998.

SELECT DISTINCT P.ProductName
FROM [Order Details] OD
JOIN Orders O on OD.OrderID = O.OrderID
JOIN Products P on OD.ProductID = P.ProductID
WHERE YEAR(O.OrderDate) >= 1998;

-- 15. List top 5 locations (Zip Code) where the products sold most.
-- Listing the count for checking purposes.

SELECT TOP 5 ShipPostalCode, COUNT(*) as Times
FROM Orders O
WHERE ShipPostalCode IS NOT NULL
GROUP BY ShipPostalCode
ORDER BY Times DESC;

-- 16. List top 5 locations (Zip Code) where the products sold most in last 27 years.

SELECT TOP 5 ShipPostalCode, COUNT(*) as Times
FROM Orders O
WHERE ShipPostalCode IS NOT NULL AND YEAR(OrderDate) >= 1998
GROUP BY ShipPostalCode
ORDER BY Times DESC;

-- 17. List all city names and number of customers in that city.     

SELECT City, Count(*) as NumOfCustomers
FROM Customers
GROUP BY City
ORDER BY City;

-- 18. List city names which have more than 2 customers, and number of customers in that city

SELECT City, Count(*) as NumOfCustomers
FROM Customers
GROUP BY City
HAVING Count(*) > 2
ORDER BY NumOfCustomers;

-- 19. List the names of customers who placed orders after 1/1/98 with order date.

SELECT DISTINCT C.ContactName, O.OrderDate
FROM Orders O
JOIN Customers C on O.CustomerID = O.CustomerID
WHERE O.OrderDate >= '1998-01-01'
ORDER BY O.OrderDate;

-- 20. List the names of all customers with most recent order dates

SELECT C.ContactName, O.OrderDate
FROM Orders O
JOIN Customers C on O.CustomerID = O.CustomerID
ORDER BY O.OrderDate DESC;

-- 21. Display the names of all customers  along with the  count of products they bought

SELECT C.ContactName, Count(OD.Quantity) as CountOfProducts
FROM [Order Details] OD
JOIN Orders O ON OD.OrderID = O.OrderID
JOIN Customers C ON O.CustomerID = C.CustomerID
GROUP BY C.ContactName
ORDER BY CountOfProducts;

-- 22. Display the customer ids who bought more than 100 Products with count of products.

SELECT C.ContactName, Count(OD.Quantity) as CountOfProducts
FROM [Order Details] OD
JOIN Orders O ON OD.OrderID = O.OrderID
JOIN Customers C ON O.CustomerID = C.CustomerID
GROUP BY C.ContactName
HAVING Count(OD.Quantity) > 100
ORDER BY CountOfProducts;

-- 23. List all of the possible ways that suppliers can ship their products. Display the results as below

SELECT SU.CompanyName as 'Supplier Company Name', SH.CompanyName as 'Shipper Company Name'
FROM Suppliers SU
CROSS JOIN Shippers SH
ORDER BY SU.CompanyName;

-- 24. Display the products order each day. Show Order date and Product Name.

SELECT DISTINCT O.OrderDate, P.ProductName
FROM [Order Details] OD
JOIN Orders O ON OD.OrderID = O.OrderID
JOIN Products P ON OD.ProductID = P.ProductID
ORDER BY O.OrderDate;

-- 25. Displays pairs of employees who have the same job title.

SELECT DISTINCT E1.FirstName + ' ' + E1.LastName as NameEmp1, E2.FirstName + ' ' + E2.LastName as NameEmp2, E1.Title
FROM Employees E1
JOIN Employees E2 ON E1.Title = E2.Title AND E1.EmployeeID < E2.EmployeeID
ORDER BY NameEmp1;

-- 26. Display all the Managers who have more than 2 employees reporting to them.

SELECT E2.EmployeeID, E2.FirstName + ' ' + E2.LastName as Name, E2.Title
FROM Employees E1
JOIN Employees E2 ON E1.ReportsTo = E2.EmployeeID
GROUP BY E2.EmployeeID, E2.LastName, E2.FirstName, E2.Title
HAVING COUNT(E1.EmployeeID) > 2;

-- 27.  Display the customers and suppliers by city. The results should have the following columns

SELECT City, CompanyName, ContactName, 'Customer' as Type 
FROM Customers
UNION 
SELECT City, ContactName, ContactName, 'Supplier' as Type
FROM Suppliers
ORDER BY City