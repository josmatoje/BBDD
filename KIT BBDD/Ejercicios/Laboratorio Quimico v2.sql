--1. Crea una base de datos de nombre �Laboratorio Quimico�.
CREATE DATABASE [Laboratorio Quimico]

USE [Laboratorio Quimico]

--2. Crea una tabla de nombre LQ_Elementos, con las columnas simbolo (dos caracteres,
--clave primaria) y nombre (Cadena variable de tama�o 15). Ninguna admite nulos.
CREATE TABLE [LQ_Elementos] (
	simbolo char(2)
	,nombre varchar(15) NOT NULL

	,CONSTRAINT PK_LQ_Elementos PRIMARY KEY (simbolo)
)

--3. Crea otra tabla llamada LQ_Tipos_Compuesto con dos columnas: tipo (entero corto,
--clave primaria, identidad) y denominacion (cadena variable de tama�o 30). Ninguna
--admite nulos. Define denominacion como clave alternativa.
CREATE TABLE [LQ_Tipos_Compuesto] (
	tipo smallint IDENTITY
	,denominacion varchar(30) NOT NULL UNIQUE

	,CONSTRAINT PK_LQ_Tipos_Compuesto PRIMARY KEY (tipo)
)

--4. Crea otra tabla llamada LQ_Moleculas con las columnas nombre_clasico (cadena
--variable longitud 30), nombre_IUPAC (cadena variable longitud 30), color (cadena
--variable longitud 20), densidad (decimal de dos cifras enteras y tres decimales),
--punto_fusion(real), punto_ebullicion (real). Ninguna admite nulos excepto densidad y
--color.
--punto_fusion y punto_ebullicion toman valores positivos. El valor de punto_ebullici�n
--ha de ser superior a punto_fusion.
CREATE TABLE [LQ_Moleculas] (
	nombre_clasico varchar(30) NOT NULL
	,nombre_IUPAC varchar(30) NOT NULL
	,color varchar(20) NULL
	,densidad decimal(5,2) NULL
	,punto_fusion decimal NOT NULL
	,punto_ebullicion decimal NOT NULL

	,CONSTRAINT CK_Positivo_Fusion CHECK ( punto_fusion >= 0 )
	,CONSTRAINT CK_Positivo_Ebullicion CHECK ( punto_ebullicion >= 0 )
	,CONSTRAINT CK_Ebullicion_Fusion CHECK ( punto_ebullicion > punto_fusion )
)

--5. A�ade dos nuevas columnas a la tabla LQ_Elementos: numero_atomico (entero corto,
--sin nulos) y masa_atomica (tres cifras enteras y cinco decimales, admite nulos). El
--n�mero at�mico no debe admitir valores inferiores a uno ni superiores a 300 y ser� clave
--alternativa.

--6. A�ade una nueva columna a LQ_Moleculas llamada codigo. Ser� de tipo entero,
--identidad y def�nela como clave primaria.

--7. Crea una nueva tabla que relacione LQ_Elementos con LQ_Moleculas, ll�mala
--LQ_MoleculasElementos. A�ade una columna numero que indique el sub�ndice del
--elemento en la mol�cula (entero corto sin nulos, valor m�nimo 1). Crea las restricciones de
--clave primaria y ajena que sean necesarias.

--8. A�ade una nueva columna a LQ_Moleculas llamada tipo que la relacione con
--LQ_Tipos_Compuesto. Puede admitir valores nulos. A�ade la restricci�n de clave ajena
--necesaria.

--9. Crea una tabla de nombre LQ_Colores para normalizar los colores y crea una clave ajena
--en LQ_Moleculas que relacione la columna color con esta nueva tabla.

--10. A�ade una nueva columna a LQ_Elementos de nombre tipo, que puede tomar
--�nicamente los siguientes valores: Metal, No metal, Gas noble, Tierra rara

--11. Prop�n una soluci�n para registrar datos sobre las reacciones qu�micas. En una reacci�n
--qu�mica intervienen varias mol�culas como reactivos y se obtienen otras como productos.
--Es importante saber las cantidades relativas de cada reactivo y cada producto. Una
--reacci�n puede absorber energ�a o liberarla, tambi�n nos interesa saber este dato. 
