CREATE DATABASE ELECCIONES
GO
USE ELECCIONES
GO

CREATE TABLE PARTIDO(
	NOMBRE CHAR(10) NOT NULL PRIMARY KEY 
	,NOMBRE_LIDER VARCHAR(15) NOT NULL 
	,IDEOLOGIA CHAR
	)

GO

CREATE TABLE COALICION(
	NOMBRE CHAR(10) NOT NULL PRIMARY KEY
	,AMBITO VARCHAR(15)
)

GO

CREATE TABLE FORMACION(
	ID INT IDENTITY PRIMARY KEY NOT NULL
	,NOMBRE_PARTIDO CHAR(10) NULL 
	,NOMBRE_COALICION CHAR(10) NULL
	,NOMBRE CHAR(10) NOT NULL
	,NOMBRE_ABREVIADO CHAR(3)
	,FECHA SMALLDATETIME NOT NULL
	,CONSTRAINT FK_PARTIDO FOREIGN KEY (NOMBRE_PARTIDO) REFERENCES PARTIDO(NOMBRE)
	ON UPDATE CASCADE ON DELETE NO ACTION
	,CONSTRAINT FK_COALICION FOREIGN KEY (NOMBRE_COALICION) REFERENCES COALICION(NOMBRE)
	ON UPDATE CASCADE ON DELETE NO ACTION
)

GO 

CREATE TABLE INTERVENTOR (
	NOMBRE CHAR(10) NOT NULL 
	,APELLIDOS VARCHAR (20) NOT NULL
	,DNI CHAR(10) NOT NULL PRIMARY KEY
	,FECHA SMALLDATETIME NOT NULL 
)

GO

CREATE TABLE APODERADO(
	NOMBRE CHAR(10) NOT NULL 
	,APELLIDOS VARCHAR (20) NOT NULL
	,DNI CHAR(10)  NOT NULL PRIMARY KEY
	,FECHA SMALLDATETIME NOT NULL 
)

GO 

CREATE TABLE DISTRITO(
	ID INT  NOT NULL PRIMARY KEY
)

GO 

CREATE TABLE SECCION(
	ID INT  NOT NULL PRIMARY KEY
	,DISTRITO INT NOT NULL
	,CONSTRAINT FK_DISTRITO FOREIGN KEY (DISTRITO) REFERENCES DISTRITO(ID)
	ON UPDATE CASCADE ON DELETE NO ACTION
)

GO

CREATE TABLE MESA(
	LETRA_MESA CHAR (1) NOT NULL
	,DIRECCIONES TEXT
	,NUMERO_ELEC INT NOT NULL
	,NUM_DISTRITO INT NOT NULL
	,NUM_SECCION INT  NOT NULL
	,CONSTRAINT FK_DISTRITO_MESA FOREIGN KEY (NUM_DISTRITO) REFERENCES DISTRITO(ID)
	ON UPDATE CASCADE ON DELETE NO ACTION
	,CONSTRAINT FK_SECCION FOREIGN KEY (NUM_SECCION) REFERENCES SECCION(ID)
	,CONSTRAINT PK_MESA PRIMARY KEY (LETRA_MESA,NUM_DISTRITO,NUM_SECCION)
)

GO

CREATE TABLE REPRESENTANTE(
	DNI CHAR(10)  NOT NULL PRIMARY KEY
	,NOMBRE VARCHAR(15)NOT NULL
	,APELLIDO VARCHAR(20) NOT NULL
	,TELEFONO INT NULL
)

GO 

CREATE TABLE  CANDIDATURA(
	ID INT NOT NULL PRIMARY KEY
	,NOMBRE CHAR(10)
	,DNI_REPRESENTANTE CHAR(10) NOT NULL
	,CONSTRAINT FK_REPRESENTANTE FOREIGN KEY (DNI_REPRESENTANTE) REFERENCES REPRESENTANTE(DNI)
	ON UPDATE CASCADE ON DELETE NO ACTION
)

GO

CREATE TABLE CANDIDATO(
	NOMBRE CHAR(10)NOT NULL
	,APELLIDOS VARCHAR(20)NOT NULL
	,DNI CHAR(10)  NOT NULL PRIMARY KEY
	,FECHA SMALLDATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
	,ORDEN_ELECCION INT NOT NULL
)

GO 

CREATE TABLE COMPONE_CAND(
	ID_CANDIDATURA INT  NOT NULL
	,NUMERO_ORDEN INT
	,DNI_CANDIDATO CHAR(10) NOT NULL
	,CONSTRAINT FK_CANDIDATURA FOREIGN KEY (ID_CANDIDATURA) REFERENCES CANDIDATURA(ID)
	ON UPDATE CASCADE ON DELETE NO ACTION
	,CONSTRAINT FK_CANDIDATO FOREIGN KEY (DNI_CANDIDATO) REFERENCES CANDIDATO(DNI)
	ON UPDATE CASCADE ON DELETE NO ACTION
)

GO

CREATE TABLE CIRCUNSCRIPCION(
	CODIGO INT  NOT NULL PRIMARY KEY
	,NOMBRE CHAR(10) NOT NULL
	,ID_CANDIDATURA INT  NOT NULL
	,CONSTRAINT FK_CANDIDATURA_CIR FOREIGN KEY (ID_CANDIDATURA) REFERENCES CANDIDATURA(ID)
	ON UPDATE CASCADE ON DELETE NO ACTION
)

GO

CREATE TABLE VOTA_CONGRESO(
	NUMERO_VOTOS INT  NULL 
	,CODIGO INT NOT NULL
	,CONSTRAINT FK_CIRCUNSCRIPCION_CONGRESO FOREIGN KEY (CODIGO) REFERENCES CIRCUNSCRIPCION(CODIGO)
	ON UPDATE CASCADE ON DELETE NO ACTION
)

GO

CREATE TABLE VOTA_SENADO(
	NUMERO_VOTOS INT  NULL CHECK(NUMERO_VOTOS>0)
	,CODIGO INT NOT NULL
	,CONSTRAINT FK_CIRCUNSCRIPCION_SENADO FOREIGN KEY (CODIGO) REFERENCES CIRCUNSCRIPCION(CODIGO)
	ON UPDATE CASCADE ON DELETE NO ACTION
)

ALTER TABLE FORMACION ADD CONSTRAINT CK_FECHA CHECK (FECHA <= CURRENT_TIMESTAMP)
ALTER TABLE VOTA_CONGRESO ADD CONSTRAINT CK_VOTOS_CONGRESO CHECK(NUMERO_VOTOS>0) 
ALTER TABLE VOTA_SENADO ADD CONSTRAINT CK_VOTOS_SENADO CHECK(NUMERO_VOTOS>0)
ALTER TABLE INTERVENTOR ADD CONSTRAINT CK_DNI1 CHECK  (INTERVENTOR LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][A-Z]')
ALTER TABLE APODERADO ADD CONSTRAINT CK_DNI2 CHECK (APODERADO LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][A-Z]')
ALTER TABLE REPRESENTANTE ADD CONSTRAINT CK_DNI3 CHECK (REPRESENTANTE LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][A-Z]')
ALTER TABLE CANDIDATO ADD CONSTRAINT CK_DNI4 CHECK (CANDIDATO LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][A-Z]')
ALTER TABLE MESA ADD CONSTRAINT CK_NUMERO_ELEC CHECK (NUMERO_ELEC>10 AND NUMERO_ELEC<1500) 
ALTER TABLE COALICION ADD CONSTRAINT CK_AMBITO CHECK (AMBITO= 'LOCAL''PROVINCIAL''REGIONAL''NACIONAL''EUROPEA')