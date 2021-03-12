--1. Nombre de los proveedores y n�mero de productos que nos vende cada uno.
SELECT * FROM Suppliers
SELECT * FROM Products

SELECT s.CompanyName, COUNT(ProductID) AS [N�mero de productos que vende]
	FROM Suppliers AS s
	INNER JOIN Products AS p
	ON s.SupplierID = p.SupplierID
		GROUP BY s.ContactName

--2. Nombre completo y telefono de los vendedores que trabajen en New York, Seattle, Vermont, Columbia, Los Angeles, Redmond o Atlanta.
SELECT * FROM Employees
SELECT * FROM EmployeeTerritories
SELECT * FROM Territories

SELECT e.FirstName, e.LastName, e.HomePhone, t.TerritoryDescription
	FROM Employees AS e
	INNER JOIN EmployeeTerritories AS et
	ON e.EmployeeID = et.EmployeeID
	INNER JOIN Territories AS t
	ON et.TerritoryID = t.TerritoryID
		WHERE t.TerritoryDescription IN ('New York', 'Seattle', 'Vermont', 'Columbia', 'Los Angeles', 'Redmond', 'Atlanta')

--3. N�mero de productos de cada categor�a y nombre de la categor�a.
SELECT * FROM Products
SELECT * FROM Categories

SELECT c.CategoryName, COUNT(p.ProductID) AS [N�mero de productos por categor�a]
	FROM Categories AS c
	INNER JOIN Products AS p
	ON c.CategoryID = p.CategoryID
		GROUP BY CategoryName

--4. Nombre de la compa��a de todos los clientes que hayan comprado queso de cabrales o tofu.
SELECT * FROM Customers
SELECT * FROM Orders
SELECT * FROM [Order Details]
SELECT * FROM Products

SELECT c.CompanyName, p.ProductName 
	FROM Products AS p
		INNER JOIN [Order Details] AS od
		ON p.ProductID = od.ProductID
		INNER JOIN Orders AS o
		ON od.OrderID = o.OrderID
		INNER JOIN Customers AS c
		ON o.CustomerID = c.CustomerID
			WHERE p.ProductName IN ('Queso Cabrales', 'Tofu')

--5. Empleados (ID, nombre, apellidos y tel�fono) que han vendido algo a Bon app' o Meter Franken.
SELECT * FROM Employees

SELECT e.EmployeeID, e.FirstName, e.LastName, e.HomePhone, c.CompanyName
	FROM Employees AS e
	INNER JOIN Orders AS o
	ON e.EmployeeID = o.EmployeeID
	INNER JOIN Customers AS c
	ON o.CustomerID = c.CustomerID
		WHERE c.CompanyName IN ('Bon app''', 'Meter Franken')

--6. Empleados (ID, nombre, apellidos, mes y d�a de su cumplea�os) que no han vendido nunca nada a ning�n cliente de Francia. *
SELECT * FROM Employees
SELECT * FROM Orders

SELECT e.EmployeeID, e.FirstName, e.LastName, MONTH(BirthDate) AS [Mes del cumplea�os], DAY(BirthDate) AS [D�a del cumplea�os]
	FROM Employees AS e
	INNER JOIN Orders AS o
	ON e.EmployeeID = o.EmployeeID

EXCEPT

SELECT e.EmployeeID, e.FirstName, e.LastName, MONTH(BirthDate) AS [Mes del cumplea�os], DAY(BirthDate) AS [D�a del cumplea�os]
	FROM Orders AS o
	INNER JOIN Employees AS e
	ON o.EmployeeID = e.EmployeeID
	WHERE ShipCountry = 'France'

--7. Total de ventas en US$ de productos de cada categor�a (nombre de la categor�a).
SELECT * FROM Categories
SELECT * FROM Products
SELECT * FROM [Order Details]

SELECT c.CategoryName, SUM(od.UnitPrice * od.Quantity) AS [Total de ventas en US$]
	FROM Categories AS c
	INNER JOIN Products AS p
	ON c.CategoryID = p.CategoryID
	INNER JOIN [Order Details] AS od
	ON p.ProductID = od.ProductID
		GROUP BY c.CategoryName

--8. Total de ventas en US$ de cada empleado cada a�o (nombre, apellidos, direcci�n).
SELECT * FROM Employees
SELECT * FROM Orders
SELECT * FROM [Order Details]

SELECT e.FirstName, e.LastName, e.[Address], SUM(od.UnitPrice * od.Quantity) AS [Total de ventas en US$], YEAR(o.OrderDate) AS [A�o de venta]
	FROM Employees AS e
	INNER JOIN Orders AS o
	ON e.EmployeeID = o.EmployeeID
	INNER JOIN [Order Details] AS od
	ON o.OrderID = od.OrderID
		GROUP BY e.FirstName, e.LastName, e.[Address], YEAR(o.OrderDate)
		ORDER BY e.FirstName, e.LastName, YEAR(o.OrderDate)

--9. Ventas de cada producto en el a�o 97. Nombre del producto y unidades.
SELECT * FROM Products
SELECT * FROM [Order Details]
SELECT * FROM Orders

SELECT p.ProductName, SUM(od.Quantity) AS [Cantidad de unidades], YEAR(o.OrderDate) AS [A�o de venta]
	FROM Products AS p
	INNER JOIN [Order Details] AS od
	ON p.ProductID = od.ProductID
	INNER JOIN Orders AS o
	ON od.OrderID = o.OrderID
		WHERE YEAR(o.OrderDate) = '1997' 
		GROUP BY P.ProductName, YEAR(o.OrderDate)

--10. Cu�l es el producto del que hemos vendido m�s unidades en cada pa�s. *
SELECT * FROM Products
SELECT * FROM [Order Details]
SELECT * FROM Orders

SELECT p.ProductName, SUM(od.Quantity) AS [Cantidad vendida], o.ShipCountry
	FROM Products AS p
	INNER JOIN [Order Details] AS od
	ON p.ProductID = od.ProductID
	INNER JOIN Orders AS o
	ON od.OrderID = o.OrderID
	GROUP BY p.ProductName, o.ShipCountry

SELECT MAX([Cantidad vendida]) AS [Cantidad m�xima vendida por pa�s], o.ShipCountry, p.ProductName
	FROM (SELECT SUM(od.Quantity) AS [Cantidad vendida], o.OrderID, p.ProductName
			FROM Products AS p
			INNER JOIN [Order Details] AS od
			ON p.ProductID = od.ProductID
			INNER JOIN Orders AS o
			ON od.OrderID = o.OrderID
			GROUP BY p.ProductName, o.ShipCountry, o.OrderID) AS [Mieo]
	INNER JOIN Orders AS o
	ON [Mieo].OrderID = o.OrderID
	INNER JOIN [Order Details] AS od
	ON o.OrderID = od.OrderID
	INNER JOIN Products AS p
	ON od.ProductID = p.ProductID
	GROUP BY o.ShipCountry, p.ProductName

--11. Empleados (nombre y apellidos) que trabajan a las �rdenes de Andrew Fuller.
SELECT * FROM Employees

SELECT EmployeeID FROM Employees
	WHERE FirstName = 'Andrew' AND LastName = 'Fuller'

SELECT FirstName, LastName, ReportsTo FROM Employees
	WHERE ReportsTo = (SELECT EmployeeID FROM Employees
							WHERE FirstName = 'Andrew' AND LastName = 'Fuller')

--12. N�mero de subordinados que tiene cada empleado, incluyendo los que no tienen ninguno. Nombre, apellidos, ID.
SELECT * FROM Employees

SELECT FirstName, LastName,EmployeeID, ReportsTo FROM Employees

/*SELECT FirstName, LastName,EmployeeID, COUNT(ReportsTo) FROM Employees
	GROUP BY FirstName, LastName,EmployeeID
	WHERE */


--* Se necesitan subconsultas