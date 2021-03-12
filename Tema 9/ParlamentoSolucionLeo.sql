﻿use Parlamento
--Consulta 1 (2 points)
--Queremos saber cuál es el voto más habitual de cada diputada, afirmativo, negativo o abstenci�n. Cuenta tanto los votos a leyes como a enmiendas.

-- Votos a leyes
SELECT IDDiputada, Voto, Count (*) AS NumVotos
	FROM VotacionLey
	GROUP BY IDDiputada, Voto

-- Lo mismo con las enmiendas
-- Votos a leyes
SELECT IDDiputada, Voto, Count (*) AS NumVotos
	FROM VotacionEnmienda
	GROUP BY IDDiputada, Voto
GO
-- Las juntamos en una sola y cuidamos los nulos
CREATE View VotosDiputadas AS
SELECT ISNULL (L.IDDiputada,E.IDDiputada) AS IDDiputada, ISNULL(L.Voto,E.Voto) AS Voto, ISNULL(L.NumVotos,0)+ISNULL (E.NumVotos,0) AS TotalVotos
	FROM (SELECT IDDiputada, Voto, Count (*) AS NumVotos
		FROM VotacionLey
		GROUP BY IDDiputada, Voto) AS L
	FULL JOIN (SELECT IDDiputada, Voto, Count (*) AS NumVotos
		FROM VotacionEnmienda
		GROUP BY IDDiputada, Voto) AS E ON L.IDDiputada = E.IDDiputada AND L.Voto = E.Voto
GO
-- Ya solo queda hacer un superventas con la vista
SELECT D.ID, D.Nombre, D.Apellidos, VD.Voto AS OpcionFavorita, VD.TotalVotos
	FROM Diputadas AS D
	INNER JOIN VotosDiputadas AS VD ON D.ID = VD.IDDiputada
	INNER JOIN (SELECT IDDiputada, MAX(TotalVotos) AS Maximo
		FROM VotosDiputadas
		GROUP BY IDDiputada
	) AS MaxVotos ON VD.IDDiputada = MaxVotos.IDDiputada AND VD.TotalVotos = MaxVotos.Maximo
	
	

GO
--Consulta 2 (2 points)
--Queremos una funci�n inline a la que pasemos el ID de una diputada y nos devuelva una lista de todas las diputadas que hayan coincidido con ella en alguna comisi�n siendo las dos miembros de grupos diferentes. 
--Los datos que nos interesan son ID, nombre, apellidos, legislatura en que coincidieron y nombre de la comisi�n.
GO
CREATE FUNCTION FNColegas (@dip Int) RETURNS TABLE AS RETURN
SELECT DO.ID,DO.Nombre,DO.Apellidos,M.Legislatura,C.Nombre As Comision
	FROM Mandatos AS M
	INNER JOIN ComisionesMandatos AS CM ON M.IDDiputada = CM.IDDiputada AND M.Legislatura = CM.Legislatura
	INNER JOIN Comisiones AS C ON CM.IDComision = C.ID
	INNER JOIN ComisionesMandatos AS CMO ON C.ID = CMO.IDComision
	INNER JOIN Mandatos AS MO ON CMO.IDDiputada = MO.IDDiputada AND CMO.Legislatura = MO.Legislatura
	INNER JOIN Diputadas AS DO ON MO.IDDiputada = DO.ID
	WHERE M.IDGrupo <> MO.IDGrupo AND M.IDDiputada = @dip
GO
SELECT * FROM FNColegas (11)

--Consulta 3 (3 points)
--Los grupos parlamentarios castigan a las diputadas que votan diferente de lo que indica el grupo. Queremos una funci�n inline a la que se pase el ID de un grupo y nos devuelva nombre y apellidos de las diputadas que se han saltado las �rdenes de voto y han votado diferente de lo que indicaba el grupo, as� como el n�mero de veces que lo han hecho.
--Para saber cu�l era la orden del grupo, miraremos qu� han votado la mayor�a de sus componentes.

-- Vamos a considerar s�lo las votaciones a leyes
-- Vamos a crear una vista que nos diga cu�l es la opci�n mayoritaria de cada grupo en cada votaci�n
-- Primero el n�mero de votos de cada opci�n en cada votaci�n
-- NOTA: Necesitamos hacer JOIN a Leyes y comisiones para tener la legislatura
GO
CREATE
--ALTER 
VIEW VotosLeyes AS
SELECT VL.IDLey, M.IDGrupo, VL.Voto, COUNT (*) AS NumVotos
	FROM VotacionLey As VL
	INNER JOIN Leyes AS L ON VL.IDLey = L.ID
	INNER JOIN Comisiones AS C ON L.IDComision = C.ID
	INNER JOIN Mandatos AS M ON VL.IDDiputada = M.IDDiputada AND C.Legislatura = M.Legislatura
	GROUP BY M.IDGrupo, VL.Voto,VL.IDLey
GO
--Y ahora un superventas
CREATE VIEW VotoGrupo AS
SELECT VL.IDLey, VL.IDGrupo,VL.Voto
	FROM VotosLeyes AS VL
	INNER JOIN (SELECT IDLey, IDGrupo, MAX(NumVotos) AS Mayor
		FROM VotosLeyes
		GROUP BY IDLey, IDGrupo
	) AS MaxVotos ON VL.IDLey = MaxVotos.IDLey AND VL.IDGrupo = MaxVotos.IDGrupo AND VL.NumVotos = MaxVotos.Mayor

GO
-- Ahora contamos cu�ntas veces cada diputada ha votado diferente de su grupo
CREATE FUNCTION FNContarInfracciones (@IDGrupo SmallInt) RETURNS TABLE AS RETURN
SELECT D.ID,D.Nombre, D.Apellidos, Count(*) AS NumInfracciones
	FROM Mandatos AS M
	INNER JOIN Diputadas AS D ON M.IDDiputada = D.ID
	INNER JOIN VotacionLey As VL ON D.ID = VL.IDDiputada
	INNER JOIN VotoGrupo As VG ON VL.IDLey = VG.IDLey AND M.IDGrupo = VG.IDGrupo
	WHERE M.IDGrupo = @IDGrupo AND VL.Voto <> VG.Voto
	GROUP BY D.ID,D.Nombre, D.Apellidos
GO
SELECT * FROM FNContarInfracciones (21)
GO
--Consulta 4 (3 points)
--Queremos saber el aumento o disminuci�n de diputadas que han experimentado los grupos parlamentarios entre la tercera y la cuarta legislatura. Un grupo se considera continuaci�n de otro si est� formado por exactamente los mismos partidos.
--Ten en cuenta que pueden haberse producido sustituciones a lo largo de la legislatura por lo que para contar el n�mero de diputadas de cada grupo debes tomar como referencia una fecha arbitraria a mediados de legislatura.

-- Empezamos haciendo una funci�n a la que pasamos un grupo de la tercera legislatura y nos devuelve el grupo que es su continuaci�n en la cuarta, si existe
-- Consideramos que dos grupos son iguales si la uni�n de los conjuntos de sus partidos tiene el mismo n�mero de elementos que su intersecci�n

CREATE FUNCTION FNGruposIguales (@Grupo3 SmallInt)	RETURNS TABLE AS RETURN
	SELECT DISTINCT PG.IDGrupo FROM PartidosGrupos AS PG
		INNER JOIN Grupos AS G ON PG.IDGrupo = G.ID
		WHERE	(SELECT COUNT (*) FROM (SELECT IdPartido FROM PartidosGrupos WHERE IDGrupo = @Grupo3
										UNION 
										SELECT IdPartido FROM PartidosGrupos WHERE IDGrupo = PG.IDGrupo) AS [Union]) =
				(SELECT COUNT (*) FROM (SELECT IdPartido FROM PartidosGrupos WHERE IDGrupo = @Grupo3
										INTERSECT 
										SELECT IdPartido FROM PartidosGrupos WHERE IDGrupo = PG.IDGrupo) AS Interseccion ) 
			AND G.Legislatura = 4
GO	
Select * FROM FNGruposIguales (22)

-- Ahora calculamos el n�mero de miembros de los dos grupos. La fecha que elegimos es el 1 de enero de 2014 para la tercera legislatura y el 1 de enero de 2018 para la cuarta
-- N�mero de miembros de los grupos de la tercera legislatura en la fecha elegida
SELECT IDGrupo, COUNT (*) As NumDiputadas 
	FROM Mandatos 
	Where Legislatura = 3 AND DATEFROMPARTS (2014,1,1) BETWEEN FechaAlta AND FechaBaja
	GROUP BY IDGrupo
	
-- Y la combinamos con otra subconsulta igual para obtener el aumento o disminuci�n

SELECT L3.IDGrupo, G3.Nombre AS GrupoAnterior, L3.NumDiputadas,L4.IDGrupo, G4.Nombre AS GrupoSiguiente, L4.NumDiputadas, L4.NumDiputadas - L3.NumDiputadas As AumentoDisminucion
	FROM (SELECT IDGrupo, COUNT (*) As NumDiputadas 
		FROM Mandatos 
		Where Legislatura = 3 AND DATEFROMPARTS (2014,1,1) BETWEEN FechaAlta AND FechaBaja
		GROUP BY IDGrupo) AS L3
	INNER JOIN (SELECT IDGrupo, COUNT (*) As NumDiputadas 
		FROM Mandatos 
		Where Legislatura = 4 AND DATEFROMPARTS (2018,1,1) BETWEEN FechaAlta AND FechaBaja
		GROUP BY IDGrupo) AS L4 ON (SELECT IDGrupo FROM FNGruposIguales(L3.IDGrupo)) = L4.IDGrupo
	INNER JOIN Grupos As G3 ON L3.IDGrupo = G3.ID
	INNER JOIN Grupos As G4 ON L4.IDGrupo = G4.ID

