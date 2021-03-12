-- illo esto est� guapo usalo
SELECT DATEADD(day, 1, EOMONTH (CURRENT_TIMESTAMP, -2)) ,EOMONTH (CURRENT_TIMESTAMP, -1) 

USE LeoMetroV2
GO

--Ejercicio 0
--La dimisi�n de Esperanza Aguirre ha causado tal conmoci�n entre los directivos de LeoMetro que han decidido conceder una amnist�a a todos los 
--pasajeros que tengan un saldo negativo en sus tarjetas. Crea un procedimiento que racargue la cantidad necesaria para dejar a 0 el saldo de las 
--tarjetas que tengan un saldo negativo y hayan sido recargadas al menos una vez en los �ltimos dos meses.

GO
CREATE PROCEDURE amnistiAguirre
AS

UPDATE LM_Tarjetas
SET Saldo=0
WHERE Saldo<0
GO

EXECUTE amnistiAguirre

--Ejercicio 1
--Crea un procedimiento RecargarTarjeta que reciba como par�metros el ID de una tarjeta y un importe y actualice el saldo de la tarjeta sum�ndole dicho 
--importe, adem�s de grabar la correspondiente recarga

GO
ALTER PROCEDURE RecargarTarjeta
@IDTarjeta AS int,
@Importe AS int
AS
--Primero realizamos la recarga
UPDATE LM_Tarjetas
SET Saldo=Saldo+@Importe
WHERE ID=@IDTarjeta

--Ahora la grabamos en la tabla recargas
INSERT INTO LM_Recargas (ID, ID_Tarjeta, Cantidad_Recarga, Momento_Recarga, SaldoResultante)
VALUES
(NEWID() ,@IDTarjeta, @Importe, CURRENT_TIMESTAMP, (SELECT Saldo FROM LM_Tarjetas WHERE ID=@IDTarjeta))
GO

EXECUTE RecargarTarjeta 2, 5

--Ejercicio 2
--Crea un procedimiento almacenado llamado PasajeroSale que reciba como par�metros el ID de una tarjeta, el ID de una estaci�n y una fecha/hora 
--(opcional). El procedimiento se llamar� cuando un pasajero pasa su tarjeta por uno de los tornos de salida del metro. Su misi�n es grabar la salida 
--en la tabla LM_Viajes. Para ello deber� localizar la entrada que corresponda, que ser� la �ltima entrada correspondiente al mismo pasajero y har� 
--un update de las columnas que corresponda. Si no existe la entrada, grabaremos una nueva fila en LM_Viajes dejando a NULL la estaci�n y el momento 
--de entrada. Si se omite el par�metro de la fecha/hora, se tomar� la actual.

GO
CREATE PROCEDURE PasajeroSale
@IDTarjeta AS int,
@IDEstacion AS smallint,
@FechaHora AS datetime
AS
-- Primero comprobamos si el par�metro FechaHora est� en null o no, si lo est�, le asignaremos la fecha y la hora del sistema.
IF (@FechaHora IS NULL)
BEGIN
	SET @FechaHora = CURRENT_TIMESTAMP
END

-- Ahora comprobamos la entrada m�s cercana del pasajero con la fecha pasada por par�metros
DECLARE @IDViaje int
SET @IDViaje=(SELECT TOP 1 ID
FROM LM_Viajes
WHERE IDTarjeta=27
ORDER BY MomentoEntrada DESC)

-- Ahora comprobamos si ese viaje tiene el momento de salida en NULL, si es el caso, actualizaremos el mismo viaje con la fecha pasada por par�metros,
-- en otro caso, crearemos un viaje nuevo con los datos disponibles, dejando el moomento de entrada 
IF (SELECT MomentoSalida FROM LM_Viajes WHERE ID=@IDViaje) IS NULL
	BEGIN
		UPDATE LM_Viajes
		SET MomentoSalida=@FechaHora, IDEstacionSalida=@IDEstacion
		WHERE ID=@IDViaje
		PRINT('Se ha a�adido la salida al viaje')
	END
ELSE
	BEGIN
		INSERT INTO LM_Viajes (IDTarjeta, IDEstacionSalida, MomentoSalida)
		VALUES
		(@IDTarjeta, @IDEstacion, @FechaHora)
		PRINT('Se a�adi� una nueva entrada, el momento de entrada se ha dejado en NULL')
	END
GO

EXECUTE PasajeroSale 9, 5, '20170225 15:57'

SELECT * FROM LM_Viajes

--Ejercicio 3
--A veces, un pasajero reclama que le hemos cobrado un viaje de forma indebida. Escribe un procedimiento que reciba como par�metro el ID de un pasajero
--y la fecha y hora de la entrada en el metro y anule ese viaje, actualizando adem�s el saldo de la tarjeta que utiliz�.

GO
ALTER PROCEDURE reclamarCobro
@IDPasajero AS int,
@FechaHoraEntrada AS smalldatetime
AS
--Primero le devolvemos el importe del viaje al pasajero
DECLARE @ImporteViaje AS smallmoney
SET @ImporteViaje = (SELECT Importe_Viaje FROM LM_Viajes AS V 
					INNER JOIN LM_Tarjetas AS T ON T.ID=V.IDTarjeta
					WHERE T.IDPasajero=@IDPasajero AND V.MomentoEntrada=@FechaHoraEntrada)
UPDATE LM_Tarjetas
SET Saldo=Saldo+@ImporteViaje
WHERE IDPasajero=@IDPasajero
PRINT('Se ha devuelto correctamente el importe del viaje a la cuenta del pasajero')

--Ahora borramos el viaje
DELETE V FROM LM_Viajes AS V INNER JOIN LM_Tarjetas AS T ON T.ID=V.IDTarjeta
WHERE T.IDPasajero=@IDPasajero AND V.MomentoEntrada=@FechaHoraEntrada
PRINT('El viaje se ha eliminado correctamente de la base de datos')
GO

DECLARE @fechiya AS smalldatetime
SET @fechiya='20170225 07:30'
EXECUTE reclamarCobro 220, @fechiya

select * from LM_viajes inner join LM_Tarjetas AS T ON LM_Viajes.IDTarjeta=T.ID

--Ejercicio 4
--La empresa de Metro realiza una campa�a de promoci�n para pasajeros fieles.Crea un procedimiento almacenado que recargue saldo a los pasajeros que 
--cumplan determinados requisitos. Se recargar�n N1 euros a los pasajeros que hayan consumido m�s de 30 euros en el mes anterior (considerar mes 
--completo, del d�a 1 al fin) y N2 euros a los que hayan utilizado m�s de 10 veces alguna estaci�n de las zonas 3 o 4. Los valores de N1 y N2 se 
--pasar�n como par�metros. Si se omiten, se tomar� el valor 5. Ambos premios son excluyentes. Si alg�n pasajero cumple ambas condiciones se le aplicar�
--la que suponga mayor bonificaci�n de las dos.

--Cambiamos la condici�n del "�ltimo mes", ya que los viajes que hay en la base de datos son de febrero, as� que tendremos en cuenta los 4 �ltimos meses

--Hacemos una consulta que devuelva la cantidad de dinero que ha gastado cada pasajero durante los �ltimos dos meses
SELECT T.IDPasajero, SUM(V.Importe_Viaje) AS ImporteTotal 
FROM LM_Tarjetas AS T
INNER JOIN LM_Viajes AS V ON V.IDTarjeta=T.ID 
WHERE DATEDIFF(MONTH, V.MomentoEntrada, CURRENT_TIMESTAMP)<4
GROUP BY T.IDPasajero
HAVING SUM(V.Importe_Viaje)>30 

-- Ahora hacemos otra consulta para saber qu� pasajeros han utilizado m�s de 10 veces alguna estacion de las zonas 3 o 4 en el �ltimo mes
SELECT DISTINCT T.IDPasajero
FROM LM_Tarjetas AS T
INNER JOIN LM_Viajes AS V ON V.IDTarjeta=T.ID
INNER JOIN LM_Estaciones AS E1 ON E1.ID=V.IDEstacionEntrada
INNER JOIN LM_Estaciones AS E2 ON E2.ID=V.IDEstacionSalida
WHERE (E1.Zona_Estacion=3 OR E1.Zona_Estacion=4 OR E2.Zona_Estacion=3 OR E2.Zona_Estacion=4) AND 
DATEDIFF(MONTH, V.MomentoEntrada, CURRENT_TIMESTAMP)<4
GROUP BY T.IDPasajero
HAVING COUNT(T.ID)>10



GO
CREATE PROCEDURE promoFiel
@N1 AS smallmoney,
@N2 AS smallmoney
AS
--Primero comprobamos si los valores N1 y N2 son null, si lo son, se tomar� el valor 5
IF @N1 IS NULL
	BEGIN
		SET @N1=5
	END
IF @N2 IS NULL
	BEGIN
		SET @N2=5
	END


	-- activamos la promo a los que hayan gastado m�s de 30 euros en el �ltimo mes
	UPDATE LM_Tarjetas
	SET Saldo=Saldo+@N1
	WHERE IDPasajero IN (
	SELECT T.IDPasajero 
	FROM LM_Tarjetas AS T
	INNER JOIN LM_Viajes AS V ON V.IDTarjeta=T.ID 
	WHERE DATEDIFF(MONTH, V.MomentoEntrada, CURRENT_TIMESTAMP)<1
	GROUP BY T.IDPasajero
	HAVING SUM(V.Importe_Viaje)>=30)

	-- ahora activamos la promo a aquellos que hayan utilizado m�s de 10 veces una estaci�n de zona 3 o 4 
	UPDATE LM_Tarjetas
	SET Saldo=Saldo+@N2
	WHERE IDPasajero IN(
	SELECT DISTINCT T.IDPasajero, COUNT(T.ID) AS ContadorZonas
	FROM LM_Tarjetas AS T
	INNER JOIN LM_Viajes AS V ON V.IDTarjeta=T.ID
	INNER JOIN LM_Estaciones AS E1 ON E1.ID=V.IDEstacionEntrada
	INNER JOIN LM_Estaciones AS E2 ON E2.ID=V.IDEstacionSalida
	WHERE (E1.Zona_Estacion=3 OR E1.Zona_Estacion=4 OR E2.Zona_Estacion=3 OR E2.Zona_Estacion=4) AND 
	DATEDIFF(MONTH, V.MomentoEntrada, CURRENT_TIMESTAMP)<4
	GROUP BY T.IDPasajero
	HAVING COUNT(T.ID)>10)

GO


--Ejercicio 5
--Crea una funci�n que nos devuelva verdadero si es posible que un pasajero haya subido a un tren en un determinado viaje. Se pasar� como par�metro 
--el c�digo del viaje y la matr�cula del tren. (Supongo que la ID Del pasajero se pasar� por par�metro tambi�n)

ALTER FUNCTION comprobarPasajeroViaje (@CodigoViaje int, @MatriculaTren char(7), @IDPasajero int)
RETURNS bit
AS
BEGIN
	DECLARE @PasajeroTren bit
	IF (SELECT DISTINCT TA.ID 
	FROM LM_Trenes AS T 
	INNER JOIN LM_Recorridos AS R ON R.Tren=T.ID
	INNER JOIN LM_Estaciones AS E ON E.ID=R.estacion
	INNER JOIN LM_Viajes AS V ON V.IDEstacionEntrada=E.ID
	INNER JOIN LM_Tarjetas AS TA ON TA.ID=V.IDTarjeta
	WHERE V.ID=@CodigoViaje AND T.Matricula=@MatriculaTren AND TA.IDPasajero=@IDPasajero) IS NULL
		BEGIN
			SET @PasajeroTren=0
		END
	ELSE
		BEGIN
			SET @PasajeroTren=1
		END
	RETURN @PasajeroTren
END
GO

PRINT( dbo.comprobarPasajeroViaje(77, '5608GLZ', 12))

--Ejercicio 6
--Crea un procedimiento SustituirTarjeta que Cree una nueva tarjeta y la asigne al mismo usuario y con el mismo saldo que otra tarjeta existente. 
--El c�digo de la tarjeta a sustituir se pasar� como par�metro.

GO
CREATE PROCEDURE SustituirTarjeta
@IDTarjeta AS int
AS
	--  creamos la tarjeta nueva
	INSERT INTO LM_Tarjetas (Saldo, IDPasajero)
	(SELECT Saldo, IDPasajero FROM LM_Tarjetas WHERE ID=@IDTarjeta)
GO

EXECUTE SustituirTarjeta 23

--Ejercicio 7
--Las estaciones de la zona 3 tienen ciertas deficiencias, lo que nos ha obligado a introducir una serie de modificaciones en los trenes  para cumplir 
--las medidas de seguridad. A consecuencia de estas modificaciones, la capacidad de los trenes se ha visto reducida en 6 plazas para los trenes de tipo 
--1 y 4 plazas para los trenes de tipo 2. Realiza un procedimiento al que se pase un intervalo de tiempo y modifique la capacidad de todos los trenes 
--que hayan circulado m�s de una vez por alguna estaci�n de la zona 3 en ese intervalo.

GO
CREATE PROCEDURE modificarCapacidadTren
@Inicio datetime, 
@Fin datetime
AS
	UPDATE LM_Trenes 
	SET Capacidad = CASE
					WHEN Tipo=1 THEN Capacidad-6
					WHEN Tipo=2 THEN Capacidad-4
					END
	WHERE ID IN( 
	SELECT T.ID
	FROM LM_Trenes AS T 
	INNER JOIN LM_Recorridos AS R ON R.Tren=T.ID
	INNER JOIN LM_Estaciones AS E ON E.ID=R.estacion
	INNER JOIN LM_Viajes AS V ON V.IDEstacionEntrada=E.ID OR V.IDEstacionSalida=E.ID
	WHERE (V.MomentoEntrada BETWEEN @Inicio AND @Fin) AND (MomentoSalida BETWEEN @Inicio AND @Fin))
GO

BEGIN TRANSACTION
EXECUTE modificarCapacidadTren '20170201', '20170301'
ROLLBACK TRANSACTION

SELECT *FROM LM_Trenes