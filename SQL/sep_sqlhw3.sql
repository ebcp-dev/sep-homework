-- SHORT ANSWERS:

--1.	In SQL Server, assuming you can find the result by using both joins and subqueries, which one would you prefer to use and why?
--	In most cases, JOINS are preferable because they more performant than subqueries.

--2.	What is CTE and when to use it?
--	Common Table Expressions (CTE) are useful when you want to reuse the result set of a query without making another query.

--3.	What are Table Variables? What is their scope and where are they created in SQL Server?
--	Table Variables are local variables that can store data temporarily. Their scope is the batch that they are declared and executed with.

--4.	What is the difference between DELETE and TRUNCATE? Which one will have better performance and why?
--	DELETE is used to remove rows from a table but doesn't change its definition and TRUNCATE removes all rows in a table and reinitializes its identity by making changes to its data definition. TRUNCATE is faster because it locks the entire table for deletion as opposed to DELETE which locks each row in the table.

--5.	What is Identity column? How does DELETE and TRUNCATE affect it?
--	IDENTITY columns allow you to have incremental values based on the order that rows are loaded into the table. TRUNCATE will reset the IDENTITY value back to its original seed value while DELETE will continue incrementing the column.

--6.	What is difference between “delete from table_name” and “truncate table table_name”?
--	"DELETE FROM table_name" will remove all rows from a table but keep the existing structure. "TRUNCATE TABLE table_name" will remove all rows and reinitialize the table's data definition.


-- QUERIES (NORTHWIND DB):
--1
SELECT DISTINCT e.City
FROM Employees e JOIN Customers c ON e.City = c.City

--2
-- subquery
SELECT DISTINCT City
FROM Customers
WHERE City NOT IN (
	SELECT City
	FROM Employees)
-- no subquery
SELECT DISTINCT City
FROM Customers
EXCEPT
SELECT DISTINCT City
FROM Employees

--3
SELECT p.ProductID, SUM(od.Quantity) AS TotalOrderQuantity
FROM 
	Products p JOIN
	[Order Details] od ON p.ProductID = od.ProductID
GROUP BY p.ProductID

--4
SELECT c.City, SUM(od.Quantity) AS ProductsOrdered
FROM
	Customers c LEFT JOIN
	Orders o ON c.City = o.ShipCity JOIN
	[Order Details] od ON o.OrderID = od.OrderID
GROUP BY c.City

--5
-- union
SELECT City, COUNT(CustomerID) AS CustomerCount
FROM Customers
GROUP BY City
HAVING COUNT(CustomerID) = 2
UNION
SELECT City, COUNT(CustomerID)
FROM Customers
GROUP BY City
HAVING COUNT(CustomerID) > 2
-- subquery/no union
SELECT City, COUNT(CustomerID) AS CustomerCount
FROM Customers
WHERE City IN (
	SELECT City
	FROM Customers
	GROUP BY City
	HAVING COUNT(CustomerID) >= 2)
GROUP BY City

--6
SELECT c.City, COUNT(DISTINCT p.CategoryID) AS ProductCategories
FROM 
	Customers c JOIN
	Orders o ON c.City = o.ShipCity JOIN
	[Order Details] od ON o.OrderID = od.OrderID JOIN
	Products p ON od.ProductID = p.ProductID
GROUP BY c.City
HAVING COUNT(p.CategoryID) >= 2

--7
SELECT CustomerID, ShipCity
FROM Orders
EXCEPT
SELECT CustomerID, City
FROM Customers

--8
SELECT TOP 5 p.ProductName, AVG(od.UnitPrice) AS AVGPrice, c.City, COUNT(od.Quantity) AS QuantityOrdered
FROM
	Products p JOIN
	[Order Details] od ON p.ProductID = od.ProductID JOIN
	Orders o ON od.OrderID = o.OrderID JOIN
	Customers c ON o.ShipCity = c.City
GROUP BY p.ProductName, c.City
ORDER BY COUNT(od.Quantity) DESC

--9
-- subquery
SELECT City
FROM Employees
WHERE City NOT IN (
	SELECT ShipCity
	FROM Orders)

-- no subquery
SELECT City
FROM Employees
EXCEPT
SELECT ShipCity
FROM Orders

--10
SELECT e.City, COUNT(o.OrderID) AS Sales
FROM Employees e JOIN Orders o ON e.City = o.ShipCity
GROUP BY e.City
ORDER BY Sales DESC

SELECT o.ShipCity, SUM(od.Quantity) AS ProductsOrdered
FROM Orders o JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY o.ShipCity
ORDER BY ProductsOrdered DESC

--11
-- You can use a recursive CTE to remove matching rows until there is only one left.

-- QUERIES (Sample Tables):
-- Employee (empid integer, mgrid integer, deptid integer, salary money)
-- Dept (deptid integer, deptname varchar(20))

--12
-- Use recursive CTE to find employee with mgrid = NULL
WITH empHierachyCTE
AS(
	SELECT empid, mgrid, 1 AS LVL
	FROM Employee
	WHERE mgrid IS NULL
	UNION ALL
	SELECT e.empid, e.mgrid, ct.lvl + 1
	FROM Employee e INNER JOIN empHierachyCTE ct ON e.mgrid = ct.empid
)
SELECT * FROM empHierachyCTE

--13
WITH deptEmployees
AS(
	SELECT d.deptid, COUNT(e.deptid) AS NoEmployees
	FROM Dept d JOIN Employee e ON d.deptid = e.deptid
	GROUP BY d.deptid
)

SELECT d.deptname, COUNT(e.empid)
FROM Employee e JOIN Dept d ON e.deptid = d.deptid
GROUP BY d.deptname
WHERE COUNT(e.empid) = (
	SELECT MAX(NoEmployees)
	FROM deptEmployees
	)

--14
SELECT d.deptname, e.empid, e.salary
FROM Employee e JOIN Dept d ON e.deptid = d.deptid
GROUP BY d.deptname
ORDER BY e.salary
