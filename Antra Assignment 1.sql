USE AdventureWorks2019
GO
-- Write a query that retrieves the columns ProductID, Name, Color and ListPrice from the Production.Product table, with no filter. 

SELECT ProductID, Name, Color, ListPrice
FROM Production.Product;

-- Write a query that retrieves the columns ProductID, Name, Color and ListPrice from the Production.Product table, excludes the rows that ListPrice is 0.
SELECT productID, Name, Color, ListPrice
FROM Production.Product
WHERE ListPrice != 0;

-- Write a query that retrieves the columns ProductID, Name, Color and ListPrice from the Production.Product table, the rows that are NULL for the Color column.
SELECT productID, Name, Color, ListPrice
FROM Production.Product
WHERE Color IS NULL;

-- Write a query that retrieves the columns ProductID, Name, Color and ListPrice from the Production.Product table, the rows that are not NULL for the Color column.
SELECT productID, Name, Color, ListPrice
FROM Production.Product
WHERE Color IS NOT NULL;

-- Write a query that retrieves the columns ProductID, Name, Color and ListPrice from the Production.Product table, the rows that are not NULL for the column Color, and the column ListPrice has a value greater than zero.
SELECT productID, Name, Color, ListPrice
FROM Production.Product
WHERE Color IS NOT NULL AND ListPrice > 0;

-- Write a query that concatenates the columns Name and Color from the Production.Product table by excluding the rows that are null for color.
SELECT Name + ' - ' + Color AS "Name Color"
FROM Production.Product
WHERE Color is NOT NULL;

-- Write a query that generates the following result set  from Production.Product: 
SELECT 'NAME: ' + Name + ' -- COLOR: ' + Color as "Name Color"
FROM Production.Product
WHERE Color IN ('Silver', 'Black')
ORDER BY Name;

-- Write a query to retrieve the to the columns ProductID and Name from the Production.Product table filtered by ProductID from 400 to 500
SELECT productID, Name
FROM Production.Product
WHERE ProductID BETWEEN 400 AND 500;
-- Write a query to retrieve the to the columns  ProductID, Name and color from the Production.Product table restricted to the colors black and blue
SELECT productID, Name, Color
FROM Production.Product
WHERE Color IN ('Black', 'Blue');

-- Write a query to get a result set on products that begins with the letter S. 
SELECT *
FROM Production.Product
WHERE Name LIKE 'S%'
-- Write a query that retrieves the columns Name and ListPrice from the Production.Product table. Your result set should look something like the following. 
-- Order the result set by the Name column. 
SELECT Name, ListPrice
FROM Production.Product
WHERE Name LIKE 'S%'
ORDER BY Name;
--  Write a query that retrieves the columns Name and ListPrice from the Production.Product table. Your result set should look something like the following. 
--  Order the result set by the Name column. 
-- The products name should start with either 'A' or 'S'
SELECT Name, ListPrice
FROM Production.Product
WHERE Name LIKE 'S%' or NAME LIKE 'A%'
ORDER BY Name;

-- Write a query so you retrieve rows that have a Name that begins with the letters SPO, but is then not followed by the letter K. 
-- After this zero or more letters can exists. Order the result set by the Name column.
SELECT Name
FROM Production.Product
WHERE NAME LIKE 'SPO%' AND Name NOT LIKE 'SPOK%'
ORDER BY Name;

-- Write a query that retrieves unique colors from the table Production.Product. Order the results  in descending  manner.
SELECT DISTINCT Color
FROM Production.Product
WHERE Color IS NOT NULL
ORDER BY Color DESC;