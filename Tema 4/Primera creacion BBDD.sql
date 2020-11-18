CREATE DATABASE Pleitos
GO
USE Pleitos
GO

CREATE TABLE Abogados (
	ID int Not NULL Constraint PK_Abogados Primary Key,
	Nombre varchar(25) Not NULL,
	Apellidos varchar(30) Not NULL
)