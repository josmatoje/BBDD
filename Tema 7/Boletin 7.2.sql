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
	(1, 'Seat', 'Ibiza', 2014, 'Banco', NULL),
	(2, 'Ford', 'Focus', 2016, 'Rojo', 1),
	(3, 'Toyota', 'Corola', 2017, 'Banco', 4),
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

BEGIN TRANSACTION

