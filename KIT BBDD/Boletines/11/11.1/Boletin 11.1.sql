USE Northwind
GO

-- EJERCICIO 1
--Deseamos incluir un producto en la tabla Products llamado "Cruzcampo botell�n� pero no estamos seguros si se ha insertado o no.
--El precio son 2,40, el proveedor es el 16, la categor�a 1 y la cantidad por unidad son "Pack de seis botellines� El resto de 
--columnas se dejar�n a NULL. Escribe un script que compruebe si existe un producto con ese nombre. En caso afirmativo, actualizar� 
--el precio y en caso negativo insertarlo. Comprueba si existe una tabla llamada ProductSales. Esta tabla ha de tener de cada 
--producto el ID, el Nombre, el Precio unitario, el n�mero total de unidades vendidas y el total de dinero facturado con ese 
--producto. Si no existe, cr�ala
IF NOT EXISTS (SELECT ProductName From Products WHERE ProductName='Cruzcampo botell�n')
	INSERT INTO [dbo].[Products]
           ([ProductName]
           ,[SupplierID]
           ,[CategoryID]
           ,[QuantityPerUnit]
           ,[UnitPrice]
           ,[UnitsInStock]
           ,[UnitsOnOrder]
           ,[ReorderLevel]
           ,[Discontinued])
     VALUES
           (<ProductName, nvarchar(40),>
           ,<SupplierID, int,>
           ,<CategoryID, int,>
           ,<QuantityPerUnit, nvarchar(20),>
           ,<UnitPrice, money,>
           ,<UnitsInStock, smallint,>
           ,<UnitsOnOrder, smallint,>
           ,<ReorderLevel, smallint,>
           ,<Discontinued, bit,>)


GO
-- EJERCICIO 2
--Comprueba si existe una tabla llamada ShipShip. Esta tabla ha de tener de cada Transportista el ID, el Nombre de la compa��a, 
--el n�mero total de env�os que ha efectuado y el n�mero de pa�ses diferentes a los que ha llevado cosas. Si no existe, cr�ala


GO
-- EJERCICIO 3
--Comprueba si existe una tabla llamada EmployeeSales. Esta tabla ha de tener de cada empleado su ID, el Nombre completo, 
--el n�mero de ventas totales que ha realizado, el n�mero de clientes diferentes a los que ha vendido y el total de dinero 
--facturado. Si no existe, cr�ala