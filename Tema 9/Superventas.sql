-- Consultas superventas
-- Producto más vendido de cada país
-- Boletín 9.1, ejercicio 10
-- Esta es un ejemplo típico de uso de las subconsultas
USE Northwind
GO
-- Primero vamos a ver las unidades de cada producto vendidas en cada país

SELECT OD.ProductID, O.ShipCountry, SUM(OD.Quantity) AS TotalUnidades
		FROM [Order Details] AS OD
			INNER JOIN Orders AS O
			ON O.OrderID = OD.OrderID
		GROUP BY OD.ProductID, O.ShipCountry

-- Sobre esta consulta, calculamos el máximo de cada país
SELECT ShipCountry, MAX(TotalUnidades) AS MayorVenta FROM 
	(SELECT OD.ProductID, O.ShipCountry, sum(OD.Quantity) AS TotalUnidades
		FROM [Order Details] as OD
			INNER JOIN Orders as O
			on O.OrderID = OD.OrderID
		group by OD.ProductID, O.ShipCountry) AS ProductoPorPais
	group by ShipCountry
--Ahora tenemos la cifra mayor de cada país, pero no sabemos a qué producto corresponden
-- Para conseguirla, hacemos join con la primera consulta, haciendo coincidir el pais y la cantidad

SELECT MayorCantidad.ShipCountry, PPP.ProductID, P.ProductName, PPP.TotalUnidades FROM
	(SELECT ShipCountry, MAX(TotalUnidades) AS MayorVenta FROM 
		(SELECT OD.ProductID, O.ShipCountry, sum(OD.Quantity) AS TotalUnidades
			FROM [Order Details] as OD
				INNER JOIN Orders as O
				on O.OrderID = OD.OrderID
			group by OD.ProductID, O.ShipCountry) AS ProductoPorPais
		group by ShipCountry) AS MayorCantidad
	INNER JOIN
	(SELECT OD.ProductID, O.ShipCountry, sum(OD.Quantity) AS TotalUnidades
		FROM [Order Details] as OD
			INNER JOIN Orders as O
			on O.OrderID = OD.OrderID
		group by OD.ProductID, O.ShipCountry) AS PPP
		ON MayorCantidad.ShipCountry = PPP.ShipCountry AND MayorCantidad.MayorVenta = PPP.TotalUnidades
	-- Y hacemos JOIN también con Productos para obtener el nombre
		INNER JOIN Products AS P
		ON PPP.ProductID = P.ProductID
-- Tachaaaaann!!!



-- También se puede usar una sintaxis alternativa en la que damos nombre a las subconsultas
With VentasProductoPorPais (Producto, NumeroProductos,Pais) AS 
	(select OD.ProductID, sum(od.Quantity),o.ShipCountry
		from [Order Details] as OD
			inner join Orders as O
			on O.OrderID = OD.OrderID
		group by OD.ProductID,O.ShipCountry)
,
VentasPorPais (NumeroProductos,Pais) AS (
	Select max(VePa.NumeroProductos),ShipCountry from 
		(Select OD.ProductID, sum(od.Quantity) as [NumeroProductos],o.ShipCountry
			from [Order Details] as OD
				inner join Orders as O
				on O.OrderID = OD.OrderID
			group by OD.ProductID,O.ShipCountry) AS VePa
		Group By ShipCountry)
-- And finally
SELECT ProductName, VPP.Pais,VPPP.NumeroProductos
	FROM VentasProductoPorPais AS VPPP INNER JOIN VentasPorPais AS VPP
	ON VPPP.NumeroProductos = VPP.NumeroProductos
		AND VPPP.Pais = VPP.Pais
	INNER JOIN Products AS P
		ON VPPP.Producto = P.ProductID
GO
-- ALTERNATIVA CON VISTAS
--

CREATE View VentasProductoPorPais AS
SELECT OD.ProductID, O.ShipCountry AS Pais, SUM(OD.Quantity) AS TotalUnidades
		FROM [Order Details] AS OD
			INNER JOIN Orders AS O
			ON O.OrderID = OD.OrderID
		GROUP BY OD.ProductID, O.ShipCountry
GO 
CREATE View VentasPorPais AS
SELECT Pais, MAX(TotalUnidades) AS NumeroProductos FROM 
	VentasProductoPorPais
	group by Pais
GO
SELECT ProductName, VPP.Pais,VPPP.TotalUnidades
	FROM VentasProductoPorPais AS VPPP INNER JOIN VentasPorPais AS VPP
	ON VPPP.TotalUnidades = VPP.NumeroProductos
		AND VPPP.Pais = VPP.Pais
	INNER JOIN Products AS P
		ON VPPP.ProductID = P.ProductID