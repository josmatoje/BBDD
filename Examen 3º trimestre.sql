--Examen Jose Maria Mata Ojeda
--Opcion B
USE HBleO
--Ejercicio 1 (2 Puntos)

GO
--Funcion Auxiliar
CREATE OR ALTER FUNCTION F_MinVistoSerie (@IdSuscripcion int) RETURNS TABLE AS
--Nombre: F_MinVistoSerie (Funcion Inline)
--Descripción: Pide el ID de una suscripcion y calcula los minutos que se han visto de cada serie
--Entradas: Id de una suscripcion
--Salidas: Tabla con el id y el titulo de la serie y los minutos que se han visto de esta
RETURN(
	SELECT S.ID, S.titulo, SUM(DATEDIFF(MINUTE, V.MinutoInicio,V.MinutoFin)) AS [Minutos vistos] FROM HPerfiles AS P
			INNER JOIN HVisionados AS V ON P.ID=V.IDPerfil
			INNER JOIN HCapitulos AS C ON V.IDContenido=C.ID --Al ser contenido una generalizacion de capitulos, contenido y capitulos tienen el mismo ID
			INNER JOIN HSeries AS S ON C.IDSerie=S.ID --La tabla capitulos contiene el IDSerie, podemos hacer inner join directamente de la tabla 
														-- serie ya que solo nos interesa el nombreWHERE P.IDSuscripcion=@IDSuscripcion
			WHERE P.IDSuscripcion=@IDSuscripcion
			GROUP BY S.ID,S.titulo) --Agrupamos por la PK q es menos costoso
GO


CREATE OR ALTER FUNCTION F_SerieFavorita (@IDSuscripcion int) RETURNS varchar(40) AS
--Nombre: F_SerieFavorita (Funcion Escalar)
--Descripción: Pide el ID de una suscripcion y calcula cual es la sere
--Entradas: Id de una suscripcion
--Salidas: Nombre de la serie favorita

BEGIN
	DECLARE @SerieFavorita varchar(40)
	DECLARE @MinutosMaximos int

	SELECT @MinutosMaximos = MAX([Minutos vistos]) FROM dbo.F_MinVistoSerie(@IDSuscripcion) 
	SELECT @SerieFavorita= titulo FROM dbo.F_MinVistoSerie(@IDSuscripcion) 
		WHERE [Minutos vistos]=@MinutosMaximos
	RETURN @SerieFavorita
END

GO
--PRUEBA
--SELECT dbo.F_SerieFavorita(8)
--SELECT * FROM dbo.F_MinVistoSerie(8) ORDER BY [Minutos vistos] DESC

--Ejercicio 2 (2 Puntos)


GO
CREATE OR ALTER FUNCTION ImporteExtraGastado (@IDSuscripcion int, @MomentoInicio date, @MomentoFin date) RETURNS smallmoney AS
--Nombre:
--Descripción:
--Entradas:
--Salidas: DEVUELVE CINCO
BEGIN
	DECLARE @ImporteExtra smallmoney
	SET @ImporteExtra= 5
						--(SELECT CASE S.tipo 
						--			WHEN 'E' THEN SUM(PP.precioE)
						--			WHEN 'S' THEN SUM(PP.precioS) 
						--		END 
						--FROM HSuscripciones AS S
						--INNER JOIN HPerfiles AS P ON S.ID=P.IDSuscripcion 
						--INNER JOIN HVisionados AS V ON P.ID=V.IDPerfil 
						--INNER JOIN HContenidos AS C ON V.IDContenido=C.ID
						--INNER JOIN HPeliculas AS PP ON C.ID=PP.ID
						--WHERE C.tipo='P' AND @IDSuscripcion=P.IDSuscripcion
						--		AND V.FechaHora BETWEEN @MomentoInicio AND @MomentoFin)
	RETURN @ImporteExtra
END

GO
--PRUEBA
--SELECT dbo.Nombredelafuncion()


--Ejercicio 3 (3 Puntos)

GO
--Funcion Auxiliar
CREATE OR ALTER FUNCTION F_MinVistoTemporadaSerie (@IdSerie smallint, @Temporada tinyint) RETURNS int AS
--Nombre: F_MinVistoTemporadaSerie (Funcion Escalar)
--Descripción: Pide el ID de una serie y el numero de temporada y devuelve los minutos que se han visto de esta
--Entradas: Id de una serie y numero de temporada
--Salidas: int con los minutos totales vistos de esa temporada
BEGIN
	DECLARE @MinutosVistos int
	SELECT @MinutosVistos= SUM(DATEDIFF(MINUTE, V.MinutoInicio,V.MinutoFin)) FROM HVisionados AS V
			INNER JOIN HCapitulos AS C ON V.IDContenido=C.ID
			WHERE C.IDSerie=@IdSerie AND C.numeroTemporada=@Temporada
			GROUP BY C.numeroTemporada --Agrupamos por la PK q es menos costoso
	RETURN @MinutosVistos
END
GO

--PRUEBAS
--SELECT dbo.F_MinVistoTemporadaSerie(9,1)
--SELECT dbo.F_MinVistoTemporadaSerie(9,2)
--SELECT dbo.F_MinVistoTemporadaSerie(9,0)

GO
CREATE OR ALTER FUNCTION F_EstadisticasSerie (@IdSerie smallint) RETURNS @Estadisticas TABLE(
--Nombre: F_EstadisticasSerie
--Descripción: Dado el id de una serie, la función nos devuelve una tabla con los siguientes datos:
											--Nº de temporada
											--Cantidad visionados que se tiene en esa temporada
											--Minutos pasados viendo la temporada
											--El Incremento/Decremento de esa temporada respecto a la anterior
--Entradas: Id de la serie
--Salidas:Tabla con columnas con los datos requeridos, por temporadas
		[Nº de temporada] tinyint,
		[Numero de visionados] smallint,
		[Minutos totales] int,
		[Incremento/Decremento] decimal(4,2)
)AS
BEGIN
	--Insertamos las temporadas que tiene la serie
	INSERT INTO @Estadisticas ([Nº de temporada])
		SELECT numero FROM HTemporadas AS T
			WHERE IDSerie= @IdSerie
	--Actualizamos los minutos totales
	UPDATE @Estadisticas 
		SET [Minutos totales]= dbo.F_MinVistoTemporadaSerie(@IdSerie,[Nº de temporada])
	--Contamos los visionados
	UPDATE @Estadisticas --Bastante feo en mi opinion, mejor una funcion escalar
		SET [Numero de visionados] =(SELECT COUNT(*) FROM HVisionados AS V
			INNER JOIN HCapitulos AS C ON V.IDContenido=C.ID
			WHERE C.IDSerie=@IdSerie AND C.numeroTemporada=[Nº de temporada])
	--Calculamos el incremento, decremento con la ayuda de la funcion para calcular los minutos totales
	UPDATE @Estadisticas --Si no queremos NULL en la primera fila pondriamos IFNULL()
		SET [Incremento/Decremento]= ((CAST([Minutos totales] AS decimal)-dbo.F_MinVistoTemporadaSerie(@IdSerie,[Nº de temporada]-1))/
										dbo.F_MinVistoTemporadaSerie(@IdSerie,[Nº de temporada]-1))*100
RETURN
END

GO


--PRUEBA
SELECT * FROM dbo.F_EstadisticasSerie(9)
SELECT * FROM HSeries

GO

--Ejercicio 4 (3 Puntos)

--Funcion Auxiliar
GO
CREATE OR ALTER FUNCTION UltimoDiaMes (@mes tinyint, @anho smallint) RETURNS tinyint AS
--Nombre:
--Descripción: dEVUELVE 28 si es febrero o 30 en caso contrario (arreglar)
--Entradas:
--Salidas:
BEGIN
	DECLARE @dia tinyint
	IF(@mes=2)
		SET @dia = 28
	ELSE
		SET @dia=30

	RETURN @dia
END

GO

CREATE OR ALTER PROCEDURE P_CrearRecibo 
--Nombre:P_CrearRecibo
--Descripción:	Crea un recibo correspondiente a la cuota y los conrtenidos
--Entradas:
--Salidas:
		@IdUsuario int,
		@Mes tinyint,
		@Anho smallint = NULL
		--YEAR(CURRENT_TIMESTAMP)
 AS BEGIN
	IF(@Anho IS NULL)
	BEGIN
		SET @Anho = YEAR(CURRENT_TIMESTAMP)
	END
	DECLARE @dineroCuota SMALLMONEY 
	SELECT @dineroCuota = TS.importeMensual FROM HSuscripciones AS S
		INNER JOIN HTiposSuscripcion AS TS ON S.tipo=TS.tipo
		WHERE S.ID=@IdUsuario

	INSERT INTO HRecibos (IDSuscripcion, numeroRecibo, inicioPeriodo, finPeriodo, fecha, importeSuscripcion, importeExtras)
	VALUES(@IdUsuario, DATEFROMPARTS(@Anho,@Mes,1), DATEFROMPARTS(@Anho,@Mes,dbo.UltimoDiaMes(@Mes,@Anho)), CURRENT_TIMESTAMP,
			@dineroCuota,dbo.ImporteExtraGastado(@IdUsuario,DATEFROMPARTS(@Anho,@Mes,1), DATEFROMPARTS(@Anho,@Mes,dbo.UltimoDiaMes(@Mes,@Anho))))

END

GO
select * from HRecibos


--PRUEBA
BEGIN TRANSACTION
EXECUTE P_CrearRecibo 1,9, 2019
print @NUMERO
rollback

