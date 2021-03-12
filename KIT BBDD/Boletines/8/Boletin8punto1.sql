/*1. Nombre del pa�s y n�mero de clientes de cada pa�s, ordenados alfab�ticamente por el nombre del pa�s.*/
SELECT * FROM Customers

SELECT Country, COUNT(Country) AS [Numero de Clientes] FROM Customers
	GROUP BY Country
	ORDER BY Country

/*2. ID de producto y n�mero de unidades vendidas de cada producto.*/
SELECT * FROM [Order Details]

SELECT ProductID, SUM(Quantity) AS [Cantidad] FROM [Order Details] 
	Group by ProductID
	ORDER BY ProductID

/*3. ID del cliente y n�mero de pedidos que nos ha hecho.*/
SELECT * FROM Orders

SELECT CustomerID, COUNT(CustomerID) AS [Numero de pedidos] FROM Orders
	GROUP BY CustomerID
	ORDER BY CustomerID

/*4. ID del cliente, a�o y n�mero de pedidos que nos ha hecho cada a�o.*/
SELECT * FROM Orders

SELECT CustomerID, YEAR(OrderDate) AS [A�o de pedido], COUNT(CustomerID) AS [Numero de pedidos] FROM Orders
	GROUP BY YEAR(OrderDate), CustomerID
	ORDER BY CustomerID

/*5. ID del producto, precio unitario y total facturado de ese producto, ordenado por cantidad facturada de mayor a menor.  djfgjxdftjdfjdrtfjhsdrtjsertjhsdfghrtfjh
Si hay varios precios unitarios para el mismo producto tomaremos el mayor.*/
SELECT * FROM Products

SELECT ProductID, MAX(UnitPrice), UnitPrice*UnitsOnOrder AS [Total facturado] FROM Products
	ORDER BY [Total facturado] DESC

/*6. ID del proveedor e importe total del stock acumulado de productos correspondientes a ese proveedor.*/
SELECT * FROM Products

SELECT SupplierID, Sum(UnitPrice*UnitsInStock) AS [Importe total del stock] FROM Products
	GROUP BY SupplierID

/*7. N�mero de pedidos registrados mes a mes de cada a�o.*/
SELECT * FROM Orders

SELECT Count(OrderID) AS [Numero de pedidos], Month(OrderDate) AS [Mes], Year(OrderDate) AS [A�o] FROM Orders
	GROUP BY Month(OrderDate), YEAR(OrderDate)
	ORDER BY A�o, Mes

/*8. A�o y tiempo medio transcurrido entre la fecha de cada pedido (OrderDate) y la fecha en la que lo hemos enviado (ShipDate), en d�as para cada a�o.*/
SELECT * FROM Orders

SELECT YEAR(OrderDate) AS [A�o del pedido], AVG(DAY(OrderDate - ShippedDate)) AS [Tiempo medio transcurrido (en d�as)]
	FROM Orders
	GROUP BY YEAR(OrderDate)
	ORDER BY YEAR(OrderDate) ASC

/*9. ID del distribuidor y n�mero de pedidos enviados a trav�s de ese distribuidor.*/
SELECT * FROM Products

SELECT SupplierID, Count(SupplierID) AS [Numero de pedidos al distribuidor] FROM Products
	GROUP BY SupplierID

/*10. ID de cada proveedor y n�mero de productos distintos que nos suministra.*/
SELECT * FROM Products

SELECT SupplierID, Count(CategoryID) AS [Numero de productos distintos] FROM Products
	GROUP BY SupplierID