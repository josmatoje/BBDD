USE master
CREATE DATABASE [Laboratorio Quimico]
GO
USE [Laboratorio Quimico]
GO

CREATE TABLE LQ_Elementos(
	simbolo char(2) NOT NULL CONSTRAINT PK_Simbolo Primary key
	,nombre nvarchar(15) NOT NULL --nvarchar preferible para caracteres de otros alfabetos
)
GO

CREATE TABLE  LQ_Tipos_Compuesto(
	tipo smallint NOT NULL Identity(1,1) CONSTRAINT PK_Tipos_Compuesto Primary key
	,denominacion varchar(30) NOT NULL UNIQUE
)
GO

CREATE TABLE LQ_Moleculas (
	 nombre_clasico varchar(30) NOT NULL
	 ,nombre_IUPAC varchar(30) NOT NULL
	 ,color varchar(20) 
	 ,densidad decimal(5,3)
	 ,punto_fusion int  NOT NULL
	 ,punto_ebullicion int  NOT NULL
)
GO