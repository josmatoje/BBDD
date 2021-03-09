USE NorthWind
--1. Número de clientes de cada país.

--2. Número de clientes diferentes que compran cada producto. Incluye el nombre
--del producto.

--3. Número de países diferentes en los que se vende cada producto. Incluye el
--nombre del producto.

--4. Empleados (nombre y apellido) que han vendido alguna vez
--“Gudbrandsdalsost”, “Lakkalikööri”, “Tourtière” o “Boston Crab Meat”.

--5. Empleados que no han vendido nunca “Northwoods Cranberry Sauce” o
--“Carnarvon Tigers”.

--6. Número de unidades de cada categoría de producto que ha vendido cada
--empleado. Incluye el nombre y apellidos del empleado y el nombre de la
--categoría.

--7. Total de ventas (US$) de cada categoría en el año 97. Incluye el nombre de la
--categoría.

--8. Productos que han comprado más de un cliente del mismo país, indicando el
--nombre del producto, el país y el número de clientes distintos de ese país que
--lo han comprado.

SELECT * FROM P

--9. Total de ventas (US$) en cada país cada año.

SELECT * FROM [Order Details] AS OD
	INNER JOIN Orders AS O ON OD.OrderID=O.OrderID
	INNER JOIN Customers AS C ON O.CustomerID=C.CustomerID

--10. Producto superventas de cada año, indicando año, nombre del producto,
--categoría y cifra total de ventas.

SELECT SUM(OD.Quantity) FROM Products AS P 
	INNER JOIN [Order Details] AS OD ON P.ProductID=OD.ProductID

--11. Cifra de ventas de cada producto en el año 97 y su aumento o disminución
--respecto al año anterior en US $ y en %.

--12. Mejor cliente (el que más nos compra) de cada país.

--13. Número de productos diferentes que nos compra cada cliente. Incluye el
--nombre y apellidos del cliente y su dirección completa.

--14. Clientes que nos compran más de cinco productos diferentes.

--15. Vendedores (nombre y apellidos) que han vendido una mayor cantidad que la
--media en US $ en el año 97.

--16. Empleados que hayan aumentado su cifra de ventas más de un 10% entre dos
--años consecutivos, indicando el año en que se produjo el aumento.
GO
CREATE VIEW VentasAnueales AS(
	SELECT E.EmployeeID, COUNT(O.OrderID) AS [Nº de pedidos], YEAR(O.OrderDate) AS Anno FROM Employees AS E
		INNER JOIN Orders AS O ON E.EmployeeID=O.EmployeeID
		GROUP BY E.EmployeeID, YEAR(O.OrderDate)
	)
GO

SELECT E.EmployeeID, E.FirstName, E.LastName, VA2.[Nº de pedidos], VA2.Anno FROM VentasAnueales AS VA1
	INNER JOIN VentasAnueales AS VA2 ON VA1.EmployeeID=VA2.EmployeeID
	INNER JOIN Employees AS E ON VA2.EmployeeID=E.EmployeeID
	WHERE VA1.[Nº de pedidos]<VA2.[Nº de pedidos]*1.1 AND
			VA1.Anno-1=VA2.Anno
	ORDER BY E.EmployeeID

			SELECT * FROM VentasAnueales
			ORDER BY EmployeeID
--COMPROBACIONES
BEGIN TRANSACTION

INSERT INTO [dbo].[Orders] ([CustomerID],[EmployeeID],[OrderDate]) 
		VALUES('GOURL' ,9 ,DATEFROMPARTS(1999,8,6))

ROLLBACK
GO

CREATE OR ALTER VIEW [Gastos] AS (
    SELECT EmployeeID, YEAR(O.OrderDate) AS Año, SUM((OD.UnitPrice * OD.Quantity) * (1 - OD.Discount)) AS Quantity FROM Orders AS O
    INNER JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID 
    GROUP BY EmployeeID, Year(O.OrderDate)
)
GO

SELECT Primero.EmployeeID, SEGUNDO.Año, ROUND((Primero.Quantity - Segundo.Quantity)/Primero.Quantity*100, 1) AS [Diferencia(%)] FROM Gastos AS Primero
INNER JOIN Gastos AS Segundo ON Primero.Año = (Segundo.Año - 1)
WHERE (Primero.Quantity - Segundo.Quantity)/Primero.Quantity*100 > 10
