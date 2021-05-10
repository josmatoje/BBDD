--Enunciado Control
--Segunda y tercera evaluaciones
USE BicisLeo
--Ejercicio 1 (2 points)
--Escribe una funci�n a la que se pase un ID de Cliente, una categor�a y un rango de fechas y nos devuelva el importe total facturado a ese cliente 
--de productos de esa categor�a en ese rango de fechas. Para calcular el importe facturado se tendr�n en cuenta las compras y las devoluciones 
--efectuadas dentro de esas fechas.
--La devoluci�n se tendr� en cuenta incluso si la compra a la que afecta fuera anterior a la fecha inicial.
GO
--Nombre: TotalFacturado
--Descripci�n: devuelve el total recaudado por un cliente de un producto concreto en un rango de fechas
--Entradas: Id del cliente, Id de categor�a, rango de fechas
--Salidas: importe total facturado con esas caracteristicas

CREATE OR ALTER FUNCTION TotalFacturado (@IdCliente int, @IdCategoria int, @FechaIni date, @FechaFin date) RETURNS money AS
BEGIN
	DECLARE @TotalCobrado money
	DECLARE @TotalDevuelto money

	SELECT @TotalCobrado = SUM(LP.precio*LP.Cantidad) FROM Clientes AS C
	INNER JOIN Pedidos AS PD ON C.ID=PD.IDCliente
	INNER JOIN LineasPedidos AS LP ON PD.ID=LP.IDPedido
	INNER JOIN Productos AS PR ON LP.IDProducto=PR.IDProducto
	INNER JOIN ProductosCategorias AS PC ON PR.IDProducto=PC.IDProducto
	WHERE C.ID=@IdCliente AND PC.IDCategoria=@IdCategoria
			AND PD.FechaPedido BETWEEN CAST(@FechaIni AS DATE) AND CAST(@FechaFin AS DATE)

	SELECT @TotalDevuelto = ISNULL(SUM(LP.precio*LD.Cantidad),0) FROM Clientes AS C
	INNER JOIN Pedidos AS PD ON C.ID=PD.IDCliente
	INNER JOIN Devoluciones AS D ON PD.ID=D.IDPEdido
	INNER JOIN LineasDevolucion AS LD ON D.IDPEdido=LD.IDPedido AND D.Num=LD.NumDevolucion
	INNER JOIN LineasPedidos AS LP ON PD.ID=LP.IDPedido
	INNER JOIN Productos AS PR ON LP.IDProducto=PR.IDProducto
	INNER JOIN ProductosCategorias AS PC ON PR.IDProducto=PC.IDProducto
	WHERE C.ID=@IdCliente AND PC.IDCategoria=@IdCategoria
			AND PD.FechaPedido BETWEEN CAST(@FechaIni AS DATE) AND CAST(@FechaFin AS DATE)
		
	SET @TotalCobrado= @TotalCobrado-@TotalDevuelto

	RETURN @TotalCobrado
END
GO
--COMPROBACIONES
DECLARE @IdCliente int = 420
DECLARE @IdCategoria int = 20
DECLARE @FechaIni date = DATEFROMPARTS(2018,9,1)
DECLARE @FechaFin date = DATEFROMPARTS(2018,12,31)

	DECLARE @TotalCobrado money
	DECLARE @TotalDevuelto money

	SELECT @TotalCobrado = ISNULL(SUM(LP.precio*LP.Cantidad),0) FROM Clientes AS C
	INNER JOIN Pedidos AS PD ON C.ID=PD.IDCliente
	INNER JOIN LineasPedidos AS LP ON PD.ID=LP.IDPedido
	INNER JOIN Productos AS PR ON LP.IDProducto=PR.IDProducto
	INNER JOIN ProductosCategorias AS PC ON PR.IDProducto=PC.IDProducto
	WHERE C.ID=@IdCliente AND PC.IDCategoria=@IdCategoria
			AND PD.FechaPedido BETWEEN CAST(@FechaIni AS DATE) AND CAST(@FechaFin AS DATE)

	
	
	SELECT @TotalDevuelto = SUM(LP.precio*LP.Cantidad) FROM Clientes AS C
	INNER JOIN Pedidos AS PD ON C.ID=PD.IDCliente
	INNER JOIN Devoluciones AS D ON PD.ID=D.IDPEdido
	INNER JOIN LineasDevolucion AS LD ON D.IDPEdido=LD.IDPedido AND D.Num=LD.NumDevolucion
	INNER JOIN LineasPedidos AS LP ON PD.ID=LP.IDPedido
	INNER JOIN Productos AS PR ON LP.IDProducto=PR.IDProducto
	INNER JOIN ProductosCategorias AS PC ON PR.IDProducto=PC.IDProducto
	WHERE C.ID=@IdCliente AND PC.IDCategoria=@IdCategoria
			AND PD.FechaPedido BETWEEN CAST(@FechaIni AS DATE) AND CAST(@FechaFin AS DATE)
			
	PRINT @TotalCobrado
	PRINT @TotalDevuelto

--PRUEBA
DECLARE @Total money
SELECT @Total = dbo.TotalFacturado(420,20,DATEFROMPARTS(2018,9,1),DATEFROMPARTS(2018,12,31))
PRINT 'El total facturado es:'
PRINT @Total 
GO

--Ejercicio 2 (2 points)
--Queremos saber qui�n es el cliente que gasta m�s dinero en cada categor�a de productos en un a�o determinado. Escribe una funci�n a la que pasemos 
--el ID de una categor�a y un a�o (entero) y nos devuelva una tabla con el nombre, apellidos e ID, as� como el nombre de la categor�a y la cantidad 
--total gastada en productos de esa categor�a. Utiliza la funci�n desarrollada en el ejercicio 1.

--No se tendr�n en cuenta las categor�as que agrupen a otras categor�as.
GO
--Nombre: MostValuableClient
--Descripci�n: Nos devuelve una tabla con los datos del cliente que m�s ha gastad en un a�o dado para cada categoria
--Entradas: A�o
--Salidas: Tabla con: Nombre, Apellidos e Id del cliente,Nombre de la categoria, cantidad gastada

CREATE OR ALTER FUNCTION MostValuableClient (@A�o int) RETURNS @MVC TABLE(
			Nombre nvarchar(50) NULL,
			Apellidos nvarchar(50)NULL,
			ID int NULL,
			Categoria nvarchar(50) NOT NULL,
			[Total facturado] money NULL
)AS
BEGIN
	INSERT INTO @MVC (Categoria)
	SELECT Nombre FROM Categorias

	UPDATE  @MVC 
	SET 
		Nombre= C.Nombre,
		Apellidos=C.Apellidos,
		ID=C.ID,
		[Total facturado]= dbo.TotalFacturado(C.ID,Categoria,DATEFROMPARTS(@A�o,1,1),DATEFROMPARTS(@A�o,12,31)) FROM Clientes AS C
		--WHERE 
		--FROM 
		--(SELECT CL.ID FROM Clientes AS CL
		--INNER JOIN Pedidos AS PD ON CL.ID=PD.IDCliente
		--INNER JOIN LineasPedidos AS LP ON PD.ID=LP.IDPedido
		--INNER JOIN Productos AS PR ON LP.IDProducto=PR.IDProducto
		--INNER JOIN ProductosCategorias AS PC ON PR.IDProducto=PC.IDProducto
		--INNER JOIN Categorias AS CA ON PC.IDCategoria=CA.IDCategoria
		--ORDER BY dbo.TotalFacturado(CL.ID,PC.IDCategoria,DATEFROMPARTS(@A�o,1,1),DATEFROMPARTS(@A�o,12,31))
		--)AS C
RETURN
END
GO
--PRUEBA
SELECT * FROM dbo.MostValuableClient(2018)

SELECT * FROM Categorias

--Ejercicio 3 (2 points)
--Crea un procedimiento almacenado para efectuar una devoluci�n de un producto. El procedimiento recibir� como par�metros el ID del pedido, el ID del
--producto y la cantidad a devolver y generar� un devoluci�n y su correspondiente l�nea de devoluci�n.

--Se valorar� si se tienen en cuenta errores en la entrada, como que el producto introducido no est� en el pedido, que la cantidad que se quiere 
--devolver sea mayor que la que se compr�, etc.
GO
--Nombre:Devolucion
--Descripci�n: introduce datos de una devolucion en la tabla devoluciones
--Entradas: Id del pedido, id del producto, cantidad
--Salidas: genera una devolucion en la tabla devoluciones y linea de devolucion

CREATE OR ALTER PROCEDURE Devolucion 
		@Idpedido uniqueidentifier,
		@IdProducto int,
		@Cantidad smallint 
AS
BEGIN
	DECLARE @NUM AS tinyint
	--DECLARE @myid uniqueidentifier = NEWID(); 

	SELECT @NUM = MAX (Num) FROM Devoluciones
			WHERE IDPEdido=@Idpedido
	IF @NUM IS NULL
		SET @NUM = 1
	ELSE
		SET @NUM= @NUM+1

	INSERT INTO Devoluciones (IDPEdido, Num, Fecha)
		VALUES(@Idpedido,@NUM,CAST(CURRENT_TIMESTAMP AS smalldatetime))

	INSERT INTO LineasDevolucion (IDLD,IDPedido,NumDevolucion,IDProducto,Cantidad)
		VALUES(NEWID(),@Idpedido,@NUM, @IdProducto,@Cantidad)
END
GO
--PRUEBA
BEGIN TRANSACTION

EXECUTE Devolucion '328707C2-A997-48CF-BC60-79A0FB780250',743,1

SELECT * FROM Devoluciones
SELECT * FROM LineasDevolucion
ROLLBACK
--COMMIT

--Ejercicio 4 (4 points)
--A algunos clientes les gusta repetir sus pedidos. Crea un procedimiento al que se pase el ID de un pedido y duplique el pedido con los mismos 
--productos, pero asign�ndole la fecha/hora actual. Deja la fecha de env�o y la de servido a NULL. El subtotal se calcular� seg�n los precios 
--actuales de venta de los productos incluidos.

--Si el pedido ha tenido alguna devoluci�n posterior, esas unidades devueltas se descontar�n del nuevo pedido. Es decir, si de un producto 
--determinado se pidieron 5 unidades y m�s tarde se devolvieron 2, el nuevo pedido tendr� s�lo 3 unidades. Si se devolvieron todas las unidades de 
--un producto, este no aparecer� en el nuevo pedido.

--Los impuestos ser�n un 8% del subtotal.

--El n�mero de Venta se generar� usando la funci�n GeneraNuevoNumeroVenta(), incluida en la base de datos.

--El resto de valores se copiar�n del pedido original.

GO
--Nombre: DuplicarPedido
--Descripci�n: Duplica un pedido dado el id del pedido como parametro
--Entradas: Id pedido
--Salidas: Cambios en las tablas

CREATE OR ALTER PROCEDURE DuplicarPedido 
		@Idpedido uniqueidentifier 
AS
BEGIN
	DECLARE @NuevoId uniqueidentifier
	SET @NuevoId = NEWID()

	INSERT INTO Pedidos (FechaPedido,NumeroVenta, IDCliente,MedioEnvio,CodigoAprobacionTarjeta,SubTotal,Impuestos,ID)
	SELECT CURRENT_TIMESTAMP, dbo.GeneraNuevoNumeroVenta(), PD.IDCliente,PD.MedioEnvio, PD.CodigoAprobacionTarjeta, PR.PVP*SubT, PR.PVP*Imp, @NuevoId FROM Pedidos AS PD
	INNER JOIN 
		(SELECT LP.IDPedido, SUM((LP.Cantidad-ISNULL(LD.Cantidad,0))) AS SubT, 0.8*SUM((LP.Cantidad-ISNULL(LD.Cantidad,0))) AS Imp FROM LineasDevolucion AS LD
		INNER JOIN LineasPedidos AS LP ON LD.IDPedido=LP.IDPedido
		WHERE LP.IDPedido=@Idpedido
		GROUP BY LP.IDPedido) AS LPP 
	ON PD.ID=LPP.IDPedido
	INNER JOIN LineasPedidos AS LP ON LPP.IDPedido=LP.IDPedido
	INNER JOIN Productos AS PR ON LP.IDProducto=PR.IDProducto

	INSERT INTO  LineasPedidos (Cantidad, IDProducto, precio, IDPedido)
	SELECT (LP.Cantidad-LD.Cantidad), LP.IDProducto, PR.PVP, @NuevoId FROM LineasDevolucion AS LD
	INNER JOIN LineasPedidos AS LP ON LD.IDPedido=LP.IDPedido
	INNER JOIN Productos AS PR ON LP.IDProducto=PR.IDProducto
	WHERE LP.IDPedido=@Idpedido

END
GO
--PRUEBA
BEGIN TRANSACTION
EXECUTE DuplicarPedido 'D238A2CE-E062-4C11-ABC4-2A3BA660C97B'

SELECT * FROM Pedidos
ORDER BY FechaPedido DESC

ROLLBACK

SELECT LP.IDPedido, PR.*
--SUM(PR.PVP*(LP.Cantidad-LD.Cantidad)) AS SubT, 0.8*SUM(PR.PVP*(LP.Cantidad-LD.Cantidad))AS Imp
FROM LineasDevolucion AS LD
		INNER JOIN LineasPedidos AS LP ON LD.IDPedido=LP.IDPedido
		INNER JOIN Productos AS PR ON LP.IDProducto=PR.IDProducto
		WHERE LP.IDPedido='D238A2CE-E062-4C11-ABC4-2A3BA660C97B'
		--GROUP BY LP.IDPedido