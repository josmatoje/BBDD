--Bolet�n 11.2 LeoMetro
USE LeoMetro
GO
--Ejercicio 0
--La convocatoria de elecciones en Madrid ha causado tal conmoci�n entre los directivos de LeoMetro que han decidido conceder una amnist�a a todos 
--los pasajeros que tengan un saldo negativo en sus tarjetas.
--Crea un procedimiento que racargue la cantidad necesaria para dejar a 0 el saldo de las tarjetas que tengan un saldo negativo y hayan sido 
--recargadas al menos una vez en los �ltimos dos meses.
--Ejercicio elaborado en colaboraci�n con Sefran.

CREATE OR ALTER PROCEDURE RecargaMinimaNecesaria
AS BEGIN
	--Variables
	DECLARE @IdTarjeta INT = (SELECT TOP(1)ID FROM LM_Tarjetas ORDER BY ID)
	DECLARE @Dineros SMALLMONEY

	WHILE @IdTarjeta<(SELECT TOP(1)ID FROM LM_Tarjetas ORDER BY ID DESC)
		BEGIN
			SELECT @Dineros = Saldo FROM LM_Tarjetas WHERE ID=@IdTarjeta
			IF(@Dineros < 0 AND DATEDIFF(DAY, (SELECT Momento_Recarga FROM LM_Recargas WHERE ID_Tarjeta=@IdTarjeta), CURRENT_TIMESTAMP)<61)--Aproximar fechas
			BEGIN
				SET @Dineros=ABS(@Dineros)
				EXECUTE dbo.RecargarTarjeta @IdTarjeta, @Dineros
			END
			SET @IdTarjeta=(SELECT TOP(1)ID FROM LM_Tarjetas WHERE ID>@IdTarjeta)
		END
END

GO
begin tran
EXECUTE dbo.RecargaMinimaNecesaria
select * from LM_Tarjetas
rollback

GO
--Ejercicio 1
--Crea un procedimiento RecargarTarjeta que reciba como par�metros el ID de una tarjeta y un importe y actualice el saldo de la tarjeta sum�ndole 
--dicho importe, adem�s de grabar la correspondiente recarga

CREATE OR ALTER PROCEDURE RecargarTarjeta 
	@IdTarjeta INT,
	@Importe SMALLMONEY
AS BEGIN
	--Actualizamos saldo de tarjeta
	UPDATE LM_Tarjetas
	SET Saldo+= @Importe WHERE ID=@IdTarjeta
	--Insertamos la recarga correspondiente
	INSERT INTO LM_Recargas (ID, ID_Tarjeta,Cantidad_Recarga,Momento_Recarga,SaldoResultante)
	VALUES (NEWID(),@IdTarjeta, @Importe, CURRENT_TIMESTAMP, (SELECT Saldo+@Importe FROM LM_Tarjetas WHERE @IdTarjeta=ID) )
END
GO
--Ejercicio 2
--Crea un procedimiento almacenado llamado PasajeroSale que reciba como par�metros el ID de una tarjeta, el ID de una estaci�n y una fecha/hora 
--(opcional). El procedimiento se llamar� cuando un pasajero pasa su tarjeta por uno de los tornos de salida del metro. Su misi�n es grabar la 
--salida en la tabla LM_Viajes. Para ello deber� localizar la entrada que corresponda, que ser� la �ltima entrada correspondiente al mismo pasajero 
--y har� un update de las columnas que corresponda. Si no existe la entrada, grabaremos una nueva fila en LM_Viajes dejando a NULL la estaci�n y el 
--momento de entrada.
--Si se omite el par�metro de la fecha/hora, se tomar� la actual.

 CREATE OR ALTER PROCEDURE PasajeroSale
	@IdTarjeta INT,
	@IdEstacionSalida SMALLINT,
	@MomentoSalida SMALLDATETIME = NULL
AS BEGIN
	DECLARE @IdEstacionEntrada SMALLINT
	DECLARE @ImporteViaje SMALLMONEY

	--Asignamos la estaci�n de entrada que se corresponda con la terjeta y que no tenga estacion de salida
	SELECT @IdEstacionEntrada=IDEstacionEntrada FROM LM_Viajes WHERE IDTarjeta=@IdTarjeta AND IDEstacionSalida = NULL
	--Selecci�n del importe del viaje
	SELECT @ImporteViaje = MAX(P.Precio_Zona) FROM LM_Zona_Precios AS P
			INNER JOIN LM_Estaciones AS E ON P.Zona=E.Zona_Estacion
			WHERE E.ID=@IdEstacionEntrada OR E.ID=@IdEstacionSalida
	--Momento de salida en caso de no introducirse como parametro
	IF (@MomentoSalida = NULL)
	BEGIN
		SET @MomentoSalida=CURRENT_TIMESTAMP
	END
	--Actualiza o inserta Viaje
	IF(@IdEstacionEntrada != NULL)
	BEGIN
		UPDATE LM_Viajes 
			SET IDEstacionSalida=@IdEstacionSalida,
				MomentoSalida = @MomentoSalida,
				Importe_Viaje=@ImporteViaje
		WHERE IDTarjeta=@IdTarjeta AND IDEstacionSalida = NULL
	END
	ELSE
	BEGIN
		--El ID del viaje se autogenera, no es necesario insertarlo
		INSERT INTO LM_Viajes (IDTarjeta, IDEstacionEntrada, IDEstacionSalida, MomentoEntrada, MomentoSalida, Importe_Viaje)
			VALUES(@IdTarjeta, @IdEstacionEntrada, @IdEstacionSalida, NULL, @MomentoSalida, @ImporteViaje )
	END
END
GO

--Ejercicio 3
--A veces, un pasajero reclama que le hemos cobrado un viaje de forma indebida. Escribe un procedimiento que reciba como par�metro el ID de un 
--pasajero y la fecha y hora de la entrada en el metro y anule ese viaje, actualizando adem�s el saldo de la tarjeta que utiliz�.

CREATE OR ALTER PROCEDURE AnularViaje
	@IdPasajero INT,
	@FechaHoraEntrada SMALLDATETIME
AS BEGIN
	DECLARE @IdTarjeta INT
	DECLARE @Importe SMALLMONEY

	SELECT @IdTarjeta=IDTarjeta, @Importe=Importe_Viaje FROM LM_Viajes AS V
		INNER JOIN LM_Tarjetas AS T ON V.IDTarjeta=T.ID 
		WHERE @IdPasajero=T.IDPasajero AND MomentoEntrada BETWEEN @FechaHoraEntrada AND DATEADD(HOUR, 1, @FechaHoraEntrada)--Fecha entre la dada y la siguiente hora
	UPDATE LM_Tarjetas SET Saldo+=@Importe
		WHERE ID=@IdTarjeta
END
GO
SELECT * FROM LM_Pasajeros
SELECT * FROM LM_Tarjetas

--Ejercicio 4
--La empresa de Metro realiza una campa�a de promoci�n para pasajeros fieles.

--Crea un procedimiento almacenado que recargue saldo a los pasajeros que cumplan determinados requisitos.
--Se recargar�n N1 euros a los pasajeros que hayan consumido m�s de 30 euros en el mes anterior (considerar mes completo, del d�a 1 al fin) y N2 
--euros a los que hayan utilizado m�s de 10 veces alguna estaci�n de las zonas 3 o 4.

--Los valores de N1 y N2 se pasar�n como par�metros. Si se omiten, se tomar� el valor 5.

--Ambos premios son excluyentes. Si alg�n pasajero cumple ambas condiciones se le aplicar� la que suponga mayor bonificaci�n de las dos.
GO
--Ejercicio 5
--Crea una funci�n que nos devuelva verdadero si es posible que un pasajero haya subido a un tren en un determinado viaje. Se pasar� como par�metro 
--el c�digo del viaje y la matr�cula del tren.

--Primera aproximaci�n: Se considera que un pasajero ha podido subir a un tren si ese tren se encontraba en serviciodurante el tiempo que el 
--pasajero ha permanecido dentro del sistema de metro
GO
--Ejercicio 6
--Crea un procedimiento SustituirTarjeta que Cree una nueva tarjeta y la asigne al mismo usuario y con el mismo saldo que otra tarjeta existente. 
--El c�digo de la tarjeta a sustituir se pasar� como par�metro.
GO
--Ejercicio 7
--Las estaciones de la zona 3 tienen ciertas deficiencias, lo que nos ha obligado a introducir una serie de modificaciones en los trenes  para 
--cumplir las medidas de seguridad.

--A consecuencia de estas modificaciones, la capacidad de los trenes se ha visto reducida en 6 plazas para los trenes de tipo 1 y 4 plazas para los 
--trenes de tipo 2.
--Realiza un procedimiento al que se pase un intervalo de tiempo y modifique la capacidad de todos los trenes que hayan circulado m�s de una vez 
--por alguna estaci�n de la zona 3 en ese intervalo.