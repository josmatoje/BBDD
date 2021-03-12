USE TransLeo

GO

/* 1. Crea un funci�n fn_VolumenPaquete que reciba el c�digo de un paquete y nos devuelva
su volumen. El volumen se expresa en litros (dm3) y ser� de tipo decimal (6,2). */

BEGIN TRANSACTION

GO

CREATE FUNCTION fn_VolumenPaquete2 (@CodigoPaquete INT)
RETURNS DECIMAL (12,2) AS
	BEGIN
		DECLARE @Volumen DECIMAl (12,2)
		SELECT @Volumen = Alto*Ancho*Largo
			FROM TL_PaquetesNormales
			RETURN @Volumen * 1000
	END

GO

--ROLLBACK
COMMIT TRANSACTION


SELECT dbo.fn_VolumenPaquete2 (600) AS Volumen


/* 2. Los paquetes normales han de envolverse. Se calcula que la cantidad de papel necesaria
para envolver el paquete es 1,8 veces su superficie. Crea una funci�n fn_PapelEnvolver
que reciba un c�digo de paquete y nos devuelva la cantidad de papel necesaria para
envolverlo, en metros cuadrados.*/

GO

BEGIN TRANSACTION

GO

CREATE FUNCTION fn_PapelEnvolver (@Codigo INT)
RETURNS INT AS
	BEGIN
		DECLARE @Papel INT

		SELECT @Papel = (2 * (Largo * Ancho + Largo * Alto + Ancho * Alto) * 1.8) 
			FROM TL_PaquetesNormales
			WHERE Codigo = @Codigo

		RETURN @Papel
	END

ROLLBACK
COMMIT TRANSACTION

GO

SELECT dbo.fn_PapelEnvolver (600) AS CantidadDePapel

/* 3. Crea una funci�n fn_OcupacionFregoneta a la que se pase el c�digo de un veh�culo y una
fecha y nos indique cu�l es el volumen total que ocupan los paquetes que ese veh�culo
entreg� en el d�a en cuesti�n. Usa las funciones de fecha y hora para comparar s�lo el d�a,
independientemente de la hora*/

BEGIN TRANSACTION

GO

ALTER FUNCTION fn_OcupacionFregoneta (@Codigo INT, @Fecha SMALLDATETIME)
RETURNS INT AS
	BEGIN
		DECLARE @Volumen INT

		SELECT @Volumen = SUM (Alto*Ancho*Largo)
			FROM TL_PaquetesNormales
			WHERE CAST (fechaEntrega AS DATE) = DATEFROMPARTS (YEAR (@Fecha), MONTH (@Fecha), DAY (@Fecha)) AND codigoFregoneta = @Codigo
		
		RETURN @Volumen
	END

ROLLBACK

COMMIT TRANSACTION

SELECT dbo.fn_OcupacionFregoneta (3, '14/03/2013 00:00') AS VolumenTotal

SELECT *
	FROM TL_PaquetesNormales