--1 
SELECT ProductID, Name, Color, ListPrice
FROM Production.Product

--2
SELECT ProductID, Name, Color, ListPrice
FROM Production.Product
WHERE ListPrice != 0

--3
SELECT ProductID, Name, Color, ListPrice
FROM Production.Product
WHERE Color IS NULL

--4
SELECT ProductID, Name, Color, ListPrice
FROM Production.Product
WHERE Color IS NOT NULL

--5
SELECT ProductID, Name, Color, ListPrice
FROM Production.Product
WHERE Color IS NOT NULL AND ListPrice > 0

--6
SELECT Name + ' ' + Color AS NameColor
FROM Production.Product
WHERE Color IS NOT NULL

--7
SELECT Name + ' ' + Color AS 'Name and Color', Color
FROM Production.Product
WHERE Color IN ('Black', 'Silver')

--8
SELECT ProductID, Name
FROM Production.Product
WHERE ProductID BETWEEN 400 AND 500; 

--9
SELECT ProductID, Name, Color
FROM Production.Product
WHERE Color IN ('Black', 'Blue')

--10
SELECT *
FROM Production.Product
WHERE Name LIKE 'S%';

--11
SELECT Name, ListPrice
FROM Production.Product
WHERE Name LIKE 'S%'
ORDER BY Name

--12
SELECT Name, ListPrice
FROM Production.Product
WHERE Name LIKE 'A%' OR Name LIKE 'S%'
ORDER BY Name

--13
SELECT Name, ListPrice
FROM Production.Product
WHERE Name LIKE 'SPO[^K]%'
ORDER BY Name

--14
SELECT DISTINCT Color
FROM Production.Product
ORDER BY Color DESC

--15
SELECT ProductSubcategoryID, Color
FROM Production.Product
WHERE ProductSubcategoryID IS NOT NULL 
	AND Color IS NOT NULL

--16
SELECT ProductSubcategoryID, LEFT([Name], 35) AS [Name], Color, ListPrice
FROM Production.Product
WHERE Color NOT IN ('Red', 'Black')
	OR (Color IN ('Red', 'Black') 
		AND ListPrice BETWEEN 1000 AND 2000
		AND ProductSubcategoryID = 1)
ORDER BY ProductID