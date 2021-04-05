--Proyecto de Angel Lopez y Jose Maria Mata

USE LeoChampionsLeague
GO

--CREACION DE VISTAS NECESARIAS
--------------------------------------------------------------
--CREATE --OR 
ALTER 
VIEW V_Numero_Partidos_Jugados AS
SELECT ELocal AS Equipo, ISNULL(NPartidosLocal,0) + ISNULL(NPartidosVisitante,0) AS NPartidosJugados FROM
	(SELECT ELocal, COUNT(*) AS NPartidosLocal FROM Partidos
		WHERE Finalizado = 1
		GROUP BY ELocal) AS PL 
	FULL JOIN
	(SELECT EVisitante, COUNT(*) AS NPartidosVisitante FROM Partidos
		WHERE Finalizado = 1
		GROUP BY EVisitante) AS PV ON PL.ELocal = PV.EVisitante
GO

--SELECT * FROM V_Numero_Partidos_Jugados

--CREATE --OR 
ALTER 
VIEW V_Partidos_Ganados AS
SELECT ELocal AS Equipo,ISNULL([Partidos Locales Ganados],0) + ISNULL([Partidos Visitantes Ganados],0) AS [Partidos Ganados] FROM
	(SELECT ELocal, COUNT(*) AS [Partidos Locales Ganados] FROM Partidos 
		WHERE GolesLocal > GolesVisitante AND Finalizado = 1
		GROUP BY ELocal) AS L
	FULL JOIN
	(SELECT EVisitante, COUNT(*) AS [Partidos Visitantes Ganados] FROM Partidos 
		WHERE GolesLocal < GolesVisitante AND Finalizado = 1
		GROUP BY EVisitante) AS V ON L.ELocal = V.EVisitante
GO	

--SELECT * FROM V_Partidos_Ganados

--CREATE --OR
 ALTER 
VIEW V_Partidos_Empatados AS
SELECT ELocal AS Equipo,ISNULL([Partidos Locales Empatados],0) + ISNULL([Partidos Visitantes Empatados],0) AS [Partidos Empatados] FROM
	(SELECT ELocal, COUNT(*) AS [Partidos Locales Empatados] FROM Partidos 
		WHERE GolesLocal = GolesVisitante AND Finalizado = 1
		GROUP BY ELocal) AS L
	FULL JOIN
	(SELECT EVisitante, COUNT(*) AS [Partidos Visitantes Empatados] FROM Partidos 
		WHERE GolesLocal = GolesVisitante AND Finalizado = 1
		GROUP BY EVisitante) AS V ON L.ELocal = V.EVisitante
GO

--SELECT * FROM V_Partidos_Empatados

--CREATE --OR 
ALTER 
VIEW V_Goles_Favor_Contra AS
SELECT ELocal AS Equipo, ISNULL(GolesFavorLocal,0) + ISNULL(GolesFavorVisitante,0) AS [Goles Favor], ISNULL(GolesContraLocal,0) + ISNULL(GolesContraVisitante,0) AS [Goles Contra] FROM
	(SELECT ELocal, SUM(GolesLocal) AS GolesFavorLocal, SUM(GolesVisitante) AS GolesContraLocal FROM Partidos
		WHERE Finalizado = 1
		GROUP BY ELocal) AS GL
	FULL JOIN
	(SELECT EVisitante, SUM(GolesVisitante) AS GolesFavorVisitante, SUM(GolesLocal) AS GolesContraVisitante FROM Partidos
		WHERE Finalizado = 1
		GROUP BY EVisitante) AS GV ON GL.ELocal = GV.EVisitante
GO

--SELECT * FROM V_Goles_Favor_Contra


--INSERCION DE DATOS
-------------------------------------------------------
TRUNCATE TABLE Clasificacion
--Insercion del id y los nombres de los equipos
BEGIN TRAN

INSERT INTO Clasificacion (IDEquipo, NombreEquipo)
	SELECT ID, Nombre FROM Equipos
GO

--Insercion de resto de datos
UPDATE Clasificacion
	SET PartidosJugados = NPartidosJugados,
		PartidosGanados = [Partidos Ganados], 
		PartidosEmpatados = [Partidos Empatados],
		GolesFavor = [Goles Favor],
		GolesContra = [Goles Contra] FROM V_Numero_Partidos_Jugados AS VPJ
			INNER JOIN V_Partidos_Ganados AS VPG ON VPJ.Equipo=VPG.Equipo
			INNER JOIN V_Partidos_Empatados AS VPE ON  VPG.Equipo = VPE.Equipo
			INNER JOIN V_Goles_Favor_Contra AS VGFC ON VPE.Equipo=VGFC.Equipo
	WHERE VPJ.Equipo = IDEquipo
	--rollback
	COMMIT

GO

--Inserci�n individual de partidos ganados y empatados (DEPRECATED)

--BEGIN TRAN
--UPDATE Clasificacion
--	SET PartidosGanados = [Partidos Ganados], 
--		PartidosEmpatados = [Partidos Empatados] FROM V_Partidos_Ganados AS VPG 
--		INNER JOIN V_Partidos_Empatados AS VPE ON  VPG.Equipo = VPE.Equipo
--	WHERE VPG.Equipo = IDEquipo

--	--ROLLBACK
--	COMMIT

--GO

--Consulta de la cladsificaci�n ordenada
SELECT * FROM Clasificacion
ORDER BY Puntos DESC, (GolesFavor-GolesContra) DESC, GolesFavor DESC

SELECT * FROM Partidos WHERE EVisitante = 'BARC'-- OR EVisitante='BARC'
