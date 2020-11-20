-- Base de datos urbanizaciones
-- 14/11/2019
-- Autor: Leo el magnífico

CREATE DataBase Urbanizacion
GO
USE Urbanizacion
GO
CREATE TABLE URViviendas (
	ID SmallInt Not NULL Identity (100,1),
	Direccion VarChar (50) Not NULL,
	Superficie Decimal (5,1) NULL,
	IDPropietario SmallInt Not NULL,
	Constraint PKViviendas Primary Key (ID)
)
GO
CREATE TABLE URPersonas(
	ID SmallInt Not NULL IDENTITY (1,1),
	Nombre VarChar(30) Not NULL,
	IDViviendaVive SmallInt Not NULL,
	IDPareja SmallInt NULL,
	CONSTRAINT PKPersonas Primary Key (ID),
	CONSTRAINT FKViviendaPersonaVive Foreign Key (IDViviendaVive) REFERENCES URViviendas (ID) ON DELETE No Action ON UPDATE NO ACTION,
	CONSTRAINT FKPareja FOREIGN KEY (IDPareja) REFERENCES URPersonas (ID) ON DELETE No Action ON UPDATE NO ACTION, 
	CONSTRAINT UQMonogamia UNIQUE (IDPareja) 
)
GO
ALTER TABLE URViviendas ADD CONSTRAINT FKViviendaPersonaPosee Foreign Key
	(IDPropietario) REFERENCES URPersonas (ID) ON DELETE No Action ON UPDATE Cascade
GO