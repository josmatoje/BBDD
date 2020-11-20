
--Abogados: ID(PK), nombre, apellidos

--Políticos: ID(PK), nombre, apellidos

--Causas: numero(PK), nombre juzgado(PK)

--Implica (también se podría poner PolíticosAbogadosCausas): ID Políticos(FK Políticos), ID Abogados (FK Abogados), numero(FK Causas), nombre juzgado(FK Causas), soborno

CREATE DATABASE Pleitos
GO
USE Pleitos
GO
CREATE TABLE Abogados(
	ID Int Not NULL Constraint PK_Abogados Primary Key
	,Nombre VarChar(15) Not NULL
	,Apellidos VarChar(30) Not NULL
)
-- Politicos encausados
CREATE TABLE Politicos (
	ID SmallInt Not NULL 
	,Nombre VarChar(15) Not NULL
	,Apellidos VarChar(30) Not NULL
	,Constraint PK_Politicos Primary Key (ID)
)
-- Causas judiciales abiertas
CREATE TABLE Causas (
	Numero Int Not NULL
	,NombreJuzgado Char (40) Not NULL
	,Constraint PK_Causas Primary Key (Numero, NombreJuzgado)
)
GO
-- Relacion entre las tablas anteriores
CREATE TABLE Implica (
	IDPolitico SmallInt Not NULL Constraint FK_ImplicaPolitico Foreign Key REFERENCES Politicos (ID) ON UPDATE No Action ON DELETE No Action
	,IDAbogado Int Not NULL Constraint FK_ImplicaAbogado Foreign Key REFERENCES Abogados (ID) ON UPDATE No Action ON DELETE No Action
	,NumeroCausa Int Not NULL
	,NombreJuzgado Char(40) Not NULL
	,Constraint PKImplica Primary Key (IDPolitico, IDAbogado, NumeroCausa, NombreJuzgado)
	,Constraint FK_ImplicaCausa Foreign Key (NumeroCausa, NombreJuzgado) REFERENCES Causas (Numero, NombreJuzgado) ON UPDATE No Action ON DELETE No Action
)
