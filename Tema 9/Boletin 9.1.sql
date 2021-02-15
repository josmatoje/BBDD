USE Northwind
--1. Nombre de los proveedores y número de productos que nos vende cada uno

--2. Nombre completo y telefono de los vendedores que trabajen en New York, Seattle, Vermont, Columbia, Los Angeles, Redmond o Atlanta.

--3. Número de productos de cada categoría y nombre de la categoría.

SELECT COUNT (*) AS [Numero de productos], C.CategoryName FROM Products AS P
INNER JOIN Categories AS C
ON P.CategoryID=C.CategoryID
GROUP BY C.CategoryID, C.CategoryName

--4. Nombre de la compañía de todos los clientes que hayan comprado queso de cabrales o tofu.

SELECT DISTINCT S.CompanyName, p.ProductName FROM Products AS P
INNER JOIN [Order Details] AS OD
ON P.ProductID=OD.ProductID
INNER JOIN Orders AS O
ON OD.OrderID=O.OrderID
INNER JOIN Shippers AS S
ON O.ShipVia=S.ShipperID
WHERE P.ProductName LIKE 'queso cabrales' OR
		P.ProductName LIKE 'tofu'

--5. Empleados (ID, nombre, apellidos y teléfono) que han vendido algo a Bon app' o Meter Franken.

--6. Empleados (ID, nombre, apellidos, mes y día de su cumpleaños) que no han vendido nunca nada a ningún cliente de Francia. (Se necesitan subconsultas)

--7. Total de ventas en US$ de productos de cada categoría (nombre de la categoría).

--8. Total de ventas en US$ de cada empleado cada año (nombre, apellidos, dirección).

--9. Ventas de cada producto en el año 97. Nombre del producto y unidades.

--10. Cuál es el producto del que hemos vendido más unidades en cada país. (Se necesitan subconsultas)

--11. Empleados (nombre y apellidos) que trabajan a las órdenes de Andrew Fuller.

--12. Número de subordinados que tiene cada empleado, incluyendo los que no tienen ninguno. Nombre, apellidos, ID.

