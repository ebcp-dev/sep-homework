--1.	What is a result set?
--		A result set is a set of rows returned by a query from the database.

--2.	What is the difference between Union and Union All?
--		Union returns only unique rows and Union All returns all rows from the query.

--3.	What are the other Set Operators SQL Server has?
--		Intersect (only include common rows from both results) and Except (only include data from first set but not second).

--4.	What is the difference between Union and Join?
--		Union combines rows from 1 or more tables and Join combines columns.

--5.	What is the difference between INNER JOIN and FULL JOIN?
--		Inner Join only returns matching rows from both tables and Full Join returns all rows from both tables.

--6.	What is difference between left join and outer join
--		Left Join returns matching rows from both tables and non-matching rows from left table. Outer Join returns non-matching rows from both tables.

--7.	What is cross join?
--		Cross Join returns the cartesian product of both tables.

--8.	What is the difference between WHERE clause and HAVING clause?
--		HAVING only works on groups so it requires GROUP BY clause. WHERE clause only works on non-aggregate data.

--9.	Can there be multiple group by columns?
--		Yes. Multiple columns will be grouped into 1 group.

-- QUERIES:

--1
SELECT COUNT(*)
FROM Production.Product
-- 504 products

--2
SELECT COUNT(*)
FROM Production.Product
WHERE ProductID IN (SELECT ProductID
					FROM Production.Product
					WHERE ProductSubcategoryID IS NOT NULL)

--3
SELECT ProductSubcategoryID, COUNT(*) AS CountedProducts
FROM Production.Product
GROUP BY ProductSubcategoryID

--4
SELECT COUNT(*)
FROM Production.Product
WHERE ProductID IN (SELECT ProductID
					FROM Production.Product
					WHERE ProductSubcategoryID IS NULL)

--5
SELECT SUM(Quantity)
FROM Production.ProductInventory

--6
SELECT ProductID, SUM(Quantity) AS TheSum
FROM Production.ProductInventory
WHERE LocationID = 40
GROUP BY ProductID
HAVING SUM(Quantity) < 100

--7
SELECT Shelf, ProductID, SUM(Quantity) AS TheSum
FROM Production.ProductInventory
WHERE LocationID = 40
GROUP BY Shelf, ProductID
HAVING SUM(Quantity) < 100

--8
SELECT AVG(Quantity) AS TheAVG
FROM Production.ProductInventory
WHERE LocationID = 10

--9
SELECT ProductID, Shelf, AVG(Quantity) AS TheAVG
FROM Production.ProductInventory
GROUP BY ProductID, Shelf

--10
SELECT ProductID, Shelf, AVG(Quantity) AS TheAVG
FROM Production.ProductInventory
GROUP BY ProductID, Shelf
HAVING Shelf != 'N/A'

--11
SELECT Color, Class, COUNT(*) AS TheCount, AVG(ListPrice) AS AvgPrice
FROM Production.Product
GROUP BY Color, Class
HAVING Color IS NOT NULL AND Class IS NOT NULL

--12
SELECT cr.Name AS Country, sp.Name AS Province
FROM Person.CountryRegion cr JOIN Person.StateProvince sp ON cr.CountryRegionCode = sp.CountryRegionCode

--13
SELECT cr.Name AS Country, sp.Name AS Province
FROM Person.CountryRegion cr JOIN Person.StateProvince sp ON cr.CountryRegionCode = sp.CountryRegionCode
WHERE cr.Name = 'Germany' OR cr.Name = 'Canada'

--Northwind DB

--14
SELECT *
FROM Orders
WHERE DATEDIFF(YEAR, OrderDate, GETDATE()) <= 25

--15
SELECT TOP 5 o.ShipPostalCode
FROM Orders o JOIN [Order Details] od ON o.OrderID = od.OrderID
ORDER BY od.Quantity

--16
SELECT TOP 5 o.ShipPostalCode
FROM Orders o JOIN [Order Details] od ON o.OrderID = od.OrderID
WHERE DATEDIFF(YEAR, GETDATE(), OrderDate) <= 25
ORDER BY od.Quantity

--17
SELECT ShipCity, COUNT(DISTINCT ShipName) AS CustomersCount
FROM Orders
GROUP BY ShipCity

--18
SELECT ShipCity, COUNT(DISTINCT ShipName) AS CustomersCount
FROM Orders
GROUP BY ShipCity
HAVING COUNT(DISTINCT ShipName) > 2

--19
SELECT DISTINCT ShipName
FROM Orders
WHERE OrderDate > '1996-01-01'

--20
SELECT DISTINCT ShipName, OrderDate
FROM Orders
ORDER BY OrderDate DESC

--21
SELECT DISTINCT o.ShipName, SUM(od.Quantity) AS ProductsBought
FROM Orders o LEFT JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY o.ShipName

--22
SELECT DISTINCT o.CustomerID, SUM(od.Quantity) AS ProductsBought
FROM Orders o JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY o.CustomerID
HAVING SUM(od.Quantity) > 100

--23 
SELECT sp.CompanyName AS 'Supplier Company Name', sh.CompanyName AS 'Shipping Company Name'
FROM 
	Shippers sh JOIN Orders o ON sh.ShipperID = o.ShipVia JOIN
	[Order Details] od ON o.OrderID = od.OrderID JOIN
	Products p ON od.ProductID = p.ProductID RIGHT JOIN
	Suppliers sp ON p.SupplierID = sp.SupplierID
GROUP BY sp.CompanyName, sh.CompanyName
ORDER BY sp.CompanyName

--24
SELECT o.OrderDate, p.ProductName
FROM 
	Orders o JOIN
	[Order Details] od ON o.OrderID = od.OrderID JOIN
	Products p ON od.ProductID = p.ProductID
GROUP BY o.OrderDate, p.ProductName

--25
SELECT DISTINCT e1.FirstName + ' ' + e1.LastName AS FullName, e1.Title
FROM 
	Employees e1 JOIN
	Employees e2 ON e1.Title = e2.Title 

--26
SELECT ReportsTo AS Manager, COUNT(EmployeeID) AS 'Number of Emps'
FROM Employees
GROUP BY ReportsTo
HAVING COUNT(ReportsTo) > 2

--27
SELECT City, CompanyName AS 'Name', ContactName, 'Customers' AS 'Type'
FROM Customers
UNION
SELECT City, CompanyName, ContactName, 'Suppliers'
FROM Suppliers