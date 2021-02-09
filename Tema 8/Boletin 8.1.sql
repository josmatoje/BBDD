USE Northwind
--1. Nombre del país y número de clientes de cada país, ordenados alfabéticamente por el nombre del país.

SELECT Country, COUNT(*) AS [Numero de clientes] FROM Customers
GROUP BY Country
ORDER BY Country

--2. ID de producto y número de unidades vendidas de cada producto.
select * from [Order Details]
SELECT ProductID, SUM(Quantity) AS [Unidades vendidas]  FROM [Order Details]
GROUP BY ProductID

--3. ID del cliente y número de pedidos que nos ha hecho.

SELECT CustomerID, COUNT(*) [Numero de pedidos] FROM Orders
GROUP BY CustomerID

--4. ID del cliente, año y número de pedidos que nos ha hecho cada año.

SELECT CustomerID, YEAR(OrderDate), COUNT(*) [Numero de pedidos] FROM Orders
GROUP BY CustomerID, YEAR(OrderDate)

--5. ID del producto, precio unitario y total facturado de ese producto, ordenado por cantidad facturada de mayor a menor. Si hay varios 
--precios unitarios para el mismo producto tomaremos el mayor.

SELECT ProductID, SUM(Quantity*UnitPrice*(1-Discount)) AS [Total facturado] FROM [Order Details]
GROUP BY ProductID
SELECT * FROM [Order Details]

--6. ID del proveedor e importe total del stock acumulado de productos correspondientes a ese proveedor.
SELECT * FROM Products
--7. Número de pedidos registrados mes a mes de cada año.

--8. Año y tiempo medio transcurrido entre la fecha de cada pedido (OrderDate) y la fecha en la que lo hemos enviado (ShipDate), en días 
--para cada año.

SELECT YEAR(OrderDate) AS Año, AVG(DATEDIFF(DAY, OrderDate, ShippedDate)) AS [Dias de media] FROM Orders
GROUP BY YEAR(OrderDate)

--9. ID del distribuidor y número de pedidos enviados a través de ese distribuidor.

--10. ID de cada proveedor y número de productos distintos que nos suministra.
SELECT SupplierID, COUNT(DISTINCT ProductID) AS [Nº productos] FROM Products
GROUP BY SupplierID

