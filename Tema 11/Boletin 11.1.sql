USE Northwind
--1. Deseamos incluir un producto en la tabla Products llamado "Cruzcampo lata” pero no estamos seguros si se ha insertado o no.
--El precio son 4,40, el proveedor es el 16, la categoría 1 y la cantidad por unidad es "Pack 6 latas” "Discontinued” toma el valor 0 y el 
--resto de columnas se dejarán a NULL.
--Escribe un script que compruebe si existe un producto con ese nombre. En caso afirmativo, actualizará el precio y en caso negativo 
--insertarlo.

GO
CREATE OR ALTER PROCEDURE InsertaActualizaCruzcampo 
			@NombreProducto nvarchar(40),
			@Proveedor int,
			@Categoria int,
			@Cantidad nvarchar(20),
			@Precio money,
			@Unidades smallint,
			@UnidadesPedidas smallint,
			@NivelDeCosa smallint,
			@Discounted bit
AS 
	BEGIN
		IF (EXISTS (SELECT * FROM Products WHERE ProductName='Cruzcampo lata'))
			BEGIN
				UPDATE Products SET UnitPrice = @Precio,
									SupplierID = @Proveedor,
									CategoryID = @Categoria,
									QuantityPerUnit = @Cantidad,
									Discontinued = @Discounted
						WHERE ProductName='Cruzcampo lata'
			END --IF
		ELSE
			BEGIN
				INSERT INTO Products (ProductName, UnitPrice, SupplierID, CategoryID, QuantityPerUnit, Discontinued)
					VALUES(@NombreProducto, @Precio, @Proveedor, @Categoria, @Cantidad, @Discounted)
			END --ELSE
	END
GO


--2. Comprueba si existe una tabla llamada ProductSales. Esta tabla ha de tener de cada producto el ID, el Nombre, el Precio unitario, el número 
--total de unidades vendidas y el total de dinero facturado con ese producto. Si no existe, créala

--3. Comprueba si existe una tabla llamada ShipShip. Esta tabla ha de tener de cada Transportista el ID, el Nombre de la compañía, el número 
--total de envíos que ha efectuado y el número de países diferentes a los que ha llevado cosas. Si no existe, créala

--4. Comprueba si existe una tabla llamada EmployeeSales. Esta tabla ha de tener de cada empleado su ID, el Nombre completo, el número de ventas 
--totales que ha realizado, el número de clientes diferentes a los que ha vendido y el total de dinero facturado. Si no existe, créala

--5. Entre los años 96 y 97 hay productos que han aumentado sus ventas y otros que las han disminuido. Queremos cambiar el precio unitario según 
--la siguiente tabla:

--	Incremento de ventas				Incremento de precio

--		Negativo							-10%
--		Entre 0 y 10%						No varía
--		Entre 10% y 50%						+5%
--		Mayor del 50%						10% con un máximo de 2,25

GO

CREATE OR ALTER FUNCTION CambioPrecio (@IdProducto INT) RETURNS MONEY
BEGIN
	DECLARE @PrecioIncrementado MONEY
	SELECT * FROM Products AS P
		INNER JOIN 

	RETURN @PrecioIncrementado
END


GO
CREATE OR ALTER FUNCTION IncrementoAnual (@AnhoFinal INT) RETURNS TABLE 
AS RETURN(
	SELECT A1.ProductID, CAST ((A2.[Cantidad vendida]-A1.[Cantidad vendida]) AS float)/A2.[Cantidad vendida] AS Diferencia FROM VentasAnuales(@AnhoFinal-1) AS A1
		INNER JOIN VentasAnuales(@AnhoFinal) AS A2 ON A1.ProductID=A2.ProductID
	)
GO

CREATE OR ALTER FUNCTION VentasAnuales (@Anho INT) RETURNS TABLE
AS RETURN(
	SELECT OD.ProductID, SUM(OD.Quantity) AS [Cantidad vendida] FROM [Order Details] AS OD
		INNER JOIN Orders AS O ON OD.OrderID=O.OrderID
		WHERE YEAR(O.OrderDate) = @Anho
		GROUP BY OD.ProductID, YEAR(O.OrderDate)
)
GO

SELECT * FROM IncrementoAnual(1997)
