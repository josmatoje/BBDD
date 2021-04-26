USE Northwind
--1. Deseamos incluir un producto en la tabla Products llamado "Cruzcampo lata� pero no estamos seguros si se ha insertado o no.
--El precio son 4,40, el proveedor es el 16, la categor�a 1 y la cantidad por unidad es "Pack 6 latas� "Discontinued� toma el valor 0 y el 
--resto de columnas se dejar�n a NULL.
--Escribe un script que compruebe si existe un producto con ese nombre. En caso afirmativo, actualizar� el precio y en caso negativo 
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


--2. Comprueba si existe una tabla llamada ProductSales. Esta tabla ha de tener de cada producto el ID, el Nombre, el Precio unitario, el n�mero 
--total de unidades vendidas y el total de dinero facturado con ese producto. Si no existe, cr�ala

--3. Comprueba si existe una tabla llamada ShipShip. Esta tabla ha de tener de cada Transportista el ID, el Nombre de la compa��a, el n�mero 
--total de env�os que ha efectuado y el n�mero de pa�ses diferentes a los que ha llevado cosas. Si no existe, cr�ala

--4. Comprueba si existe una tabla llamada EmployeeSales. Esta tabla ha de tener de cada empleado su ID, el Nombre completo, el n�mero de ventas 
--totales que ha realizado, el n�mero de clientes diferentes a los que ha vendido y el total de dinero facturado. Si no existe, cr�ala

--5. Entre los a�os 96 y 97 hay productos que han aumentado sus ventas y otros que las han disminuido. Queremos cambiar el precio unitario seg�n 
--la siguiente tabla:

--	Incremento de ventas				Incremento de precio

--		Negativo							-10%
--		Entre 0 y 10%						No var�a
--		Entre 10% y 50%						+5%
--		Mayor del 50%						10% con un m�ximo de 2,25

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
