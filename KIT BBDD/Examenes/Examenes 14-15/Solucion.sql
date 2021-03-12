--Ejercicio 1
--N�mero de veces que ha actuado cada cantaor en cada festival de la provincia de C�diz, incluyendo a los que no han actuado nunca
SELECT F.Denominacion, F.Localidad, C.Nombre_Artistico, COUNT (F.Cod) AS [Numero de veces]
	FROM F_Cantaores AS C LEFT JOIN F_Festivales_Cantaores AS FC ON C.Codigo = FC.Cod_Cantaor
	LEFT JOIN F_Festivales AS F ON FC.Cod_Festival = F.Cod
	LEFT JOIN F_Provincias AS Pr On F.Provincia = Pr.Cod_Provincia
	WHERE Pr.Provincia = 'C�diz' OR Pr.Provincia IS NULL
	GROUP BY  F.Denominacion, F.Localidad, C.Nombre_Artistico


--Ejercicio 2
--Crea un nuevo palo llamado �Ton�. 
--Haz que todos los cantaores que cantaban Bamberas o Peteneras canten Ton�s. No utilices los c�digos de los palos, sino sus nombres.
INSERT INTO F_Palos (Cod_Palo,Palo)
     VALUES ('TO','Ton�s')
GO

UPDATE F_Palos_Cantaor SET Cod_Palo = 'TO' 
	FROM F_Palos
	Where F_Palos_Cantaor.Cod_Palo=F_Palos.Cod_Palo AND Palo IN ('Bambera','Petenera')
-- Este UPDATE Falla porque hay cantaores que cantan ambos palos (Bamberas y Peteneras) y al cambiarlos se viola la PK
-- Para solucionarlo es necesario hacer una DELETE de una de las dos filas de ese cantaor que quedar�an repetidas pero es complicado de hacer sin usar subconsultas

-- Esta consulta nos devuelve todos los que cantan Bamberas
SELECT Cod_cantaor FROM F_Palos_Cantaor C JOIN F_Palos P ON C.Cod_Palo = P.Cod_Palo
	WHERE P.Palo = 'Bambera'
-- La usamos para borrar los que cantan ambas cosas
DELETE F_Palos_Cantaor FROM F_Palos 
	Where F_Palos_Cantaor.Cod_Palo=F_Palos.Cod_Palo AND F_Palos.Palo = 'Petenera' 
	AND Cod_cantaor IN (SELECT Cod_cantaor FROM F_Palos_Cantaor C JOIN F_Palos P ON C.Cod_Palo = P.Cod_Palo
							WHERE P.Palo = 'Bambera'
	)

-- Tambi�n se puede hacer con una JOIN Recursivo sobre F_Palos_Cantaor
-- Este SELECT nos devuelve los que cantan ambas cosas
SELECT * 
	FROM F_Palos_Cantaor AS PCP JOIN F_Palos_Cantaor AS PCB ON PCP.Cod_cantaor = PCB.Cod_cantaor
	JOIN F_Palos AS PP ON PCP.Cod_Palo = PP.Cod_Palo
	JOIN F_Palos AS PB ON PCB.Cod_Palo = PB.Cod_Palo
	WHERE PP.Palo = 'Petenera' AND PB.Palo = 'Bambera'
-- Lo transformamos en un DELETE, Eliminando las filas se�aladas
DELETE PCP FROM F_Palos_Cantaor AS PCP JOIN  F_Palos_Cantaor AS PCB ON PCP.Cod_cantaor = PCB.Cod_cantaor 
	JOIN F_Palos AS PP ON PCP.Cod_Palo = PP.Cod_Palo
	JOIN F_Palos AS PB ON PCB.Cod_Palo = PB.Cod_Palo
	WHERE  PP.Palo = 'Petenera' AND PB.Palo = 'Bambera'

--Ejercicio 3
--N�mero de cantaores mayores de 30 a�os que han actuado cada a�o en cada pe�a. Se contar� la edad que ten�an en el a�o de la actuaci�n
SELECT P.Nombre, P.Localidad, YEAR (A.Fecha) As [A�o], COUNT(*) AS [Numero de actuaciones]
	FROM F_Cantaores AS C JOIN F_Actua AS A ON C.Codigo = A.Cod_Cantaor
	JOIN F_Penhas AS P ON A.Cod_Penha = P.Codigo
	WHERE (YEAR (A.Fecha) - C.Anno)>30
	GROUP BY P.Nombre, P.Localidad, YEAR (A.Fecha)

--Ejercicio 4
--Cantaores (nombre, apellidos y nombre art�stico) que hayan actuado m�s de dos veces en pe�as de la provincia de Sevilla y canten Fandangos o Buler�as. S�lo se incluyen las actuaciones directas en Pe�as, no los festivales.
SELECT C.Nombre, C.Apellidos, C.Nombre_Artistico, COUNT(DISTINCT A.Fecha) AS [Numero Actuaciones]
	FROM F_Cantaores AS C JOIN F_Actua AS A ON C.Codigo = A.Cod_Cantaor
	JOIN F_Penhas AS Pe ON A.Cod_Penha = Pe.Codigo
	JOIN F_Palos_Cantaor AS PC ON C.Codigo = PC.Cod_cantaor
	JOIN F_Palos AS Pa ON PC.Cod_Palo = Pa.Cod_Palo
	JOIN F_Provincias As Pr ON Pe.Cod_provincia = Pr.Cod_Provincia
	WHERE Pr.Provincia = 'Sevilla' AND Pa.Palo IN ('Fandangos de Huelva','Buler�as')
	GROUP BY C.Nombre, C.Apellidos, C.Nombre_Artistico
	Having COUNT (*) > 2



--Ejercicio 5
--N�mero de actuaciones que se han celebrado en cada pe�a, incluyendo actuaciones directas y en festivales. Incluye el nombre de la pe�a y la localidad.
-- Como no hay una relaci�n entre las pe�as y los festivales, lo haremos a trav�s de la localidad. As� lo que en realidad vamos a obtener son las actuaciones por localidads
-- Actuaciones en festivales, agrupadas por localidad

SELECT F.Localidad, Count(*) As Actuaciones
	FROM F_Festivales AS F JOIN F_Festivales_Cantaores AS FC ON F.Cod = FC.Cod_Festival
	GROUP BY F.Localidad

--Actuaciones en pe�as, tambi�n agrupadas por localidad
SELECT P.Localidad, COUNT(*) As Actuaciones
	FROM F_Actua AS A JOIN F_Penhas AS P ON A.Cod_Penha = P.Codigo
	GROUP BY P.Localidad

--Con lo que sabemos hasta ahora no es posible hacer la consulta. Incluyo la soluci�n de todos modos
-- As� juntamos las dos consultas
SELECT F.Localidad, Count(*) As Actuaciones
	FROM F_Festivales AS F JOIN F_Festivales_Cantaores AS FC ON F.Cod = FC.Cod_Festival
	GROUP BY F.Localidad
UNION
SELECT P.Localidad, COUNT(*) As Actuaciones
	FROM F_Actua AS A JOIN F_Penhas AS P ON A.Cod_Penha = P.Codigo
	GROUP BY P.Localidad

-- Solo queda agrupar por localidad y sumar
SELECT Total.Localidad, SUM (Total.Actuaciones) AS Actuaciones
FROM (SELECT F.Localidad, Count(*) As Actuaciones
		FROM F_Festivales AS F JOIN F_Festivales_Cantaores AS FC ON F.Cod = FC.Cod_Festival
		GROUP BY F.Localidad
	UNION
	SELECT P.Localidad, COUNT(*) As Actuaciones
		FROM F_Actua AS A JOIN F_Penhas AS P ON A.Cod_Penha = P.Codigo
		GROUP BY P.Localidad) AS Total
GROUP BY Total.Localidad