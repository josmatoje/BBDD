--Lenguaje SQL. Consultas
--Escribe el c�digo SQL necesario para realizar las siguientes operaciones sobre la base de datos
--�NorthWind�
--De la 1 a la 7 se pueden hacer sin usar funciones de agregados.

USE Northwind

-- 1. Nombre de la compa��a y direcci�n completa (direcci�n, cuidad, pa�s) de todos los clientes que no sean de los Estados Unidos.
SELECT CompanyName, Address, City, Country FROM Customers 
WHERE Country != 'USA'

--2. La consulta anterior ordenada por pa�s y ciudad.
SELECT CompanyName, Address, City, Country FROM Customers 
WHERE Country != 'USA' ORDER BY Country, City

--3. Nombre, Apellidos, Ciudad y Edad de todos los empleados, ordenados por antig�edad en la empresa.
SELECT LastName, FirstName, City, Year(CURRENT_TIMESTAMP-BirthDate)-1900 AS Age FROM Employees
ORDER BY HireDate

--4. Nombre y precio de cada producto, ordenado de mayor a menor precio.
SELECT ProductName, UnitPrice FROM Products
ORDER BY UnitPrice DESC

--5. Nombre de la compa��a y direcci�n completa de cada proveedor de alg�n pa�s de Am�rica del Norte.
SELECT CompanyName, Address, City, Region, Country FROM Suppliers 
WHERE Country IN ('Canada', 'USA')

--6. Nombre del producto, n�mero de unidades en stock y valor total del stock, de los productos que no sean de la categor�a 4.
SELECT ProductName, UnitsInStock, UnitPrice * UnitsInStock AS ValorTotalStock FROM Products
WHERE CategoryID != '4'

--7. Clientes (Nombre de la Compa��a, direcci�n completa, persona de contacto) que no residan en un pa�s de Am�rica del Norte y que la persona de contacto no sea el propietario de la compa��a
SELECT CompanyName, Address, City, Region, Country, ContactName FROM Customers
WHERE (Country NOT IN ('Canada', 'USA')) AND (ContactTitle NOT LIKE 'Owner%')

--8. ID del cliente y n�mero de pedidos realizados por cada cliente, ordenado de mayor a
--menor n�mero de pedidos.
SELECT CustomerID, COUNT(OrderID) AS NumeroPedidos FROM Orders
GROUP BY CustomerID 
ORDER BY NumeroPedidos DESC

--9. N�mero de pedidos enviados a cada ciudad, incluyendo el nombre de la ciudad.
SELECT ShipCity, COUNT(OrderID) AS NumeroPedidos FROM Orders
GROUP BY ShipCity 
ORDER BY NumeroPedidos DESC

--10. N�mero de productos de cada categor�a.
SELECT CategoryID, COUNT(ProductID) AS NumeroProductos FROM Products
GROUP BY CategoryID
ORDER BY CategoryID

