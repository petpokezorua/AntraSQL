USE Northwind
GO

-- 1. List all cities that have both Employees and Customers.

SELECT DISTINCT Employees.City
FROM Employees
JOIN Customers ON Employees.City = Customers.City;

-- 2. List all cities that have Customers but no Employee.
-- a. Using subquery

SELECT DISTINCT City
FROM Customers
WHERE City NOT IN ( SELECT DISTINCT City FROM Employees);

-- b. Not using Subquery
SELECT DISTINCT Customers.City
FROM Customers
LEFT JOIN Employees ON Customers.City = Employees.City 
WHERE Employees.City IS NULL;  

-- 3. List all products and their total order quantities throughout all orders.

SELECT P.ProductName, SUM(OD.Quantity) AS TotalOrderQuantities
FROM [Order Details] OD
JOIN Products P ON OD.ProductID = P.ProductID
GROUP BY P.ProductName
ORDER BY 2;

-- 4. List all Customer Cities and total products ordered by that city

SELECT Customers.City, SUM(OD.ProductID) AS TotalProductsOrdered
FROM Customers
JOIN Orders ON Customers.CustomerID = Orders.CustomerID	
JOIN [Order Details] OD ON Orders.OrderID = OD.OrderID
GROUP BY Customers.City
ORDER BY 1;

-- 5. List all Customer Cities that have at least two customers.

SELECT City, COUNT(CustomerID) as CustomerCount
FROM Customers 
GROUP BY City
HAVING COUNT(CustomerID) >= 2;

-- 6. List all Customer Cities that have ordered at least two different kinds of products.

SELECT Customers.City, COUNT(DISTINCT OD.ProductID) AS TotalProductsOrdered
FROM Customers
JOIN Orders ON Customers.CustomerID = Orders.CustomerID	
JOIN [Order Details] OD ON Orders.OrderID = OD.OrderID
GROUP BY Customers.City
HAVING COUNT(DISTINCT OD.ProductID) >= 2;


-- 7. List all Customers who have ordered products, but have the ‘ship city’ on the order different from their own customer cities.

SELECT DISTINCT C.ContactName, C.City, O.ShipCity
FROM Customers C
Join Orders O ON C.CustomerID = O.CustomerID
WHERE C.City != O.ShipCity;

-- 8. List 5 most popular products, their average price, and the customer city that ordered most quantity of it.

WITH ProductPopularity AS (
	SELECT TOP 5 OD.ProductID, SUM(OD.Quantity) AS TotalQuantity
	FROM [Order Details] OD
	GROUP BY OD.ProductID
	ORDER BY TotalQuantity DESC
),

CityOrders AS (
    SELECT OD.ProductID, C.City, SUM(OD.Quantity) AS CityTotalQuantity,
           RANK() OVER (PARTITION BY OD.ProductID ORDER BY SUM(OD.Quantity) DESC) AS CityRank
    FROM [Order Details] OD
    JOIN Orders O ON OD.OrderID = O.OrderID
    JOIN Customers C ON O.CustomerID = C.CustomerID
    GROUP BY OD.ProductID, C.City
)

SELECT P.ProductName, AVG(P.UnitPrice) AS AvgPrice, CO.City
FROM ProductPopularity PP
JOIN Products P ON PP.ProductID = P.ProductID
JOIN CityOrders CO ON PP.ProductID = CO.ProductID AND CO.CityRank = 1
GROUP BY P.ProductName, CO.City, PP.TotalQuantity
ORDER BY PP.TotalQuantity DESC;

-- 9. List all cities that have never ordered something but we have employees there.
-- Without subquery: 

SELECT DISTINCT E.City
FROM Employees E
LEFT JOIN Customers C ON E.City = C.City
LEFT JOIN Orders O ON C.CustomerID = O.CustomerID
WHERE O.OrderID IS NULL;

-- With Subquery:

SELECT DISTINCT E.City
FROM Employees E
WHERE E.City NOT IN (
    SELECT DISTINCT C.City
    FROM Customers C
    JOIN Orders O ON C.CustomerID = O.CustomerID
);

-- 10.  List one city, if exists, that is the city from where the employee sold most orders (not the product quantity) is, and also the city of most total quantity of products ordered from.

WITH EmployeeTopCity AS (
    SELECT TOP 1 E.City AS EmployeeCity
    FROM Employees E
    JOIN Orders O ON E.EmployeeID = O.EmployeeID
    GROUP BY E.City
    ORDER BY COUNT(O.OrderID) DESC
),
CustomerTopCity AS (
    SELECT TOP 1 C.City AS CustomerCity
    FROM Customers C
    JOIN Orders O ON C.CustomerID = O.CustomerID
    JOIN [Order Details] OD ON O.OrderID = OD.OrderID
    GROUP BY C.City
    ORDER BY SUM(OD.Quantity) DESC
)

SELECT ET.EmployeeCity
FROM EmployeeTopCity ET
JOIN CustomerTopCity CT ON ET.EmployeeCity = CT.CustomerCity;

-- 11. How do you remove the duplicates record of a table?

-- I will use Row_Number and DELETE FROM