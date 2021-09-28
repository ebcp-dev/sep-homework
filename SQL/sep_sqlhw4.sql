--1.	What is View? What are the benefits of using views?
--		Views are virtual tables based on the result-set of a SQL statement. They are beneficial when you want to hide data complexity or if you want to store and reuse complex queries.

--2.	Can data be modified through views?
--		No. They can only retrieve data.

--3.	What is stored procedure and what are the benefits of using it?
--		Stored Procedures are a batch of statements that are grouped as a single unit and stored in the database.

--4.	What is the difference between view and stored procedure?
--		Views show the result of a predetermined query and Stored Procedures can return different results based on input parameters.

--5.	What is the difference between stored procedure and functions?
--		Functions must return a value but it is optional in Stored Procedures.

--6.	Can stored procedure return multiple result sets?
--		Yes. Stored Procedures can have multiple SELECT statements but the user has to take this into account.

--7.	Can stored procedure be executed as part of SELECT Statement? Why?
--		No. They have to be executed independently.

--8.	What is Trigger? What types of Triggers are there?
--		Triggers are a special types of function that are executed automatically everytime a database event happens.

--9.	What are the scenarios to use Triggers?
--		When you want something done automatically for every database transaction.

--10.	What is the difference between Trigger and Stored Procedure?
--		Triggers are automatically executed and Stored Procedures have to be called manually.

-- QUERIES (Northwind DB):

--1
INSERT INTO Region
	VALUES(5, 'Middle Earth')

INSERT INTO Territories
	VALUES(11111, 'Gondor', 5)

INSERT INTO EmployeeTerritories
	VALUES(10, 'Aragorn', 11111)

--2
UPDATE Territories
SET TerritoryDescription = 'Arnor'
WHERE TerritoryID = 11111

--3
DELETE FROM Region
WHERE RegionDescription = 'Middle Earth'

--4
CREATE VIEW view_product_order_perez AS
	SELECT p.ProductID, SUM(od.Quantity) AS QuantityOrdered
	FROM Products p JOIN [Order Details] od ON p.ProductID = od.ProductID
	GROUP BY p.ProductID

--5
CREATE PROCEDURE sp_product_order_quantity_perez 
@ProductID INT,
@QuantityOrdered INT OUTPUT AS
	SELECT @QuantityOrdered = SUM(od.Quantity)
	FROM Products p JOIN [Order Details] od ON p.ProductID = od.ProductID
	GROUP BY p.ProductID
	HAVING p.ProductID = @ProductID

--6
CREATE PROCEDURE sp_product_order_city_perez 
@ProductName NVARCHAR(40) AS
	SELECT TOP 5 p.ProductName, o.ShipCity, SUM(od.Quantity) AS ProductsOrdered
	FROM 
		Products p JOIN 
		[Order Details] od ON p.ProductID = od.ProductID JOIN
		Orders o ON od.OrderID = o.OrderID
	GROUP BY p.ProductName, o.ShipCity
	HAVING p.ProductName = @ProductName
	ORDER BY ProductsOrdered DESC

--7
--8
--9
CREATE TABLE city_perez (
	CityID INT PRIMARY KEY,
	CityName VARCHAR(20)
)
CREATE TABLE people_perez (
	PersonID INT PRIMARY KEY,
	PersonName VARCHAR(20),
	CityID INT
		FOREIGN KEY REFERENCES city_perez(CityID) 
		ON DELETE SET NULL
)

CREATE TRIGGER insertandupdate_on_delete
ON city_perez
FOR DELETE
AS 
	IF NOT EXISTS (
		SELECT CityName
		FROM city_perez
		WHERE CityName = 'Seattle')
			BEGIN
			INSERT INTO city_perez VALUES (3, 'Madison')
			UPDATE people_perez SET CityID = 3 WHERE CityID IS NULL
			END

INSERT INTO city_perez
VALUES 
	(1, 'Seattle'),
	(2, 'Green Bay')
INSERT INTO people_perez
VALUES 
	(1, 'Aaron Rodgers', 2),
	(2, 'Russell Wilson', 1),
	(3, 'Jody Nelson', 2)

DELETE FROM city_perez WHERE CityID = 1

CREATE VIEW Packers_perez AS
	SELECT *
	FROM people_perez
	WHERE City = 2
	
DROP TABLE people_perez
DROP TABLE city_perez
DROP VIEW Packers_perez

--10
CREATE PROCEDURE sp_birthday_employees_perez AS
	SELECT *
	INTO birthday_employees_perez
	FROM Employees
	WHERE MONTH(BirthDate) = 2

EXEC sp_birthday_employees_perez

DROP TABLE birthday_employees_perez

--11
-- no subquery
CREATE PROCEDURE sp_perez_1 AS
	SELECT o.ShipCity, COUNT(DISTINCT o.CustomerID) AS NoOfCustomers
	FROM 
		[Order Details] od JOIN
		Orders o ON od.OrderID = o.OrderID
	GROUP BY o.ShipCity
	HAVING COUNT(DISTINCT o.CustomerID) >= 2
	INTERSECT
	SELECT o.CustomerID, COUNT(DISTINCT od.ProductID) AS ProductTypesOrdered
	FROM 
		[Order Details] od JOIN
		Orders o ON od.OrderID = o.OrderID
	GROUP BY o.CustomerID
	HAVING COUNT(DISTINCT od.ProductID) <= 1
-- with subquery
CREATE PROCEDURE sp_perez_2 AS
	SELECT o.ShipCity, COUNT(DISTINCT o.CustomerID) AS NoOfCustomers
	FROM 
		[Order Details] od JOIN
		Orders o ON od.OrderID = o.OrderID
	GROUP BY o.ShipCity
	HAVING o.CustomerID IN (
		SELECT o.CustomerID
		FROM 
			[Order Details] od JOIN
			Orders o ON od.OrderID = o.OrderID
		GROUP BY o.CustomerID
		HAVING COUNT(DISTINCT od.ProductID) <= 1	
	)

--12
--SELECT * FROM table1
--EXCEPT
--SELECT * FROM table2
-- returns 0 rows if both are identical

--14
--SELECT [First Name] + ' ' + [Last Name] + ISNULL([Middle Name], ' ') + '.' AS [Full Name]
--FROM names

--15
--SELECT TOP 1 Marks
--FROM students
--WHERE Sex = 'F'
--ORDER BY Marks DESC

--16
--SELECT Student, Marks, Sex
--FROM students
--ORDER BY Sex, Marks