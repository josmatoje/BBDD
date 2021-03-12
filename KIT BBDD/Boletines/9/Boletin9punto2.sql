USE Northwind

/*1. N�mero de clientes de cada pa�s.*/
SELECT COUNT(CustomerID) AS [N�mero de clientes], Country FROM Customers
	GROUP BY Country

/*2. N�mero de clientes diferentes que compran cada producto.*/
SELECT COUNT(c.CustomerID) AS [N�mero de clientes], p.ProductName
	FROM Customers AS c
	INNER JOIN Orders AS o
	ON c.CustomerID = o.CustomerID
	INNER JOIN [Order Details] AS od
	ON o.OrderID = od.OrderID
	INNER JOIN Products AS p
	ON od.ProductID = p.ProductID
		GROUP BY p.ProductName

/*3. N�mero de pa�ses diferentes en los que se vende cada producto.*/
SELECT COUNT(o.ShipCountry) AS [N�mero de paises], p.ProductName
	FROM Orders AS o
	INNER JOIN [Order Details] AS od
	ON o.OrderID = od.OrderID
	INNER JOIN Products AS p
	ON od.ProductID = p.ProductID
		GROUP BY p.ProductName

/*4. Empleados que han vendido alguna vez �Gudbrandsdalsost�, �Lakkalik��ri�, �Tourti�re� o �Boston Crab Meat�.*/
SELECT * FROM Employees
SELECT * FROM Orders
SELECT * FROM [Order Details]
SELECT * FROM Products

SELECT DISTINCT e.FirstName, e.LastName
	FROM Employees AS e
	INNER JOIN Orders AS o
	ON e.EmployeeID = o.EmployeeID
	INNER JOIN [Order Details] AS od
	ON o.OrderID = od.OrderID
	INNER JOIN Products AS p
	ON od.ProductID = p.ProductID
		WHERE p.ProductName IN ('Gudbrandsdalsost', 'Lakkalik��ri', 'Tourti�re', 'Boston Crab Meat')

/*5. Empleados que no han vendido nunca �Chartreuse verte� ni �Ravioli Angelo�.*/
--
SELECT * FROM Employees
SELECT * FROM Orders
SELECT * FROM [Order Details]
SELECT * FROM Products

SELECT DISTINCT e.FirstName, e.LastName		--Se puede quitar el DISTINCT teniendo el EXCEPT
	FROM Employees AS e
	INNER JOIN Orders AS o
	ON e.EmployeeID = o.EmployeeID
	INNER JOIN [Order Details] AS od
	ON o.OrderID = od.OrderID
	INNER JOIN Products AS p
	ON od.ProductID = p.ProductID

EXCEPT

SELECT DISTINCT e.FirstName, e.LastName		--Se puede quitar el DISTINCT teniendo el EXCEPT
	FROM Employees AS e
	INNER JOIN Orders AS o
	ON e.EmployeeID = o.EmployeeID
	INNER JOIN [Order Details] AS od
	ON o.OrderID = od.OrderID
	INNER JOIN Products AS p
	ON od.ProductID = p.ProductID
		WHERE p.ProductName IN ('Chartreuse verte', 'Ravioli Angelo')

/*6. N�mero de unidades de cada categor�a de producto que ha vendido cada empleado.*/
SELECT * FROM Employees
SELECT * FROM Orders
SELECT * FROM [Order Details]
SELECT * FROM Products
SELECT * FROM Categories

SELECT SUM(od.Quantity) AS [N�mero de unidades vendidas], c.CategoryName
	FROM Categories AS c
	INNER JOIN Products AS p
	ON c.CategoryID = p.CategoryID
	INNER JOIN [Order Details] AS od
	ON p.ProductID = od.ProductID
	INNER JOIN Orders AS o
	ON od.OrderID = o.OrderID
	INNER JOIN Employees AS e
	ON o.EmployeeID = e.EmployeeID
		GROUP BY c.CategoryName
		

/*7. Total de ventas (US$) de cada categor�a en el a�o 97.*/
SELECT * FROM Categories
SELECT * FROM Products
SELECT * FROM [Order Details]
SELECT * FROM Orders

SELECT CategoryName, SUM(od.Quantity * od.UnitPrice * (1 - od.Discount)) AS [Total de ventas]
	FROM Categories AS c
	INNER JOIN Products AS p
	ON c.CategoryID = p.CategoryID
	INNER JOIN [Order Details] AS od
	ON p.ProductID = od.ProductID
	INNER JOIN Orders AS o
	ON od.OrderID = o.OrderID
		WHERE YEAR(o.OrderDate) = '1997'
		GROUP BY c.CategoryName

/*8. Productos que han comprado m�s de un cliente del mismo pa�s, indicando
el nombre del producto, el pa�s y el n�mero de clientes distintos de ese pa�s que lo han comprado.*/
SELECT * FROM Products
SELECT * FROM [Order Details]
SELECT * FROM Orders
SELECT * FROM Customers

SELECT p.ProductName, o.ShipCountry, COUNT(c.CustomerID) AS [N�mero de clientes]
	FROM Products AS p
	INNER JOIN [Order Details] AS od
	ON p.ProductID = od.ProductID
	INNER JOIN Orders AS o
	ON od.OrderID = o.OrderID
	INNER JOIN Customers AS c
	ON o.CustomerID = c.CustomerID
		GROUP BY p.ProductName, o.ShipCountry
		HAVING COUNT(c.CustomerID) > 1			--Utilizamos HAVING porque en CustomerID hemos utilizado un agregado (que tiene un COUNT vamoh)

/*9. Total de ventas (US$) en cada pa�s cada a�o.*/
SELECT * FROM [Order Details]
SELECT * FROM Orders

SELECT SUM(od.Quantity * od.UnitPrice * (1- od.Discount)) AS [Total de ventas], o.ShipCountry, YEAR(o.OrderDate) AS [A�o de venta]
	FROM [Order Details] AS od
	INNER JOIN Orders AS o
	ON od.OrderID = o.OrderID
		GROUP BY o.ShipCountry, YEAR(o.OrderDate)
		ORDER BY o.ShipCountry, YEAR(o.OrderDate) ASC

/*10. Producto superventas de cada a�o, indicando a�o, nombre del producto, categor�a y cifra total de ventas.*/
SELECT * FROM Categories
SELECT * FROM [Order Details]
SELECT * FROM Orders

--Esta consulta nos da toda la cantidad vendida de cada producto cada a�o
SELECT p.ProductName, SUM(od.Quantity) AS [Cantidad vendida], YEAR(o.OrderDate) AS [A�o]
	FROM Categories AS c
		INNER JOIN Products AS p
		ON c.CategoryID = p.CategoryID
		INNER JOIN [Order Details] AS od
		ON p.ProductID = od.ProductID
		INNER JOIN Orders AS o
		ON od.OrderID = o.OrderID
		GROUP BY p.ProductName, YEAR(o.OrderDate)

/*Esta consulta utiliza la consulta anterior (que tiene una subconsulta vamoh) para poder saber la cantidad m�xima
Porque como tenemos que hacer el MAX de un SUM tenemeos que hacerlo con una subconsulta.
No podemos a�adir el nombre del producto a la consulta porque nos saldr�a la m�xima cantidad por a�o de cada elemento y queremos la m�xima de cada a�o.

CONSULTA MAL HECHA PORQUE NOS SEPARA POR NOMBRE TAMBI�N
SELECT MAX(a.[Cantidad vendida]) AS [Cantidad m�xima vendida], a.A�o, a.ProductName
	FROM (SELECT p.ProductName, SUM(od.Quantity) AS [Cantidad vendida], YEAR(o.OrderDate) AS [A�o], c.CategoryName
			FROM Categories AS c
			INNER JOIN Products AS p
			ON c.CategoryID = p.CategoryID
			INNER JOIN [Order Details] AS od
			ON p.ProductID = od.ProductID
			INNER JOIN Orders AS o
			ON od.OrderID = o.OrderID
				GROUP BY p.ProductName, YEAR(o.OrderDate), c.CategoryName) AS a
	GROUP BY a.A�o, a.ProductName*/

/*MISMA CONSULTA PERO SIN EL NOMBRE DEL PRODUCTO*/
SELECT MAX(a.[Cantidad vendida]) AS [Cantidad m�xima vendida], a.A�o
	FROM (SELECT p.ProductName, SUM(od.Quantity) AS [Cantidad vendida], YEAR(o.OrderDate) AS [A�o], c.CategoryName
			FROM Categories AS c
			INNER JOIN Products AS p
			ON c.CategoryID = p.CategoryID
			INNER JOIN [Order Details] AS od
			ON p.ProductID = od.ProductID
			INNER JOIN Orders AS o
			ON od.OrderID = o.OrderID
				GROUP BY p.ProductName, YEAR(o.OrderDate), c.CategoryName) AS a
	GROUP BY a.A�o

/*Como en la consulta anterior no pudimos consultar el nombre porque se nos fastidiaba, tenemos que hacer INNER JOIN con otra consulta que si tenga el nombre.
Vamos a consultar la tabla que hicimos antes de utilizar el SUM.
Para eso necesitamos saber que columna utilizaremos para unirlas. (MIRAR EL ON PARA SABER DE QUE HABLO)*/

SELECT paraPorfavor.A�o, odioLasSubconsultas.ProductName, odioLasSubconsultas.CategoryName, paraPorfavor.[Cantidad m�xima vendida]
	FROM (SELECT MAX(a.[Cantidad vendida]) AS [Cantidad m�xima vendida], a.A�o
		FROM (SELECT p.ProductName, SUM(od.Quantity) AS [Cantidad vendida], YEAR(o.OrderDate) AS [A�o], c.CategoryName
				FROM Categories AS c
				INNER JOIN Products AS p
				ON c.CategoryID = p.CategoryID
				INNER JOIN [Order Details] AS od
				ON p.ProductID = od.ProductID
				INNER JOIN Orders AS o
				ON od.OrderID = o.OrderID
					GROUP BY p.ProductName, YEAR(o.OrderDate), c.CategoryName) AS a
			GROUP BY a.A�o) AS [paraPorfavor]

	INNER JOIN (SELECT p.ProductName, SUM(od.Quantity) AS [Cantidad vendida], YEAR(o.OrderDate) AS [A�o], c.CategoryName
					FROM Categories AS c
					INNER JOIN Products AS p
					ON c.CategoryID = p.CategoryID
					INNER JOIN [Order Details] AS od
					ON p.ProductID = od.ProductID
					INNER JOIN Orders AS o
					ON od.OrderID = o.OrderID
						GROUP BY p.ProductName, YEAR(o.OrderDate), c.CategoryName) AS [odioLasSubconsultas]

	ON paraPorfavor.[Cantidad m�xima vendida] = odioLasSubconsultas.[Cantidad vendida]
	--Utilizando [Cantidad m�xima vendida] y [Cantidad vendida] veremos solo donde coinciden la m�xima conforme a la tabla con todos los productos
	--que es donde podemos ver el nombre que va asociado a esa cantidad

/*MISMO EJERCICIO PERO CON VISTAS (utilizando el VIEW vamoh)*/
GO
CREATE VIEW [CantidadVendidaPorA�oDeCadaElemento] AS
SELECT p.ProductName, SUM(od.Quantity) AS [Cantidad vendida], YEAR(o.OrderDate) AS [A�o]
	FROM Categories AS c
		INNER JOIN Products AS p
		ON c.CategoryID = p.CategoryID
		INNER JOIN [Order Details] AS od
		ON p.ProductID = od.ProductID
		INNER JOIN Orders AS o
		ON od.OrderID = o.OrderID
		GROUP BY p.ProductName, YEAR(o.OrderDate)
GO

GO
CREATE VIEW [M�ximaCantidadPorA�o] AS
SELECT MAX(a.[Cantidad vendida]) AS [Cantidad m�xima vendida], a.A�o
	FROM (SELECT p.ProductName, SUM(od.Quantity) AS [Cantidad vendida], YEAR(o.OrderDate) AS [A�o], c.CategoryName
			FROM Categories AS c
			INNER JOIN Products AS p
			ON c.CategoryID = p.CategoryID
			INNER JOIN [Order Details] AS od
			ON p.ProductID = od.ProductID
			INNER JOIN Orders AS o
			ON od.OrderID = o.OrderID
				GROUP BY p.ProductName, YEAR(o.OrderDate), c.CategoryName) AS a
	GROUP BY a.A�o
GO

SELECT a.ProductName, maxima.[Cantidad m�xima vendida], a.A�o
	FROM [CantidadVendidaPorA�oDeCadaElemento] AS a
	INNER JOIN [M�ximaCantidadPorA�o] AS maxima
	ON a.[Cantidad vendida] = maxima.[Cantidad m�xima vendida]

/*11. Cifra de ventas de cada producto en el a�o 97 y su aumento o disminuci�n respecto al a�o anterior en US $ y en %.*/
SELECT * FROM Products
SELECT * FROM [Order Details]
SELECT * FROM Orders

SELECT SUM(od.Quantity) AS [Cantidad], p.ProductName, YEAR(o.OrderDate) AS [A�o]
	FROM Products AS p
	INNER JOIN[Order Details] AS od
	ON p.ProductID = od.ProductID
	INNER JOIN Orders AS o
	ON od.OrderID = o.OrderID
		WHERE YEAR(o.OrderDate) = '1996'
		GROUP BY p.ProductName, YEAR(o.OrderDate)

SELECT SUM(od.Quantity) AS [Cantidad], p.ProductName, YEAR(o.OrderDate) AS [A�o]
	FROM Products AS p
	INNER JOIN[Order Details] AS od
	ON p.ProductID = od.ProductID
	INNER JOIN Orders AS o
	ON od.OrderID = o.OrderID
		WHERE YEAR(o.OrderDate) = '1997'
		GROUP BY p.ProductName, YEAR(o.OrderDate)

SELECT [a�o97].Cantidad97, ([a�o97].[Dinero97] - [a�o96].[Dinero96]) AS [Aumento/Decrecimiento]
	FROM (SELECT SUM(od.Quantity) AS [Cantidad96], SUM((od.Quantity * od.UnitPrice) * (1 - od.Discount)) AS [Dinero96], p.ProductName, YEAR(o.OrderDate) AS [A�o]
			FROM Products AS p
			INNER JOIN[Order Details] AS od
			ON p.ProductID = od.ProductID
			INNER JOIN Orders AS o
			ON od.OrderID = o.OrderID
				WHERE YEAR(o.OrderDate) = '1996'
				GROUP BY p.ProductName, YEAR(o.OrderDate)) AS [a�o96]

	INNER JOIN (SELECT SUM(od.Quantity) AS [Cantidad97], SUM((od.Quantity * od.UnitPrice) * (1 - od.Discount)) AS [Dinero97], p.ProductName, YEAR(o.OrderDate) AS [A�o]
					FROM Products AS p
					INNER JOIN[Order Details] AS od
					ON p.ProductID = od.ProductID
					INNER JOIN Orders AS o
					ON od.OrderID = o.OrderID
						WHERE YEAR(o.OrderDate) = '1997'
						GROUP BY p.ProductName, YEAR(o.OrderDate)) AS [a�o97]

	ON [a�o96].ProductName = [a�o97].ProductName

/*12. Mejor cliente (el que m�s nos compra) de cada pa�s.*/
SELECT * FROM Customers
SELECT * FROM Orders
SELECT * FROM [Order Details]

GO
ALTER VIEW ClientesCantidadPais AS
SELECT SUM(od.Quantity) AS [Cantidad comprada], c.CompanyName, o.ShipCountry
	FROM Customers AS c
	INNER JOIN Orders AS o
	ON c.CustomerID = o.CustomerID
	INNER JOIN [Order Details] AS od
	ON o.OrderID = od.OrderID
		GROUP BY c.CompanyName, o.ShipCountry
GO

SELECT MAX(ccp.[Cantidad comprada]) AS [M�xima cantidad comprada], ccp.ShipCountry
	FROM ClientesCantidadPais AS ccp
		GROUP BY ccp.ShipCountry

SELECT MAX(ccp.[Cantidad comprada]) AS [M�xima cantidad comprada], ccp.CompanyName, ccp.ShipCountry
	FROM ClientesCantidadPais AS ccp
		GROUP BY ccp.CompanyName, ccp.ShipCountry

SELECT A.[M�xima cantidad comprada], A.ShipCountry, B.CompanyName
	FROM (SELECT MAX(ccp.[Cantidad comprada]) AS [M�xima cantidad comprada], ccp.ShipCountry
			FROM ClientesCantidadPais AS ccp
				GROUP BY ccp.ShipCountry) AS [A]

	INNER JOIN (SELECT MAX(ccp.[Cantidad comprada]) AS [M�xima cantidad comprada], ccp.CompanyName, ccp.ShipCountry
					FROM ClientesCantidadPais AS ccp
						GROUP BY ccp.CompanyName, ccp.ShipCountry) AS [B]

	ON A.[M�xima cantidad comprada] = B.[M�xima cantidad comprada] AND A.ShipCountry = B.ShipCountry

/*13. N�mero de productos diferentes que nos compra cada cliente.*/

/*14. Clientes que nos compran m�s de cinco productos diferentes.*/

/*15. Vendedores que han vendido una mayor cantidad que la media en US $ en el a�o 97.*/

/*16. Empleados que hayan aumentado su cifra de ventas m�s de un 10% entre dos a�os consecutivos, indicando el a�o en que se produjo el aumento.*/
