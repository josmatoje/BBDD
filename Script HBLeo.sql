/* Control 11/5/2021 
Base de datos para un servicio de visi�n de contenidos a la carta tipo NetFlix o HBO
*/
Create Database HBleO
GO
Use HBleO
GO
/****** Object:  Table Titulares     ******/

CREATE TABLE HTitulares (
	ID int NOT NULL,
	Nombre nvarchar(15) NOT NULL,
	Apellidos nvarchar(25) NOT NULL,
	Nick nchar(12) NOT NULL,
	PassWord nchar(12) NOT NULL,
	FechaNacimiento date NOT NULL,
	Bloqueado bit Not NULL CONSTRAINT DFBloqueado Default 0,
	CONSTRAINT PKTitulares PRIMARY KEY (ID)
) 
CREATE TABLE HTiposSuscripcion (
	tipo Char(1) Not NULL,
	nombreTipo VarChar(20) Not NULL,
	importeMensual SmallMoney Not NULL,
	CONSTRAINT PKTipos Primary Key (tipo)
)
GO
CREATE TABLE HSuscripciones(
	ID int Not NULL,
	tipo char(1) Not NULL,
	fechaAlta Date Not NULL,
	fechaBaja Date NULL,
	CONSTRAINT PKSuscripciones Primary Key (ID),
	CONSTRAINT FKSuscripcionesTitulares Foreign Key (ID) REFERENCES HTitulares(ID) On Delete CASCADE On Update CASCADE,
	CONSTRAINT FKSuscripcionesTipos Foreign Key (tipo) REFERENCES HTiposSuscripcion(tipo) On Delete No Action On Update No Action,
	CONSTRAINT CKFechasSuscripcion CHECK (fechaAlta<fechaBaja)
)
GO
CREATE TABLE HRecibos (
	IDSuscripcion int Not NULL,
	numeroRecibo SmallInt Not NULL,
	inicioPeriodo Date Not NULL,
	finPeriodo Date Not NULL,
	fecha Date Not NULL,
	importeSuscripcion SmallMoney Not NULL,
	importeExtras SmallMoney Not NULL CONSTRAINT DFImporteExtras Default 0.0,
	importeTotal AS importeSuscripcion + importeExtras,
	CONSTRAINT PKRecibos Primary Key (IDSuscripcion, numeroRecibo),
	CONSTRAINT CKFechasPeriodo CHECK (inicioPeriodo<finPeriodo),
	CONSTRAINT CKFechaEmision CHECK (fecha>finPeriodo),
	CONSTRAINT FKRecibosSuscripciones Foreign Key (IDSuscripcion) REFERENCES HSuscripciones(ID) On Delete CASCADE On Update CASCADE
)
-- Perfiles. Cada suscripci�n puede tener hasta diez perfiles asociados
CREATE TABLE HPerfiles (
	ID UniqueIdentifier Not NULL,
	IDSuscripcion int Not NULL,
	nombre VarChar(20) Not NULL,
	password VarChar(20) NULL,
	grupoEdad TinyInt Not NULL,
	CONSTRAINT PKPerfiles Primary Key (ID),
	CONSTRAINT FKPerfilesSuscripciones Foreign Key (IDSuscripcion) REFERENCES HSuscripciones(ID) On Delete NO ACTION On Update NO ACTION,
	CONSTRAINT CKEdadPerfil CHECK (grupoEdad BETWEEN 0 AND 2)
)

-- G�neros de los contenidos
CREATE TABLE HGeneros (
	ID TinyInt Not NULL,
	genero VarChar(20) Not NULL,
	CONSTRAINT PKGeneros PRIMARY KEY (ID)
)
-- Series
CREATE TABLE HSeries (
	ID SmallInt Not NULL,
	titulo VarChar (40),
	CONSTRAINT PKSeries PRIMARY KEY (ID)
)
GO
CREATE TABLE HTemporadas (
	IDSerie SmallInt Not NULL,
	numero TinyInt Not NULL,
	FechaEstreno Date,
	CONSTRAINT PKTemporada PRIMARY KEY (IDSerie, numero),
	CONSTRAINT FKTemporadasSeries Foreign Key (IDSerie) REFERENCES HSeries(ID) On Delete CASCADE On Update CASCADE
)
GO
-- Contenidos
CREATE TABLE HContenidos (
	ID UniqueIdentifier Not NULL,
	tipo Char(1) NULL,
	duracion time NULL,
	grupoEdad TinyInt Not NULL,	-- 0: Todos los p�blicos, 1: Mayores de 12, 2: Mayores de 18
	CONSTRAINT PKContenido PRIMARY KEY (ID),
	CONSTRAINT CKEdadContenido CHECK (grupoEdad BETWEEN 0 AND 2),
	CONSTRAINT CKTipoContenido CHECK (tipo IN('P','S'))
)
GO
--Capitulos
CREATE TABLE HCapitulos (
	ID UniqueIdentifier Not NULL,
	IDSerie SmallInt Not NULL,
	numeroTemporada TinyInt Not NULL,
	numero TinyInt Not NULL,
	CONSTRAINT PKCapitulo PRIMARY KEY (ID),
	CONSTRAINT FKCapitulosContenidos Foreign Key (ID) REFERENCES HContenidos(ID) On Delete NO ACTION On Update NO ACTION,
	CONSTRAINT FKCapitulosTemporadas Foreign Key (IDSerie,numeroTemporada) REFERENCES HTemporadas(IDSerie,numero) On Delete NO ACTION On Update NO ACTION
)
--Peliculas
CREATE TABLE HPeliculas (
	ID UniqueIdentifier Not NULL,
	titulo VarChar(30) Not NULL,
	fechaEstreno Date NULL,
	precioS SmallMoney Not NULL CONSTRAINT DFprecioS DEFAULT 0,
	precioE SmallMoney Not NULL CONSTRAINT DFprecioE DEFAULT 0,
	CONSTRAINT PKPelicula PRIMARY KEY (ID),
	CONSTRAINT FKPeliculasContenidos Foreign Key (ID) REFERENCES HContenidos(ID) On Delete NO ACTION On Update NO ACTION,
	CONSTRAINT CKPrecios CHECK (precioS >= precioE)
)
GO
--Peliculas-Generos
CREATE TABLE HPeliculasGeneros (
	IDPelicula UniqueIdentifier Not NULL,
	IDGenero TinyInt Not NULL,
	CONSTRAINT PKPeliculasGeneros  PRIMARY KEY (IDPelicula, IDGenero),
	CONSTRAINT FKPGPeliculas FOREIGN KEY (IDPelicula) REFERENCES HPeliculas (ID) On Delete NO ACTION On Update NO ACTION,
	CONSTRAINT FKPGGeneros FOREIGN KEY (IDGenero) REFERENCES HGeneros (ID) On Delete NO ACTION On Update NO ACTION
)
--Visionados (Relaci�n entre Contenidos y Perfiles)
CREATE TABLE HVisionados (
	ID UniqueIdentifier Not NULL,
	IDContenido UniqueIdentifier Not NULL,
	IDPerfil UniqueIdentifier Not NULL,
	FechaHora DateTime Not NULL,
	MinutoInicio Time NULL,
	MinutoFin Time NULL,
	CONSTRAINT PKVisionados Primary Key (ID),
	CONSTRAINT FKVisionadosContenidos Foreign Key (IDContenido) REFERENCES HContenidos(ID) On Delete NO ACTION On Update NO ACTION,
	CONSTRAINT FKVisionadosPerfiles Foreign Key (IDPerfil) REFERENCES HPerfiles(ID) On Delete NO ACTION On Update NO ACTION,
	CONSTRAINT CKTiempoVisionado CHECK(MinutoInicio<MinutoFin)
)
--								Insertamos datos
-- Suscripciones
INSERT INTO HTiposSuscripcion (tipo, nombreTipo, importeMensual) 
	VALUES ('S','Standard',10.0),('E','Extra',15.0),('P','Premium',40.0)

-- Generos
INSERT INTO HGeneros (ID, genero) 
	VALUES (1,'Comedia'), (2, 'Acci�n'), (3, 'Drama'), (4,'Thriller'), (5,'Terror'),(6,'Rom�ntica'),
	(7,'Hist�rica'), (8,'B�lica'), (9,'Documental'), (10,'Animaci�n'), (11,'Policiaca'), (12,'Western')
INSERT INTO HGeneros (ID, genero) 
	VALUES	(13,'Religi�n'), (14,'Biopic'), (15,'Gangsters'), (16,'Musical'), (17,'Melodrama'), (18,'Periodismo'),
	(19, 'Ciencia ficci�n'), (20, 'Comic')

-- Series
INSERT INTO HSeries (ID,titulo)
     VALUES (1,'La venganza del calabac�n'),(2,'Breaking Bad'),(3,'Calls'),(4,'Fantasmas'),(5,'La infamia'),(6,'El infiltrado'),
	 (7,'Estoy vivo'),(8,'True detective'),(9,'Small Axe'),(10,'El cuento de la criada'),(11,'El ala oeste de la Casa Blanca'),(12,'Los Soprano')

-- Titulares
INSERT INTO HTitulares (ID,Nombre,Apellidos,Nick,PassWord,FechaNacimiento,Bloqueado)
	--SELECT ID,Nombre,Apellidos,Nick,PassWord,FechaNacimiento,Bloqueada
	--	FROM ClubJuegos.dbo.CJUsuarias
VALUES (1, N'Arturo', N'Cantalapiedra', N'acanta      ', N'123         ', CAST(N'1974-06-15' AS Date), 0)
, (2, N'Olga', N'Rabato', N'ogara       ', N'479         ', CAST(N'1990-03-21' AS Date), 0)
, (3, N'Celestina', N'Ja', N'ceja        ', N'608         ', CAST(N'1988-08-11' AS Date), 0)
, (4, N'Conde', N'Mor', N'cmor        ', N'934         ', CAST(N'1960-11-06' AS Date), 0)
, (5, N'Salustio', N'Del Pollo', N'spollo      ', N'407         ', CAST(N'1995-02-28' AS Date), 0)
, (6, N'Bernardo', N'Minguero', N'mingo       ', N'778         ', CAST(N'1986-12-03' AS Date), 0)
, (7, N'Ombligo', N'Pato', N'bankiaman   ', N'666         ', CAST(N'1955-10-13' AS Date), 0)
, (8, N'Paquito', N'ElMecanico', N'Paco        ', N'paquitome   ', CAST(N'1992-06-12' AS Date), 0)
, (9, N'Mercurio', N'CromoVerde', N'Mercu       ', N'elmercuri   ', CAST(N'1993-01-05' AS Date), 0)
, (10, N'Baldomero', N'Empanado', N'BMempa      ', N'456         ', CAST(N'1990-06-14' AS Date), 1)
INSERT INTO HTitulares (ID,Nombre,Apellidos,Nick,PassWord,FechaNacimiento,Bloqueado)
VALUES (11, N'Bartolina', N'Baleares', N'BBalear     ', N'123         ', CAST(N'1980-02-12' AS Date), 0)
, (12, N'Protasia', N'Espiolea', N'PEspiol     ', N'123         ', CAST(N'1946-01-01' AS Date), 0)
, (13, N'Tentudia', N'Melocoton', N'TMeloco     ', N'123         ', CAST(N'1952-07-06' AS Date), 0)
, (14, N'Sinibaldo', N'Currupipi', N'SCurrup     ', N'123         ', CAST(N'1948-06-10' AS Date), 0)
, (15, N'Zosima', N'Melocoton', N'ZMeloco     ', N'123         ', CAST(N'1982-12-06' AS Date), 0)
, (16, N'Leonino', N'Escobilla', N'LEscobi     ', N'123         ', CAST(N'1964-01-06' AS Date), 0)
, (17, N'Casimira', N'Escalada', N'CEscala     ', N'123         ', CAST(N'1974-02-06' AS Date), 0)
, (18, N'Setefilla', N'Laca�ina', N'SLaca�i     ', N'123         ', CAST(N'1983-03-01' AS Date), 0)
, (19, N'Rafaela', N'Cangrejo', N'RCangre     ', N'123         ', CAST(N'1891-02-04' AS Date), 0)
, (20, N'Evelina', N'Desconchon', N'EDescon     ', N'123         ', CAST(N'1991-05-05' AS Date), 0)
INSERT INTO HTitulares (ID,Nombre,Apellidos,Nick,PassWord,FechaNacimiento,Bloqueado)
VALUES (21, N'Angela', N'Burguillos', N'ABurgui     ', N'123         ', CAST(N'1992-05-06' AS Date), 0)
, (22, N'Pier', N'Burguillos', N'PBurgui     ', N'123         ', CAST(N'1938-10-06' AS Date), 0)
, (23, N'Fernando', N'Pimpinelo', N'FPimpin     ', N'123         ', CAST(N'1995-07-06' AS Date), 0)
, (24, N'Porfirio', N'Escalpelo', N'PEscalp     ', N'123         ', CAST(N'1912-02-04' AS Date), 0)
, (25, N'Miren', N'de la Vega', N'Mdeblab     ', N'123         ', CAST(N'1971-10-03' AS Date), 0)
, (26, N'Eufrasia', N'Cantalaina', N'ECantal     ', N'123         ', CAST(N'1994-02-06' AS Date), 0)
, (27, N'Cayetano', N'Siguenza', N'CSiguen     ', N'123         ', CAST(N'1975-05-11' AS Date), 0)
, (28, N'Evaristo', N'Tura', N'ETura       ', N'123         ', CAST(N'1981-02-03' AS Date), 0)
, (29, N'Wenceslao', N'Pino', N'WPino       ', N'123         ', CAST(N'1969-03-03' AS Date), 0)
, (30, N'Emiliano', N'Escobilla', N'EEscobi     ', N'123         ', CAST(N'1991-06-03' AS Date), 0)
INSERT INTO HTitulares (ID,Nombre,Apellidos,Nick,PassWord,FechaNacimiento,Bloqueado) 
VALUES (31, N'Rocco', N'Sigfredo', N'RSigfre     ', N'123         ', CAST(N'1991-03-03' AS Date), 0)
, (32, N'Amadeo', N'De la Rosa', N'ADeblab     ', N'123         ', CAST(N'1991-10-03' AS Date), 0)
, (33, N'Herminia', N'Tura', N'HTura       ', N'123         ', CAST(N'1923-10-09' AS Date), 0)
, (34, N'Fulgencio', N'Espiolea', N'FEspiol     ', N'123         ', CAST(N'1981-03-03' AS Date), 0)
, (35, N'Leonardo', N'Cabanillas', N'LCabani     ', N'123         ', CAST(N'1900-02-12' AS Date), 0)
, (36, N'Melardo', N'Pino', N'MPino       ', N'123         ', CAST(N'2001-01-08' AS Date), 0)
, (37, N'Felipa', N'Gonzalez', N'FGonzal     ', N'123         ', CAST(N'1996-04-03' AS Date), 0)
, (38, N'Petronila', N'Rebollo', N'PReboll     ', N'123         ', CAST(N'1990-02-04' AS Date), 0)
, (39, N'Eduvigis', N'Regomello', N'ERegome     ', N'123         ', CAST(N'1992-01-06' AS Date), 0)
, (40, N'Teoduceo', N'Calcamillas', N'TCalcam     ', N'123         ', CAST(N'1974-04-04' AS Date), 0)
INSERT INTO HTitulares (ID,Nombre,Apellidos,Nick,PassWord,FechaNacimiento,Bloqueado) 
VALUES (41, N'Angel Luis', N'Ulloa', N'AUlloa      ', N'123         ', CAST(N'1976-09-01' AS Date), 0)
, (42, N'Desidonia', N'Tarancon', N'DTaranc     ', N'123         ', CAST(N'1960-02-12' AS Date), 0)
, (43, N'Carolo', N'Cabrera', N'CCabrer     ', N'123         ', CAST(N'1968-02-02' AS Date), 0)
, (44, N'Rycky', N'Minglanillas', N'RMingla     ', N'123         ', CAST(N'1979-08-11' AS Date), 0)
, (45, N'Clodovea', N'Cabrera', N'CCabrer     ', N'123         ', CAST(N'1960-03-05' AS Date), 0)
, (46, N'Ursilinio', N'Regomello', N'URegome     ', N'123         ', CAST(N'1978-02-12' AS Date), 0)
, (47, N'Pompilio', N'Carmona', N'PCarmon     ', N'123         ', CAST(N'1993-01-12' AS Date), 0)
, (48, N'Sequedo', N'Di Maria', N'SDibMar     ', N'123         ', CAST(N'2003-02-06' AS Date), 0)
, (49, N'Bolusiano', N'Alcaparra', N'BAlcapa     ', N'123         ', CAST(N'1991-10-02' AS Date), 0)
, (50, N'Mandilio', N'Gomez', N'MGomez      ', N'123         ', CAST(N'1994-02-12' AS Date), 0)
INSERT INTO HTitulares (ID,Nombre,Apellidos,Nick,PassWord,FechaNacimiento,Bloqueado)
VALUES (51, N'Capitolino', N'Sanchez', N'CSanche     ', N'123         ', CAST(N'1991-02-07' AS Date), 0)
, (52, N'Querem�n', N'de la guardia', N'Qdeblab     ', N'123         ', CAST(N'1993-02-07' AS Date), 0)
, (53, N'Antero', N'Espartero', N'AEspart     ', N'123         ', CAST(N'1994-02-03' AS Date), 0)
, (54, N'Claudinete', N'Minglanillas', N'CMingla     ', N'123         ', CAST(N'1989-01-01' AS Date), 0)
, (55, N'Climaco', N'Gutierrez', N'CGutier     ', N'123         ', CAST(N'1980-01-12' AS Date), 0)
, (56, N'Aroa', N'Ulloa', N'AUlloa      ', N'123         ', CAST(N'1999-02-09' AS Date), 0)
, (57, N'Aquiles', N'Tarancon', N'ATaranc     ', N'123         ', CAST(N'2001-02-05' AS Date), 0)
, (58, N'Rinofito', N'Minglanillas', N'RMingla     ', N'123         ', CAST(N'1921-10-02' AS Date), 0)
, (59, N'Rigoberto', N'Calcamillas', N'RCalcam     ', N'123         ', CAST(N'1987-10-01' AS Date), 0)
, (60, N'Adalberto', N'Pendulon', N'APendul     ', N'123         ', CAST(N'1990-10-10' AS Date), 0)
INSERT INTO HTitulares (ID,Nombre,Apellidos,Nick,PassWord,FechaNacimiento,Bloqueado)
VALUES (61, N'Norberto', N'Laina', N'NLaina      ', N'123         ', CAST(N'2000-02-12' AS Date), 0)
, (62, N'Mandolino', N'Singorrio', N'MSingor     ', N'123         ', CAST(N'1975-06-11' AS Date), 0)
, (63, N'Bandurrio', N'Perez', N'BPerez      ', N'123         ', CAST(N'1980-01-10' AS Date), 0)
, (64, N'Carcamala', N'jimenez', N'Cjimene     ', N'123         ', CAST(N'1991-05-07' AS Date), 0)
, (65, N'Vidala', N'Carmona', N'VCarmon     ', N'123         ', CAST(N'1978-02-04' AS Date), 0)
, (66, N'Sisinanda', N'Segovina', N'SSegovi     ', N'123         ', CAST(N'1921-03-03' AS Date), 0)
, (67, N'Consorcia', N'Perez', N'CPerez      ', N'123         ', CAST(N'1970-11-10' AS Date), 0)

GO
Set NoCount ON
-- Suscripciones

INSERT INTO HSuscripciones (id, tipo, fechaAlta, fechaBaja) 
SELECT ID, 'S', CURRENT_TIMESTAMP,NULL FROM HTitulares
GO
-- Ajustamos la fecha de alta
DECLARE @VCB int
SELECT @VCB = MIN(ID) FROM HSuscripciones 
WHILE @VCB < = (SELECT MAX(ID) FROM HSuscripciones )
BEGIN
	UPDATE HSuscripciones
		SET fechaAlta = DATEADD(DD,RAND()*(-1500)-500,fechaAlta)
		,fechaBaja = CASE WHEN (ID+Day(fechaAlta)) % 11 = 0 THEN DATEADD(DD,RAND()*(-500),CURRENT_TIMESTAMP) END
		,tipo = CASE WHEN (ID+Month(fechaAlta)) % 7 = 0 THEN 'E'
						WHEN (ID+3+Day(fechaAlta)*2) % 13 = 0 THEN 'P'
						ELSE tipo END
		WHERE ID = @VCB
		
	SELECT @VCB = MIN(ID) FROM HSuscripciones WHERE ID > @VCB
END -- While

-- Perfiles
DECLARE @IDSuscripcion Int, @NumPerfiles TinyInt, @contPerfiles tinyInt, @GrupoEdad tinyInt
DECLARE CSUSCRIPCIONES CURSOR FOR SELECT ID FROM HSuscripciones
OPEN CSuscripciones
FETCH NEXT FROM Csuscripciones INTO @IDSuscripcion
While @@FETCH_STATUS = 0
Begin
	SET @numPerfiles = RAND() * 7 + 1
	SET @contPerfiles = 1
	While @contPerfiles <= @NumPerfiles
	Begin
		SET @GrupoEdad = RAND () * 3
		INSERT INTO HPerfiles (ID,IDSuscripcion,nombre,password,grupoEdad)
			 VALUES (NewID(),@IDSuscripcion, 'peruano','123',@GrupoEdad)
		SET @contPerfiles += 1
	End -- While
	FETCH NEXT FROM Csuscripciones INTO @IDSuscripcion
End -- While
CLOSE CSuscripciones
DEALLOCATE CSuscripciones
GO

GO
-- Temporadas
DECLARE CSeries CURSOR FOR SELECT ID FROM HSeries
DECLARE @IDSerie SmallInt, @numTemporadas TinyInt, @ContTemporadas TinyInt
DECLARE @FechaEstreno Date

OPEN CSeries
FETCH NEXT FROM Cseries INTO @IDSerie
While @@FETCH_STATUS = 0
Begin
	SET @numTemporadas = RAND() * 5 + 1
	SET @FechaEstreno = DATEADD(DD,RAND()*(-100)-380*@numTemporadas,CURRENT_TIMESTAMP)
	SET @ContTemporadas = 1
	WHILE @ContTemporadas <= @numTemporadas
	Begin
		INSERT INTO HTemporadas (IDSerie,numero,FechaEstreno)
			VALUES (@IDSerie,@ContTemporadas,@FechaEstreno)
		SET @FechaEstreno= DATEADD (DD,340+RAND()*40,@fechaEstreno)
		SET @ContTemporadas+=1
	End -- While
	FETCH NEXT FROM Cseries INTO @IDSerie
End -- While
Close Cseries
Deallocate Cseries
GO

-- Contenidos

DECLARE @ContContenidos SmallInt
SET @ContContenidos = 1
-- Bucle peliculas y capitulos
While @ContContenidos <= 1000
BEGIN
	INSERT INTO HContenidos(ID,tipo,duracion,grupoEdad)
		 VALUES (NewID(),'P',DateADD(minute,RAND()*100+80,TimeFromParts(0,0,0,0,0)),RAND()*3)
	INSERT INTO HContenidos(ID,tipo,duracion,grupoEdad)
		 VALUES (NewID(),'S',DateADD(minute,RAND()*60+30,TimeFromParts(0,0,0,0,0)),RAND()*3)
	SET @ContContenidos += 1
END
GO

-- Peliculas
DECLARE @ID UniqueIdentifier, @PrecioS SmallMoney, @PrecioE SmallMoney
DECLARE CContenidos CURSOR FOR SELECT ID FROM HContenidos Where tipo = 'P'
OPEN CContenidos
FETCH NEXT FROM CContenidos INTO @ID
WHILE @@FETCH_STATUS = 0
Begin
	SET @PrecioS = FLOOR(RAND()*30)/10.0 + 3.5
	IF Floor(@PrecioS*10+3)%4 = 0
	Begin
		SET @PrecioS = 0
		SET @PrecioE = 0
	End
	ELSE IF @PrecioS < 4
		SET @PrecioE = 0
	ELSE
		SET @PrecioE = @PrecioS - FLOOR((RAND()*2 + 2)*10)/10.0
	INSERT INTO HPeliculas (ID,titulo,fechaEstreno,precioS,precioE)
		 VALUES (@ID,'Pelicula buenisima',DateAdd (day,RAND()*(-5500)-100, CURRENT_Timestamp)
			   ,@PrecioS,@PrecioE)
	FETCH NEXT FROM CContenidos INTO @ID
End	--While
CLOSE  CContenidos
DEALLOCATE CContenidos
GO
-- PeliculasGeneros
DECLARE @IDPelicula UniqueIdentifier, @cont TinyInt, @MaxGenero TinyInt, @NumGeneros TinyInt, @Genero TinyInt
DECLARE CPeliculas CURSOR FOR SELECT ID FROM HPeliculas
Open CPeliculas
SELECT @MaxGenero = MAX(ID) FROM HGeneros
FETCH NEXT FROM CPeliculas INTO @IDPelicula
WHILE @@FETCH_STATUS = 0
Begin
	SET @cont = 0
	SET @NumGeneros = Floor (RAND()*5+2)
	While @cont < @NumGeneros
	BEGIN
		SET @Genero = Floor(RAND()*@MaxGenero+1)
		IF NOT EXISTS (SELECT * FROM HPeliculasGeneros Where IDPelicula = @IDPelicula AND IDGenero = @Genero)
		Begin
			INSERT INTO HPeliculasGeneros (IDPelicula,IDGenero)
				VALUES (@IDPelicula,@Genero)
			SET @cont += 1
		End -- IF
	End -- While
	FETCH NEXT FROM CPeliculas INTO @IDPelicula
	
End -- While
Close CPeliculas
DEALLOCATE CPeliculas
GO
-- Capitulos

DECLARE @IDSerie SmallInt, @cont TinyInt, @MaxCapitulos TinyInt, @NumTemporadas TinyInt, @Temporada TinyInt
DECLARE @IDContenido UniqueIdentifier
 
DECLARE CTemporadas CURSOR FOR SELECT IDSerie, Numero FROM HTemporadas
Open CTemporadas

FETCH NEXT FROM CTemporadas INTO @IDSerie, @Temporada
WHILE @@FETCH_STATUS = 0
Begin
	SET @cont = 1
	SET @MaxCapitulos = Floor (RAND()*6)+8
	While @cont < @MaxCapitulos
	BEGIN
		SELECT TOP 1 @IDContenido = ID FROM HContenidos AS C
			Where tipo = 'S' AND ID NOT IN (SELECT ID FROM HCapitulos)
			ORDER BY NewID()
		INSERT INTO HCapitulos (ID,IDSerie,numeroTemporada,numero)
			VALUES (@IDContenido,@IDSerie,@Temporada,@cont)
		SET @cont += 1
	End -- While
	FETCH NEXT FROM CTemporadas INTO @IDSerie, @Temporada
	
End -- While
CLOSE CTemporadas
DEALLOCATE CTemporadas
-- Borramos los contenidos que no tienen nada asociado
DELETE HContenidos	
	Where ID NOT IN (SELECT ID FROM HCapitulos) AND tipo = 'C'

GO
-- Visionados
GO
DECLARE @IDContenido UniqueIdentifier,@IDPerfil UniqueIdentifier
DECLARE @Momento DateTime, @Inicio Time, @Fin Time, @cont Int, @TotalVisionados Int
DECLARE @NumPerfiles Int, @NumContenidos Int, @Duracion Time, @Suerte SmallInt

SELECT @NumPerfiles = COUNT(*) FROM HPerfiles
SELECT @NumContenidos = COUNT(*) FROM HContenidos
SET @TotalVisionados = @NumPerfiles * @NumContenidos / 10
SET @cont = 1
While @cont <= @TotalVisionados
Begin
	SELECT Top 1 @IDPerfil = ID FROM HPerfiles ORDER BY NewID()
	SELECT TOP 1 @IDContenido = ID, @Fin = duracion FROM HContenidos ORDER BY NewID()
	SET @Suerte = Floor(RAND()*10000)
	SET @Momento = DateAdd(SECOND, RAND()*(-86500000),CURRENT_TIMESTAMP)
	IF @Suerte % 15 = 0
		SET @Inicio = DateAdd(second,RAND()*3000+600, TIMEFROMPARTS (0,0,0,0,0))
	ELSE
		SET @Inicio = TIMEFROMPARTS (0,0,0,0,0)
	IF @Suerte % 17 = 0
		SET @Fin = DateAdd(second,RAND()*(-2000)-600, @Fin)
	IF @Inicio > @Fin
		SET @Inicio = TIMEFROMPARTS (0,0,0,0,0)
	INSERT INTO HVisionados (ID,IDContenido,IDPerfil,FechaHora,MinutoInicio,MinutoFin)
		 VALUES (NewID(),@IDContenido,@IDPerfil,@Momento,@Inicio,@Fin)
	SET @Cont+=1
End -- While
GO
--Recibos
Set Dateformat ymd
INSERT HRecibos (IDSuscripcion, numeroRecibo, inicioPeriodo, finPeriodo, fecha, importeSuscripcion, importeExtras) VALUES (1, 1, CAST(N'2020-01-01' AS Date), CAST(N'2020-01-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 0.0000)
, (1, 2, CAST(N'2020-02-01' AS Date), CAST(N'2020-02-29' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 0.0000)
, (1, 3, CAST(N'2020-03-01' AS Date), CAST(N'2020-03-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 0.0000)
, (1, 4, CAST(N'2020-04-01' AS Date), CAST(N'2020-04-30' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 0.0000)
, (2, 1, CAST(N'2020-01-01' AS Date), CAST(N'2020-01-31' AS Date), CAST(N'2020-05-10' AS Date), 20.0000, 0.0000)
, (2, 2, CAST(N'2020-02-01' AS Date), CAST(N'2020-02-29' AS Date), CAST(N'2020-05-10' AS Date), 20.0000, 0.0000)
, (2, 3, CAST(N'2020-03-01' AS Date), CAST(N'2020-03-31' AS Date), CAST(N'2020-05-10' AS Date), 20.0000, 0.0000)
, (2, 4, CAST(N'2020-04-01' AS Date), CAST(N'2020-04-30' AS Date), CAST(N'2020-05-10' AS Date), 20.0000, 0.0000)
, (3, 1, CAST(N'2020-01-01' AS Date), CAST(N'2020-01-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 21.6000)
, (3, 2, CAST(N'2020-02-01' AS Date), CAST(N'2020-02-29' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 26.3000)
INSERT HRecibos (IDSuscripcion, numeroRecibo, inicioPeriodo, finPeriodo, fecha, importeSuscripcion, importeExtras) 
VALUES (3, 3, CAST(N'2020-03-01' AS Date), CAST(N'2020-03-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 32.6000)
GO
INSERT [dbo].[HRecibos] ([IDSuscripcion], [numeroRecibo], [inicioPeriodo], [finPeriodo], [fecha], [importeSuscripcion], [importeExtras]) VALUES (3, 4, CAST(N'2020-04-01' AS Date), CAST(N'2020-04-30' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 25.9000)
, (4, 1, CAST(N'2020-01-01' AS Date), CAST(N'2020-01-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 107.8000)
, (4, 2, CAST(N'2020-02-01' AS Date), CAST(N'2020-02-29' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 36.2000)
, (4, 3, CAST(N'2020-03-01' AS Date), CAST(N'2020-03-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 76.0000)
, (4, 4, CAST(N'2020-04-01' AS Date), CAST(N'2020-04-30' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 32.7000)
, (5, 1, CAST(N'2020-01-01' AS Date), CAST(N'2020-01-31' AS Date), CAST(N'2020-05-10' AS Date), 40.0000, 0.0000)
GO
INSERT [dbo].[HRecibos] ([IDSuscripcion], [numeroRecibo], [inicioPeriodo], [finPeriodo], [fecha], [importeSuscripcion], [importeExtras]) VALUES (5, 2, CAST(N'2020-02-01' AS Date), CAST(N'2020-02-29' AS Date), CAST(N'2020-05-10' AS Date), 40.0000, 0.0000)
, (5, 3, CAST(N'2020-03-01' AS Date), CAST(N'2020-03-31' AS Date), CAST(N'2020-05-10' AS Date), 40.0000, 0.0000)
, (5, 4, CAST(N'2020-04-01' AS Date), CAST(N'2020-04-30' AS Date), CAST(N'2020-05-10' AS Date), 40.0000, 0.0000)
, (6, 1, CAST(N'2020-01-01' AS Date), CAST(N'2020-01-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 10.4000)
INSERT HRecibos (IDSuscripcion, numeroRecibo, inicioPeriodo, finPeriodo, fecha, importeSuscripcion, importeExtras) 
VALUES (6, 2, CAST(N'2020-02-01' AS Date), CAST(N'2020-02-29' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 9.0000)
, (6, 3, CAST(N'2020-03-01' AS Date), CAST(N'2020-03-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 4.0000)
, (6, 4, CAST(N'2020-04-01' AS Date), CAST(N'2020-04-30' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 28.8000)
, (7, 1, CAST(N'2020-01-01' AS Date), CAST(N'2020-01-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 9.1000)
, (7, 2, CAST(N'2020-02-01' AS Date), CAST(N'2020-02-29' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 17.6000)
, (7, 3, CAST(N'2020-03-01' AS Date), CAST(N'2020-03-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 20.8000)
, (7, 4, CAST(N'2020-04-01' AS Date), CAST(N'2020-04-30' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 0.0000)
, (8, 1, CAST(N'2020-01-01' AS Date), CAST(N'2020-01-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 39.7000)
, (8, 2, CAST(N'2020-02-01' AS Date), CAST(N'2020-02-29' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 45.1000)
, (8, 3, CAST(N'2020-03-01' AS Date), CAST(N'2020-03-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 27.4000)
, (8, 4, CAST(N'2020-04-01' AS Date), CAST(N'2020-04-30' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 27.0000)

INSERT HRecibos (IDSuscripcion, numeroRecibo, inicioPeriodo, finPeriodo, fecha, importeSuscripcion, importeExtras) 
VALUES (9, 1, CAST(N'2020-01-01' AS Date), CAST(N'2020-01-31' AS Date), CAST(N'2020-05-10' AS Date), 20.0000, 3.1000)
, (9, 2, CAST(N'2020-02-01' AS Date), CAST(N'2020-02-29' AS Date), CAST(N'2020-05-10' AS Date), 20.0000, 0.0000)
, (9, 3, CAST(N'2020-03-01' AS Date), CAST(N'2020-03-31' AS Date), CAST(N'2020-05-10' AS Date), 20.0000, 1.3000)
, (9, 4, CAST(N'2020-04-01' AS Date), CAST(N'2020-04-30' AS Date), CAST(N'2020-05-10' AS Date), 20.0000, 1.8000)
, (10, 1, CAST(N'2020-01-01' AS Date), CAST(N'2020-01-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 17.5000)
, (10, 2, CAST(N'2020-02-01' AS Date), CAST(N'2020-02-29' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 14.1000)
, (10, 3, CAST(N'2020-03-01' AS Date), CAST(N'2020-03-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 29.3000)
, (10, 4, CAST(N'2020-04-01' AS Date), CAST(N'2020-04-30' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 5.2000)
, (11, 1, CAST(N'2020-01-01' AS Date), CAST(N'2020-01-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 0.0000)
, (11, 2, CAST(N'2020-02-01' AS Date), CAST(N'2020-02-29' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 0.0000)
, (11, 3, CAST(N'2020-03-01' AS Date), CAST(N'2020-03-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 0.0000)
INSERT HRecibos (IDSuscripcion, numeroRecibo, inicioPeriodo, finPeriodo, fecha, importeSuscripcion, importeExtras) 
VALUES (11, 4, CAST(N'2020-04-01' AS Date), CAST(N'2020-04-30' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 0.0000)
, (12, 1, CAST(N'2020-01-01' AS Date), CAST(N'2020-01-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 22.5000)
, (12, 2, CAST(N'2020-02-01' AS Date), CAST(N'2020-02-29' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 48.1000)
, (12, 3, CAST(N'2020-03-01' AS Date), CAST(N'2020-03-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 32.1000)
, (12, 4, CAST(N'2020-04-01' AS Date), CAST(N'2020-04-30' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 9.1000)
, (13, 1, CAST(N'2020-01-01' AS Date), CAST(N'2020-01-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 25.6000)
, (13, 2, CAST(N'2020-02-01' AS Date), CAST(N'2020-02-29' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 49.3000)
, (13, 3, CAST(N'2020-03-01' AS Date), CAST(N'2020-03-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 37.0000)
, (13, 4, CAST(N'2020-04-01' AS Date), CAST(N'2020-04-30' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 64.8000)
, (14, 1, CAST(N'2020-01-01' AS Date), CAST(N'2020-01-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 16.5000)
, (14, 2, CAST(N'2020-02-01' AS Date), CAST(N'2020-02-29' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 4.6000)
, (14, 3, CAST(N'2020-03-01' AS Date), CAST(N'2020-03-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 15.2000)

INSERT HRecibos (IDSuscripcion, numeroRecibo, inicioPeriodo, finPeriodo, fecha, importeSuscripcion, importeExtras) 
VALUES (14, 4, CAST(N'2020-04-01' AS Date), CAST(N'2020-04-30' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 24.3000)
, (15, 1, CAST(N'2020-01-01' AS Date), CAST(N'2020-01-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 58.1000)
, (15, 2, CAST(N'2020-02-01' AS Date), CAST(N'2020-02-29' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 67.9000)
, (15, 3, CAST(N'2020-03-01' AS Date), CAST(N'2020-03-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 53.8000)
, (15, 4, CAST(N'2020-04-01' AS Date), CAST(N'2020-04-30' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 34.4000)
, (16, 1, CAST(N'2020-01-01' AS Date), CAST(N'2020-01-31' AS Date), CAST(N'2020-05-10' AS Date), 20.0000, 8.2000)
, (16, 2, CAST(N'2020-02-01' AS Date), CAST(N'2020-02-29' AS Date), CAST(N'2020-05-10' AS Date), 20.0000, 17.8000)
, (16, 3, CAST(N'2020-03-01' AS Date), CAST(N'2020-03-31' AS Date), CAST(N'2020-05-10' AS Date), 20.0000, 12.9000)
, (16, 4, CAST(N'2020-04-01' AS Date), CAST(N'2020-04-30' AS Date), CAST(N'2020-05-10' AS Date), 20.0000, 22.1000)
, (17, 1, CAST(N'2020-01-01' AS Date), CAST(N'2020-01-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 14.5000)
, (17, 2, CAST(N'2020-02-01' AS Date), CAST(N'2020-02-29' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 7.5000)
, (17, 3, CAST(N'2020-03-01' AS Date), CAST(N'2020-03-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 9.0000)
, (17, 4, CAST(N'2020-04-01' AS Date), CAST(N'2020-04-30' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 16.5000)
GO
INSERT HRecibos (IDSuscripcion, numeroRecibo, inicioPeriodo, finPeriodo, fecha, importeSuscripcion, importeExtras) 
VALUES (18, 1, CAST(N'2020-01-01' AS Date), CAST(N'2020-01-31' AS Date), CAST(N'2020-05-10' AS Date), 40.0000, 0.0000)
, (18, 2, CAST(N'2020-02-01' AS Date), CAST(N'2020-02-29' AS Date), CAST(N'2020-05-10' AS Date), 40.0000, 0.0000)
, (18, 3, CAST(N'2020-03-01' AS Date), CAST(N'2020-03-31' AS Date), CAST(N'2020-05-10' AS Date), 40.0000, 0.0000)
, (18, 4, CAST(N'2020-04-01' AS Date), CAST(N'2020-04-30' AS Date), CAST(N'2020-05-10' AS Date), 40.0000, 0.0000)
, (19, 1, CAST(N'2020-01-01' AS Date), CAST(N'2020-01-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 32.2000)
, (19, 2, CAST(N'2020-02-01' AS Date), CAST(N'2020-02-29' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 0.0000)
, (19, 3, CAST(N'2020-03-01' AS Date), CAST(N'2020-03-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 29.8000)
, (19, 4, CAST(N'2020-04-01' AS Date), CAST(N'2020-04-30' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 4.7000)
, (20, 1, CAST(N'2020-01-01' AS Date), CAST(N'2020-01-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 33.1000)
, (20, 2, CAST(N'2020-02-01' AS Date), CAST(N'2020-02-29' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 0.0000)
, (20, 3, CAST(N'2020-03-01' AS Date), CAST(N'2020-03-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 15.1000)
INSERT HRecibos (IDSuscripcion, numeroRecibo, inicioPeriodo, finPeriodo, fecha, importeSuscripcion, importeExtras) 
VALUES (20, 4, CAST(N'2020-04-01' AS Date), CAST(N'2020-04-30' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 16.1000)
, (21, 1, CAST(N'2020-01-01' AS Date), CAST(N'2020-01-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 14.2000)
, (21, 2, CAST(N'2020-02-01' AS Date), CAST(N'2020-02-29' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 11.0000)
, (21, 3, CAST(N'2020-03-01' AS Date), CAST(N'2020-03-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 28.2000)
, (21, 4, CAST(N'2020-04-01' AS Date), CAST(N'2020-04-30' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 14.8000)
, (22, 1, CAST(N'2020-01-01' AS Date), CAST(N'2020-01-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 0.0000)
, (22, 2, CAST(N'2020-02-01' AS Date), CAST(N'2020-02-29' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 0.0000)
, (22, 3, CAST(N'2020-03-01' AS Date), CAST(N'2020-03-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 0.0000)
, (22, 4, CAST(N'2020-04-01' AS Date), CAST(N'2020-04-30' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 0.0000)
, (23, 1, CAST(N'2020-01-01' AS Date), CAST(N'2020-01-31' AS Date), CAST(N'2020-05-10' AS Date), 20.0000, 0.0000)
, (23, 2, CAST(N'2020-02-01' AS Date), CAST(N'2020-02-29' AS Date), CAST(N'2020-05-10' AS Date), 20.0000, 0.0000)
, (23, 3, CAST(N'2020-03-01' AS Date), CAST(N'2020-03-31' AS Date), CAST(N'2020-05-10' AS Date), 20.0000, 0.0000)
INSERT HRecibos (IDSuscripcion, numeroRecibo, inicioPeriodo, finPeriodo, fecha, importeSuscripcion, importeExtras) 
VALUES (23, 4, CAST(N'2020-04-01' AS Date), CAST(N'2020-04-30' AS Date), CAST(N'2020-05-10' AS Date), 20.0000, 0.0000)
, (24, 1, CAST(N'2020-01-01' AS Date), CAST(N'2020-01-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 14.0000)
, (24, 2, CAST(N'2020-02-01' AS Date), CAST(N'2020-02-29' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 22.5000)
, (24, 3, CAST(N'2020-03-01' AS Date), CAST(N'2020-03-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 10.6000)
, (24, 4, CAST(N'2020-04-01' AS Date), CAST(N'2020-04-30' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 13.7000)
, (25, 1, CAST(N'2020-01-01' AS Date), CAST(N'2020-01-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 11.1000)
, (25, 2, CAST(N'2020-02-01' AS Date), CAST(N'2020-02-29' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 23.1000)
, (25, 3, CAST(N'2020-03-01' AS Date), CAST(N'2020-03-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 29.4000)
, (25, 4, CAST(N'2020-04-01' AS Date), CAST(N'2020-04-30' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 18.1000)
INSERT HRecibos (IDSuscripcion, numeroRecibo, inicioPeriodo, finPeriodo, fecha, importeSuscripcion, importeExtras) 
VALUES (26, 1, CAST(N'2020-01-01' AS Date), CAST(N'2020-01-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 21.5000)
, (26, 2, CAST(N'2020-02-01' AS Date), CAST(N'2020-02-29' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 11.6000)
, (26, 3, CAST(N'2020-03-01' AS Date), CAST(N'2020-03-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 16.1000)
, (26, 4, CAST(N'2020-04-01' AS Date), CAST(N'2020-04-30' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 15.4000)
, (27, 1, CAST(N'2020-01-01' AS Date), CAST(N'2020-01-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 4.8000)
, (27, 2, CAST(N'2020-02-01' AS Date), CAST(N'2020-02-29' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 31.7000)
, (27, 3, CAST(N'2020-03-01' AS Date), CAST(N'2020-03-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 35.9000)
, (27, 4, CAST(N'2020-04-01' AS Date), CAST(N'2020-04-30' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 18.8000)
, (28, 1, CAST(N'2020-01-01' AS Date), CAST(N'2020-01-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 30.7000)
, (28, 2, CAST(N'2020-02-01' AS Date), CAST(N'2020-02-29' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 26.8000)
, (28, 3, CAST(N'2020-03-01' AS Date), CAST(N'2020-03-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 61.1000)
GO
INSERT [dbo].[HRecibos] ([IDSuscripcion], [numeroRecibo], [inicioPeriodo], [finPeriodo], [fecha], [importeSuscripcion], [importeExtras]) VALUES (28, 4, CAST(N'2020-04-01' AS Date), CAST(N'2020-04-30' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 44.9000)
GO
INSERT HRecibos (IDSuscripcion, numeroRecibo, inicioPeriodo, finPeriodo, fecha, importeSuscripcion, importeExtras) 
VALUES (29, 1, CAST(N'2020-01-01' AS Date), CAST(N'2020-01-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 35.9000)
, (29, 2, CAST(N'2020-02-01' AS Date), CAST(N'2020-02-29' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 32.3000)
, (29, 3, CAST(N'2020-03-01' AS Date), CAST(N'2020-03-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 31.3000)
, (29, 4, CAST(N'2020-04-01' AS Date), CAST(N'2020-04-30' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 14.8000)
, (30, 1, CAST(N'2020-01-01' AS Date), CAST(N'2020-01-31' AS Date), CAST(N'2020-05-10' AS Date), 20.0000, 7.3000)
, (30, 2, CAST(N'2020-02-01' AS Date), CAST(N'2020-02-29' AS Date), CAST(N'2020-05-10' AS Date), 20.0000, 11.8000)
, (30, 3, CAST(N'2020-03-01' AS Date), CAST(N'2020-03-31' AS Date), CAST(N'2020-05-10' AS Date), 20.0000, 2.4000)
, (30, 4, CAST(N'2020-04-01' AS Date), CAST(N'2020-04-30' AS Date), CAST(N'2020-05-10' AS Date), 20.0000, 2.2000)
, (31, 1, CAST(N'2020-01-01' AS Date), CAST(N'2020-01-31' AS Date), CAST(N'2020-05-10' AS Date), 40.0000, 0.0000)
, (31, 2, CAST(N'2020-02-01' AS Date), CAST(N'2020-02-29' AS Date), CAST(N'2020-05-10' AS Date), 40.0000, 0.0000)
INSERT HRecibos (IDSuscripcion, numeroRecibo, inicioPeriodo, finPeriodo, fecha, importeSuscripcion, importeExtras) 
VALUES (31, 3, CAST(N'2020-03-01' AS Date), CAST(N'2020-03-31' AS Date), CAST(N'2020-05-10' AS Date), 40.0000, 0.0000)
, (31, 4, CAST(N'2020-04-01' AS Date), CAST(N'2020-04-30' AS Date), CAST(N'2020-05-10' AS Date), 40.0000, 0.0000)
, (32, 1, CAST(N'2020-01-01' AS Date), CAST(N'2020-01-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 25.2000)
, (32, 2, CAST(N'2020-02-01' AS Date), CAST(N'2020-02-29' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 47.3000)
, (32, 3, CAST(N'2020-03-01' AS Date), CAST(N'2020-03-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 52.4000)
, (32, 4, CAST(N'2020-04-01' AS Date), CAST(N'2020-04-30' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 17.1000)
, (33, 1, CAST(N'2020-01-01' AS Date), CAST(N'2020-01-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 24.6000)
, (33, 2, CAST(N'2020-02-01' AS Date), CAST(N'2020-02-29' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 16.2000)
, (33, 3, CAST(N'2020-03-01' AS Date), CAST(N'2020-03-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 32.2000)
, (33, 4, CAST(N'2020-04-01' AS Date), CAST(N'2020-04-30' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 37.8000)
, (34, 1, CAST(N'2020-01-01' AS Date), CAST(N'2020-01-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 46.2000)
, (34, 2, CAST(N'2020-02-01' AS Date), CAST(N'2020-02-29' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 51.9000)
INSERT HRecibos (IDSuscripcion, numeroRecibo, inicioPeriodo, finPeriodo, fecha, importeSuscripcion, importeExtras) 
VALUES (34, 3, CAST(N'2020-03-01' AS Date), CAST(N'2020-03-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 39.2000)
, (34, 4, CAST(N'2020-04-01' AS Date), CAST(N'2020-04-30' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 30.0000)
, (35, 1, CAST(N'2020-01-01' AS Date), CAST(N'2020-01-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 27.8000)
, (35, 2, CAST(N'2020-02-01' AS Date), CAST(N'2020-02-29' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 18.1000)
, (35, 3, CAST(N'2020-03-01' AS Date), CAST(N'2020-03-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 28.9000)
, (35, 4, CAST(N'2020-04-01' AS Date), CAST(N'2020-04-30' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 41.0000)
, (36, 1, CAST(N'2020-01-01' AS Date), CAST(N'2020-01-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 5.0000)
, (36, 2, CAST(N'2020-02-01' AS Date), CAST(N'2020-02-29' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 36.1000)
, (36, 3, CAST(N'2020-03-01' AS Date), CAST(N'2020-03-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 18.9000)
, (36, 4, CAST(N'2020-04-01' AS Date), CAST(N'2020-04-30' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 44.4000)
, (37, 1, CAST(N'2020-01-01' AS Date), CAST(N'2020-01-31' AS Date), CAST(N'2020-05-10' AS Date), 20.0000, 22.1000)
GO
INSERT HRecibos (IDSuscripcion, numeroRecibo, inicioPeriodo, finPeriodo, fecha, importeSuscripcion, importeExtras) 
VALUES (37, 2, CAST(N'2020-02-01' AS Date), CAST(N'2020-02-29' AS Date), CAST(N'2020-05-10' AS Date), 20.0000, 6.7000)
, (37, 3, CAST(N'2020-03-01' AS Date), CAST(N'2020-03-31' AS Date), CAST(N'2020-05-10' AS Date), 20.0000, 9.5000)
, (37, 4, CAST(N'2020-04-01' AS Date), CAST(N'2020-04-30' AS Date), CAST(N'2020-05-10' AS Date), 20.0000, 30.2000)
, (38, 1, CAST(N'2020-01-01' AS Date), CAST(N'2020-01-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 0.0000)
, (38, 2, CAST(N'2020-02-01' AS Date), CAST(N'2020-02-29' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 9.1000)
, (38, 3, CAST(N'2020-03-01' AS Date), CAST(N'2020-03-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 21.0000)
, (38, 4, CAST(N'2020-04-01' AS Date), CAST(N'2020-04-30' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 13.0000)
, (39, 1, CAST(N'2020-01-01' AS Date), CAST(N'2020-01-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 13.9000)
, (39, 2, CAST(N'2020-02-01' AS Date), CAST(N'2020-02-29' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 24.7000)
, (39, 3, CAST(N'2020-03-01' AS Date), CAST(N'2020-03-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 36.0000)
, (39, 4, CAST(N'2020-04-01' AS Date), CAST(N'2020-04-30' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 82.9000)
INSERT HRecibos (IDSuscripcion, numeroRecibo, inicioPeriodo, finPeriodo, fecha, importeSuscripcion, importeExtras) 
VALUES (40, 1, CAST(N'2020-01-01' AS Date), CAST(N'2020-01-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 0.0000)
, (40, 2, CAST(N'2020-02-01' AS Date), CAST(N'2020-02-29' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 0.0000)
, (40, 3, CAST(N'2020-03-01' AS Date), CAST(N'2020-03-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 0.0000)
, (40, 4, CAST(N'2020-04-01' AS Date), CAST(N'2020-04-30' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 0.0000)
, (41, 1, CAST(N'2020-01-01' AS Date), CAST(N'2020-01-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 28.0000)
, (41, 2, CAST(N'2020-02-01' AS Date), CAST(N'2020-02-29' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 44.4000)
,(41, 3, CAST(N'2020-03-01' AS Date), CAST(N'2020-03-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 14.7000)
, (41, 4, CAST(N'2020-04-01' AS Date), CAST(N'2020-04-30' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 40.8000)
, (41, 5, CAST(N'2021-03-01' AS Date), CAST(N'2021-03-31' AS Date), CAST(N'2021-05-10' AS Date), 10.0000, 51.9000)
, (42, 1, CAST(N'2020-01-01' AS Date), CAST(N'2020-01-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 24.9000)
, (42, 2, CAST(N'2020-02-01' AS Date), CAST(N'2020-02-29' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 16.6000)
INSERT HRecibos (IDSuscripcion, numeroRecibo, inicioPeriodo, finPeriodo, fecha, importeSuscripcion, importeExtras) 
VALUES (42, 3, CAST(N'2020-03-01' AS Date), CAST(N'2020-03-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 20.6000)
, (42, 4, CAST(N'2020-04-01' AS Date), CAST(N'2020-04-30' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 20.4000)
, (43, 1, CAST(N'2020-01-01' AS Date), CAST(N'2020-01-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 28.8000)
, (43, 2, CAST(N'2020-02-01' AS Date), CAST(N'2020-02-29' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 7.4000)
, (43, 3, CAST(N'2020-03-01' AS Date), CAST(N'2020-03-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 35.3000)
, (43, 4, CAST(N'2020-04-01' AS Date), CAST(N'2020-04-30' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 36.8000)
, (44, 1, CAST(N'2020-01-01' AS Date), CAST(N'2020-01-31' AS Date), CAST(N'2020-05-10' AS Date), 20.0000, 26.3000)
, (44, 2, CAST(N'2020-02-01' AS Date), CAST(N'2020-02-29' AS Date), CAST(N'2020-05-10' AS Date), 20.0000, 23.7000)
, (44, 3, CAST(N'2020-03-01' AS Date), CAST(N'2020-03-31' AS Date), CAST(N'2020-05-10' AS Date), 20.0000, 33.7000)
, (44, 4, CAST(N'2020-04-01' AS Date), CAST(N'2020-04-30' AS Date), CAST(N'2020-05-10' AS Date), 20.0000, 41.9000)
, (45, 1, CAST(N'2020-01-01' AS Date), CAST(N'2020-01-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 14.3000)
, (45, 2, CAST(N'2020-02-01' AS Date), CAST(N'2020-02-29' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 5.4000)
GO
INSERT HRecibos (IDSuscripcion, numeroRecibo, inicioPeriodo, finPeriodo, fecha, importeSuscripcion, importeExtras) 
VALUES (45, 3, CAST(N'2020-03-01' AS Date), CAST(N'2020-03-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 19.8000)
, (45, 4, CAST(N'2020-04-01' AS Date), CAST(N'2020-04-30' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 6.4000)
, (46, 1, CAST(N'2020-01-01' AS Date), CAST(N'2020-01-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 35.9000)
, (46, 2, CAST(N'2020-02-01' AS Date), CAST(N'2020-02-29' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 21.7000)
, (46, 3, CAST(N'2020-03-01' AS Date), CAST(N'2020-03-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 6.2000)
, (46, 4, CAST(N'2020-04-01' AS Date), CAST(N'2020-04-30' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 19.9000)
, (47, 1, CAST(N'2020-01-01' AS Date), CAST(N'2020-01-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 0.0000)
, (47, 2, CAST(N'2020-02-01' AS Date), CAST(N'2020-02-29' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 0.0000)
, (47, 3, CAST(N'2020-03-01' AS Date), CAST(N'2020-03-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 0.0000)
, (47, 4, CAST(N'2020-04-01' AS Date), CAST(N'2020-04-30' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 0.0000)
, (48, 1, CAST(N'2020-01-01' AS Date), CAST(N'2020-01-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 0.0000)
INSERT HRecibos (IDSuscripcion, numeroRecibo, inicioPeriodo, finPeriodo, fecha, importeSuscripcion, importeExtras) 
VALUES (48, 2, CAST(N'2020-02-01' AS Date), CAST(N'2020-02-29' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 0.0000)
, (48, 3, CAST(N'2020-03-01' AS Date), CAST(N'2020-03-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 0.0000)
, (48, 4, CAST(N'2020-04-01' AS Date), CAST(N'2020-04-30' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 0.0000)
, (49, 1, CAST(N'2020-01-01' AS Date), CAST(N'2020-01-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 6.0000)
, (49, 2, CAST(N'2020-02-01' AS Date), CAST(N'2020-02-29' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 6.4000)
, (49, 3, CAST(N'2020-03-01' AS Date), CAST(N'2020-03-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 5.1000)
, (49, 4, CAST(N'2020-04-01' AS Date), CAST(N'2020-04-30' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 21.3000)
, (50, 1, CAST(N'2020-01-01' AS Date), CAST(N'2020-01-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 15.7000)
, (50, 2, CAST(N'2020-02-01' AS Date), CAST(N'2020-02-29' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 4.3000)
, (50, 3, CAST(N'2020-03-01' AS Date), CAST(N'2020-03-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 0.0000)
, (50, 4, CAST(N'2020-04-01' AS Date), CAST(N'2020-04-30' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 7.8000)
INSERT HRecibos (IDSuscripcion, numeroRecibo, inicioPeriodo, finPeriodo, fecha, importeSuscripcion, importeExtras) 
VALUES (51, 1, CAST(N'2020-01-01' AS Date), CAST(N'2020-01-31' AS Date), CAST(N'2020-05-10' AS Date), 20.0000, 0.0000)
, (51, 2, CAST(N'2020-02-01' AS Date), CAST(N'2020-02-29' AS Date), CAST(N'2020-05-10' AS Date), 20.0000, 0.0000)
, (51, 3, CAST(N'2020-03-01' AS Date), CAST(N'2020-03-31' AS Date), CAST(N'2020-05-10' AS Date), 20.0000, 0.0000)
, (51, 4, CAST(N'2020-04-01' AS Date), CAST(N'2020-04-30' AS Date), CAST(N'2020-05-10' AS Date), 20.0000, 0.0000)
, (52, 1, CAST(N'2020-01-01' AS Date), CAST(N'2020-01-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 11.1000)
, (52, 2, CAST(N'2020-02-01' AS Date), CAST(N'2020-02-29' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 14.8000)
, (52, 3, CAST(N'2020-03-01' AS Date), CAST(N'2020-03-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 22.1000)
GO
INSERT [dbo].[HRecibos] ([IDSuscripcion], [numeroRecibo], [inicioPeriodo], [finPeriodo], [fecha], [importeSuscripcion], [importeExtras]) VALUES (52, 4, CAST(N'2020-04-01' AS Date), CAST(N'2020-04-30' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 11.6000)
, (53, 1, CAST(N'2020-01-01' AS Date), CAST(N'2020-01-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 0.0000)
, (53, 2, CAST(N'2020-02-01' AS Date), CAST(N'2020-02-29' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 0.0000)
, (53, 3, CAST(N'2020-03-01' AS Date), CAST(N'2020-03-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 0.0000)
, (53, 4, CAST(N'2020-04-01' AS Date), CAST(N'2020-04-30' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 0.0000)
, (54, 1, CAST(N'2020-01-01' AS Date), CAST(N'2020-01-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 0.0000)
, (54, 2, CAST(N'2020-02-01' AS Date), CAST(N'2020-02-29' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 28.1000)
, (54, 3, CAST(N'2020-03-01' AS Date), CAST(N'2020-03-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 8.6000)
, (54, 4, CAST(N'2020-04-01' AS Date), CAST(N'2020-04-30' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 9.5000)
, (55, 1, CAST(N'2020-01-01' AS Date), CAST(N'2020-01-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 18.1000)
, (55, 2, CAST(N'2020-02-01' AS Date), CAST(N'2020-02-29' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 17.8000)
, (55, 3, CAST(N'2020-03-01' AS Date), CAST(N'2020-03-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 21.2000)
, (55, 4, CAST(N'2020-04-01' AS Date), CAST(N'2020-04-30' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 3.9000)
, (56, 1, CAST(N'2020-01-01' AS Date), CAST(N'2020-01-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 0.0000)
INSERT HRecibos (IDSuscripcion, numeroRecibo, inicioPeriodo, finPeriodo, fecha, importeSuscripcion, importeExtras) 
VALUES (56, 2, CAST(N'2020-02-01' AS Date), CAST(N'2020-02-29' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 0.0000)
, (56, 3, CAST(N'2020-03-01' AS Date), CAST(N'2020-03-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 0.0000)
, (56, 4, CAST(N'2020-04-01' AS Date), CAST(N'2020-04-30' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 0.0000)
, (57, 1, CAST(N'2020-01-01' AS Date), CAST(N'2020-01-31' AS Date), CAST(N'2020-05-10' AS Date), 40.0000, 0.0000)
, (57, 2, CAST(N'2020-02-01' AS Date), CAST(N'2020-02-29' AS Date), CAST(N'2020-05-10' AS Date), 40.0000, 0.0000)
, (57, 3, CAST(N'2020-03-01' AS Date), CAST(N'2020-03-31' AS Date), CAST(N'2020-05-10' AS Date), 40.0000, 0.0000)
, (57, 4, CAST(N'2020-04-01' AS Date), CAST(N'2020-04-30' AS Date), CAST(N'2020-05-10' AS Date), 40.0000, 0.0000)
, (58, 1, CAST(N'2020-01-01' AS Date), CAST(N'2020-01-31' AS Date), CAST(N'2020-05-10' AS Date), 20.0000, 15.9000)
, (58, 2, CAST(N'2020-02-01' AS Date), CAST(N'2020-02-29' AS Date), CAST(N'2020-05-10' AS Date), 20.0000, 8.9000)
, (58, 3, CAST(N'2020-03-01' AS Date), CAST(N'2020-03-31' AS Date), CAST(N'2020-05-10' AS Date), 20.0000, 7.0000)
, (58, 4, CAST(N'2020-04-01' AS Date), CAST(N'2020-04-30' AS Date), CAST(N'2020-05-10' AS Date), 20.0000, 4.5000)
INSERT HRecibos (IDSuscripcion, numeroRecibo, inicioPeriodo, finPeriodo, fecha, importeSuscripcion, importeExtras) 
VALUES (59, 1, CAST(N'2020-01-01' AS Date), CAST(N'2020-01-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 21.0000)
, (59, 2, CAST(N'2020-02-01' AS Date), CAST(N'2020-02-29' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 28.7000)
, (59, 3, CAST(N'2020-03-01' AS Date), CAST(N'2020-03-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 55.1000)
, (59, 4, CAST(N'2020-04-01' AS Date), CAST(N'2020-04-30' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 32.3000)
, (60, 1, CAST(N'2020-01-01' AS Date), CAST(N'2020-01-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 17.4000)
, (60, 2, CAST(N'2020-02-01' AS Date), CAST(N'2020-02-29' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 9.6000)
, (60, 3, CAST(N'2020-03-01' AS Date), CAST(N'2020-03-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 3.9000)
, (60, 4, CAST(N'2020-04-01' AS Date), CAST(N'2020-04-30' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 0.0000)
, (61, 1, CAST(N'2020-01-01' AS Date), CAST(N'2020-01-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 0.0000)
, (61, 2, CAST(N'2020-02-01' AS Date), CAST(N'2020-02-29' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 0.0000)
, (61, 3, CAST(N'2020-03-01' AS Date), CAST(N'2020-03-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 0.0000)
, (61, 4, CAST(N'2020-04-01' AS Date), CAST(N'2020-04-30' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 0.0000)
GO
INSERT HRecibos (IDSuscripcion, numeroRecibo, inicioPeriodo, finPeriodo, fecha, importeSuscripcion, importeExtras) 
VALUES (62, 1, CAST(N'2020-01-01' AS Date), CAST(N'2020-01-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 0.0000)
, (62, 2, CAST(N'2020-02-01' AS Date), CAST(N'2020-02-29' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 0.0000)
, (62, 3, CAST(N'2020-03-01' AS Date), CAST(N'2020-03-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 0.0000)
, (62, 4, CAST(N'2020-04-01' AS Date), CAST(N'2020-04-30' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 0.0000)
, (63, 1, CAST(N'2020-01-01' AS Date), CAST(N'2020-01-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 16.9000)
, (63, 2, CAST(N'2020-02-01' AS Date), CAST(N'2020-02-29' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 5.0000)
, (63, 3, CAST(N'2020-03-01' AS Date), CAST(N'2020-03-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 14.2000)
, (63, 4, CAST(N'2020-04-01' AS Date), CAST(N'2020-04-30' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 17.7000)
, (64, 1, CAST(N'2020-01-01' AS Date), CAST(N'2020-01-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 7.0000)
, (64, 2, CAST(N'2020-02-01' AS Date), CAST(N'2020-02-29' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 12.7000)
, (64, 3, CAST(N'2020-03-01' AS Date), CAST(N'2020-03-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 16.1000)
, (64, 4, CAST(N'2020-04-01' AS Date), CAST(N'2020-04-30' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 0.0000)
INSERT HRecibos (IDSuscripcion, numeroRecibo, inicioPeriodo, finPeriodo, fecha, importeSuscripcion, importeExtras) 
VALUES (65, 1, CAST(N'2020-01-01' AS Date), CAST(N'2020-01-31' AS Date), CAST(N'2020-05-10' AS Date), 20.0000, 0.0000)
, (65, 2, CAST(N'2020-02-01' AS Date), CAST(N'2020-02-29' AS Date), CAST(N'2020-05-10' AS Date), 20.0000, 0.0000)
, (65, 3, CAST(N'2020-03-01' AS Date), CAST(N'2020-03-31' AS Date), CAST(N'2020-05-10' AS Date), 20.0000, 0.0000)
, (65, 4, CAST(N'2020-04-01' AS Date), CAST(N'2020-04-30' AS Date), CAST(N'2020-05-10' AS Date), 20.0000, 0.0000)
, (66, 1, CAST(N'2020-01-01' AS Date), CAST(N'2020-01-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 33.5000)
, (66, 2, CAST(N'2020-02-01' AS Date), CAST(N'2020-02-29' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 31.7000)
, (66, 3, CAST(N'2020-03-01' AS Date), CAST(N'2020-03-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 57.2000)
, (66, 4, CAST(N'2020-04-01' AS Date), CAST(N'2020-04-30' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 28.9000)
, (67, 1, CAST(N'2020-01-01' AS Date), CAST(N'2020-01-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 17.5000)
, (67, 2, CAST(N'2020-02-01' AS Date), CAST(N'2020-02-29' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 9.8000)
, (67, 3, CAST(N'2020-03-01' AS Date), CAST(N'2020-03-31' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 20.0000)
, (67, 4, CAST(N'2020-04-01' AS Date), CAST(N'2020-04-30' AS Date), CAST(N'2020-05-10' AS Date), 10.0000, 21.2000)



----------		SELECT * FROM HVisionados
----------		SELECT * FROM HTemporadas
----------      SELECT * FROM HContenidos
----------      SELECT * FROM HPeliculas
----------      SELECT * FROM HCapitulos ORder By IDSerie, NumeroTemporada, numero
----------      SELECT * FROM HPeliculasGeneros
----------		SELECT * FROM HTitulares
----------		SELECT * FROM HPerfiles
----------      SELECT * FROM HSuscripciones
----------      SELECT * FROM HRecibos

----------      DELETE HContenidos
----------      DELETE HCapitulos
----------		DELETE HPerfiles
----------		DELETE HSuscripciones
----------		DELETE HVisionados
----------		DELETE HRecibos
