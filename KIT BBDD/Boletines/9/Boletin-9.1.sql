USE Northwind
GO

--1.Nombre de los proveedores y n�mero de productos que nos vende cada uno--
SELECT * FROM Suppliers
SELECT * FROM Products

SELECT S.CompanyName, COUNT(*) AS NumberOfProducts
FROM Suppliers AS S
INNER JOIN Products AS P
ON S.SupplierID=P.SupplierID
GROUP BY S.CompanyName

--2.Nombre completo y telefono de los vendedores que trabajen en New York, 
--Seattle, Vermont, Columbia, Los Angeles, Redmond o Atlanta.--
SELECT * FROM Employees

SELECT FirstName,LastName, HomePhone
FROM Employees
WHERE City in ('New York', 'Seattle', 'Vermont', 'Columbia', 'Los Angeles', 'Redmond' , 'Atlanta')

--3.N�mero de productos de cada categor�a y nombre de la categor�a.--
SELECT * FROM Categories
SELECT * FROM Products

SELECT C.CategoryName, COUNT(P.ProductID) AS NumberOfProducts
FROM Categories AS C
INNER JOIN Products AS P
ON C.CategoryID=P.CategoryID
GROUP BY CategoryName

--4.Nombre de la compa��a de todos los clientes que hayan comprado queso de cabrales o tofu.--
SELECT * FROM Customers
SELECT * FROM Orders
SELECT * FROM [Order Details]
SELECT * FROM Products

SELECT C.CompanyName
FROM Customers AS C
INNER JOIN Orders AS O
ON C.CustomerID=O.CustomerID
INNER JOIN [Order Details] AS OD
ON O.OrderID=OD.OrderID
INNER JOIN Products AS P
ON P.ProductID=OD.ProductID
WHERE P.ProductName LIKE 'Cabrales' OR P.ProductName LIKE 'Tofu'

--5.Empleados (ID, nombre, apellidos y tel�fono) que han vendido algo a Bon app' o Meter Franken'.--
SELECT * FROM Employees
SELECT * FROM Orders
SELECT * FROM Customers

SELECT E.EmployeeID, E.FirstName, E.LastName, E.HomePhone, C.CompanyName
FROM Employees as E
INNER JOIN Orders AS O
ON E.EmployeeID=O.EmployeeID
INNER JOIN Customers AS C
ON C.CustomerID=O.CustomerID
WHERE C.CompanyName LIKE 'Bon app_' OR C.CompanyName LIKE 'Meter Franken'

--6.Empleados (ID, nombre, apellidos, mes y d�a de su cumplea�os) que no han vendido nunca nada --
--a ning�n cliente de Francia. Se necesitan subconsultas --
SELECT * FROM Employees
SELECT * FROM Orders
SELECT * FROM Customers

SELECT E.EmployeeID, E.FirstName, E.LastName, DAY(E.BirthDate) AS Day, MONTH(E.BirthDate) AS Month
FROM Employees as E
INNER JOIN Orders AS O
ON E.EmployeeID=O.EmployeeID
INNER JOIN Customers AS C
ON C.CustomerID=O.CustomerID
WHERE O.ShipCountry NOT LIKE 'France'

--7.Total de ventas en US$ de productos de cada categor�a (nombre de la categor�a).--


--8.Total de ventas en US$ de cada empleado cada a�o (nombre, apellidos, direcci�n).--


--9.Ventas de cada producto en el a�o 97. Nombre del producto y unidades.--


--10.Cu�l es el producto del que hemos vendido m�s unidades en cada pa�s. Se necesitan subconsultas --


--11.Empleados (nombre y apellidos) que trabajan a las �rdenes de Andrew Fuller.--


--12.N�mero de subordinados que tiene cada empleado, incluyendo los que no tienen ninguno. Nombre,--
-- apellidos, ID.--

