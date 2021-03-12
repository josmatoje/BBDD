--Boletin 8.1
--Escribe el c�digo SQL necesario para realizar las siguientes operaciones sobre la base de datos "NorthWind�
--Consultas sobre una sola Tabla
USE Northwind

--1. Nombre del pa�s y n�mero de clientes de cada pa�s, ordenados alfab�ticamente por el nombre del pa�s.
SELECT Country, COUNT(CustomerID) AS [Numero de clientes]
FROM Customers
GROUP BY Country
ORDER BY Country

--2. ID de producto y n�mero de unidades vendidas de cada producto. 
SELECT ProductID, SUM (Quantity) AS [Numero de unidades vendidas]
FROM [Order Details] 
GROUP BY ProductID

--3. ID del cliente y n�mero de pedidos que nos ha hecho.
SELECT CustomerID, COUNT (OrderID) AS [Numero de pedidos]
FROM Orders 
GROUP BY CustomerID

--4. ID del cliente, a�o y n�mero de pedidos que nos ha hecho cada a�o.
SELECT CustomerID, YEAR(OrderDate), COUNT (OrderID) AS [Numero de pedidos]
FROM Orders 
GROUP BY CustomerID, YEAR(OrderDate)

--5. ID del producto, precio unitario y total facturado de ese producto, ordenado por cantidad facturada de mayor a menor.
--   Si hay varios precios unitarios para el mismo producto tomaremos el mayor.
SELECT ProductID, UnitPrice, SUM(UnitPrice * Quantity) AS [Total Facturado], SUM((UnitPrice * Quantity) * (1 - Discount) ) AS [Total facturado con descuento]
FROM [Order Details]
GROUP BY ProductID, UnitPrice
ORDER BY [Total facturado] DESC

--6. ID del proveedor e importe total del stock acumulado de productos correspondientes a ese proveedor.
SELECT SupplierID, SUM(CAST (UnitPrice * UnitsInStock AS smallmoney)) AS  [importe total del stock acumulado] 
FROM Products
GROUP BY SupplierID

--7. N�mero de pedidos registrados mes a mes de cada a�o.
SELECT COUNT (OrderID) AS [Numero de Pedidos], MONTH(OrderDate) AS MES, YEAR(OrderDate) AS A�O
FROM Orders
GROUP BY MONTH(OrderDate), YEAR(OrderDate) 
ORDER BY MONTH(OrderDate)

--8. A�o y tiempo medio transcurrido entre la fecha de cada pedido (OrderDate) y la fecha en la que lo hemos enviado (ShipDate),
--   en d�as para cada a�o.

--9. ID del distribuidor y n�mero de pedidos enviados a trav�s de ese distribuidor.
SELECT CustomerID, COUNT(OrderID) AS [numero de pedidos enviados]
FROM Orders
GROUP BY CustomerID

--10. ID de cada proveedor y n�mero de productos distintos que nos suministra.
SELECT DISTINCT SupplierID, COUNT(ProductID) AS [numero de productos distintos]
FROM Products
GROUP BY SupplierID