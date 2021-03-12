/*1. Nombre de la compa��a y direcci�n completa (direcci�n, cuidad, pa�s) de todos los clientes que no sean de los Estados Unidos.*/
SELECT CompanyName,Address,City,Country FROM Customers
	WHERE Country <> 'USA'

/*2. La consulta anterior ordenada por pa�s y ciudad.*/
SELECT CompanyName,Address,Country,City FROM Customers
	WHERE Country <> 'USA'
	ORDER BY Country,City

/*3. Nombre, Apellidos, Ciudad y Edad de todos los empleados, ordenados por antig�edad en la empresa.*/
--SELECT FirstName,LastName,City,(CURRENT_TIMESTAMP) AS Age FROM Employees

/*4. Nombre y precio de cada producto, ordenado de mayor a menor precio.*/
SELECT ProductName,UnitPrice FROM Products
	ORDER BY UnitPrice DESC

/*5. Nombre de la compa��a y direcci�n completa de cada proveedor de alg�n pa�s de Am�rica del Norte.*/
SELECT CompanyName,Address,City,Country FROM Suppliers
	WHERE Country IN ('USA', 'Canada', 'Mexico')

/*6. Nombre del producto, n�mero de unidades en stock y valor total del stock, de los productos que no sean de la categor�a 4.*/
SELECT ProductName,UnitsInStock,(UnitsInStock*UnitPrice) AS PriceOfStock FROM Products
	WHERE CategoryID <> 4

/*7. Clientes (Nombre de la Compa��a, direcci�n completa, persona de contacto) que no residan en un pa�s de Am�rica del Norte
y que la persona de contacto no sea el propietario de la compa��a.*/
SELECT CompanyName, Address, City,Country, ContactName FROM Customers
	WHERE Country <> 'USA' AND ContactTitle <> 'Owner'

/*8. ID del cliente y n�mero de pedidos realizados por cada cliente, ordenado de mayor a menor n�mero de pedidos.*/
SELECT CustomerID, COUNT(OrderID) AS [N�mero de pedidos] FROM Orders
	GROUP BY CustomerID
	ORDER BY COUNT(OrderID) DESC

/*9. N�mero de pedidos enviados a cada ciudad, incluyendo el nombre de la ciudad.*/
SELECT COUNT(ShipCity) AS [N�mero de pedidos], ShipCity FROM Orders
	GROUP BY ShipCity
	ORDER BY ShipCity

/*10. N�mero de productos de cada categor�a.*/
SELECT CategoryID, COUNT(CategoryID) AS [N�mero de productos] FROM Products
	GROUP BY CategoryID
