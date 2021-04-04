--TRABAJO ACTUALIZACION LEOCHAMPIONSLEAGUE
--INSERTAR EL IDEQUIPO Y NOMBRE EQUIPO DE LA TABLA CLASIFICACION 
GO
DELETE FROM Clasificacion
INSERT INTO Clasificacion(IDEquipo,NombreEquipo) SELECT E.ID,E.Nombre FROM Equipos AS E
SELECT*FROM Clasificacion



--CREO VISTA PARTIDOS JUGADOS
GO
CREATE OR ALTER VIEW [VPJ] AS 
SELECT PGL.ELocal,(PGL.NumeroPartidos+PJV.NumeroPartidos) AS [NumeroPartidosJugados] FROM
(SELECT P.ELocal,COUNT(*) AS [NumeroPartidos] FROM Partidos AS P
WHERE P.Finalizado=1 
GROUP BY P.ELocal) AS PGL
INNER JOIN
(SELECT P.EVisitante,COUNT(*) AS [NumeroPartidos] FROM Partidos AS P
WHERE P.Finalizado=1 
GROUP BY P.EVisitante) AS PJV ON PGL.ELocal=PJV.EVisitante
GO

--FUNCION INLINE QUE TE DICE CUANTOS PARTIDOS A JUGADO CADA EQUIPO PASANDOLE EL ID DE ESTE POR PARÁMETROS
GO
CREATE OR ALTER FUNCTION [FIPartidoJugados]
(@IdEquipo varchar(20)) RETURNS TABLE AS
RETURN SELECT PGL.ELocal,(PGL.NumeroPartidos+PJV.NumeroPartidos) AS [NumeroPartidosJugados] FROM
(SELECT P.ELocal,COUNT(*) AS [NumeroPartidos] FROM Partidos AS P
WHERE P.Finalizado=1  AND P.ELocal=@IdEquipo
GROUP BY P.ELocal) AS PGL
INNER JOIN
(SELECT P.EVisitante,COUNT(*) AS [NumeroPartidos] FROM Partidos AS P
WHERE P.Finalizado=1 AND P.EVisitante=@IdEquipo
GROUP BY P.EVisitante) AS PJV ON PGL.ELocal=PJV.EVisitante
GO

--ACTUALIZO LOS PARTIDOS JUGADOS DE CADA EQUIPO USANDO LA VISTA ANTERIOR
GO
UPDATE Clasificacion SET PartidosJugados=VPJ.NumeroPartidosJugados FROM VPJ WHERE VPJ.ELocal=Clasificacion.IDEquipo

--CREO VISTA CON LOS PARTIDOS GANADOS POR CADA EQUIPO
GO
CREATE OR ALTER VIEW [VPG] AS
SELECT PGL.ELocal,(PGL.PartidosGanados+PGV.PartidosGanados) AS [PartidosGanados] FROM 
(SELECT P.ELocal,COUNT(*) AS [PartidosGanados] FROM Partidos AS P
WHERE P.GolesLocal>P.GolesVisitante AND P.Finalizado=1 
GROUP BY P.ELocal) AS PGL
INNER JOIN 
(SELECT P.EVisitante,COUNT(*) AS [PartidosGanados] FROM Partidos AS P
WHERE P.GolesVisitante>P.GolesLocal AND P.Finalizado=1 
GROUP BY P.EVisitante) AS PGV ON PGL.ELocal=PGV.EVisitante
GO

--CREO VISTA CON LOS PARTIDOS EMPATADOS POR CADA EQUIPO
GO
CREATE OR ALTER VIEW [VPE] AS
SELECT  PEL.EVisitante,(PEL.PartidosEmpatados+PEV.PartidosEmpatados) AS [PartidosEmpatados] FROM
(SELECT P.EVisitante,COUNT(*) AS [PartidosEmpatados] FROM Partidos AS P
WHERE P.GolesVisitante=P.GolesLocal AND P.Finalizado=1 
GROUP BY P.EVisitante) AS PEL
INNER JOIN
(SELECT P.ELocal,COUNT(*) AS [PartidosEmpatados] FROM Partidos AS P
WHERE P.GolesLocal=P.GolesVisitante AND P.Finalizado=1 
GROUP BY P.ELocal) AS PEV ON PEL.EVisitante=PEV.ELocal
GO

--CREO VISTA CON LOS PARTIDOS PERDIDOS DE CADA EQUIPO
GO
CREATE OR ALTER VIEW [VPP] AS
SELECT VPJ.ELocal,VPJ.NumeroPartidosJugados-(VPG.PartidosGanados+VPE.PartidosEmpatados) AS [NumeroPartidosPerdidos] FROM VPJ INNER JOIN
VPG ON VPJ.ELocal=VPG.ELocal INNER JOIN VPE ON VPJ.ELocal=VPE.EVisitante
GO

--CREO VISTA CON LOS PUNTOS DE CADA EQUIPO
GO
CREATE OR ALTER VIEW [VPPE] AS
SELECT VPG.ELocal,(VPE.PartidosEmpatados+VPG.PartidosGanados*3) AS [Puntos] FROM VPG INNER JOIN
VPE ON VPG.ELocal=VPE.EVisitante
GO

--GOLES A FAVOR DE CADA EQUIPO
GO
CREATE OR ALTER VIEW [VGF] AS
SELECT GL.ELocal, (GL.Goles+GV.Goles) AS [Goles] FROM
(SELECT P.ELocal,SUM(P.GolesLocal) AS [Goles] FROM Partidos AS P
GROUP BY  P.ELocal) AS GL INNER JOIN 
(SELECT P.EVisitante,SUM(P.GolesVisitante) AS [Goles] FROM Partidos AS P
GROUP BY  P.EVisitante)AS GV ON GL.ELocal=GV.EVisitante
GO

--GOLES EN CONTRA DE CADA EQUIPO
GO
CREATE OR ALTER VIEW [VGC] AS
SELECT GL.EVisitante, (GL.GolesContra+GV.GolesContra) AS [Goles] FROM
(SELECT P.EVisitante,SUM(P.GolesLocal) AS [GolesContra] FROM Partidos AS P
GROUP BY  P.EVisitante) AS GL INNER JOIN 
(SELECT P.ELocal,SUM(P.GolesVisitante) AS [GolesContra] FROM Partidos AS P
GROUP BY  P.ELocal)AS GV ON GL.EVisitante=GV.ELocal
GO

--ACTUALIZO LA TABLA AÑADIENDO LOS DATOS RESTANTES
GO
UPDATE Clasificacion SET PartidosGanados=VPG.PartidosGanados,PartidosEmpatados=VPE.PartidosEmpatados,
GolesFavor=VGF.Goles,GolesContra=VGC.Goles 
FROM VPG INNER JOIN  
VPE ON VPG.ELocal=VPE.EVisitante INNER JOIN
--VPP ON VPG.ELocal=VPE.EVisitante INNER JOIN
--VPPE ON VPG.ELocal=VPPE.ELocal INNER JOIN 
VGF ON VPG.ELocal=VGF.ELocal INNER JOIN
VGC ON VPG.ELocal=VGC.EVisitante
WHERE VPG.ELocal=Clasificacion.IDEquipo
GO

--VER ORDENADO POR CRITERIOS DE ORDENACIÓN
SELECT*FROM Clasificacion AS P
ORDER BY P.Puntos DESC,(P.GolesFavor-P.GolesContra) DESC,P.GolesFavor DESC