USE AdventureWorks2012

				/**Consultas sencillas**/

/*1.Nombre del producto, c�digo y precio, ordenado de mayor a menor precio*/
SELECT * FROM Production.Product

SELECT Name,ProductNumber, ListPrice FROM Production.Product
	ORDER BY ListPrice DESC

/*2.N�mero de direcciones de cada Estado/Provincia*/
SELECT * FROM Person.Address

SELECT COUNT(AddressID) AS [N�mero de direcciones], StateProvinceID FROM Person.Address
	GROUP BY StateProvinceID

/*3.Nombre del producto, c�digo, n�mero, tama�o y peso de los productos que estaban a la venta durante todo el mes de septiembre de 2002.
No queremos que aparezcan aquellos cuyo peso sea superior a 2000.*/
SELECT * FROM Production.Product

SET DATEFORMAT ymd

SELECT Name, ProductID, ProductNumber, Size, [Weight] FROM Production.Product
	WHERE SellStartDate BETWEEN '2002-09-01' AND '2002-09-30'

/*4.Margen de beneficio de cada producto (Precio de venta menos el coste), y porcentaje que supone respecto del precio de venta.*/
SELECT * FROM Production.Product

SELECT (ListPrice - StandardCost) AS [Margen de beneficio] FROM Production.Product


				/**Consultas de dificultad media**/

/*5.N�mero de productos de cada categor�a*/
SELECT * FROM Production.ProductSubcategory

SELECT ProductCategoryID, COUNT(Name) AS [N�mero de productos]  FROM Production.ProductSubcategory
	GROUP BY ProductCategoryID

/*6.Igual a la anterior, pero considerando las categor�as generales (categor�as de categor�as).*/

/* Ni idea :) */

/*7.N�mero de unidades vendidas de cada producto cada a�o.*/
SELECT * FROM Sales.SalesOrderDetail


/*8.Nombre completo, compa��a y total facturado a cada cliente*/
SELECT * FROM Sales.Customer
SELECT * FROM Person.Person

/*9.N�mero de producto, nombre y precio de todos aquellos en cuya descripci�n aparezcan las palabras "race�, "competition� o "performance�*/
SELECT * FROM Production.Product

/*SELECT ProductNumber, Name, ListPrice FROM Production.Product
	WHERE */


				/**Consultas avanzadas**/

/*10.Facturaci�n total en cada pa�s*/
SELECT * FROM Sales.SalesTerritory

SELECT CountryRegionCode, SUM(SalesYTD) AS [Facturaci�n total] FROM Sales.SalesTerritory
	GROUP BY CountryRegionCode

/*11.Facturaci�n total en cada Estado*/
SELECT * FROM Sales.SalesTerritory

SELECT * FROM Person.StateProvince

/*12.Margen medio de beneficios y total facturado en cada pa�s*/
SELECT * FROM Sales.SalesTerritory

SELECT CountryRegionCode FROM Sales.SalesTerritory