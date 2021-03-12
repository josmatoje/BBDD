--use master 
--go
--drop database [Laboratorio Quimico]

--1. Crea una base de datos de nombre �Laboratorio Quimico�.
create database [Laboratorio Quimico]
go
use [Laboratorio Quimico]
go

--2. Crea una tabla de nombre LQ_Elementos, con las columnas simbolo (dos caracteres,
--clave primaria) y nombre (Cadena variable de tama�o 15). Ninguna admite nulos.
create table LQ_Elementos
(
	Simbolo char (2) not null,
	Nombre varchar (15) null,

	----------------------
	constraint PK_LQ_Elementos primary key (Simbolo)
)
go

--3. Crea otra tabla llamada LQ_Tipos_Compuesto con dos columnas: tipo (entero corto,
--clave primaria, identidad) y denominacion (cadena variable de tama�o 30). Ninguna
--admite nulos. Define denominacion como clave alternativa.
create table LQ_Tipos_Compuesto
(
	Tipo tinyint not null identity(1,1),
	Denominacion varchar (30) not null unique,--se pone unique para convertir en clave alternativa

	----------------------
	constraint PK_LQ_Tipos_Compuesto primary key (Tipo)
)
go

--4. Crea otra tabla llamada LQ_Moleculas con las columnas nombre_clasico (cadena
--variable longitud 30), nombre_IUPAC (cadena variable longitud 30), color (cadena
--variable longitud 20), densidad (decimal de dos cifras enteras y tres decimales),
--punto_fusion(real), punto_ebullicion (real). Ninguna admite nulos excepto densidad y
--color.
--punto_fusion y punto_ebullicion toman valores positivos. El valor de punto_ebullici�n--------
--ha de ser superior a punto_fusion.--------
create table LQ_Moleculas
(
	Nombre_clasico varchar (30) not null,
	nombre_IUPAC varchar (30) not null,
	Color varchar (20) null,
	Densidad decimal (5,3) null,
	Punto_fusion float not null,--tambien podemos poner REAL
	Punto_ebullicion float not null,
)
go
alter table LQ_Moleculas add constraint CK_Punto_fusion check (Punto_fusion>0)
go
alter table LQ_Moleculas add constraint CK_Punto_ebullicion check (Punto_ebullicion>0 and Punto_ebullicion>Punto_fusion)

--5. A�ade dos nuevas columnas a la tabla LQ_Elementos: numero_atomico (entero corto,
--sin nulos) y masa_atomica (tres cifras enteras y cinco decimales, admite nulos). El
--n�mero at�mico no debe admitir valores inferiores a uno ni superiores a 300 y ser� clave
--alternativa.
alter table LQ_Elementos ADD Numero_atomico tinyint not null unique
go
alter table LQ_Elementos ADD Masa_atomica decimal (8,5) null
go
alter table LQ_Elementos add constraint CK_Numero_atomico check (Numero_atomico between 1 and 300)
go

--6. A�ade una nueva columna a LQ_Moleculas llamada codigo. Ser� de tipo entero,
--identidad y def�nela como clave primaria.
alter table LQ_Moleculas ADD Codigo int not null identity (1,1) constraint PK_Codigo primary key (Codigo)
go
--7. Crea una nueva tabla que relacione LQ_Elementos con LQ_Moleculas, ll�mala
--LQ_MoleculasElementos. A�ade una columna numero que indique el sub�ndice del
--elemento en la mol�cula (entero corto sin nulos, valor m�nimo 1). Crea las restricciones de
--clave primaria y ajena que sean necesarias.


create table LQ_MoleculasElementos
(
	SimboloElementos char (2) not null,	
	CodigoMoleculas int not null,
	Numero tinyint not null,

	----------------------------
	constraint PK_LQ_MoleculasElementos primary key (SimboloElementos,CodigoMoleculas),

	-------------------------------------
	constraint FK_LQ_Moleculas_Elementos foreign key (SimboloElementos) references LQ_Elementos (Simbolo),
	constraint FK_LQ_Elementos_Moleculas foreign key (CodigoMoleculas) references LQ_Moleculas (Codigo)
)
go

alter table LQ_MoleculasElementos add constraint CK_Numero check (Numero>0)
go

--8. A�ade una nueva columna a LQ_Moleculas llamada tipo que la relacione con
--LQ_Tipos_Compuesto. Puede admitir valores nulos. A�ade la restricci�n de clave ajena
--necesaria.
alter table LQ_Moleculas add Tipo tinyint null
go
alter table LQ_Tipos_Compuesto add constraint UQ_Tipo unique (Tipo)--para que puedan relacionarse tiene que ser �nico
go
alter table LQ_Moleculas add constraint FK_LQ_Moleculas_Tipos_Compuesto foreign key (Tipo) references LQ_Tipos_Compuesto (Tipo)
go

--9. Crea una tabla de nombre LQ_Colores para normalizar los colores y crea una clave ajena
--en LQ_Moleculas que relacione la columna color con esta nueva tabla.
create table LQ_Colores
(
	ID tinyint not null,
	Color varchar (20) not null unique,

	----------------------------
	constraint PK_LQ_Colores primary key (ID)
)
go
alter table LQ_Moleculas add constraint FK_LQ_Moleculas_Colores foreign key (Color) references LQ_Colores (Color)
go

--10. A�ade una nueva columna a LQ_Elementos de nombre tipo, que puede tomar
--�nicamente los siguientes valores: Metal, No metal, Gas noble, Tierra rara
alter table LQ_Elementos add Tipo varchar (11) null
go
alter table LQ_Elementos add constraint CK_Tipo_Elementos check (Tipo in('Metal','No metal','Gas noble','Tierra rara'))
go
--11. Prop�n una soluci�n para registrar datos sobre las reacciones qu�micas. En una reacci�n
--qu�mica intervienen varias mol�culas como reactivos y se obtienen otras como productos.
--Es importante saber las cantidades relativas de cada reactivo y cada producto. Una
--reacci�n puede absorber energ�a o liberarla, tambi�n nos interesa saber este dato. 