USE AdventureWorks2012

--Consultas sencillas
--1.Nombre del producto, c�digo y precio, ordenado de mayor a menor precio
SELECT Name, ProductID, ListPrice FROM Production.Product
	--WHERE
	--GROUP BY
	--HAVING
	ORDER BY ListPrice DESC

--2.N�mero de direcciones de cada Estado/Provincia
SELECT A.StateProvinceID, S.Name, COUNT (A.AddressID) AS CountAddress 
FROM Person.Address AS A
	JOIN Person.StateProvince AS S
	ON A.StateProvinceID = S.StateProvinceID
	--WHERE
	GROUP BY A.StateProvinceID, S.Name
	--HAVING
	--ORDER BY

--3.Nombre del producto, c�digo, n�mero, tama�o y peso de los productos que estaban a la venta durante todo el mes de septiembre de 2002. No queremos que aparezcan aquellos cuyo peso sea superior a 2000.
SELECT Name, ProductID, ProductNumber, Size, Weight FROM  Production.Product
	WHERE Weight<2000 AND SellStartDate<DATEFROMPARTS(2002, 9, 1) AND (SellEndDate>DATEFROMPARTS(2002,10,1) OR SellEndDate is NULL)
	--GROUP BY
	--HAVING
	--ORDER BY

--4.Margen de beneficio de cada producto (Precio de venta menos el coste), y porcentaje que supone respecto del precio de venta.
SELECT Name, (ListPrice-StandardCost) AS Margen, ((StandardCost/ListPrice)*100) AS [%] FROM Production.Product 
	WHERE ListPrice!=0
	--GROUP BY
	--HAVING
	--ORDER BY

--Consultas de dificultad media
--5.N�mero de productos de cada categor�a
SELECT ProductSubcategoryID, COUNT(ProductID) AS N�Products FROM Production.Product 
	WHERE ProductSubcategoryID is not NULL
	GROUP BY ProductSubcategoryID
	--HAVING
	--ORDER BY

--6.Igual a la anterior, pero considerando las categor�as generales (categor�as de categor�as).
--SELECT FROM 
	--WHERE
	--GROUP BY
	--HAVING
	--ORDER BY

--7.N�mero de unidades vendidas de cada producto cada a�o.
SELECT YEAR(EndDate) AS A�oVenta, ProductID, COUNT(ProductID) AS Numero FROM Production.ProductListPriceHistory
	WHERE EndDate is not null
	GROUP BY YEAR(EndDate), ProductID
	--HAVING
	--ORDER BY

--8.Nombre completo, compa��a y total facturado a cada cliente
SELECT * FROM Person.Person
SELECT * FROM Sales.Customer
SELECT * FROM Sales.SalesOrderDetail
 

SELECT FROM  
	WHERE
	GROUP BY
	HAVING
	ORDER BY

--9.N�mero de producto, nombre y precio de todos aquellos en cuya descripci�n aparezcan las palabras "race�, "competition� o "performance�


SELECT * FROM Production.Product
SELECT  FROM 
	WHERE
	GROUP BY
	HAVING
	ORDER BY

--Consultas avanzadas
--10.Facturaci�n total en cada pa�s
SELECT FROM 
	WHERE
	GROUP BY
	HAVING
	ORDER BY

--11.Facturaci�n total en cada Estado
SELECT FROM 
	WHERE
	GROUP BY
	HAVING
	ORDER BY

--12.Margen medio de beneficios y total facturado en cada pa�s
SELECT FROM 
	WHERE
	GROUP BY
	HAVING
	ORDER BY
