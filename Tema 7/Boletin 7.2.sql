USE Colegas
GO
SET DATEFORMAT DMY

BEGIN TRANSACTION

INSERT INTO People (ID, Nombre, Apellidos, FechaNac) VALUES 
	(1, 'Eduardo', 'Mingo', '14/07/1990'),
	(2, 'Margarita', 'Padera', '11/11/1992'),
	(4, 'Eloisa', 'Lamandra', '02/03/2000'),
	(5, 'Jordi', 'Videndo', '28/05/1989'),
	(6, 'Alfonso', 'Sito', '10/10/1978')

GO
select * from People

INSERT INTO Carros (ID, Marca,Modelo, Anho, Color, IDPropietario)VALUES 
	(1, 'Seat', 'Ibiza', 2014, 'Blanco', NULL),
	(2, 'Ford', 'Focus', 2016, 'Rojo', 1),
	(3, 'Toyota', 'Corola', 2017, 'Blanco', 4),
	(5, 'Renault', 'Megane', 2015, 'Azul', 2),
	(8, 'Mitsubishi', 'Colt', 2011, 'Rojo', 6)
GO
select * from Carros

INSERT INTO Libros (ID, Titulo, Autors) VALUES
	(2, 'El corazón de las Tinieblas', 'Joseph Conrad'),
	(4, 'Cien años de soledad', 'Gabriel García Márquez'),
	(8, 'Harry Potter y la cámara de los secretos', 'J. K. Rowling'),
	(16, 'Evangelio del Flying Spaguetti Monster', 'Bobby Henderson')
GO
select * from Libros

--ROLLBACK
COMMIT
GO

BEGIN TRANSACTION
--4. Eduardo Mingo ha leído Cien años de Soledad el año pasado. 
-- Margarita ha leído El corazón de las tinieblas en 2014. 
-- Eloisa ha leído Cien años de soledad en 2015 y Harry Potter en 2017. 
-- Jordi y Alfonso han leído El Evangelio del FSM en 2010.
INSERT INTO Lecturas (IDLibro, IDLector, AnhoLectura) VALUES
	(4,1,YEAR(CURRENT_TIMESTAMP)-1),
	(2, 2, 2014),
	(4, 4, 2015),
	(8, 4, 2017),
	(16, 5, 2010),
	(16, 6, 2010)

	--SELECT * FROM Lecturas
	--ROLLBACK
COMMIT
GO

BEGIN TRANSACTION
--5. Margarita le ha vendido su coche a Alfonso.
UPDATE Carros SET IDPropietario=6
	 WHERE IDPropietario=2

	 --SELECT * FROM Carros

--ROLLBACK
COMMIT
GO

--6. Queremos saber los nombres y apellidos de todos los que tienen 30 años o más
SELECT Nombre, Apellidos FROM People
WHERE 30 <= YEAR (CURRENT_TIMESTAMP- CAST (FechaNac AS datetime))-1900
GO

--7. Marca, año y modelo de todos los coches que no sean blancos ni verdes
SELECT Marca, Anho, Modelo, Color FROM Carros
	WHERE ((Color NOT LIKE '[Bb]lanco' ) AND
			(Color NOT LIKE '[Vv]erde'))
GO
select * from Carros

BEGIN TRANSACTION
--8. El nuevo gobierno regional ha prohibido todas las religiones, excepto la oficial. Por ello, los pastafarianos se ven obligados a ocultarse. 
--Inserta un nuevo libro titulado "Vidas santas" cuyo autor es el Abate Bringas. Actualiza la tabla lecturas para cambiar las lecturas del Evangelio 
--del FSM por este nuevo libro

GO

BEGIN TRANSACTION
--9. Eloísa también ha leído El corazón de las tinieblas y le ha gustado mucho.

GO

BEGIN TRANSACTION
--10. Jordi se ha comprado el Seat Ibiza
UPDATE Carros SET IDPropietario=5
WHERE Marca LIKE 'Seat' AND Modelo LIKE	'Ibiza'

SELECT * FROM Carros
COMMIT
GO


BEGIN TRANSACTION
--11. Haz una consulta que nos devuelva los ids de los colegas que han leído alguno de los libros con ID par.
SELECT DISTINCT IDLector FROM Lecturas
	WHERE IDLibro%2=0 

SELECT * FROM Lecturas

ROLLBACK
GO