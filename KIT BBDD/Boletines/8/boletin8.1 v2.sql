--1. Nombre del pa�s y n�mero de clientes de cada pa�s, ordenados alfab�ticamente por el nombre del pa�s.
SELECT Country, COUNT(CustomerID) AS [Numero_Clientes] FROM Customers
	GROUP BY country ORDER BY Country ASC --COUNT cuenta el numero de filas.

--2. ID de producto y n�mero de unidades vendidas de cada producto. 
SELECT productID, SUM(UnitsOnOrder) AS [Unidades_vendidas] FROM Products
	GROUP BY productID ORDER BY Unidades_vendidas DESC --SUM calcula la suma de todos los valores no nulos

--3. ID del cliente y n�mero de pedidos que nos ha hecho.
SELECT CustomerID, COUNT(CustomerID) AS [Numero_Pedidos] FROM Orders
	GROUP BY CustomerID ORDER BY Numero_Pedidos ASC

--4. ID del cliente, a�o y n�mero de pedidos que nos ha hecho cada a�o.
SELECT CustomerID, OrderDate, COUNT(CustomerID) as [Num_Pedidos]
	FROM Orders
		GROUP BY CustomerID, OrderDate ORDER BY Num_Pedidos DESC

--5. ID del producto, precio unitario y total facturado de ese producto, ordenado por cantidad facturada de mayor a menor. Si hay varios precios unitarios para el mismo producto tomaremos el mayor.
SELECT productID, UnitPrice, (Unitprice * UnitsOnOrder) AS [Total Facturado] FROM Products
	ORDER BY [Total Facturado] DESC

--6. ID del proveedor e importe total del stock acumulado de productos correspondientes a ese proveedor.
SELECT S.SupplierID, P.UnitsInStock FROM Suppliers AS[S]
	INNER JOIN Products AS [P] ON S.SupplierID = P.SupplierID

--7. N�mero de pedidos registrados mes a mes de cada a�o.
SELECT YEAR(OrderDate) AS [A�o], MONTH(OrderDate) AS [MES], COUNT (MONTH(OrderDate)) AS[Numero] FROM Orders
	GROUP BY YEAR(OrderDate), MONTH(OrderDate)
		ORDER BY A�o ASC

--8. A�o y tiempo medio transcurrido entre la fecha de cada pedido (OrderDate) y la fecha en la que lo hemos enviado (ShipDate), en d�as para cada a�o.
SELECT YEAR(OrderDate) AS [A�o], AVG(DAY(ShippedDate - OrderDate)) AS [Media] FROM Orders
	GROUP BY YEAR(OrderDate)

--9. ID del distribuidor y n�mero de pedidos enviados a trav�s de ese distribuidor.
SELECT S.SupplierID, COUNT(O.OrderID) AS[Number_Order] FROM Suppliers AS [S]
	INNER JOIN Products AS [P] ON S.SupplierID = P.SupplierID
		INNER JOIN [Order details] AS [OD] ON P.ProductID = OD.ProductID
			INNER JOIN Orders AS[O] ON OD.OrderID  = O.OrderID
				GROUP BY S.SupplierID ORDER BY S.SupplierID ASC

--10. ID de cada proveedor y n�mero de productos distintos que nos suministra.
SELECT SupplierID, COUNT(SupplierID) AS [Productos] FROM Products
	GROUP BY SupplierID
