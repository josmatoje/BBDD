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
	 ,color varchar(20) NULL
	 ,densidad decimal(5,3) NULL
	 ,punto_fusion int  NOT NULL
	 ,punto_ebullicion int  NOT NULL
	 ,CONSTRAINT CK_PuntoFusion Check (punto_fusion > 0)
	 ,CONSTRAINT CK_PuntoEbullicion Check (punto_ebullicion>punto_fusion)
)
GO

ALTER TABLE LQ_Elementos ADD
	numero_atomico smallint NOT NULL UNIQUE
	,masa_atomica decimal(8,5) NULL
	,CONSTRAINT CK_NumeroAtomico Check (numero_atomico < 300) 

GO

ALTER TABLE LQ_Moleculas ADD
	codigo int Identity(1,1) CONSTRAINT PK_Moleculas Primary Key

GO

CREATE TABLE LQ_MoleculasElementos(
	[Codigo molecula] int CONSTRAINT FK_CodigoMolecula Foreign Key REFERENCES LQ_Moleculas(codigo)
	,Elemento char(2) CONSTRAINT FK_SimboloElemento Foreign Key REFERENCES LQ_Elementos(simbolo)
	,numero smallint NOT NULL CONSTRAINT CK_Numero Check (numero>=1)
	, CONSTRAINT PK_MoleculaElemntos Primary Key ([Codigo molecula],Elemento)
)

GO

