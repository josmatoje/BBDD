--CONSULTAS RANDOMS 
GO 
USE HBleO
GO
--Consulta Pedro

--SELECTs

SELECT * FROM HCapitulos
SELECT * FROM HContenidos
SELECT * FROM HGeneros
SELECT * FROM HPeliculas
SELECT * FROM HPeliculasGeneros
SELECT * FROM HPerfiles
SELECT * FROM HRecibos
SELECT * FROM HSeries
SELECT * FROM HSuscripciones
SELECT * FROM HTemporadas
SELECT * FROM HTiposSuscripcion
SELECT * FROM HTitulares
SELECT * FROM HVisionados


--TRANSACCIONES
BEGIN TRANSACTION
COMMIT
ROLLBACK
GO
CREATE OR ALTER FUNCTION FN_TotalVisionado (@IdSuscripcion Int) RETURNS TABLE AS
RETURN(
	SELECT HP.ID,SUM(DATEDIFF(MINUTE,MinutoInicio,MinutoFin)) AS [Minutos Visionados] FROM HVisionados AS HV
	INNER JOIN HPerfiles AS HP ON HV.IDPerfil=HP.ID
	WHERE HP.IDSuscripcion=@IdSuscripcion
	GROUP BY HP.ID 
	)
GO
GO
CREATE OR ALTER PROCEDURE PC_CrearRecibo @IdSuscripcion Int  AS
BEGIN 
	
END
GO

--Funciones Juanjo

--CALCULANDO EL IMPORTE EXTRA

--FORMA 1
SELECT S.ID,SUM(CASE S.Tipo WHEN 'E' THEN PP.precioE 
WHEN 'S' THEN PP.precioS ELSE 0 END)
FROM HSuscripciones AS S
INNER JOIN HPerfiles AS P ON S.ID=P.IDSuscripcion INNER JOIN HVisionados AS V 
ON P.ID=V.IDPerfil INNER JOIN HContenidos AS C ON V.IDContenido=C.ID
INNER JOIN HPeliculas AS PP ON C.ID=PP.ID
WHERE C.tipo='P'
GROUP BY S.ID


--FORMA 2
DECLARE @Importe money
SET @Importe= (SELECT S.ID, CASE S.tipo WHEN 'E' THEN SUM(PP.precioE)
WHEN 'S' THEN SUM(PP.precioS) END 
FROM HSuscripciones AS S
INNER JOIN HPerfiles AS P ON S.ID=P.IDSuscripcion INNER JOIN HVisionados AS V 
ON P.ID=V.IDPerfil INNER JOIN HContenidos AS C ON V.IDContenido=C.ID
INNER JOIN HPeliculas AS PP ON C.ID=PP.ID
WHERE C.tipo='P'
GROUP BY S.ID)


--CANTIDAD DE PELICULAS COMPRADAS POR USUARIOS
SELECT NPU.ID,COUNT(*) AS CantidadPeliculas FROM 
(SELECT S.ID,P.ID AS IDPeliculas, COUNT(DISTINCT P.ID) AS NPeliculas FROM HContenidos AS CN INNER JOIN HPeliculas AS P ON CN.ID=P.ID
INNER JOIN HVisionados AS V ON CN.ID=V.IDContenido INNER JOIN HPerfiles AS PP ON V.IDPerfil=PP.ID
INNER JOIN HSuscripciones AS S ON PP.IDSuscripcion=S.ID
WHERE CN.tipo='P'
GROUP BY S.ID,P.ID) AS NPU GROUP BY NPU.ID
--Procedimiento Santi
GO
/*
* CABECERA: PROCEDURE PC_CrearRecibo @IdSuscripcion Int, @InicioPeriodo datetime, @FinPeriodo datetime
* ENTRADA: @IdSuscripcion Int, @InicioPeriodo datetime, @FinPeriodo datetime
* SALIDA: Ninguna
* Postcondiciones: Procedimiento para crear un recibo e insertar en la tabla
*/
CREATE OR ALTER PROCEDURE PC_CrearRecibo @IdSuscripcion Int, @InicioPeriodo datetime, @FinPeriodo datetime  AS
BEGIN 

    INSERT INTO HRecibos
    SELECT @IdSuscripcion, @InicioPeriodo, @FinPeriodo, CURRENT_TIMESTAMP, TS.importeMensual * DATEDIFF(MONTH, @InicioPeriodo, @FinPeriodo), CASE WHEN TS.tipo = 'P' THEN 0
                                                                                                                                                  WHEN TS.tipo = 'S' THEN SUM(PEL.precioS)
                                                                                                                                                  WHEN TS.tipo = 'E' THEN SUM(PEL.precioE)
                                                                                                                                                  END 
        FROM HSuscripciones AS S

        INNER JOIN HTiposSuscripcion AS TS ON S.tipo = TS.tipo
        INNER JOIN HPerfiles AS P ON S.ID = P.IDSuscripcion
        INNER JOIN HVisionados AS V ON P.ID = V.IDPerfil
        INNER JOIN HPeliculas AS PEL ON V.IDContenido = PEL.ID

END
GO