USE Northwind
--2. ID de producto y n�mero de unidades vendidas de cada producto.  A�ade el nombre del producto
select * from [Order Details]
SELECT ProductID, SUM(Quantity) AS [Unidades vendidas]  FROM [Order Details]
GROUP BY ProductID

--3. ID del cliente y n�mero de pedidos que nos ha hecho. A�ade nombre (CompanyName) y ciudad del cliente

--4. ID del cliente, a�o y n�mero de pedidos que nos ha hecho cada a�o. A�ade nombre (CompanyName) y ciudad del cliente, as� como la fecha del primer pedido que nos hizo.

--5. ID del producto, precio unitario y total facturado de ese producto, ordenado por cantidad facturada de mayor a menor. Si hay varios precios unitarios para el mismo producto tomaremos el mayor. A�ade el nombre del producto

--6. ID del proveedor e importe total del stock acumulado de productos correspondientes a ese proveedor. A�ade el nombre del proveedor



--9. ID del distribuidor y n�mero de pedidos enviados a trav�s de ese distribuidor. A�ade el nombre del distribuidor

--10. ID de cada proveedor y n�mero de productos distintos que nos suministra. A�ade el nombre del proveedor.