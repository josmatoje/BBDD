USE LeoMetro
--1. Crea una funci�n inline que nos devuelva el n�mero de estaciones que ha recorrido cada tren en un determinado periodo de tiempo.
--El principio y el fin de ese periodo se pasar�n como par�metros
GO
CREATE FUNCTION EstacionesTrenesPeriodo(@PeriodoInicio date, @PeriodoFin date)
RETURNS TABLE AS
RETURN
(SELECT
	T.ID, T.Matricula, COUNT(E.ID) AS [Estaciones recorridas]
FROM
	LM_Trenes AS T
	INNER JOIN LM_Recorridos AS R
	ON T.ID = R.Tren
	INNER JOIN LM_Estaciones AS E
	ON R.estacion = E.ID
WHERE
	R.Momento > @PeriodoInicio AND R.Momento < @PeriodoFin
GROUP BY
	T.ID, T.Matricula)
GO

SELECT * FROM EstacionesTrenesPeriodo('20170301', '20180101')
SELECT * FROM EstacionesTrenesPeriodo('20160301', '20180101')

--2. Crea una funci�n inline que nos devuelva el n�mero de veces que cada usuario ha entrado en el metro en un periodo de tiempo.
--El principio y el fin de ese periodo se pasar�n como par�metros
GO
CREATE FUNCTION UsuarioEntradasPeiodo(@PeriodoInicio date, @PeriodoFin date)
RETURNS TABLE AS
RETURN
(SELECT
	P.Nombre, P.Apellidos, COUNT(V.MomentoEntrada) AS [N�mero de veces que entra en el metro]
FROM
	LM_Pasajeros AS P
	INNER JOIN LM_Viajes AS V
	ON P.ID = V.IDPasajero
WHERE
	V.MomentoEntrada > @PeriodoInicio AND V.MomentoEntrada < @PeriodoFin
GROUP BY V.IDPasajero, P.Nombre, P.Apellidos)
GO

SELECT * FROM UsuarioEntradasPeiodo('20170226', '20170228')

--3. Crea una funci�n inline a la que pasemos la matr�cula de un tren y una fecha de inicio y fin
--y nos devuelva una tabla con el n�mero de veces que ese tren ha estado en cada estaci�n, adem�s del ID, nombre
--y direcci�n de la estaci�n
GO
CREATE FUNCTION VecesEstacionMatriculaPeriodo(@Matricula char(7), @PeriodoInicio date, @PeriodoFin date)
RETURNS TABLE AS
RETURN
(SELECT
	E.ID, E.Denominacion, E.Direccion, COUNT(*) AS [Veces que ha pasado]
FROM
	LM_Trenes AS T
	INNER JOIN LM_Recorridos AS R
	ON T.ID = R.Tren
	INNER JOIN LM_Estaciones AS E
	ON R.estacion = E.ID
WHERE
	T.Matricula = @Matricula AND R.Momento > @PeriodoInicio AND R.Momento < @PeriodoFin
GROUP BY
	E.ID, E.Denominacion, E.Direccion)
GO
SELECT * FROM VecesEstacionMatriculaPeriodo('3290GPT', '20170226', '20170228')

--4. Crea una funci�n inline que nos diga el n�mero de personas que han pasado por una estacion en un periodo de tiempo.
--Se considera que alguien ha pasado por una estaci�n si ha entrado o salido del metro por ella.
--El principio y el fin de ese periodo se pasar�n como par�metros


--5. Crea una funci�n inline que nos devuelva los kil�metros que ha recorrido cada tren en un periodo de tiempo.
--El principio y el fin de ese periodo se pasar�n como par�metros


--6. Crea una funci�n inline que nos devuelva el n�mero de trenes que ha circulado por cada l�nea en un periodo de tiempo.
--El principio y el fin de ese periodo se pasar�n como par�metros. Se devolver� el ID, denominaci�n y color de la l�nea
GO
CREATE FUNCTION TrenesPorLineaPeriodo(@PeriodoInicio date, @PeriodoFin date)
RETURNS TABLE AS
RETURN
(SELECT
	L.ID, L.Denominacion, L.Color, COUNT(T.ID) AS [N�mero de trenes que han pasado]
FROM
	LM_Trenes AS T
	INNER JOIN LM_Recorridos AS R
	ON T.ID = R.Tren
	INNER JOIN LM_Lineas AS L
	ON R.Linea = L.ID
WHERE
	R.Momento > @PeriodoInicio AND R.Momento < @PeriodoFin
GROUP BY
	L.ID, L.Denominacion, L.Color)
GO
SELECT * FROM TrenesPorLineaPeriodo('20170226', '20170228')

--7. Crea una funci�n inline que nos devuelva el tiempo total que cada usuario ha pasado en el metro en un periodo de tiempo.
--El principio y el fin de ese periodo se pasar�n como par�metros. Se devolver� ID, nombre y apellidos del pasajero.
--El tiempo se expresar� en horas y minutos.
