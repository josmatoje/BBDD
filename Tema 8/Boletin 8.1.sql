USE Northwind
--1. Nombre del pa�s y n�mero de clientes de cada pa�s, ordenados alfab�ticamente por el nombre del pa�s.

SELECT Country, COUNT(*) AS [Numero de clientes] FROM Customers
GROUP BY Country
ORDER BY Country

--2. ID de producto y n�mero de unidades vendidas de cada producto.
select * from [Order Details]
SELECT ProductID, SUM(Quantity) AS [Unidades vendidas]  FROM [Order Details]
GROUP BY ProductID

--3. ID del cliente y n�mero de pedidos que nos ha hecho.

SELECT CustomerID, COUNT(*) [Numero de pedidos] FROM Orders
GROUP BY CustomerID

--4. ID del cliente, a�o y n�mero de pedidos que nos ha hecho cada a�o.

SELECT CustomerID, YEAR(OrderDate), COUNT(*) [Numero de pedidos] FROM Orders
GROUP BY CustomerID, YEAR(OrderDate)

--5. ID del producto, precio unitario y total facturado de ese producto, ordenado por cantidad facturada de mayor a menor. Si hay varios 
--precios unitarios para el mismo producto tomaremos el mayor.

SELECT ProductID, SUM(Quantity*UnitPrice*(1-Discount)) AS [Total facturado] FROM [Order Details]
GROUP BY ProductID
ORDER BY [Cantidad facturada]
SELECT * FROM [Order Details]

--6. ID del proveedor e importe total del stock acumulado de productos correspondientes a ese proveedor.

SELECT SupplierID, SUM(UnitPrice*UnitsInStock) AS [Importe Total] FROM Products 
GROUP BY SupplierID

--7. N�mero de pedidos registrados mes a mes de cada a�o.

SELECT YEAR(OrderDate) AS A�o, COUNT(OrderDate) AS [Numero de pedidos] FROM Orders
GROUP BY YEAR(OrderDate)

--8. A�o y tiempo medio transcurrido entre la fecha de cada pedido (OrderDate) y la fecha en la que lo hemos enviado (ShipDate), en d�as 
--para cada a�o.

SELECT YEAR(OrderDate) AS A�o, AVG(DATEDIFF(DAY, OrderDate, ShippedDate)) AS [Dias de media] FROM Orders
GROUP BY YEAR(OrderDate)

--9. ID del distribuidor y n�mero de pedidos enviados a trav�s de ese distribuidor.

SELECT ShipVia, COUNT(*) AS [Numero de pedidos] FROM Orders
GROUP BY ShipVia

--10. ID de cada proveedor y n�mero de productos distintos que nos suministra.
SELECT SupplierID, COUNT(DISTINCT ProductID) AS [N� productos] FROM Products
GROUP BY SupplierID

