--BOLETIN 8.1
USE Northwind

--1. Nombre del pa�s y n�mero de clientes de cada pa�s, ordenados alfab�ticamente por el nombre del pa�s.
SELECT Country, COUNT(*) AS NumberCustomer FROM Customers
	--WHERE 
	GROUP BY Country
	ORDER BY Country

--2. ID de producto y n�mero de unidades vendidas de cada producto. 
SELECT ProductID, SUM(Quantity) AS CantidadTotal FROM [Order Details]
	--WHERE
	GROUP BY ProductID
	ORDER BY ProductID

--3. ID del cliente y n�mero de pedidos que nos ha hecho.
SELECT CustomerID, COUNT (CustomerID) AS CantidadPedidos FROM Orders
	--WHERE
	GROUP BY CustomerID
	--ORDER BY

--4. ID del cliente, a�o y n�mero de pedidos que nos ha hecho cada a�o.
SELECT CustomerID, YEAR(OrderDate) AS [Year], COUNT(CustomerID) AS Orders FROM Orders
	--WHERE
	GROUP BY CustomerID, YEAR(OrderDate)
	ORDER BY CustomerID

--5. ID del producto, precio unitario y total facturado de ese producto, ordenado por cantidad facturada de mayor a menor. Si hay varios precios unitarios para el mismo producto tomaremos el mayor.
SELECT ProductID, MAX(UnitPrice) AS PrecioUnitarioMaximo, SUM(Quantity) AS CantidaTotal, (MAX(UnitPrice)*SUM(Quantity)) AS TotalFacturado FROM [Order Details]
	--WHERE
	GROUP BY ProductID
	ORDER BY (MAX(UnitPrice)*SUM(Quantity)) DESC

--6. ID del proveedor e importe total del stock acumulado de productos correspondientes a ese proveedor.
SELECT SupplierID, (SUM(UnitsInStock)*AVG(UnitPrice)) AS ImporteTotal FROM Products
	--WHERE
	GROUP BY SupplierID
	--ORDER BY

--7. N�mero de pedidos registrados mes a mes de cada a�o.
SELECT YEAR(OrderDate) AS YEAR, MONTH(Orderdate) AS MONTH, COUNT(OrderID) AS ORDERS FROM Orders
	--WHERE
	GROUP BY YEAR(OrderDate), MONTH(OrderDate) 
	ORDER BY YEAR(OrderDate), MONTH(OrderDate) 

--8. A�o y tiempo medio transcurrido entre la fecha de cada pedido (OrderDate) y la fecha en la que lo hemos enviado (ShipDate), en d�as para cada a�o.
SELECT YEAR(OrderDate) AS A�o, AVG(DAY(ShippedDate) - DAY(OrderDate)) AS TiempoMedioDias FROM Orders
	--WHERE
	GROUP BY YEAR(OrderDate)
	--ORDER BY
	--ESTE FALTA DATEDIFF

--9. ID del distribuidor y n�mero de pedidos enviados a trav�s de ese distribuidor.
SELECT ShipVia, COUNT(OrderID) as NumeroPedidos FROM Orders
	--WHERE 
	GROUP BY ShipVia
	--ORDER BY

--10. ID de cada proveedor y n�mero de productos distintos que nos suministra.
SELECT SupplierID, COUNT(ProductID) as NumeroDeProductosDistintos FROM Products
	--WHERE 
	GROUP BY SupplierID
	--ORDER BY 
