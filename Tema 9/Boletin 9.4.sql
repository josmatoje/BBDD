USE NorthWind
--1. N�mero de clientes de cada pa�s.

--2. N�mero de clientes diferentes que compran cada producto. Incluye el nombre
--del producto.

--3. N�mero de pa�ses diferentes en los que se vende cada producto. Incluye el
--nombre del producto.

--4. Empleados (nombre y apellido) que han vendido alguna vez
--�Gudbrandsdalsost�, �Lakkalik��ri�, �Tourti�re� o �Boston Crab Meat�.

--5. Empleados que no han vendido nunca �Northwoods Cranberry Sauce� o
--�Carnarvon Tigers�.

--6. N�mero de unidades de cada categor�a de producto que ha vendido cada
--empleado. Incluye el nombre y apellidos del empleado y el nombre de la
--categor�a.

--7. Total de ventas (US$) de cada categor�a en el a�o 97. Incluye el nombre de la
--categor�a.

--8. Productos que han comprado m�s de un cliente del mismo pa�s, indicando el
--nombre del producto, el pa�s y el n�mero de clientes distintos de ese pa�s que
--lo han comprado.

SELECT * FROM P

--9. Total de ventas (US$) en cada pa�s cada a�o.

SELECT * FROM [Order Details] AS OD
	INNER JOIN Orders AS O ON OD.OrderID=O.OrderID
	INNER JOIN Customers AS C ON O.CustomerID=C.CustomerID

--10. Producto superventas de cada a�o, indicando a�o, nombre del producto,
--categor�a y cifra total de ventas.

--SELECT SUM(OD.Quantity) FROM Products AS P 
--	INNER JOIN [Order Details] AS OD ON P.ProductID=OD.ProductID

	--sin primera consulta
	SELECT P.ProductName,C.CategoryName,JOSEMARIA.[Cantidad Producto],PEDRO.Ano2 FROM Products AS P
	INNER JOIN Categories AS C ON P.CategoryID=C.CategoryID
	INNER JOIN 
	(	SELECT MAX(GRUPO2.[N� De Productos Vendidos]) AS [Cantidad Producto],GRUPO2.Ano AS [Ano3] FROM
			(
				SELECT P.ProductID,SUM(OD.Quantity) AS [N� De Productos Vendidos],YEAR(O.OrderDate) AS [Ano] FROM Products AS P
				INNER JOIN [Order Details] AS OD ON P.ProductID=OD.ProductID
				INNER JOIN Orders AS O ON OD.OrderID=O.OrderID

--11. Cifra de ventas de cada producto en el a�o 97 y su aumento o disminuci�n
--respecto al a�o anterior en US $ y en %.

--12. Mejor cliente (el que m�s nos compra) de cada pa�s.

--13. N�mero de productos diferentes que nos compra cada cliente. Incluye el
--nombre y apellidos del cliente y su direcci�n completa.

--14. Clientes que nos compran m�s de cinco productos diferentes.

--15. Vendedores (nombre y apellidos) que han vendido una mayor cantidad que la
--media en US $ en el a�o 97.

--16. Empleados que hayan aumentado su cifra de ventas m�s de un 10% entre dos
--a�os consecutivos, indicando el a�o en que se produjo el aumento.
GO
CREATE VIEW VentasAnueales AS(
	SELECT E.EmployeeID, COUNT(O.OrderID) AS [N� de pedidos], YEAR(O.OrderDate) AS Anno FROM Employees AS E
		INNER JOIN Orders AS O ON E.EmployeeID=O.EmployeeID
		GROUP BY E.EmployeeID, YEAR(O.OrderDate)
	)
GO

SELECT E.EmployeeID, E.FirstName, E.LastName, VA2.[N� de pedidos], VA2.Anno FROM VentasAnueales AS VA1
	INNER JOIN VentasAnueales AS VA2 ON VA1.EmployeeID=VA2.EmployeeID
	INNER JOIN Employees AS E ON VA2.EmployeeID=E.EmployeeID AND VA1.Anno=VA2.Anno-1
	WHERE VA1.[N� de pedidos]*1.1 <=VA2.[N� de pedidos]
	ORDER BY E.EmployeeID

			SELECT * FROM VentasAnueales
			ORDER BY EmployeeID
--COMPROBACIONES
BEGIN TRANSACTION

INSERT INTO [dbo].[Orders] ([CustomerID],[EmployeeID],[OrderDate]) 
		VALUES('GOURL' ,9 ,DATEFROMPARTS(1999,8,6))

ROLLBACK
GO

--CONSULTA MANU

CREATE OR ALTER VIEW [Gastos] AS (
    SELECT EmployeeID, YEAR(O.OrderDate) AS A�o, SUM((OD.UnitPrice * OD.Quantity) * (1 - OD.Discount)) AS Quantity FROM Orders AS O
    INNER JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID 
    GROUP BY EmployeeID, Year(O.OrderDate)
)
GO

SELECT Primero.EmployeeID, SEGUNDO.A�o, ROUND((Primero.Quantity - Segundo.Quantity)/Primero.Quantity*100, 1) AS [Diferencia(%)] FROM Gastos AS Primero
INNER JOIN Gastos AS Segundo ON Primero.A�o = (Segundo.A�o - 1)
WHERE (Primero.Quantity - Segundo.Quantity)/Primero.Quantity*100 > 10
