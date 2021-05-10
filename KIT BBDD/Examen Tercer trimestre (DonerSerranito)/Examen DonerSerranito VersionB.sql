--Versión B
--Si la inicial de tu primer apellido está entre la M y la Z (incluidas)

USE DonerSerranito

--Ejercicio 1 (2 points) (Exámen)
--Escribe una función a la que se pase un establecimiento y un rango de fechas, una salsa y un tipo de carne y nos devuelva el número de serranitos 
--que se han vendido en ese establecimiento que contengan ese tipo de carne y esa salsa en ese rango de fechas.

GO
--Nombre: NumeroSerranitosTipo
--Descripcion: Nos devuelve el numero de serranitos del tipo especificado (incluye serranitos con otra salsa aparte de la especificada) 
--				en el establecimiento dado en las fechas dadas.
--Entradas: Nombre del Establecimiento, Rango de fechas (fecha Inicio/fecha Fin), Id Salsa y el tipo de carne
											--Tomaremos la fecha de entrega como referencia
--Salida: Numero de serranitos con los parametros dados

CREATE OR ALTER FUNCTION NumeroSerranitosTipo (@Establecimiento varchar(30) , @FechaInicio date, @FechaFin date, @IdSalsa Int, @TipoCarne varchar(12)) RETURNS int AS
BEGIN
	DECLARE @CantidadSerranito Int
	SELECT @CantidadSerranito = COUNT(PL.ID) FROM DSEstablecimientos AS E
			INNER JOIN DSPedidos AS PE ON E.ID=PE.IDEstablecimiento
			INNER JOIN DSPlatos AS PL ON PE.ID=PL.IDPedido
			INNER JOIN DSPlatosSalsas AS PS ON PE.ID=PS.IDPlato
			WHERE	E.Denominacion=@Establecimiento AND
					PE.Enviado BETWEEN @FechaInicio AND @FechaFin AND
					PS.IDSalsa = @IdSalsa AND
					PL.TipoCarne = @TipoCarne
	RETURN @CantidadSerranito
END
GO
--PRUEBA
DECLARE @NumeroSerranito int
SET @NumeroSerranito= dbo.NumeroSerranitosTipo('La Fragua',DATEFROMPARTS(2017,2,1),DATEFROMPARTS(2017,4,30),2,'Ibérico')
PRINT @NumeroSerranito
SET @NumeroSerranito= dbo.NumeroSerranitosTipo('Sabroso',DATEFROMPARTS(2017,1,1),DATEFROMPARTS(2017,12,30),3,'Avestruz')
PRINT @NumeroSerranito
GO

--Ejercicio 2 (2 points) (Exámen)
--Queremos saber cuál es la salsa que prefieren los clientes de un establecimiento para acompañar cada tipo de carne. Escribe una función a la que 
--pasemos el nombre de un establecimiento y nos devuelva una tabla con los distintos tipos de carne y la salsa que más veces la acompaña, así como el
--número total de serranitos vendidos que incluyan ese tipo de carne y esa salsa. Utiliza la función desarrollada en el ejercicio 1

GO
--FUNCION AUXILIAR
--Nombre: RecuentoSalsaCarne
--Descripcion: Nos devuelve el numero de platos con esa salsa para cada eleccion de  carne seleccionada en un estblecimiento dado
--Entrada: Nombre del Establecimiento
--Salida: La salsa que se han seleccionado para cada carne en ese establecimiento

CREATE OR ALTER FUNCTION MejorSalsaCarne (@Establecimiento varchar(30)) RETURNS TABLE AS
RETURN
	(SELECT TipoCarne,IDSalsa, COUNT (IDPlato) AS [NumPlatos] FROM DSPlatosSalsas AS PS
	INNER JOIN DSPlatos AS PL ON PS.IDPlato=PL.ID
	INNER JOIN DSPedidos AS PE ON PL.IDPedido=PE.ID
	INNER JOIN DSEstablecimientos AS E ON PE.IDEstablecimiento=E.ID
	WHERE  E.Denominacion = @Establecimiento
	GROUP BY TipoCarne,IDSalsa)
GO

SELECT * FROM dbo.MejorSalsaCarne('La Fragua') AS A
INNER JOIN dbo.MejorSalsaCarne('La Fragua') AS B ON A.TipoCarne=B.TipoCarne

GO
--Nombre: MejorSalsa
--Descripcion: Nos devuelve una tabla con los tipos de carne y la salsa que mejor acompaña a cada tipo de carne, asi como el numero de serranitos que 
--				se han vendido con esa combinación.
--Entrada: Nombre del establecimiento
--Salida: Todos los tipos de carne, las salsas preferidas para cada carne y el numero total de Serranitos vendidos con esa combinacion.

CREATE OR ALTER FUNCTION MejorSalsa (@Establecimiento varchar(30))
	RETURNS @MejoresSalsas TABLE (
		Carne varchar(30),
		SalsaPreferida varchar (12) NULL,
		NumeroSerranitos smallint NULL
	)AS
	BEGIN
	INSERT INTO @MejoresSalsas (Carne, SalsaPreferida)
		SELECT TipoCarne, MAX(NumPlatos) FROM dbo.MejorSalsaCarne(@Establecimiento)
		GROUP BY TipoCarne
	
	UPDATE @MejoresSalsas SET SalsaPreferida = IDSalsa FROM dbo.MejorSalsaCarne(@Establecimiento) AS A
					WHERE SalsaPreferida= A.NumPlatos AND Carne=A.TipoCarne

	UPDATE @MejoresSalsas SET NumeroSerranitos = dbo.NumeroSerranitosTipo(@Establecimiento,DATEFROMPARTS(2000,1,1), CURRENT_TIMESTAMP,SalsaPreferida, Carne)
	RETURN
	END
GO

--PRUEBA
SELECT * FROM dbo.MejorSalsa('La Fragua')

--Ejercicio 3 (3 points) (Exámen)
--A algunos clientes les gusta repetir sus pedidos. Crea un procedimiento al que se pase el ID de un cliente, el nombre de un establecimiento y una 
--fecha/hora y busque el último pedido de ese cliente anterior a esa fecha/hora (puede haber un margen de error) y duplique el pedido con los mismos 
--serranitos, salsas y complementos, en el mismo establecimiento, pero asignándole la fecha/hora actual. La fecha de envío serán 20' más de la hora 
--actual y deja el repartidor a NULL.

GO
--Nombre: RepetirPedido
--Descripcion:Busca el ultimo pedido de un inclente en ese establecimiento
--Entradas: Id Cliente, Nombre del establecimiento, Fecha Hora
--Salidas: Cambios (Actualizacion) en la tabla pedidos

CREATE OR ALTER PROCEDURE RepetirPedido
	@IdCliente int,
	@Establecimiento varchar(30),
	@Fecha smalldatetime
AS BEGIN
	DECLARE @IDPedido int
	INSERT  INTO DSPedidos (Recibido, Enviado, IDCliente)
		VALUES (CURRENT_TIMESTAMP, DATEADD(MINUTE, 20, CURRENT_TIMESTAMP), @IdCliente)
	SET @IDPedido = @@IDENTITY
	--Almacenamos los ides de los platos
	DECLARE @UltimoPedido AS TABLE
	(ID int NOT NULL )

	--SET ID FROM @UltimoPedido=(
	--	SELECT PL.ID FROM DSEstablecimientos AS E
	--	INNER JOIN DSPedidos AS PE ON E.ID=PE.IDEstablecimiento
	--	INNER JOIN DSPlatos AS PL ON PE.ID=PL.IDPedido
	--	INNER JOIN DSPlatosSalsas AS PS ON PL.ID=PS.IDPlato
	--	WHERE IDCliente=@IdCliente AND PE.Recibido<@Fecha)

	--insertamos los valores en la tabla platos y en el resto de tablas (complementos y salsas)
	INSERT INTO DSPlatos
		SELECT PL.* FROM DSEstablecimientos AS E
		INNER JOIN DSPedidos AS PE ON E.ID=PE.IDEstablecimiento
		INNER JOIN DSPlatos AS PL ON PE.ID=PL.IDPedido
		INNER JOIN DSPlatosSalsas AS PS ON PL.ID=PS.IDPlato
		--WHERE 


END
GO
SELECT * FROM DSPedidos
---------------------------------------------------------------------------------------------------------------------------------------------


--Ejercicio 4 (3 points) (Exámen)
--Escribe una función a la que pasemos el ID de un establecimiento y nos devuelva una tabla con los nombre de cada uno de los adicionales, el número 
--total y el porcentaje de serranitos que los llevan, referido a los pedidos que se han servido en ese local. También queremos saber el precio medio 
--de los pedidos que incluyen cada uno de los adicionales.
--Las columnas serán: Nombre adicional, número de serranitos, porcentaje de serranitos, precio medio de pedidos con ese adicional

GO
--Nombre: TablaAdicionales
--Descripcion:
--Entrada: ID del establecimiento
--Salida: Nombre adicional, número de serranitos, porcentaje de serranitos y precio medio de pedidos con ese adicional

CREATE OR ALTER FUNCTION TablaAdicionales (@IdEstablecimiento int) 
RETURNS @Adicionales TABLE (
	NombreAdicional varchar(20) NULL,
	NumeroSerranitos int NULL,
	Porcentaje int NULL,
	PrecioMedio smallmoney NULL
)AS
BEGIN
--INSERTAMOS ADICIONALES DEL ESTABLECIMIENTO
	INSERT INTO @Adicionales (NombreAdicional)
	SELECT * FROM DSPlatosAdicionales

	UPDATE @Adicionales (NumeroSerranitos)
	--Usar funcion de ejercicio 1

RETURN
END
GO
---------------------------------------------------------------------------------------------------------------------------------------------

