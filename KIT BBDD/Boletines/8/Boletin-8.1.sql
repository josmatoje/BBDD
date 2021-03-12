USE Northwind
GO

--1. Nombre del pa�s y n�mero de clientes de cada pa�s, ordenados alfab�ticamente por el nombre del pa�s.
SELECT * FROM Customers

SELECT Country, COUNT (Country) AS ClientPerCountry
FROM Customers
GROUP BY Country
ORDER BY Country

--SELECT Country, COUNT(CustomerID) AS NumberCustomers 
--FROM Customers 
--GROUP BY Country
--ORDER BY Country ASC

--2. ID de producto y n�mero de unidades vendidas de cada producto. 
SELECT * FROM [Order Details] ORDER BY ProductID

SELECT ProductID, SUM (Quantity) AS SoldUnit
FROM [Order Details]
GROUP BY ProductID
ORDER BY ProductID

--3. ID del cliente y n�mero de pedidos que nos ha hecho.
SELECT * FROM Orders

SELECT CustomerID, COUNT (OrderID) AS OrdersNumber
FROM Orders
GROUP BY CustomerID

--4. ID del cliente, a�o y n�mero de pedidos que nos ha hecho cada a�o.
SELECT * FROM Orders

SELECT DISTINCT CustomerID, COUNT(YEAR(OrderDate)) AS OrdersNumber, YEAR(OrderDate) AS Year
FROM Orders
GROUP BY CustomerID, OrderDate
ORDER BY CustomerID, YEAR(OrderDate)

--5. ID del producto, precio unitario y total facturado de ese producto, ordenado por cantidad facturada de mayor a menor. 
--Si hay varios precios unitarios para el mismo producto tomaremos el mayor.
SELECT * FROM [Order Details]

SELECT ProductID, MAX(UnitPrice) AS MAXUnitPrice, SUM(UnitPrice*Quantity*(1-Discount)) AS Total
FROM [Order Details]
GROUP BY ProductID
ORDER BY Total DESC

--6. ID del proveedor e importe total del stock acumulado de productos correspondientes a ese proveedor.
SELECT * FROM Products

SELECT SupplierID, SUM (UnitsInStock*UnitPrice) AS Total
FROM Products
GROUP BY SupplierID

--7. N�mero de pedidos registrados mes a mes de cada a�o.
SELECT * FROM Orders

SELECT COUNT(*) AS Number, MONTH(OrderDate) AS Month, YEAR(OrderDate) AS Year
FROM Orders
GROUP BY MONTH(OrderDate),YEAR(OrderDate)
ORDER BY Year, Month

--8. A�o y tiempo medio transcurrido entre la fecha de cada pedido (OrderDate) y la fecha en la que lo hemos enviado 
--(ShipDate), en d�as para cada a�o.
SELECT * FROM Orders

SELECT YEAR(OrderDate) AS OrderYear,AVG(DATEDIFF(DAY,OrderDate,ShippedDate)) AS Days
FROM Orders
GROUP BY OrderDate

--9. ID del distribuidor y n�mero de pedidos enviados a trav�s de ese distribuidor.
SELECT * FROM Orders

SELECT ShipVia, COUNT(OrderID) AS NumberShipped
FROM Orders
GROUP BY ShipVia

--10. ID de cada proveedor y n�mero de productos distintos que nos suministra.
SELECT * FROM Products

SELECT SupplierID, COUNT(ProductID) AS DifferentProducts
FROM Products
GROUP BY SupplierID