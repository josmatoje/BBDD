USE Northwind
GO
/*1. Nombre de los proveedores y n�mero de productos que nos vende cada uno*/
SELECT S.CompanyName,COUNT(P.ProductID) AS [N�mero de productos]
FROM Suppliers AS S
INNER JOIN Products AS P ON S.SupplierID = P.SupplierID
--WHERE
GROUP BY S.CompanyName
--ORDER BY
/*2. Nombre completo y telefono de los vendedores que trabajen en New York,
Seattle, Vermont, Columbia, Los Angeles, Redmond o Atlanta.*/
SELECT DISTINCT E.FirstName,E.LastName,E.HomePhone
FROM Employees AS E
INNER JOIN EmployeeTerritories AS ET ON E.EmployeeID = ET.EmployeeID
INNER JOIN Territories AS T ON ET.TerritoryID = T.TerritoryID
WHERE T.TerritoryDescription IN ('New York','Seattle','Vermont','Columbia','Los Angeles','Redmond','Atlanta')
--GROUP BY
--ORDER BY
/*3. N�mero de productos de cada categor�a y nombre de la categor�a.*/
SELECT C.CategoryName, COUNT(P.ProductID) AS [N�mero de productos]
FROM Products AS P
INNER JOIN Categories AS C ON P.CategoryID = C.CategoryID
--WHERE
GROUP BY C.CategoryName
--ORDER BY
/*4. Nombre de la compa��a de todos los clientes que hayan comprado queso de cabrales o tofu.*/
SELECT DISTINCT C.CompanyName
FROM Customers AS C
INNER JOIN Orders AS O ON C.CustomerID = O.CustomerID
INNER JOIN [Order Details] AS OD ON O.OrderID=OD.OrderID
INNER JOIN Products AS P ON OD.ProductID=P.ProductID
WHERE P.ProductName IN ('Queso de cabrales','Tofu')
--GROUP BY
--ORDER BY
/*5. Empleados (ID, nombre, apellidos y tel�fono) que han vendido algo a Bon app' o Meter Franken.*/
SELECT E.EmployeeID,E.FirstName,E.LastName,E.HomePhone
FROM Employees AS E
INNER JOIN Orders AS O ON E.EmployeeID=O.EmployeeID
INNER JOIN Customers AS C ON O.CustomerID=C.CustomerID
WHERE C.CompanyName IN ('Bon app''','Meter Franken')
--GROUP BY
--ORDER BY
/*6. Empleados (ID, nombre, apellidos, mes y d�a de su cumplea�os) que no han vendido nunca
nada a ning�n cliente de Francia. **/
SELECT E.EmployeeID,E.FirstName,E.LastName,DATENAME(MONTH,E.BirthDate) AS [Mes de nacimiento],DATENAME(DAY,E.BirthDate) AS [D�a de nacimiento]
FROM Employees AS E
EXCEPT
SELECT E.EmployeeID,E.FirstName,E.LastName,DATENAME(MONTH,E.BirthDate) AS [Mes de nacimiento],DATENAME(DAY,E.BirthDate) AS [D�a de nacimiento]
FROM Employees AS E
INNER JOIN Orders AS O ON E.EmployeeID=O.EmployeeID
INNER JOIN Customers AS C ON O.CustomerID=C.CustomerID
WHERE C.Country LIKE 'Mexico'
--GROUP BY
--ORDER  BY
/*7. Total de ventas en US$ de productos de cada categor�a (nombre de la categor�a).*/
SELECT C.CategoryName, SUM(OD.Quantity*(OD.UnitPrice*(1-OD.Discount))) AS [Total facturado]
FROM Categories AS C
INNER JOIN Products AS P ON C.CategoryID=P.CategoryID
INNER JOIN [Order Details] AS OD ON P.ProductID=OD.ProductID
--WHERE
GROUP BY C.CategoryName
--ORDER  BY
/*8. Total de ventas en US$ de cada empleado cada a�o (nombre, apellidos, direcci�n).*/
SELECT E.FirstName,E.LastName,E.Address,YEAR(O.OrderDate) AS [A�o de venta],SUM(OD.Quantity*(OD.UnitPrice*(1-OD.Discount))) AS [Total Facturado]
FROM Employees AS E
INNER JOIN Orders AS O ON E.EmployeeID=O.EmployeeID
INNER JOIN [Order Details] AS OD ON O.OrderID=OD.OrderID
--WHERE
GROUP BY E.FirstName,E.LastName,E.Address,YEAR(O.OrderDate)
ORDER  BY E.FirstName,E.LastName,YEAR(O.OrderDate)
/*9. Ventas de cada producto en el a�o 97. Nombre del producto y unidades.*/
SELECT P.ProductName,SUM(OD.Quantity)AS [Cantidad vendida],SUM(OD.Quantity*(OD.UnitPrice*(1-OD.Discount))) AS [Total Facturado]
FROM Products AS P
INNER JOIN [Order Details] AS OD ON P.ProductID=OD.ProductID
INNER JOIN Orders AS O ON OD.OrderID=O.OrderID
WHERE YEAR(O.OrderDate)=1997
GROUP BY P.ProductName
ORDER  BY P.ProductName

/*10. Cu�l es el producto del que hemos vendido m�s unidades en cada pa�s. **/
SELECT C.Country,P.ProductName, sum(Quantity) Cantidad
FROM Products AS P
INNER JOIN [Order Details] AS OD ON P.ProductID=OD.ProductID
INNER JOIN Orders AS O ON OD.OrderID=O.OrderID
INNER JOIN Customers AS C ON O.CustomerID=C.CustomerID
INNER JOIN(
SELECT [Unidades Vendidas por Producto y Pa�s].Country,MAX([Unidades Vendidas por Producto y Pa�s].[Cantidad vendida]) AS [Uds Vendidas del m�s vendido] 
FROM(

SELECT P.ProductName,C.Country,SUM(OD.Quantity) AS [Cantidad vendida]
FROM Products AS P
INNER JOIN [Order Details] AS OD ON P.ProductID=OD.ProductID
INNER JOIN Orders AS O ON OD.OrderID=O.OrderID
INNER JOIN Customers AS C ON O.CustomerID=C.CustomerID
--WHERE
GROUP BY P.ProductName,C.Country
--ORDER BY P.ProductName
) AS [Unidades Vendidas por Producto y Pa�s]
--WHERE
GROUP BY [Unidades Vendidas por Producto y Pa�s].Country
--ORDER BY
) AS UDSDELTOPVENTAS ON UDSDELTOPVENTAS.Country=C.Country
GROUP BY P.ProductName,C.Country,[Uds Vendidas del m�s vendido]
HAVING SUM(OD.Quantity)=UDSDELTOPVENTAS.[Uds Vendidas del m�s vendido]




/*Con vistas*/
GO
CREATE VIEW [Ventas por Producto y Pa�s] AS(
SELECT P.ProductName, C.Country, SUM(OD.Quantity) AS [Unidades Vendidas]
FROM Products AS P
INNER JOIN [Order Details] AS OD ON P.ProductID=OD.ProductID
INNER JOIN Orders AS O ON OD.OrderID=O.OrderID
INNER JOIN Customers AS C ON O.CustomerID=C.CustomerID
--WHERE
GROUP BY P.ProductName, C.Country
)
GO
CREATE VIEW UdsdelTopVentas AS(
SELECT Country,MAX([Ventas por Producto y Pa�s].[Unidades Vendidas]) AS [Unidades del m�s vendido]
FROM [Ventas por Producto y Pa�s]
--WHERE
GROUP BY Country
--ORDER BY
)
GO
SELECT VPP.Country,VPP.ProductName,VPP.[Unidades Vendidas] AS Unidades
FROM [Ventas por Producto y Pa�s] AS VPP
INNER JOIN UdsdelTopVentas ON VPP.Country=UdsdelTopVentas.Country AND VPP.[Unidades Vendidas]=UdsdelTopVentas.[Unidades del m�s vendido]
--WHERE


/*11. Empleados (nombre y apellidos) que trabajan a las �rdenes de Andrew Fuller.*/
SELECT E.FirstName,E.LastName
FROM Employees AS E
WHERE E.ReportsTo = (SELECT E.EmployeeID FROM Employees AS E WHERE E.FirstName='Andrew' AND E.LastName='Fuller')
--GROUP BY
--ORDER  BY
/*Forma f�cil pero teniendo que saber el ID de Andrew Fuller*/
SELECT E.FirstName,E.LastName
FROM Employees AS E
WHERE E.ReportsTo=2
--GROUP BY
--ORDER  BY

/*12. N�mero de subordinados que tiene cada empleado, incluyendo los que no tienen ninguno. Nombre, apellidos, ID.*/
SELECT JEFES.FirstName,JEFES.LastName,JEFES.EmployeeID, COUNT(E.EmployeeID) AS [N�mero de empleados]
FROM Employees AS E
RIGHT JOIN Employees AS JEFES ON E.ReportsTo=JEFES.EmployeeID
--WHERE
GROUP BY JEFES.FirstName,JEFES.LastName,JEFES.EmployeeID
--ORDER  BY
