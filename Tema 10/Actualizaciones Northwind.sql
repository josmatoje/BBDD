USE Northwind
--1. Inserta un nuevo cliente.

INSERT INTO Customers (CustomerID,CompanyName)
	VALUES ('XEMOJ', 'La company loca')

SELECT * FROM Customers

--2. V�ndele (hoy) tres unidades de "Pavlova�, diez de "Inlagd Sill� y 25 de "Filo Mix�. El distribuidor ser� Speedy Express y el vendedor Laura 
--	Callahan.

INSERT INTO Orders

--3. Ante la bajada de ventas producida por la crisis, hemos de adaptar nuestros precios seg�n las siguientes reglas:

--	Los productos de la categor�a de bebidas (Beverages) que cuesten m�s de $10 reducen su precio en un d�lar.

--	Los productos de la categor�a L�cteos que cuesten m�s de $5 reducen su precio en un 10%.

--	Los productos de los que se hayan vendido menos de 200 unidades en el �ltimo a�o, reducen su precio en un 5%



--4. Inserta un nuevo vendedor llamado Michael Trump. As�gnale los territorios de Louisville, Phoenix, Santa Cruz y Atlanta.

--5. Haz que las ventas del a�o 97 de Robert King que haya hecho a clientes de los estados de California y Texas se le asignen al nuevo empleado.

--6. Inserta un nuevo producto con los siguientes datos:
--	ProductID: 90 (NO)
--	ProductName: Nesquick Power Max
--	SupplierID: 12
--	CategoryID: 3
--	QuantityPerUnit: 10 x 300g
--	UnitPrice: 2,40
--	UnitsInStock: 38
--	UnitsOnOrder: 0
--	ReorderLevel: 0
--	Discontinued: 0

INSERT INTO Products


--7. Inserta un nuevo producto con los siguientes datos:
--	ProductID: 91
--	ProductName: Mecca Cola
--	SupplierID: 1
--	CategoryID: 1
--	QuantityPerUnit: 6 x 75 cl
--	UnitPrice: 7,35
--	UnitsInStock: 14
--	UnitsOnOrder: 0
--	ReorderLevel: 0
--	Discontinued: 0

--8. Todos los que han comprado "Outback Lager" han comprado cinco a�os despu�s la misma cantidad de Mecca Cola al mismo vendedor

SELECT O.* FROM Orders AS O
INNER JOIN [Order Details] AS OD ON O.OrderID=OD.OrderID
INNER JOIN Products AS P ON OD.ProductID=P.ProductID
WHERE P.ProductName='Outback Lager'

GO
CREATE TRIGGER NuevoPedido ON Orders AFTER INSERT AS
BEGIN
	DECLARE @NewId AS TABLE(
		ID int Not NULL)
	INSERT INTO @NewId (ID)
		 SELECT * FROM inserted


END

GO


SELECT * FROM Products

--9. El pasado 20 de enero, Margaret Peacock consigui� vender una caja de Nesquick Power Max a todos los clientes que le hab�an comprado algo 
-- anteriormente. Los datos de env�o (direcci�n, transportista, etc) son los mismos de alguna de sus ventas anteriores a ese cliente).


