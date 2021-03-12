USE AirLeo
GO

--Ejercicio 1
--Escribe un procedimiento que cancele un pasaje y las tarjetas de embarque asociadas.
--Recibir� como par�metros el ID del pasaje.

ALTER PROCEDURE cancelarPasaje
	@Pasaje AS int 
AS
	DELETE FROM AL_Vuelos_Pasajes
	WHERE Numero_Pasaje=@Pasaje
	DELETE FROM Al_Tarjetas
	WHERE Numero_Pasaje=@Pasaje
	DELETE FROM Al_Pasajes
	WHERE Numero=@Pasaje
GO

EXECUTE cancelarPasaje 24

--Ejercicio 2
--Escribe un procedimiento almacenado que reciba como par�metro el ID de un pasajero y devuelva en un par�metro de salida el n�mero de vuelos 
--diferentes que ha tomado ese pasajero.

CREATE PROCEDURE numeroVuelos
	@IDPasajero AS char(9),
	@Vuelos AS int OUTPUT
AS
	SELECT @Vuelos = COUNT(PJ.Numero)
		FROM AL_Pasajeros AS P
		INNER JOIN AL_Pasajes AS PJ ON PJ.ID_Pasajero=P.ID
	WHERE P.ID=@IDPasajero
GO

DECLARE @Vuelos INT
EXECUTE numeroVuelos 'A055', @Vuelos OUTPUT
PRINT @Vuelos

--Ejercicio 3
--Escribe un procedimiento almacenado que reciba como par�metro el ID de un pasajero y dos fechas y nos devuelva en otro par�metro (de salida) el 
--n�mero de horas que ese pasajero ha volado durante ese intervalo de fechas.

GO
CREATE PROCEDURE horasVoladas
	@IDPasajero AS char(9),
	@Inicio AS date,
	@Fin AS date,
	@HorasVoladas AS decimal(6,2) OUTPUT
AS
SELECT @HorasVoladas = SUM(DATEDIFF(MINUTE, Salida, Llegada))
	FROM AL_Pasajeros AS P
	INNER JOIN AL_Pasajes AS PJ ON PJ.ID_Pasajero=P.ID
	INNER JOIN AL_Vuelos_Pasajes AS VP ON VP.Numero_Pasaje=PJ.Numero
	INNER JOIN AL_Vuelos AS V ON V.Codigo=VP.Codigo_Vuelo
	WHERE (Salida BETWEEN @Inicio AND @Fin) AND (Llegada BETWEEN @Inicio AND @Fin) AND P.ID=@IDPasajero
	SET @HorasVoladas=@HorasVoladas/60
GO

DECLARE @Horas decimal(6,2)
EXECUTE horasVoladas 'A003', '2012-01-12', '2012-01-15', @Horas OUTPUT
PRINT @Horas

--Ejercicio 4
--Escribe un procedimiento que reciba como par�metro todos los datos de un pasajero y un n�mero de vuelo y realice el siguiente proceso:
--En primer lugar, comprobar� si existe el pasajero. Si no es as�, lo dar� de alta.
--A continuaci�n comprobar� si el vuelo tiene plazas disponibles (hay que consultar la capacidad del avi�n) y en caso afirmativo crear� un nuevo 
--pasaje para ese vuelo.

GO
ALTER PROCEDURE crearPasaje
	@IDPasajero AS char(9),
	@Nombre AS varchar(20),
	@Apellidos AS varchar(50),
	@Direccion AS varchar(60),
	@Fecha_Nacimiento AS date,
	@Nacionalidad AS varchar(30),
	@CodigoVuelo AS int
AS
	-- Comprobamos si el pasajero est� registrado o no en la base de datos, si no lo est� ser� a�adido.
	IF NOT EXISTS (SELECT * FROM AL_Pasajeros 
					WHERE ID=@IDPasajero AND Nombre=@Nombre AND Apellidos=@Apellidos AND Fecha_Nacimiento=@Fecha_Nacimiento)
		BEGIN
			PRINT ('El pasajero no est� registrado en la base de datos, vamos a a�adirlo')
			INSERT INTO AL_Pasajeros (ID, Nombre, Apellidos, Direccion, Fecha_Nacimiento, Nacionalidad)
			VALUES (@IDPasajero, @Nombre, @Apellidos, @Direccion, @Fecha_Nacimiento, @Nacionalidad)
			PRINT('Pasajero a�adido correctamente')
		END
	ELSE
		BEGIN
			PRINT('El pasajero ya est� registrado')
		END

	-- SI el n�mero de plazas ocupadas es menor al n�mero de plazas que tiene el avi�n, se crear� el pasaje, en otro caso no se crear�.
	IF ((SELECT COUNT(P.Numero) FROM AL_Pasajes AS P 
			INNER JOIN AL_Vuelos_Pasajes AS VP ON VP.Numero_Pasaje=P.Numero 
			INNER JOIN AL_Vuelos AS V ON V.Codigo=VP.Codigo_Vuelo
			WHERE V.Codigo=@CodigoVuelo) <
		(SELECT (Filas*Asientos_x_Fila) FROM AL_Aviones AS A 
		INNER JOIN AL_Vuelos AS V ON V.Matricula_Avion=A.Matricula WHERE V.Codigo=@CodigoVuelo) )
		BEGIN
			PRINT('El avi�n tiene plazas disponibles, se crear� un pasaje')
			INSERT INTO AL_Pasajes (ID_Pasajero)
			VALUES (@IDPasajero)
			PRINT('El pasaje se ha creado correctamente')
		END
	ELSE
		BEGIN
			PRINT('El avi�n no tiene plazas disponibles, no se puede crear el pasaje')
		END
GO 

EXECUTE crearPasaje 'J666', 'Jes�s', 'Prieto Monge', 'Calle Araquil 12, Sevilla', '1997-01-09', 'Espa�a', 175

--Ejercicio 5
--Escribe un procedimiento almacenado que cancele un vuelo y reubique a sus pasajeros en otro. Se ocupar�n los asientos libres en el vuelo sustituto. 
--Se comprobar� que ambos vuelos realicen el mismo recorrido. Se borrar�n todos los pasajes y las tarjetas de embarque y se generar�n nuevos pasajes.
--No se generar�n nuevas tarjetas de embarque. El vuelo a cancelar y el sustituto se pasar�n como par�metros. Si no se pasa el vuelo sustituto, 
--se buscar� el primer vuelo inmediatamente posterior al cancelado que realice el mismo recorrido.

GO
CREATE PROCEDURE reubicarVuelo
	@VueloACancelar AS int,
	@VueloSustituto AS int
AS
	
GO

--Ejercicio 6
--Escribe un procedimiento al que se pase como par�metros un c�digo de un avi�n y un momento (dato fecha-hora) y nos escriba un mensaje que indique 
--d�nde se encontraba ese avi�n en ese momento. El mensaje puede ser "En vuelo entre los aeropuertos de NombreAeropuertoSalida y 
--NombreaeropuertoLlegada� si el avi�n estaba volando en ese momento, o "En tierra en el aeropuerto NombreAeropuerto� si no est� volando. 
--Para saber en qu� aeropuerto se encuentra el avi�n debemos consultar el �ltimo vuelo que realiz� antes del momento indicado.
--Si se omite el segundo par�metro, se tomar� el momento actual.

GO
CREATE PROCEDURE localizarAvion
	@Matricula AS char(10),
	@Momento AS smalldatetime
AS
	
GO