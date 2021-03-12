USE AirLeo
GO
/*1.Escribe un procedimiento que cancele un pasaje y las tarjetas de embarque asociadas.
Recibir� como par�metros el ID del pasaje.

Nombre:
	cancelarPasaje
Precondiciones:
	Ninguna
Entradas:
	Un entero
Salidas:
	Ninguna
Postcondiciones:
	Ninguna
*/

CREATE PROCEDURE cancelarPasaje @numPasaje INT
AS
BEGIN
	DELETE FROM AL_Tarjetas WHERE Numero_Pasaje = @numPasaje
	DELETE FROM AL_Vuelos_Pasajes WHERE Numero_Pasaje = @numPasaje
	DELETE FROM AL_Pasajes WHERE Numero = @numPasaje
END
GO

BEGIN TRANSACTION
EXECUTE cancelarPasaje 1
ROLLBACK

GO

/*2.Escribe un procedimiento almacenado que reciba como par�metro el ID de un pasajero
y devuelva en un par�metro de salida el n�mero de vuelos diferentes que ha tomado ese pasajero.
Nombre:
	vuelosPasajero
Precondiciones:
	Ninguna
Entradas:
	Una cadena
Salidas:
	Un entero
Postcondiciones:
	Se devolver� como par�metro de salida el n�mero de vuelos realizados por el pasajero con ID dado
*/
CREATE PROCEDURE vuelosPasajero @idPasajero CHAR(9), @numVuelos INT OUTPUT
AS
BEGIN
	SELECT
	@numVuelos = COUNT(*)
	FROM AL_Vuelos AS V
	INNER JOIN AL_Vuelos_Pasajes AS VP
	ON V.Codigo = VP.Codigo_Vuelo
	INNER JOIN AL_Pasajes AS PES
	ON VP.Numero_Pasaje = PES.Numero
	WHERE PES.ID_Pasajero = @idPasajero
END
GO

DECLARE @vuelos INT
EXECUTE vuelosPasajero 'A003', @vuelos OUTPUT
PRINT 'Vuelos realizados: '+CAST(@vuelos AS VARCHAR)
GO

/*3.Escribe un procedimiento almacenado que reciba como par�metro el ID de un pasajero y dos fechas
y nos devuelva en otro par�metro (de salida) el n�mero de horas que ese pasajero ha volado durante ese intervalo de fechas.
Nombre:
	horasPasajeroEntreFechas
Precondiciones:
	Ninguna
Entradas:
	Una cadena y dos fechas
Salidas:
	Un entero
Precondiciones:
	Se devolver� como par�metro de salida el n�mero de horas voladas por el pasajero dado entre las fechas dadas
*/
CREATE PROCEDURE horasPasajeroEntreFechas @idPasajero CHAR(9), @fechaInicio DATE, @fechaFin DATE, @horasVoladas INT OUTPUT
AS
BEGIN
	SELECT
		@horasVoladas = SUM(DATEDIFF(HOUR, V.Salida, V.Llegada))
	FROM AL_Pasajeros AS POS
		INNER JOIN AL_Pasajes AS PES
		ON POS.ID = PES.ID_Pasajero
		INNER JOIN AL_Vuelos_Pasajes AS VP
		ON PES.Numero = VP.Numero_Pasaje
		INNER JOIN AL_Vuelos AS V
		ON VP.Codigo_Vuelo = V.Codigo
	WHERE POS.ID = @idPasajero AND (V.Salida BETWEEN @fechaInicio AND @fechaFin) AND V.Llegada BETWEEN @fechaInicio AND @fechaFin
END
GO

DECLARE @horasVoladas INT
DECLARE @fechaInicio DATE
SET @fechaInicio = DATEFROMPARTS(2008,1,1)
DECLARE @fechaFin DATE
SET @fechaFin = DATEFROMPARTS(2008,12,31)

EXECUTE horasPasajeroEntreFechas 'A003', @fechaInicio, @fechaFin, @horasVoladas OUTPUT
PRINT 'Horas voladas: ' + CAST(@horasVoladas AS VARCHAR)
GO

/*4.Escribe un procedimiento que reciba como par�metro todos los datos de un pasajero
y un n�mero de vuelo y realice el siguiente proceso:
En primer lugar, comprobar� si existe el pasajero. Si no es as�, lo dar� de alta.
A continuaci�n comprobar� si el vuelo tiene plazas disponibles (hay que consultar la capacidad del avi�n)
y en caso afirmativo crear� un nuevo pasaje para ese vuelo.	

Nombre:
	crearPasajePasajero
Precondiciones:
	Ninguna
Entradas:
	Un CHAR, cuatro VARCHAR, un DATE, un INT
	(id, nombre, apellidos, direcci�n, fecha de nacimiento, nacionalidad, codigo de vuelo)
Salidas:
	Ninguna
Postcondiciones:
	Si no coinciden todos los datos con los de un pasajero, ser� creado.
*/
CREATE PROCEDURE crearPasajePasajero @id CHAR(9), @nombre VARCHAR(20), @apellidos VARCHAR(50), @direccion VARCHAR(60),
	@fechaNacimiento DATE, @nacionalidad VARCHAR(30), @codigoVuelo INT
AS
BEGIN
	DECLARE @capacidadAvion INT
	DECLARE @plazasOcupadas INT
	DECLARE @numeroPasaje INT

	--Comprobar si el pasajero no existe y crearlo si se da el caso
	IF NOT EXISTS(
		SELECT * FROM AL_Pasajeros
		WHERE
			ID = @id AND
			Nombre = @nombre AND
			Apellidos = @apellidos AND
			Direccion = @direccion AND
			Fecha_Nacimiento = @fechaNacimiento AND
			Nacionalidad = @nacionalidad)
		BEGIN
			INSERT INTO AL_Pasajeros VALUES (@id, @nombre, @apellidos, @direccion, @fechaNacimiento, @nacionalidad)
			PRINT 'El usuario ha sido creado'
		END
	ELSE
		BEGIN
			PRINT 'El usuario ya exist�a'
		END

	--Comprobar la capacidad del avi�n
	SELECT
		@capacidadAvion = A.Filas * A.Asientos_x_Fila
	FROM AL_Vuelos AS V
	INNER JOIN AL_Aviones AS A
	ON V.Matricula_Avion = A.Matricula
	WHERE V.Codigo = @codigoVuelo

	PRINT 'Capacidad del avi�n: '+CAST(@capacidadAvion AS VARCHAR)

	--Comprobar plazas ocupadas
	BEGIN TRANSACTION --Comprobar plazas y crear pasaje en la misma transacci�n para no exceder las plazas
	SELECT
		@plazasOcupadas = COUNT(*)
	FROM
		AL_Pasajeros AS POS
		INNER JOIN AL_Pasajes AS PES
		ON POS.ID = PES.ID_Pasajero
		INNER JOIN AL_Vuelos_Pasajes VP
		ON PES.Numero = VP.Numero_Pasaje
		INNER JOIN AL_Vuelos AS V
		ON VP.Codigo_Vuelo = V.Codigo
	WHERE
		V.Codigo = @codigoVuelo
	PRINT 'Plazas ocupadas: '+ CAST(@plazasOcupadas AS VARCHAR)

	--Crear el pasaje si quedan plazas libres
	IF(@plazasOcupadas < @capacidadAvion)
		BEGIN
			INSERT INTO AL_Pasajes VALUES (@id)
			SET @numeroPasaje = @@IDENTITY --�ANTES O DESPU�S?
			INSERT INTO AL_Vuelos_Pasajes VALUES (@codigoVuelo, @numeroPasaje, 'N')
			PRINT 'Pasaje creado'
		END
	ELSE
		BEGIN
			PRINT 'El avi�n est� lleno, no se puede incluir el pasaje'
		END
	COMMIT TRANSACTION
END

GO

DECLARE @fechaNacimiento DATE
SET @fechaNacimiento = DATEFROMPARTS(1995,11,10)
EXECUTE crearPasajePasajero
	'A027', 'Pepito', 'P�rez', 'Calle Falsa 123', @fechaNacimiento, 'Hispania', 20

SELECT * FROM AL_Pasajeros WHERE ID = 'A027'
SELECT * FROM AL_Pasajes WHERE ID_Pasajero = 'A027'
SELECT * FROM AL_Vuelos_Pasajes WHERE Numero_Pasaje = 502 OR Numero_Pasaje = 503
GO

/*5.Escribe un procedimiento almacenado que cancele un vuelo y reubique a sus pasajeros en otro.
Se ocupar�n los asientos libres en el vuelo sustituto.
Se comprobar� que ambos vuelos realicen el mismo recorrido. HECHO
Se borrar�n todos los pasajes y las tarjetas de embarque HECHO
y se generar�n nuevos pasajes.
No se generar�n nuevas tarjetas de embarque. HECHO
El vuelo a cancelar y el sustituto se pasar�n como par�metros. HECHO
Si no se pasa el vuelo sustituto, se buscar� el primer vuelo inmediatamente posterior al cancelado que
realice el mismo recorrido.

Nombre:
	cancelarVuelo
Precondiciones:
	Ninguna
Entradas:
	Dos INT
Salidas:
	Ninguna
Postcondiciones:
	Ninguna
Comentarios:
	Solo se reasignar�n tantos pasajeros como asientos libres haya en el vuelo sustituto
*/

DECLARE @vueloOriginal INT
DECLARE @vueloSustituto INT
DECLARE @pasajesOriginal TABLE (Numero_Pasaje INT)
SET @vueloOriginal = 20
SET @vueloSustituto = 44

BEGIN TRANSACTION
--Comprueba que tengan los mismos aeropuertos de salida y llegada
IF( (SELECT Aeropuerto_Salida FROM AL_Vuelos WHERE Codigo = @vueloOriginal) = (SELECT Aeropuerto_Salida FROM AL_Vuelos WHERE Codigo = @vueloSustituto) AND
	(SELECT Aeropuerto_Llegada FROM AL_Vuelos WHERE Codigo = @vueloOriginal) = (SELECT Aeropuerto_Llegada FROM AL_Vuelos WHERE Codigo = @vueloSustituto)
	)
BEGIN
	PRINT 'Los vuelos son compatibles'
	--BEGIN TRANSACTION
	DELETE AL_Tarjetas WHERE Codigo_Vuelo = @vueloOriginal
	/*Se guardan los n�meros de los pasajes en una variable tipo tabla para
	poder borrar las filas de AL_Vuelos_Pasajes antes que las de AL_Vuelos*/
	INSERT INTO @pasajesOriginal SELECT Numero_Pasaje FROM AL_Vuelos_Pasajes WHERE Codigo_Vuelo = 20
	DELETE AL_Vuelos_Pasajes WHERE Codigo_Vuelo = @vueloOriginal
	DELETE AL_Pasajes WHERE Numero IN (SELECT * FROM @pasajesOriginal)
	DELETE AL_Vuelos WHERE Codigo = @vueloOriginal
	--COMMIT TRANSACTION
	PRINT 'Tarjetas, pasajes y vuelo borrados'
END
ELSE
	RAISERROR('Los vuelos no son compatibles',16,1)
ROLLBACK TRANSACTION

------------------------------------------------------------------------------------------------------------------------------------------------------------

DECLARE @contador INT
DECLARE @numPasajeros INT
DECLARE @pasajero TABLE(id CHAR(9), nombre VARCHAR(20), apellidos VARCHAR(50), direccion VARCHAR(60),
	fechaNacimiento DATE, nacionalidad VARCHAR(30))
SET @contador = 1
SET @numPasajeros = 0

--Se obtiene el n�mero de pasajeros
SELECT
	@numPasajeros = COUNT(*)
FROM
	AL_Vuelos AS V
	INNER JOIN AL_Vuelos_Pasajes AS VP
	ON V.Codigo = VP.Codigo_Vuelo
	INNER JOIN AL_Pasajes AS PES
	ON VP.Numero_Pasaje = PES.Numero
	INNER JOIN AL_Pasajeros AS POS
	ON PES.ID_Pasajero = POS.ID
WHERE
	Codigo = 20

WHILE @contador < @numPasajeros
BEGIN
	--Se guarda cada pasajero
	BEGIN TRANSACTION
	DECLARE @pasajero TABLE(id CHAR(9), nombre VARCHAR(20), apellidos VARCHAR(50), direccion VARCHAR(60),
	fechaNacimiento DATE, nacionalidad VARCHAR(30))
	INSERT INTO @pasajero SELECT ID, Nombre, Apellidos, Direccion, Fecha_Nacimiento, Nacionalidad FROM
		(SELECT
			ROW_NUMBER() OVER (ORDER BY POS.ID) AS RN,
			POS.ID, POS.Nombre, POS.Apellidos, POS.Direccion, POS.Fecha_Nacimiento, POS.Nacionalidad
		FROM
			AL_Vuelos AS V
			INNER JOIN AL_Vuelos_Pasajes AS VP
			ON V.Codigo = VP.Codigo_Vuelo
			INNER JOIN AL_Pasajes AS PES
			ON VP.Numero_Pasaje = PES.Numero
			INNER JOIN AL_Pasajeros AS POS
			ON PES.ID_Pasajero = POS.ID
		WHERE
			Codigo = 20) AS SC
	WHERE
		SC.RN = 3
	EXECUTE crearPasajePasajero 
	ROLLBACK TRANSACTION
END

/*6.Escribe un procedimiento al que se pase como par�metros un c�digo de un avi�n y un momento (dato fecha-hora)
y nos escriba un mensaje que indique d�nde se encontraba ese avi�n en ese momento.
El mensaje puede ser "En vuelo entre los aeropuertos de NombreAeropuertoSalida y NombreaeropuertoLlegada�
si el avi�n estaba volando en ese momento, o "En tierra en el aeropuerto NombreAeropuerto� si no est� volando.
Para saber en qu� aeropuerto se encuentra el avi�n debemos consultar el �ltimo vuelo que realiz� antes del momento indicado.
Si se omite el segundo par�metro, se tomar� el momento actual.*/