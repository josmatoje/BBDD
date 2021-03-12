USE LeoSailing

--Ejercicio 1
--Queremos saber nombre, apellidos y edad de cada miembro y el n�mero de regatas que ha disputado en barcos de cada clase.
SELECT  distinct
	nombre,
	apellidos,
	YEAR(CURRENT_TIMESTAMP-(M.f_nacimiento))-1900 as Edad
FROM
	EV_Miembros as M
JOIN
	EV_Miembros_Barcos_Regatas as MR
ON M.licencia_federativa = MR.licencia_miembro

--Ejercicio 2
--Miembros que tengan m�s de 250 horas de cursos y que nunca hayan disputado una regata compartiendo barco con Esteban Dido.
SELECT *
FROM

--Ejercicio 3
--Crea una vista VTrabajoMonitores que contenga n�mero de licencia, nombre y apellidos de cada monitor, n�mero de cursos y 
--n�mero total de horas que ha impartido, as� como el n�mero total de alumnos que han participado en sus cursos. A la hora 
--de contar los asistentes, se contaran participaciones, no personas. Es decir, si un mismo miembro ha asistido a tres cursos 
--distintos, se contar� como tres, no como uno. Deben incluirse los monitores a cuyos cursos no haya asistido nadie, para echarles una buena bronca.

--Ejercicio 4
--N�mero de horas de cursos acumuladas por cada miembro que no haya disputado una regata en la clase 470 en los dos �ltimos 
--a�os (2013 y 2014). Se contar�n �nicamente las regatas que se hayan disputado en un campo de regatas situado en longitud Oeste (W). 
--Se sabe que la longitud es W porque el n�mero es negativo.





--Ejercicio 5
--El comit� de competiciones est� preocupado por el bajo rendimiento de los regatistas en las clases Tornado y 49er, as� que decide 
--organizar unos cursos para repasar las t�cnicas m�s importantes. Los cursos se titulan "Perfeccionamiento Tornado� y "Perfeccionamiento 49er�, 
--ambos de 120 horas de duraci�n. Comezar�n los d�as 21 de marzo y 10 de abril, respectivamente. El primero ser� impartido por Salud Itos y el 
--segundo por Fernando Minguero.

--Escribe un INSERT-SELECT para matricular en estos cursos a todos los miembros que hayan participado en regatas en alguna de estas clases 
--desde el 1 de Abril de 2014, cuidando de que los propios monitores no pueden ser tambi�n alumnos.