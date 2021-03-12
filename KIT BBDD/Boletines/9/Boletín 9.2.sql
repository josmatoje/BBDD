USE Northwind
GO
/*1.N�mero de clientes de cada pa�s.*/
SELECT C.Country,COUNT(C.CustomerID)
FROM Customers AS C
--WHERE
GROUP BY C.Country
--ORDER BY

/*2. N�mero de clientes diferentes que compran cada producto.*/
SELECT OD.ProductID,COUNT(DISTINCT O.CustomerID) AS [N�mero de clientes diferentes]
FROM Orders AS O
INNER JOIN [Order Details] AS OD ON O.OrderID=OD.OrderID
--WHERE
GROUP BY OD.ProductID
--ORDER BY

/*3. N�mero de pa�ses diferentes en los que se vende cada producto.*/
SELECT P.ProductName, COUNT(DISTINCT O.ShipCountry) AS [N�mero de pa�ses diferentes]
FROM [Order Details] AS OD
INNER JOIN Orders AS O ON OD.OrderID=O.OrderID
INNER JOIN Products AS P ON OD.ProductID=P.ProductID
--WHERE
GROUP BY P.ProductName
--ORDER BY

/*4. Empleados que han vendido alguna vez �Gudbrandsdalsost�, �Lakkalik��ri�,
�Tourti�re� o �Boston Crab Meat�.*/
SELECT DISTINCT E.EmployeeID,E.FirstName,E.LastName
FROM Employees AS E
INNER JOIN Orders AS O ON E.EmployeeID=O.EmployeeID
INNER JOIN [Order Details] AS OD ON O.OrderID=OD.OrderID
INNER JOIN Products AS P ON OD.ProductID=P.ProductID
WHERE P.ProductName IN ('Gudbrandsdalsost','Lakkalik��ri','Tourti�re','Boston Crab Meat')
--GROUP BY
--ORDER BY

/*5. Empleados que no han vendido nunca �Chartreuse verte� ni �Ravioli Angelo�.*/
SELECT E.EmployeeID,E.FirstName,E.LastName
FROM Employees AS E
/*INNER JOIN Orders AS O ON E.EmployeeID=O.EmployeeID
INNER JOIN [Order Details] AS OD ON O.OrderID=OD.OrderID
INNER JOIN Products AS P ON OD.ProductID=P.ProductID*/
EXCEPT
SELECT E.EmployeeID,E.FirstName,E.LastName
FROM Employees AS E
INNER JOIN Orders AS O ON E.EmployeeID=O.EmployeeID
INNER JOIN [Order Details] AS OD ON O.OrderID=OD.OrderID
INNER JOIN Products AS P ON OD.ProductID=P.ProductID
WHERE P.ProductName IN ('Chartreuse verte','Ravioli Angelo')
GROUP BY E.EmployeeID,E.FirstName,E.LastName
--ORDER BY

/*6. N�mero de unidades de cada categor�a de producto que ha vendido cada
empleado.*/
SELECT E.EmployeeID,E.FirstName,E.LastName,C.CategoryName,COUNT(OD.ProductID) AS [Unidades Vendidas]
FROM Categories AS C
INNER JOIN Products AS P ON C.CategoryID=P.CategoryID
INNER JOIN [Order Details] AS OD ON P.ProductID=OD.ProductID
INNER JOIN Orders AS O ON OD.OrderID=O.OrderID
INNER JOIN Employees AS E ON O.EmployeeID=E.EmployeeID
--WHERE
GROUP BY E.EmployeeID,E.FirstName,E.LastName,C.CategoryName
ORDER BY E.EmployeeID,E.FirstName,E.LastName

/*7. Total de ventas (US$) de cada categor�a en el a�o 97.*/
SELECT C.CategoryName,SUM(OD.Quantity*(OD.UnitPrice*(1-OD.Discount))) AS Facturaci�n
FROM Categories AS C
INNER JOIN Products AS P ON C.CategoryID=P.CategoryID
INNER JOIN [Order Details] AS OD ON P.ProductID=OD.ProductID
INNER JOIN Orders AS O ON OD.OrderID=O.OrderID
WHERE YEAR(O.OrderDate)=1997
GROUP BY C.CategoryName
--ORDER BY

/*8. Productos que han comprado m�s de un cliente del mismo pa�s, indicando el
nombre del producto, el pa�s y el n�mero de clientes distintos de ese pa�s que
lo han comprado.*/
SELECT P.ProductName, C.Country, COUNT(DISTINCT C.CustomerID)
FROM Products AS P
INNER JOIN [Order Details] AS OD ON P.ProductID=OD.ProductID
INNER JOIN Orders AS O ON OD.OrderID=O.OrderID
INNER JOIN Customers AS C ON O.CustomerID=C.CustomerID
--WHERE
GROUP BY P.ProductName, C.Country
--ORDER BY
HAVING COUNT(DISTINCT O.CustomerID)>1

/*9. Total de ventas (US$) en cada pa�s cada a�o.*/
SELECT C.Country,YEAR(O.OrderDate),SUM(OD.Quantity*(OD.UnitPrice*(1-OD.Discount))) AS [Total Facturado]
FROM [Order Details] AS OD
INNER JOIN Orders AS O ON OD.OrderID=O.OrderID
INNER JOIN Customers AS C ON O.CustomerID=C.CustomerID
--WHERE
GROUP BY C.Country,YEAR(O.OrderDate)
ORDER BY C.Country,YEAR(O.OrderDate)

/*10. Producto superventas de cada a�o, indicando a�o, nombre del producto,
categor�a y cifra total de ventas.*/
SELECT YEAR(O.OrderDate) AS A�o,P.ProductName,C.CategoryName,SUM(OD.Quantity) AS [Unidades Vendidas Top Ventas]
FROM Categories AS C
INNER JOIN Products AS P ON C.CategoryID=P.CategoryID
INNER JOIN [Order Details] AS OD ON P.ProductID=OD.ProductID
INNER JOIN Orders AS O ON OD.OrderID=O.OrderID
INNER JOIN(
SELECT [Unidades Vendidas por a�o y producto].A�o,MAX([Unidades Vendidas por a�o y producto].[Unidades Vendidas]) AS [M�s vendido]
FROM Products AS P
INNER JOIN [Order Details] AS OD ON P.ProductID=OD.ProductID
INNER JOIN Orders AS O ON OD.OrderID=O.OrderID
INNER JOIN(
	SELECT P.ProductID,P.ProductName,C.CategoryID, YEAR(O.OrderDate) AS A�o,SUM(OD.Quantity) AS [Unidades Vendidas]
	FROM Products AS P
	INNER JOIN Categories AS C ON P.CategoryID=C.CategoryID
	INNER JOIN [Order Details] AS OD ON P.ProductID=OD.ProductID
	INNER JOIN Orders AS O ON OD.OrderID=O.OrderID
	--WHERE
	GROUP BY P.ProductID,P.ProductName,C.CategoryID, YEAR(O.OrderDate)
	--HAVING
	--ORDER BY P.ProductID,P.ProductName, YEAR(O.OrderDate)
	) AS [Unidades Vendidas por a�o y producto] ON [Unidades Vendidas por a�o y producto].ProductID=P.ProductID
GROUP BY [Unidades Vendidas por a�o y producto].A�o
) AS UDSDELTOPVENTAS ON UDSDELTOPVENTAS.A�o=YEAR(O.OrderDate)
GROUP BY P.ProductName,C.CategoryName,YEAR(O.OrderDate),UDSDELTOPVENTAS.[M�s vendido]
HAVING SUM(OD.Quantity)=UDSDELTOPVENTAS.[M�s vendido]
ORDER BY A�o

/*11. Cifra de ventas de cada producto en el a�o 97 y su aumento o disminuci�n
respecto al a�o anterior en US $ y en %.*/
SELECT P.ProductID,P.ProductName,SUM(OD.Quantity*(OD.UnitPrice*(1-OD.Discount))) AS [Total Facturado],(SUM(OD.Quantity*(OD.UnitPrice*(1-OD.Discount)))-[Total Facturado96]) AS [Aumento/Disminucion],(((SUM(OD.Quantity*(OD.UnitPrice*(1-OD.Discount)))/[Total Facturado96])-1)*100) AS [Porcentaje crecimiento de ventas]
FROM Products AS P
INNER JOIN [Order Details] AS OD ON P.ProductID=OD.ProductID
INNER JOIN Orders AS O ON OD.OrderID=O.OrderID
INNER JOIN (
	SELECT P.ProductID,P.ProductName,SUM(OD.Quantity*(OD.UnitPrice*(1-OD.Discount))) AS [Total Facturado96]
	FROM Products AS P
	INNER JOIN [Order Details] AS OD ON P.ProductID=OD.ProductID
	INNER JOIN Orders AS O ON OD.OrderID=O.OrderID
	WHERE YEAR(O.OrderDate)=1996
	GROUP BY P.ProductID,P.ProductName
) AS [Ventas 1996] ON P.ProductID=[Ventas 1996].ProductID
WHERE YEAR(O.OrderDate)=1997
GROUP BY P.ProductID,P.ProductName,[Total Facturado96]
ORDER BY P.ProductID

/*12. Mejor cliente (el que m�s nos compra) de cada pa�s.*/
SELECT C.CustomerID,C.CompanyName,C.Country,[Veces que nos ha comprado el mejor cliente]
FROM Customers AS C
INNER JOIN Orders AS O ON C.CustomerID=O.CustomerID
INNER JOIN(
	SELECT [N�mero Ventas a cada cliente].Country,MAX([N�mero Ventas a cada cliente].[Veces que ha comprado])AS [Veces que nos ha comprado el mejor cliente]
	FROM Customers AS C
	INNER JOIN Orders AS O ON C.CustomerID=O.CustomerID
	INNER JOIN (
		SELECT C.CustomerID,C.CompanyName, C.Country,COUNT(O.CustomerID) AS [Veces que ha comprado]
		FROM Customers AS C
		INNER JOIN Orders AS O ON C.CustomerID=O.CustomerID
		--WHERE
		GROUP BY C.CustomerID,C.CompanyName,C.Country
		--ORDER BY
		) AS [N�mero Ventas a cada cliente] ON C.CustomerID=[N�mero Ventas a cada cliente].CustomerID
	--WHERE
	GROUP BY [N�mero Ventas a cada cliente].Country
	--ORDER BY
	) AS VECESMEJORCLIENTE ON C.Country=VECESMEJORCLIENTE.Country
	--WHERE
	GROUP BY C.CustomerID,C.CompanyName,C.Country,[Veces que nos ha comprado el mejor cliente]
	HAVING COUNT(O.CustomerID)=VECESMEJORCLIENTE.[Veces que nos ha comprado el mejor cliente]

/*13. N�mero de productos diferentes que nos compra cada cliente.*/
SELECT C.CustomerID,COUNT(DISTINCT OD.ProductID) AS [N�mero de productos diferentes]
FROM Customers AS C
INNER JOIN Orders AS O ON C.CustomerID=O.CustomerID
INNER JOIN [Order Details] AS OD ON O.OrderID=OD.OrderID
--WHERE
GROUP BY C.CustomerID
ORDER BY C.CustomerID

/*14. Clientes que nos compran m�s de cinco productos diferentes.*/
SELECT C.CustomerID,COUNT(DISTINCT OD.ProductID) AS [N�mero de productos diferentes]
FROM Customers AS C
INNER JOIN Orders AS O ON C.CustomerID=O.CustomerID
INNER JOIN [Order Details] AS OD ON O.OrderID=OD.OrderID
--WHERE
GROUP BY C.CustomerID
HAVING COUNT(DISTINCT OD.ProductID)>5
ORDER BY C.CustomerID

/*15. Vendedores que han vendido una mayor cantidad que la media en US $ en el
a�o 97.*/
SELECT E.EmployeeID,E.FirstName,E.LastName,SUM(OD.Quantity*(OD.UnitPrice*(1-OD.Discount))) AS [Total Facturado Mejores Vendedores]
FROM Employees AS E
INNER JOIN Orders AS O ON E.EmployeeID=O.EmployeeID
INNER JOIN [Order Details] AS OD ON O.OrderID=OD.OrderID
WHERE YEAR(O.OrderDate)=1997
GROUP BY E.EmployeeID,E.FirstName,E.LastName
HAVING (SUM(OD.Quantity*(OD.UnitPrice*(1-OD.Discount)))) > (
	SELECT AVG([Ventas por empleado 97].[Total Facturado]) AS MediaVentas
	FROM
	(
		SELECT E.EmployeeID,SUM(OD.Quantity*(OD.UnitPrice*(1-OD.Discount))) AS [Total Facturado]
		FROM Employees AS E
		INNER JOIN Orders AS O ON E.EmployeeID=O.EmployeeID
		INNER JOIN [Order Details] AS OD ON O.OrderID=OD.OrderID
		WHERE YEAR(O.OrderDate)=1997
		GROUP BY E.EmployeeID
		--HAVING 
		--ORDER BY
	) AS [Ventas por empleado 97]
)
ORDER BY E.EmployeeID
/**/
--WHERE YEAR(O.OrderDate)=1997
--GROUP BY E.EmployeeID,E.FirstName,E.LastName
--HAVING

/*16. Empleados que hayan aumentado su cifra de ventas m�s de un 10% entre dos
a�os consecutivos, indicando el a�o en que se produjo el aumento.*/
SELECT E.EmployeeID,E.FirstName,E.LastName,YEAR(O.OrderDate) AS A�o,SUM([A�o Consecutivo].Facturaci�n) AS [Fas],SUM(OD.Quantity*(OD.UnitPrice*(1-OD.Discount))) AS [Facturaci�n]
FROM Employees AS E
INNER JOIN Orders AS O ON E.EmployeeID=O.EmployeeID
INNER JOIN [Order Details] AS OD ON O.OrderID=OD.OrderID
INNER JOIN (
	SELECT E.EmployeeID,YEAR(O.OrderDate) AS A�o,(OD.Quantity*(OD.UnitPrice*(1-OD.Discount))) AS [Facturaci�n]
	FROM Employees AS E
	INNER JOIN Orders AS O ON E.EmployeeID=O.EmployeeID
	INNER JOIN [Order Details] AS OD ON O.OrderID=OD.OrderID
) AS [A�o Consecutivo] 
ON E.EmployeeID=[A�o Consecutivo].EmployeeID AND YEAR(O.OrderDate)=[A�o Consecutivo].A�o+1
--WHERE
GROUP BY E.EmployeeID,E.FirstName,E.LastName,YEAR(O.OrderDate)
HAVING SUM([A�o Consecutivo].Facturaci�n) >Facturaci�n*1.1
--ORDER BY


SELECT A�o1.EmployeeID,A�o1.FirstName,A�o1.LastName,A�o1.Facturaci�n,A�o2.Facturaci�n,A�o1.A�o FROM 
(SELECT E.EmployeeID,E.FirstName,E.LastName,YEAR(O.OrderDate) AS A�o,SUM(OD.Quantity*(OD.UnitPrice*(1-OD.Discount))) AS [Facturaci�n]
FROM Employees AS E
INNER JOIN Orders AS O ON E.EmployeeID=O.EmployeeID
INNER JOIN [Order Details] AS OD ON O.OrderID=OD.OrderID
GROUP BY E.EmployeeID,E.FirstName,E.LastName,YEAR(O.OrderDate))as A�o1
INNER JOIN
(SELECT E.EmployeeID,YEAR(O.OrderDate) AS A�o,SUM(OD.Quantity*(OD.UnitPrice*(1-OD.Discount))) AS [Facturaci�n]
FROM Employees AS E
INNER JOIN Orders AS O ON E.EmployeeID=O.EmployeeID
INNER JOIN [Order Details] AS OD ON O.OrderID=OD.OrderID
GROUP BY E.EmployeeID,YEAR(O.OrderDate))as A�o2
ON A�o1.EmployeeID=a�o2.EmployeeID AND A�o1.A�o=A�o2.A�o+1
WHERE A�o1.Facturaci�n*1.1<A�o2.Facturaci�n
--HAVING SUM([A�o Consecutivo].Facturaci�n) >Facturaci�n*1.1



/*Extra:*/
/*Clientes que han comprado productos de una categor�a que contiene menos de 10 productos
diferentes*/
go
SELECT DISTINCT CUST.CustomerID--,CUST.CompanyName,CUST.City,P.CategoryID
FROM Customers AS CUST
INNER JOIN Orders AS O ON CUST.CustomerID=O.CustomerID
INNER JOIN [Order Details] AS OD ON O.OrderID=OD.OrderID
INNER JOIN Products AS P ON OD.ProductID=P.ProductID
WHERE P.CategoryID IN (
SELECT C.CategoryID/*,C.CategoryName, COUNT(DISTINCT P.ProductID) AS [N�mero de productos diferentes]*/
FROM Categories AS C
INNER JOIN Products AS P ON C.CategoryID=P.CategoryID
--WHERE
GROUP BY C.CategoryID,C.CategoryName
HAVING COUNT(DISTINCT P.ProductID)<10
--ORDER BY
)
/*Segunda forma de hacerlo, para probar subconsultas en where y from*/
SELECT DISTINCT CUST.CustomerID--,CUST.CompanyName,CUST.City,P.CategoryID
FROM Customers AS CUST
INNER JOIN Orders AS O ON CUST.CustomerID=O.CustomerID
INNER JOIN [Order Details] AS OD ON O.OrderID=OD.OrderID
INNER JOIN Products AS P ON OD.ProductID=P.ProductID
INNER JOIN (
SELECT P.CategoryID/*,C.CategoryName, COUNT(DISTINCT P.ProductID) AS [N�mero de productos diferentes]*/
FROM Products AS P
--WHERE
GROUP BY P.CategoryID--,C.CategoryName
HAVING COUNT(DISTINCT P.ProductID)<10
--ORDER BY
) AS [Categor�as que tienen menos de 10 productos diferentes] ON P.CategoryID=[Categor�as que tienen menos de 10 productos diferentes].CategoryID
--WHERE P.CategoryID IN ([Categor�as que tienen menos de 10 productos diferentes].CategoryID) Opcional