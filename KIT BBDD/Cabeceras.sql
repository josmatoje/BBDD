--Estructuras funcion escalar, funcion inline, función multiples instrucciones y procedimientos

--FUNCION ESCALAR

GO
--Nombre:
--Descripción:
--Entradas:
--Salidas:

CREATE OR ALTER FUNCTION Nombredelafuncion (@variable1 int, @v2 char) RETURNS smallint AS
BEGIN
	DECLARE @devolucion smallint
	SELECT @devolucion = * FROM
	RETURN @devolucion
END

--PRUEBA
SELECT dbo.Nombredelafuncion()



--FUNCION INLINE

GO
--Nombre:
--Descripción:
--Entradas:
--Salidas:

CREATE OR ALTER FUNCTION Nombredelafuncion (@variable1 int, @v2 char) RETURNS TABLE AS
RETURN(SELECT * FROM )

--PRUEBA
SELECT * FROM dbo.Nombredelafuncion()


--FUNCION MULTIPLES INSTRUCCIONES

GO
--Nombre:
--Descripción:
--Entradas:
--Salidas:

CREATE OR ALTER FUNCTION Nombredelafuncion (@variable1 int, @v2 char) RETURNS @NombreTabla TABLE(
		PrimeraCol varchar(20),
		SegundaColumna smallint,
		TerceraColumna char
)AS
BEGIN
	INSERT INTO @NombreTabla

	UPDATE @NombreTabla

RETURN
END

--PRUEBA
SELECT * FROM dbo.Nombredelafuncion()


--PROCEDIMIENTOS

GO
--Nombre:
--Descripción:
--Entradas:
--Salidas:

CREATE OR ALTER PROCEDURE Nombredelafuncion 
		@variable1 int,
		@v2 char,
		@SALIDA int OUTPUT AS
BEGIN
	SET @SALIDA int


END

--PRUEBA
BEGIN TRANSACTION
DECLARE @NUMERO int
EXECUTE InscribeCaballo 1,9, @NUMERO OUTPUT
print @NUMERO
rollback


