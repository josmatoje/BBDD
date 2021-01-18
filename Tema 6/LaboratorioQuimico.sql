--1. Crea una base de datos de nombre �Laboratorio Quimico�.

USE master
CREATE DATABASE [Laboratorio Quimico]
GO
USE [Laboratorio Quimico]
GO

--2. Crea una tabla de nombre LQ_Elementos, con las columnas simbolo (dos caracteres,
--clave primaria) y nombre (Cadena variable de tama�o 15). Ninguna admite nulos.

CREATE TABLE LQ_Elementos(
	simbolo char(2) NOT NULL CONSTRAINT PK_Simbolo Primary key
	,nombre nvarchar(15) NOT NULL --nvarchar preferible para caracteres de otros alfabetos
)
GO

--3. Crea otra tabla llamada LQ_Tipos_Compuesto con dos columnas: tipo (entero corto,
--clave primaria, identidad) y denominacion (cadena variable de tama�o 30). Ninguna
--admite nulos. Define denominacion como clave alternativa.

CREATE TABLE  LQ_Tipos_Compuesto(
	tipo smallint NOT NULL Identity(1,1) CONSTRAINT PK_Tipos_Compuesto Primary key
	,denominacion varchar(30) NOT NULL UNIQUE
)
GO

--4. Crea otra tabla llamada LQ_Moleculas con las columnas nombre_clasico (cadena
--variable longitud 30), nombre_IUPAC (cadena variable longitud 30), color (cadena
--variable longitud 20), densidad (decimal de dos cifras enteras y tres decimales),
--punto_fusion(real), punto_ebullicion (real). Ninguna admite nulos excepto densidad y
--color.
--punto_fusion y punto_ebullicion toman valores positivos. El valor de punto_ebullici�n
--ha de ser superior a punto_fusion.

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

--5. A�ade dos nuevas columnas a la tabla LQ_Elementos: numero_atomico (entero corto,
--sin nulos) y masa_atomica (tres cifras enteras y cinco decimales, admite nulos). El
--n�mero at�mico no debe admitir valores inferiores a uno ni superiores a 300 y ser� clave
--alternativa.

ALTER TABLE LQ_Elementos ADD
	numero_atomico smallint NOT NULL UNIQUE
	,masa_atomica decimal(8,5) NULL
	,CONSTRAINT CK_NumeroAtomico Check (numero_atomico < 300) 

GO

--6. A�ade una nueva columna a LQ_Moleculas llamada codigo. Ser� de tipo entero,
--identidad y def�nela como clave primaria.

ALTER TABLE LQ_Moleculas ADD
	codigo int Identity(1,1) CONSTRAINT PK_Moleculas Primary Key

GO

--7. Crea una nueva tabla que relacione LQ_Elementos con LQ_Moleculas, ll�mala
--LQ_MoleculasElementos. A�ade una columna numero que indique el sub�ndice del
--elemento en la mol�cula (entero corto sin nulos, valor m�nimo 1). Crea las restricciones de
--clave primaria y ajena que sean necesarias.

CREATE TABLE LQ_MoleculasElementos(
	[Codigo molecula] int CONSTRAINT FK_CodigoMolecula Foreign Key REFERENCES LQ_Moleculas(codigo)
	,Elemento char(2) CONSTRAINT FK_SimboloElemento Foreign Key REFERENCES LQ_Elementos(simbolo)
	,numero smallint NOT NULL CONSTRAINT CK_Numero Check (numero>=1)
	, CONSTRAINT PK_MoleculaElemntos Primary Key ([Codigo molecula],Elemento)
)
GO

--8. A�ade una nueva columna a LQ_Moleculas llamada tipo que la relacione con
--LQ_Tipos_Compuesto. Puede admitir valores nulos. A�ade la restricci�n de clave ajena
--necesaria.

ALTER TABLE LQ_Moleculas ADD
	tipo smallint NULL CONSTRAINT FK_TiposCompuestos Foreign Key REFERENCES LQ_Tipos_Compuesto
GO

--9. Crea una tabla de nombre LQ_Colores para normalizar los colores y crea una clave ajena
--en LQ_Moleculas que relacione la columna color con esta nueva tabla.

CREATE TABLE LQ_Colores(
	colores varchar(20) CONSTRAINT PK_Colores Primary Key
)
GO

ALTER TABLE LQ_Moleculas ADD
	CONSTRAINT FK_Colores Foreign Key REFERENCES LQ_Moleculas
GO

--10. A�ade una nueva columna a LQ_Elementos de nombre tipo, que puede tomar
--�nicamente los siguientes valores: Metal, No metal, Gas noble, Tierra rara

ALTER TABLE LQ_Elementos ADD
	
GO

--11. Prop�n una soluci�n para registrar datos sobre las reacciones qu�micas. En una reacci�n
--qu�mica intervienen varias mol�culas como reactivos y se obtienen otras como productos.
--Es importante saber las cantidades relativas de cada reactivo y cada producto. Una
--reacci�n puede absorber energ�a o liberarla, tambi�n nos interesa saber este dato. 

