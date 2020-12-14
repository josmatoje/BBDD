/*
	EXAMEN BBDD 4 DE DICIEMBRE 2020
EJERCICIO 2: MODELO RELACIONAL NORMALIZADO
(Todos los comentarios respecto a las tablas están debajo de las mismas)

Propuestas: ID(PK), IDPropuestasSustituida (FK Propuestas) ,Titulo, texto, FechaHoraPresentacion
	No hace falta explicar: (Al ser la relación sustituye reflexiva 1:N no hace falta crear una tabla y solo he añadido una clave agena a la tabla 
	propuestas)

Inscritos: ID(PK), nombre, apellido, fechaAlta, cargo

Motivos: Codigo (PK), texto

Politicas: IDPropuesta (PK) (FK Propuestas), Tema, Presupuesto
	(A pesar de ser una generalización total y exclusiva que normalmente se resuelve con dos tablas para cada subtipo sin hacer una para el supertipo, 
	he decidido mantener la tabla de propuestas debido a su gran número de relaciones con otras tablas)

Organizativas: IDPropuesta (PK) (FK Propuestas), otrospartidos, TextoBase, NumeroArticulo (FK Articulos)
	(A pesar de ser una generalización total y exclusiva que normalmente se resuelve con dos tablas para cada subtipo sin hacer una para el supertipo, 
	he decidido mantener la tabla de propuestas debido a su gran número de relaciones con otras tablas)

Articulos: Numero (PK), bloqueo, texto

Personajes: ID(PK), Nombre, Apellidos, alias, fechaNacimiento, fechaMuerte, nacionalidad, IDPoliticaInspira (FK Politicas)
	(He traspasado la clave agena de politicas a personajes ya que todos los personajes inspiran a una politica pero hay politicas que no son ispiradas 
	por ningún personaje)

IPAvala: IDInscrito (PK)(FK Inscritos), IDPropuesta (PK) (FK Propuestas)

IPHace: IDInscrito (PK)(FK Inscritos), IDPropuesta (PK) (FK Propuestas)

IPVota: IDInscrito (PK)(FK Inscritos), IDPropuesta (PK) (FK Propuestas), FavorContra
	(El atributo de relación se incluye en la tabla que hemos creado para la relacion al ser esta N:M)

MotivosContradicenPropuestas: IDPropuestasInicial (PK) (FK Propuestas), IDPropuestaContradecida (PK) (FK Propuestas), CodigoMotivo (PK) (FK Motivos)

*/

USE master
CREATE DATABASE Politicas
go
USE Politicas
go
CREATE TABLE Propuestas(
	ID int NOT NULL Constraint PK_Propuestas Primary key, 
	IDPropuestasSustituida int NULL ,
	Titulo varchar(20) NOT NULL, 
	Texto varchar(max) NULL,
	[Fecha Hora Presentacion] datetime2 NOT NULL,
	Constraint FK_PropuestasSustituida Foreign key (IDPropuestasSustituida) REFERENCES Propuestas(ID) ON DELETE NO ACTION ON UPDATE NO ACTION
)

GO

CREATE TABLE Inscritos(
	ID int NOT NULL Constraint PK_Inscritos Primary key,
	nombre varchar(20) NOT NULL, 
	apellido varchar(40) NOT NULL, 
	fechaAlta date NOT NULL, 
	cargo varchar(max) NOT NULL
)

GO

CREATE TABLE Motivos(
	Codigo int NOT NULL Constraint PK_Motivos Primary key,
	texto varchar(max)
)

GO

CREATE TABLE Articulos(
	Numero int NOT NULL Constraint PK_Articuloss Primary key, 
	bloqueo bit NOT NULL, 
	texto varchar(max) NOT NULL
)

GO

CREATE TABLE Politicas(
	IDPropuesta int NOT NULL Constraint PK_PropuestasPoliticas Primary key Constraint FK_PropuestasPoliticas Foreign key REFERENCES Propuestas(ID) ON DELETE CASCADE ON UPDATE CASCADE,
	Tema varchar(30) NOT NULL,
	Presupuesto money NOT NULL
)

GO

CREATE TABLE Organizativas(
	IDPropuesta int NOT NULL Constraint PK_PropuestasOrganizativas Primary key Constraint FK_PropuestasOrganizativas Foreign key REFERENCES Propuestas(ID) ON DELETE CASCADE ON UPDATE CASCADE,
	otrospartidos bit NOT NULL, 
	TextoBase varchar(max) NOT NULL, 
	NumeroArticulo int NOT NULL Constraint FK_ArticuloOrganizativo Foreign key REFERENCES Articulos(Numero) ON DELETE NO ACTION ON UPDATE NO ACTION
)

GO

CREATE TABLE Personajes(
	ID int NOT NULL Constraint PK_Personaje Primary key, 
	Nombre varchar(20) NOT NULL, 
	Apellidos varchar(40) NOT NULL, 
	alias varchar(20) NOT NULL, 
	fechaNacimiento date NOT NULL, 
	fechaMuerte date NULL , 
	nacionalidad varchar(20) NOT NULL, 
	IDPoliticaInspira int Constraint FK_PoliticaInspiradora Foreign key REFERENCES Politicas(IDPropuesta) ON DELETE NO ACTION ON UPDATE NO ACTION
)

GO

CREATE TABLE IPAvala(
	IDInscrito int NOT NULL Constraint FK_InscritoAvala Foreign key REFERENCES Inscritos (ID) ON DELETE NO ACTION ON UPDATE NO ACTION,
	IDPropuesta int NOT NULL Constraint FK_PropuestaAvala Foreign key REFERENCES Propuestas (ID) ON DELETE NO ACTION ON UPDATE NO ACTION
	Constraint PK_IPAvala Primary key (IDInscrito, IDPropuesta)
)

GO

CREATE TABLE IPHace(
	IDInscrito int NOT NULL Constraint FK_InscritoHace Foreign key REFERENCES Inscritos (ID) ON DELETE NO ACTION ON UPDATE NO ACTION,
	IDPropuesta int NOT NULL Constraint FK_PropuestaHace Foreign key REFERENCES Propuestas (ID) ON DELETE NO ACTION ON UPDATE NO ACTION
	Constraint PK_IPHace Primary key (IDInscrito, IDPropuesta)
)

GO

CREATE TABLE IPVota(
	IDInscrito int NOT NULL Constraint FK_InscritoVota Foreign key REFERENCES Inscritos (ID) ON DELETE NO ACTION ON UPDATE NO ACTION,
	IDPropuesta int NOT NULL Constraint FK_PropuestaVota Foreign key REFERENCES Propuestas (ID) ON DELETE NO ACTION ON UPDATE NO ACTION
	Constraint PK_IPVota Primary key (IDInscrito, IDPropuesta),
	FavorContra varchar(5)
)

GO