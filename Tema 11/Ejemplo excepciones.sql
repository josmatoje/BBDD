/*
https://docs.microsoft.com/es-es/sql/t-sql/language-elements/throw-transact-sql?view=sql-server-2017
*/
-- C�mo lanzar una excepci�n
-- Opci�n 1
-- La instrucci�n anterior debe terminar en ;
-- El n�mero de mensaje (primer par�metro) debe ser superior a 50000

-- IF falla
THROW 51000, 'Esto ha cascado brutalmente', 1;  


-- Opci�n 2. M�s sofisticado:
-- Guardamos el mensaje en una tabla del sistema
-- Debemos usar IDs a partir de 50000

-- Primero hay que guardar la versi�n en ingl�s para que Bill lo entienda
EXEC sys.sp_addmessage @msgnum = 50100, @severity = 16, @msgtext = N'This was brutaly crashed.',@lang = 'us_english',@replace='replace';
-- Ahora en la lengua de Cervantes
EXEC sys.sp_addmessage @msgnum = 50100, @severity = 16, @msgtext = N'Esto ha cascado brutalmente.', @lang ='spanish',@replace='replace';

--Ahora se lanza usando el ID del error
DECLARE @Mensaje NVarChar(255)=FormatMessage(50100);
THROW 50100,@Mensaje,1;  
GO
-- Se pueden usar par�metros
EXEC sp_addmessage @msgnum = 50101, @severity = 7, @msgtext = 'Database %s smells!',@lang = 'us_english',@replace='replace';
-- Versi�n doblada
EXEC sp_addmessage @msgnum = 50101, @severity = 7, @msgtext = 'La base de datos %1! huele mal!', @lang ='spanish',@replace='replace';
-- Y lo probamos
DECLARE @Mensaje NVarChar(255)=FormatMessage(50101,'Pinreles');
THROW 50101,@Mensaje,1;  


-- Para ver informaci�n sobre los errores se consulta una vista del sistema
-- Todos los mensajes personalizados en espa�ol
select * from master.dbo.sysmessages where msglangid=3082 and error > 50000
select * from master.dbo.sysmessages where msglangid=3082 and error Between 8114 AND 8141
-- Todos los mensajes personalizados
select * from master.dbo.sysmessages where error > 50000
select * from master.dbo.sysmessages where msglangid=3082 and description LIKE '%cadena%'
GO


-- Otro ejemplo con par�metros
-- Primero en ingl�s. Se usan los descriptores de formato tipo C
EXEC sp_addmessage @msgnum = 50102, @severity = 7, @msgtext = 'The table %s has more than %d rows',@lang = 'us_english',@replace='replace'

-- En los dem�s idiomas se usan placeholders (1, 2, 3...)
EXEC sp_addmessage @msgnum = 50102, @severity = 7, @msgtext = 'Hay m�s de %2! filas en la tabla %1!', @lang ='spanish',@replace='replace'

-- Y lo probamos
DECLARE @Mensaje NVarChar(255)=FormatMessage(50102,'Palabras',200);
THROW 50102,@Mensaje,1;  
-- Idomas existentes
EXEC sp_helplanguage 

SET Language Italian
SET Language Spanish
-- Como capturar una excepci�n
USE Ejemplos
BEGIN Transaction 
BEGIN TRY
	-- Instrucciones que pueden fallar
	INSERT INTO Criaturitas (Nombre,ID,Puntos)
		VALUES ('Ataulfo',1,1)
	Commit
END TRY
BEGIN CATCH
	RollBack
END CATCH