USE MASTER
CREATE DATABASE Asamblea

USE Asamblea
DROP TABLE PROPUESTA
CREATE TABLE Propuesta (
	[Numero de registro] int CONSTRAINT PK_Propuesta Primary key,
	texto varchar(1000) 
)

CREATE TABLE Inscritos (
	ID int CONSTRAINT PK_Inscritos Primary key,
	Nombre varchar(20),
	Apellidos varchar(30),
	direccion varchar (30)
)

CREATE TABLE PropuestaInscritos (
	
)