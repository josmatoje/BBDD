use Northwind
select * from orders
--1. Nombre del país y número de clientes de cada país, ordenados alfabéticamente por el nombre del país.
select country as pais,count(CustomerID)as numers from Customers group by country

--2. ID de producto y número de unidades vendidas de cada producto. 
select country as pais,count(CustomerID)as numers from Customers group by country

--3. ID del cliente y número de pedidos que nos ha hecho.
select CustomerID as ID, count(customerID) as numero from orders group by CustomerID

--4. ID del cliente, año y número de pedidos que nos ha hecho cada año.
select 
	CustomerID, 
	year(OrderDate) as año , 
	count(orderDate) as numeroPedi 
from orders 
group by  year(OrderDate), CustomerID

--5. ID del producto, precio unitario y total facturado de ese producto, ordenado por 
--cantidad facturada de mayor a menor. Si hay varios precios unitarios para el mismo producto tomaremos el mayor.

--6. ID del proveedor e importe total del stock acumulado de productos correspondientes a ese proveedor.
select * from Suppliers


--7. Número de pedidos registrados mes a mes de cada año.

--8. Año y tiempo medio transcurrido entre la fecha de cada pedido (OrderDate) y la fecha en la que lo 
--hemos enviado (ShipDate), en días para cada año.

--9. ID del distribuidor y número de pedidos enviados a través de ese distribuidor.

--10. ID de cada proveedor y número de productos distintos que nos suministra.
