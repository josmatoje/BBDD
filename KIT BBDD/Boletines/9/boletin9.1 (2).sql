USE Northwind
SELECT * FROM Categories
--Escribe las siguientes consultas sobre la base de datos NorthWind.
--Pon el enunciado como comentario junta a cada una
--Nombre de los proveedores y n�mero de productos que nos vende cada uno

SELECT
	S.CompanyName AS Nombre,
	Count(P.ProductID) AS Numero
FROM Suppliers AS S
INNER JOIN Products AS P
	ON S.SupplierID = P.SupplierID
GROUP BY  CompanyName

--Nombre completo y telefono de los vendedores que trabajen en New York, Seattle, Vermont, Columbia, Los Angeles, Redmond o Atlanta.

SELECT 
	LastName, 
	FirstName, 
	HomePhone, 
	ShipCity 
FROM Employees As emp 
INNER JOIN Orders as ord 
ON emp.EmployeeID = ord.EmployeeID 
WHERE ShipCity IN ('New York', 'Seattle', 'Vermont', 'Columbia', 'Los Angeles', 'Redmond' ,'Atlanta')

--N�mero de productos de cada categor�a y nombre de la categor�a.

SELECT 
	COUNT(CategoryName) as numero, 
	c.CategoryName as numero 
FROM Products as p 
LEFT JOIN Categories as c 
ON  p.CategoryID = c.CategoryID 
Group by p.CategoryID, c.CategoryName

--Nombre de la compa��a de todos los clientes que hayan comprado queso de cabrales o tofu.

SELECT 
	CompanyName, 
	ContactName 
FROM Customers 
INNER JOIN Orders 
ON Customers.CustomerID=Orders.CustomerID 
INNER JOIN [Order Details] 
ON Orders.OrderID=[Order Details].OrderID 
INNER JOIN Products 
ON [Order Details].ProductID=Products.ProductID
Where Products.ProductName IN ('Queso Cabrales','Tofu') 

--Empleados (ID, nombre, apellidos y tel�fono) que han vendido algo a Bon app' o Meter Franken.

SELECT
	FirstName, 
	LastName, 
	Phone, 
	Empleados.EmployeeID 
FROM Employees as Empleados 
INNER JOIN Orders as Pedido 
ON Empleados.EmployeeID=Pedido.EmployeeID 
INNER JOIN Customers as Cliente 
ON Pedido.CustomerID=Cliente.CustomerID 
Where Cliente.CompanyName IN ('Bon app''','Meter Franken')

--Empleados (ID, nombre, apellidos, mes y d�a de su cumplea�os) que no han vendido nunca nada a ning�n cliente de Francia. *

SELECT
	E.EmployeeID AS ID,
	E.FirstName AS Nombre,
	E.LastName AS Apellidos,
    Month(BirthDate) AS MesCumple,
	Day(BirthDate) AS DiaCumple
	
FROM Employees as E
INNER JOIN Orders as O
	ON E.EmployeeID=O.EmployeeID
WHERE O.ShipCountry LIKE 'France' 
GROUP BY E.EmployeeID, E.FirstName, E.LastName, Month(BirthDate), Day(BirthDate)

--Total de ventas en US$ de productos de cada categor�a (nombre de la categor�a).
--Total de ventas en US$ de cada empleado cada a�o (nombre, apellidos, direcci�n).
--Ventas de cada producto en el a�o 97. Nombre del producto y unidades.
--Cu�l es el producto del que hemos vendido m�s unidades en cada pa�s. *
--Empleados (nombre y apellidos) que trabajan a las �rdenes de Andrew Fuller.



--N�mero de subordinados que tiene cada empleado, incluyendo los que no tienen ninguno. Nombre, apellidos, ID.