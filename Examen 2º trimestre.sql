USE Antisistemas
--Notas
--Puedes utilizar vistas o subconsultas donde sea necesario
--Revisa que no incluyas tablas innecesarias

--Ejercicio 1 (2 points)

--Queremos saber cuántos actos ha convocado cada organización o grupo (aunque sea conjuntamente con otros) y cuántas 
--personas en total han sido detenidas en los mismos.

SELECT G.Nombre, COUNT(*) AS [Nº de actos], SUM(DE.[Nº de detenidos]) AS [Nº de detenidos en actos] FROM Grupos AS G
	INNER JOIN GruposProtestas AS GP ON G.ID=GP.IDGrupo
	INNER JOIN V_DetenidosEnActos AS DE ON GP.IDActo=DE.ID
	GROUP BY G.ID, G.Nombre
	--REVISAR Nº DE DETENIDOS Y NUMERO DE ACTOS COINCIDE 

GO
CREATE
--ALTER 
VIEW V_DetenidosEnActos AS(	--Añado ciudad ya que me servirá en el ejercicio 3
	SELECT AP.ID, AP.Titulo, COUNT(*) AS [Nº de detenidos], AP.Ciudad FROM ActosProtesta AS AP
		INNER JOIN Detenciones AS D ON AP.ID=D.IDActo
		GROUP BY AP.ID, AP.Titulo, AP.Ciudad)
GO
--SELECT * FROM V_DetenidosEnActos

--PRUUEBAS
		----TOTAL DE DETENIDOS Y DE ACTOS EN LA CONSULTA ANTERIOR
		--SELECT SUM(A.[Nº de detenidos en actos]) AS DETENIDOS, SUM(A.[Nº de actos]) AS ACTOS 
		--	FROM (SELECT G.Nombre, COUNT(*) AS [Nº de actos], SUM(DE.[Nº de detenidos]) AS [Nº de detenidos en actos] FROM Grupos AS G
		--			INNER JOIN GruposProtestas AS GP ON G.ID=GP.IDGrupo
		--			INNER JOIN V_DetenidosEnActos AS DE ON GP.IDActo=DE.ID
		--			GROUP BY G.ID, g.Nombre) AS A

		----DETENIDOS EN ACTOS (coinciden filas con nuero de detenidos)
		--SELECT * FROM Detenciones AS D 
		--INNER JOIN ActosProtesta AS AP ON D.IDActo=AP.ID
		--INNER JOIN GruposProtestas AS GP ON AP.ID=GP.IDActo

		----NUMERO DE ACTOS NO COINCIDE (no se si estoy comparando correctamente)
		--SELECT * FROM ActosProtesta AS A
		--INNER JOIN GruposProtestas AS GP ON A.ID=GP.IDActo

GO
--Ejercicio 2 (2 points)

--Queremos saber en qué Actos se han producido incidentes en los que no han intervenido materiales de la categoría 
--“Arrojadizas” ni “Armas blancas”

--Con EXCEPT
SELECT DISTINCT AP.* FROM ActosProtesta AS AP
	INNER JOIN Incidentes AS I ON AP.ID=I.IDActo
	EXCEPT 
	SELECT DISTINCT AP.* FROM ActosProtesta AS AP
		INNER JOIN Incidentes AS I ON AP.ID=I.IDActo
		INNER JOIN MaterialesIncidentes AS MI ON I.IDActo=MI.IDActo AND I.Ord=MI.OrdIncidente
		INNER JOIN Materiales AS M ON MI.IDMaterial=M.ID
		INNER JOIN Categorias AS C ON M.Categoria=C.ID
		WHERE C.Nombre ='Arrojadizas' OR C.Nombre ='Armas blancas'

-- Con NOT IN (Algo de mejor rendimiento, una tabla menos en la subconsulta)

SELECT DISTINCT AP.* FROM ActosProtesta AS AP
	INNER JOIN Incidentes AS I ON AP.ID=I.IDActo
	WHERE AP.ID NOT IN(
	SELECT DISTINCT I.IDActo FROM Incidentes AS I
		INNER JOIN MaterialesIncidentes AS MI ON I.IDActo=MI.IDActo AND I.Ord=MI.OrdIncidente
		INNER JOIN Materiales AS M ON MI.IDMaterial=M.ID
		INNER JOIN Categorias AS C ON M.Categoria=C.ID
		WHERE C.Nombre ='Arrojadizas' OR C.Nombre ='Armas blancas')

GO
--Ejercicio 3 (2 points)

--Queremos saber cuál fue el acto en el que más detenciones se han producido en cada ciudad y cuántos de los detenidos en 
--ese acto eran 
--menores de edad (menos de 18 años) en el momento de producirse la detención.

GO
CREATE
--ALTER 
VIEW V_MenoresDetenidosEnActos AS(
	SELECT AP.ID, AP.Titulo, COUNT (*) AS [Nº de menores detenidos], AP.Ciudad FROM Activistas AS A
		INNER JOIN Detenciones AS D ON A.ID=D.IDActivista
		INNER JOIN ActosProtesta AS AP ON D.IDActo=AP.ID
		--WHERE (DATEDIFF(DAY, A.FechaNac, AP.Fecha)/365)<18 --Aproximación muy cercana REVISAR
															--No estaba muy cerca
		WHERE DATEADD(YEAR, 18, A.FechaNac)<AP.Fecha --Añadimos 18 años a la fecha de nacimiento y esta tiene que ser menor que la fecha del acto
		GROUP BY AP.ID, AP.Titulo, AP.Ciudad)
GO

CREATE
--ALTER 
VIEW V_MaximoDetenidosPorCiudad AS (	--Creamos vista para facilitar la legibilidad a Leo
	SELECT MAX([Nº de detenidos]) AS [Mas detenidos por ciudad], Ciudad FROM V_DetenidosEnActos 
			GROUP BY Ciudad)
GO
--SELECT * FROM V_DetenidosEnActos
--SELECT * FROM V_MenoresDetenidosEnActos
--SELECT * FROM V_MaximoDetenidosPorCiudad

SELECT VD.ID, VD.Titulo, VD.[Nº de detenidos], ISNULL(VMD.[Nº de menores detenidos],0) AS [Nº de menores detenidos], VD.Ciudad FROM V_DetenidosEnActos AS VD
	LEFT JOIN  V_MenoresDetenidosEnActos AS VMD ON VD.ID=VMD.ID
	INNER JOIN V_MaximoDetenidosPorCiudad AS MAXD ON VD.[Nº de detenidos]=MAXD.[Mas detenidos por ciudad] AND 
													 VD.Ciudad=MAXD.Ciudad


GO
--Ejercicio 4 (2 points)

--Queremos saber cuál es la hora más peligrosa en cada ciudad. Consideramos que la más peligrosa es cuando se producen un 
--mayor número de detenciones. Se considerarán tramos de una hora: De las 19:00 a las 19:59, de las 20:00 a las 20:59, etc.
GO
CREATE VIEW V_DetencionesHoraCiudad AS (
	SELECT AP.Ciudad, DATEPART(HOUR, D.Hora) AS Hora, COUNT(*) AS [Nº de detenciones] FROM Detenciones AS D
		INNER JOIN ActosProtesta AS AP ON D.IDActo=AP.ID
		GROUP BY AP.Ciudad, DATEPART(HOUR, D.Hora)
		)
GO

CREATE VIEW V_MaximoDetencionesHoraCiudad AS (	--Creamos vista para facilitar la legibilidad a Leo
	SELECT Ciudad, MAX([Nº de detenciones]) AS [Maximo de detenciones/h] FROM V_DetencionesHoraCiudad
	GROUP BY Ciudad
)
GO

--COMPROBACIONES (Hay varias horas peligrosas)
--	SELECT * FROM V_DetencionesHoraCiudad
--	ORDER BY Ciudad
--	SELECT * FROM V_MaximoDetencionesHoraCiudad

SELECT DHC.Ciudad, DHC.Hora FROM V_DetencionesHoraCiudad AS DHC
	RIGHT JOIN V_MaximoDetencionesHoraCiudad AS MDHC ON DHC.Ciudad=MDHC.Ciudad AND
														DHC.[Nº de detenciones]=MDHC.[Maximo de detenciones/h]
ORDER BY Ciudad --Aparecen varias veces ciudades porque tienen varias horas peligrosas (igual numero de detenciones)


GO
--Ejercicio 5 (2 points)

--El grupo “Club de fans de El Fari” ha decidido nombrar socios a todos los activistas que hayan sido detenidos en algún 
--acto en el que dicho grupo figure entre los convocantes. Actualiza la tabla Activistas para que quede recogido.

BEGIN TRANSACTION

UPDATE Activistas
SET Organizacion = (SELECT ID FROM Grupos WHERE Nombre= 'Club de fans de El Fari') --Nos aseguramos que escogemos el id del grupo en concreto
	WHERE ID IN(
	SELECT DISTINCT A.ID FROM Detenciones AS D
		INNER JOIN Activistas AS A ON D.IDActivista=A.ID
		INNER JOIN ActivistasProtestas AS AP ON A.ID=AP.IDActivista
		INNER JOIN GruposProtestas AS GP ON AP.IDActo=GP.IDActo
		INNER JOIN Grupos AS G ON GP.IDGrupo=G.ID
		WHERE G.Nombre = 'Club de fans de El Fari')

--ROLLBACK
COMMIT

--SELECT * FROM Activistas