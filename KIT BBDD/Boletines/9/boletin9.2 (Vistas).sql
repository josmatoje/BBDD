USE Northwind

--1. N�mero de clientes de cada pa�s.
SELECT
	COUNT(*) AS N
	,Country
FROM
	Customers
GROUP BY 
	Country

--2. N�mero de clientes diferentes que compran cada producto.
SELECT
	COUNT(C.CustomerID) AS N
	,ProductName
FROM
	Products AS P
	JOIN [Order Details] AS OD
	ON P.ProductID = OD.ProductID
	JOIN Orders AS O
	ON OD.OrderID = O.OrderID
	JOIN Customers AS C
	ON O.CustomerID = C.CustomerID
GROUP BY
	ProductName


--3. N�mero de pa�ses diferentes en los que se vende cada producto.
SELECT
	COUNT(O.ShipCountry) AS Pais
	,ProductName
FROM
	Products AS P
	JOIN [Order Details] AS OD
	ON P.ProductID = OD.ProductID
	JOIN Orders AS O
	ON OD.OrderID = O.OrderID
Group BY 
	ProductName

--4. Empleados que han vendido alguna vez �Gudbrandsdalsost�, �Lakkalik��ri�,
--�Tourti�re� o �Boston Crab Meat�.
SELECT
	E.FirstName
	,E.LastName
FROM
	Employees AS E
	JOIN Orders AS O
		ON E.EmployeeID = O.EmployeeID
	JOIN [Order Details] AS OD
		ON O.OrderID = OD.OrderID
	JOIN Products AS P
		ON OD.ProductID = P.ProductID
WHERE
	ProductName IN ('Gudbrandsdalsost','Lakkalik��ri','Tourti�re','Boston Crab Meat')
GROUP BY
	E.FirstName,E.LastName

--5. Empleados que no han vendido nunca �Chartreuse verte� ni �Ravioli Angelo�.
SELECT
	E.FirstName
	,E.LastName
FROM
	Employees AS E
	JOIN Orders AS O
		ON E.EmployeeID = O.EmployeeID
	JOIN [Order Details] AS OD
		ON O.OrderID = OD.OrderID
	JOIN Products AS P
		ON OD.ProductID = P.ProductID
WHERE
	ProductName NOT IN ('Chartreuse verte','Ravioli Angelo')
GROUP BY
	E.FirstName,E.LastName

--6. N�mero de unidades de cada categor�a de producto que ha vendido cada
--empleado.
SELECT DISTINCT
	E.EmployeeID
	,P.CategoryID
	,COUNT(*)
FROM
	Employees AS E
	JOIN Orders AS O
		ON E.EmployeeID = O.EmployeeID
	JOIN [Order Details] AS OD
		ON O.OrderID = OD.OrderID
	JOIN Products AS P
		ON OD.ProductID = P.ProductID
GROUP BY 
	E.EmployeeID, P.CategoryID
ORDER BY
	E.EmployeeID, P.CategoryID ASC

--7. Total de ventas (US$) de cada categor�a en el a�o 97.
SELECT
	P.CategoryID
	,SUM(OD.UnitPrice*Quantity)
FROM Orders AS O
	JOIN [Order Details] AS OD
		ON O.OrderID = OD.OrderID
	JOIN Products AS P
		ON OD.ProductID = P.ProductID
WHERE
	YEAR(O.OrderDate) = 1997
GROUP BY
	P.CategoryID 
ORDER BY 
	P.CategoryID ASC

--8. Productos que han comprado m�s de un cliente del mismo pa�s, indicando el
--nombre del producto, el pa�s y el n�mero de clientes distintos de ese pa�s que
--lo han comprado.
SELECT
	P.ProductName AS [Nombre producto]
	,C.Country AS [Pais]
	,COUNT (DISTINCT C.CustomerID) AS [N clientes]
FROM
	Products AS P
	JOIN [Order Details] AS OD
		ON P.ProductID = OD.ProductID
	JOIN Orders AS O
		ON OD.OrderID = O.OrderID
	JOIN Customers AS C
		ON O.CustomerID = C.CustomerID
GROUP BY
	P.ProductName,  C.Country
HAVING
	COUNT (DISTINCT C.CustomerID) > 1

	-----------------------------

select P.ProductID,C.Country,count (distinct C.CustomerID) as [Clientes] from Products as P
inner join [Order Details] as OD on P.ProductID=OD.ProductID
inner join Orders as O on OD.OrderID=O.OrderID
inner join Customers as C on O.CustomerID=C.CustomerID
group by P.ProductID,C.Country
having count(distinct C.CustomerID)>1

--9. Total de ventas (US$) en cada pa�s cada a�o.
SELECT
	O.ShipCountry
	,Round(SUM((OD.Quantity*OD.UnitPrice)*(1-OD.Discount)), 2,1564)
	--,SUM((OD.Quantity*OD.UnitPrice)*(1-OD.Discount))
FROM
	Orders AS O
	JOIN [Order Details] AS OD
	ON O.OrderID = OD.OrderID
GROUP BY
	O.ShipCountry

--10. Producto superventas de cada a�o, indicando a�o, nombre del producto,
--categor�a y cifra total de ventas.
SELECT
	--* AS [N Ventas]
	YEAR(O.OrderDate)
FROM
	Orders AS O
	JOIN [Order Details] AS OD
	ON O.OrderID = OD.OrderID
	JOIN Products AS P
	ON OD.ProductID = P.ProductID
	JOIN Categories AS C
	ON P.CategoryID = C.CategoryID

--11. Cifra de ventas de cada producto en el a�o 97 y su aumento o disminuci�n
--respecto al a�o anterior en US $ y en %.
SELECT
	P.ProductName
	,COUNT(OD.ProductID)
	,(
		SELECT
			COUNT(OD.ProductID)
			FROM
				Orders AS O
				JOIN [Order Details] AS OD
					ON O.OrderID = OD.OrderID
				JOIN Products AS P
					ON OD.ProductID = P.ProductID
			WHERE 
				YEAR (O.OrderDate) = 1996
			GROUP BY
				P.ProductName
		) AS [A�o anterior]
FROM
	Orders AS O
	JOIN [Order Details] AS OD
		ON O.OrderID = OD.OrderID
	JOIN Products AS P
		ON OD.ProductID = P.ProductID
WHERE 
	YEAR (O.OrderDate) = 1997
GROUP BY
	P.ProductName

	----------------

select 
		P.ProductID
		,P.ProductName
		, sum(OD.Quantity*(OD.UnitPrice*(1-OD.Discount))) as [Cifra de ventas de cada producto]
		,(SUM(OD.Quantity*(OD.UnitPrice*(1-OD.Discount)))-[Cifra de ventas del 96]) AS [Aumento/Disminucion]
		,(((SUM(OD.Quantity*(OD.UnitPrice*(1-OD.Discount)))/[Cifra de ventas del 96])-1)*100) AS [Porcentaje crecimiento de ventas] 
	from Orders as O
	inner join [Order Details] as OD on O.OrderID=OD.OrderID
	inner join Products as P on OD.ProductID=P.ProductID
	inner join (
			select 
				P.ProductID
				,P.ProductName
				, sum(OD.Quantity*(OD.UnitPrice*(1-OD.Discount))) as [Cifra de ventas del 96] 
			from Orders as O
			inner join [Order Details] as OD on O.OrderID=OD.OrderID
			inner join Products as P on OD.ProductID=P.ProductID
			where year(O.OrderDate)=1996
			group by P.ProductName,P.ProductID
	)AS [Ventas 1996] ON P.ProductID=[Ventas 1996].ProductID
where year(O.OrderDate)=1997
group by P.ProductName,P.ProductID,[Cifra de ventas del 96]
order by P.ProductID


--12. Mejor cliente (el que m�s nos compra) de cada pa�s.
GO
CREATE VIEW [PedidosDeCadaCliente] AS
SELECT
	C.CompanyName
	,C.Country
	,COUNT(OD.OrderID) AS [NPedidos]
FROM
	Customers AS C
	JOIN Orders AS O
		ON C.CustomerID = O.CustomerID
	JOIN [Order Details] AS OD
		ON O.OrderID = OD.OrderID
GROUP BY
	C.CompanyName ,C.Country
GO

CREATE VIEW [MaximoPais] AS
	SELECT 
		Country
		,MAX(NPedidos) AS [NPedidos]
	FROM
		 [PedidosDeCadaCliente]  AS C
	GROUP BY
		C.Country
GO

SELECT 
	PC.CompanyName
	,PC.Country
	,MP.[NPedidos]
FROM
	[MaximoPais] AS MP
	JOIN  [PedidosDeCadaCliente]  AS PC
	ON MP.NPedidos = PC.NPedidos AND MP.Country = PC.Country

--13. N�mero de productos diferentes que nos compra cada cliente.


--14. Clientes que nos compran m�s de cinco productos diferentes.


--15. Vendedores que han vendido una mayor cantidad que la media en US $ en el
--a�o 97.


--16. Empleados que hayan aumentado su cifra de ventas m�s de un 10% entre dos
--a�os consecutivos, indicando el a�o en que se produjo el aumento.

