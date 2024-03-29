SET Dateformat ymd
Create DataBase [LeoTurfTest]
Go
USE [LeoTurfTest]
GO
/****** Object:  StoredProcedure [dbo].[AsignaPremios]    Script Date: 04/03/2018 20:27:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[AsignaPremios] (@Carrera SmallInt) AS
  BEgin
	Declare @TotalApostado SmallMoney, @PremioPrimero SmallMoney, @PremioSegundo SmallMoney
	-- Calculamos el total de las apuestas de esa carrera
	Select @TotalApostado = Sum (Importe) From LTApuestas
		Where IDCarrera = @Carrera
	-- Repartimos por categorias
	--Para los que acierten el primero el 60%
	Set @PremioPrimero = @TotalApostado * 0.6
	-- Para los que acierten el segundo, el 20%
	Set @PremioSegundo = @TotalApostado * 0.2
	Update LTCaballosCarreras 
		Set Premio1 = IsNull(@PremioPrimero/dbo.TotalApostadoCC(IDCaballo,@Carrera),100)
		, Premio2 = IsNull(@PremioSegundo/dbo.TotalApostadoCC(IDCaballo,@Carrera),100)
		Where IDCarrera = @Carrera
  End -- Procedure AsignaPremios
GO
/****** Object:  StoredProcedure [dbo].[grabaApuesta]    Script Date: 04/03/2018 20:27:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[grabaApuesta] 
	@Carrera SmallInt
	,@Caballo SmallInt
	,@Importe SmallMoney
	,@Clave Char(12)
	,@Id SmallInt OUTPUT
	AS Begin
		INSERT INTO LTApuestas ( Clave, IDCaballo, IDCarrera,Importe) VALUES (@Clave, @Caballo, @Carrera, @Importe) 
		SET @ID = @@IDENTITY
	End --PROCEDURE grabaApuesta 
GO
/****** Object:  UserDefinedFunction [dbo].[TotalApostadoCC]    Script Date: 04/03/2018 20:27:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  -- Función que nos devuelve la cantidad apostada por un caballo en una carrera. Si no se ha apostado nada, devuelve NULL
  Create Function [dbo].[TotalApostadoCC] (@Caballo SmallInt, @Carrera SmallInt) Returns SmallMoney AS
  Begin
	Declare @Importe SmallMoney
	Select @Importe = Sum (Importe) From LTApuestas
		Where IDCaballo = @Caballo AND IDCarrera = @Carrera
	Return @Importe
  End	--Function TotalApostadoCC
GO
/****** Object:  Table [dbo].[LTApuestas]    Script Date: 04/03/2018 20:27:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LTApuestas](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Clave] [char](12) NULL,
	[IDCaballo] [smallint] NOT NULL,
	[IDCarrera] [smallint] NOT NULL,
	[Importe] [smallmoney] NOT NULL,
	[IDJugador] [int] NULL,
 CONSTRAINT [PKApuestas] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LTCaballos]    Script Date: 04/03/2018 20:27:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LTCaballos](
	[ID] [smallint] NOT NULL,
	[Nombre] [varchar](30) NOT NULL,
	[FechaNacimiento] [date] NULL,
	[Sexo] [char](1) NULL,
 CONSTRAINT [PKCaballos] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LTCaballosCarreras]    Script Date: 04/03/2018 20:27:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LTCaballosCarreras](
	[IDCaballo] [smallint] NOT NULL,
	[IDCarrera] [smallint] NOT NULL,
	[Numero] [tinyint] NOT NULL,
	[Posicion] [tinyint] NULL,
	[Premio1] [decimal](4, 1) NULL,
	[Premio2] [decimal](4, 1) NULL,
 CONSTRAINT [PKCaballosCarreras] PRIMARY KEY CLUSTERED 
(
	[IDCaballo] ASC,
	[IDCarrera] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[LTCarreras]    Script Date: 04/03/2018 20:27:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LTCarreras](
	[ID] [smallint] NOT NULL,
	[Hipodromo] [varchar](30) NOT NULL,
	[Fecha] [date] NOT NULL,
	[NumOrden] [smallint] NOT NULL,
 CONSTRAINT [PKCarreras] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LTHipodromos]    Script Date: 04/03/2018 20:27:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LTHipodromos](
	[Nombre] [varchar](30) NOT NULL,
 CONSTRAINT [PKHipodromo] PRIMARY KEY CLUSTERED 
(
	[Nombre] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LTJugadores]    Script Date: 04/03/2018 20:27:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LTJugadores](
	[ID] [int] NOT NULL,
	[Nombre] [varchar](20) NOT NULL,
	[Apellidos] [varchar](30) NOT NULL,
	[Direccion] [varchar](50) NULL,
	[Telefono] [char](9) NULL,
	[Ciudad] [varchar](20) NOT NULL,
 CONSTRAINT [PKJugadores] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[LTApuestas] ON 

INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (1, N'jkdfjkasnfjk', 1, 1, 20.0000, 1)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (2, N'jkdfjkasnfjk', 3, 1, 10.0000, 2)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (3, N'jkdfjkasofjk', 10, 1, 20.0000, 3)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (4, N'jkrfjkasnfjk', 21, 1, 20.0000, 4)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (5, N'jkdfjkhsnfjk', 11, 1, 20.0000, 5)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (6, N'jkdfjkasnfjk', 6, 1, 20.0000, 6)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (7, N'jkdfjkasnfjk', 2, 2, 20.0000, 7)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (8, N'jkdfjkasnfjk', 4, 2, 80.0000, 8)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (9, N'jkdfjkasnfjk', 5, 2, 20.0000, 9)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (10, N'jkdfjkasnfjk', 7, 2, 10.0000, 10)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (11, N'jkdfjkasnfjk', 8, 2, 60.0000, 11)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (12, N'jkdfjkasnfjk', 9, 3, 20.0000, 12)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (13, N'jkdfjkasnfjk', 12, 3, 20.0000, 13)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (14, N'jkdfjkasnfjk', 13, 3, 20.0000, 14)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (15, N'jkdfjkas6fjk', 14, 3, 100.0000, 15)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (16, N'jkdfju8snfjk', 15, 3, 20.0000, 16)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (17, N'jkdi04asnfjk', 16, 3, 50.0000, 17)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (18, N'61dfjkasnfjk', 17, 3, 20.0000, 18)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (19, N'jkdi04asnfjk', 18, 4, 50.0000, 19)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (20, N'jkdi04asnfjk', 19, 4, 50.0000, 20)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (21, N'jkdi04asnfjk', 20, 4, 50.0000, 21)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (22, N'jkdi04asnfjk', 22, 4, 50.0000, 22)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (23, N'jkdi04asnfjk', 23, 4, 50.0000, 23)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (24, N'jkdi04asnfjk', 24, 4, 20.0000, 24)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (25, N'jkdi04aGH7jk', 20, 4, 50.0000, 25)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (26, N'jkdi04KL02jk', 22, 4, 30.0000, 26)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (27, N'5W&i04asnfjk', 23, 4, 10.0000, 27)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (28, N'jkdi04asnfjk', 25, 5, 50.0000, 28)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (29, N'jkdi04asnfjk', 26, 5, 50.0000, 29)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (30, N'jkdi04asnfjk', 27, 5, 50.0000, 100)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (31, N'jkdi04asnfjk', 28, 5, 50.0000, 101)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (32, N'jkdi04asnfjk', 29, 5, 50.0000, 200)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (33, N'jkdi04asnfjk', 30, 6, 50.0000, 207)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (34, N'0r7i04asnfjk', 2, 6, 30.0000, 214)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (35, N'jkdi04asnfjk', 13, 6, 15.0000, 220)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (36, N'jkdi04asnfjk', 10, 6, 50.0000, 234)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (37, N'jkdi04asnfjk', 5, 6, 25.0000, 245)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (38, N'jkdi04asnfjk', 16, 6, 50.0000, 307)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (39, N'jkdi04asnfjk', 17, 6, 50.0000, 407)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (40, N'0r7i04asnfjk', 30, 10, 30.0000, 440)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (41, N'0r7i04asnfjk', 2, 10, 30.0000, 507)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (42, N'0r7i04asnfjk', 13, 10, 30.0000, 516)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (43, N'0r7i04asnfjk', 10, 10, 30.0000, 607)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (44, N'0r7i04asnfjk', 5, 10, 30.0000, 736)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (45, N'0r7i04asnfjk', 16, 10, 30.0000, 1)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (46, N'0r7i04asnfjk', 17, 10, 30.0000, 2)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (47, N'0r7i04K9Mfjk', 10, 10, 100.0000, 3)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (48, N'r7i04asBX61k', 5, 10, 80.0000, 4)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (49, N'0r7i04asnfjk', 1, 11, 30.0000, 5)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (50, N'0r7i04asnfED', 3, 11, 30.0000, 6)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (51, N'0r7i04asnfjk', 4, 11, 30.0000, 7)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (52, N'M27i04as5h2Q', 21, 11, 10.0000, 8)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (53, N'0r7i04PLDfjk', 11, 11, 100.0000, 9)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (54, N'0r7i04asn6Mg', 6, 11, 30.0000, 10)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (55, N'0r7i0444FfED', 3, 11, 120.0000, 11)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (56, N'PQgi04asnfjk', 4, 11, 80.0000, 12)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (57, N'0r7i04asnfjk', 20, 12, 70.0000, 13)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (58, N'0r7i04aBYfjk', 14, 12, 50.0000, 14)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (59, N'0r7i04asnfjk', 15, 12, 10.0000, 15)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (60, N'0r7i04asnfjk', 7, 12, 130.0000, 16)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (61, N'0r7i04asnfjk', 8, 12, 30.0000, 17)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (62, N'M27i04as5h2Q', 21, 13, 30.0000, 18)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (63, N'M27i04as5h2Q', 22, 13, 10.0000, 19)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (64, N'M27i04as5h2Q', 23, 13, 10.0000, 20)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (65, N'M27i04as5h2Q', 24, 13, 10.0000, 21)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (66, N'M27i04as5h2Q', 25, 13, 30.0000, 22)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (67, N'M27i04as5h2Q', 26, 13, 10.0000, 23)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (68, N'M27i04as5h2Q', 27, 13, 10.0000, 24)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (69, N'M27i04as5h2Q', 24, 13, 40.0000, 25)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (70, N'M27i04655h2Q', 25, 13, 120.0000, 26)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (71, N'M27i04as5L$Q', 26, 13, 70.0000, 27)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (72, N'M27i04as5h2Q', 28, 14, 40.0000, 28)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (73, N'M27i04as5h2Q', 1, 14, 10.0000, 29)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (74, N'M27i0H3u5h2Q', 4, 14, 15.0000, 100)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (75, N'M27i04as5h2Q', 2, 14, 10.0000, 101)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (76, N'M27i04as5h2Q', 5, 14, 15.0000, 200)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (77, N'M27i04as5h2Q', 3, 14, 10.0000, 207)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (78, N'M27i0H3u5h2Q', 29, 15, 15.0000, 214)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (79, N'M27i0H3u5h2Q', 6, 15, 15.0000, 220)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (80, N'M27i0H3u5h2Q', 9, 15, 15.0000, 234)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (81, N'M27i0H3u5h2Q', 7, 15, 15.0000, 245)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (82, N'M27i0H3u5h2Q', 8, 15, 40.0000, 307)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (83, N'M27i0H3u5h2Q', 9, 15, 105.0000, 407)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (84, N'M27P=H3u5h2Q', 7, 15, 70.0000, 440)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (85, N'M27i0H3u5K%Q', 8, 15, 20.0000, 507)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (86, N'i0HH&g3u5h2Q', 30, 16, 85.0000, 516)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (87, N'M27i0H3u5h2Q', 20, 16, 15.0000, 607)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (88, N'M27i0H3u5h2Q', 13, 16, 15.0000, 736)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (89, N'M27i0H3u5h2Q', 11, 16, 15.0000, 1)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (90, N'M27i0H3u5h2Q', 10, 16, 35.0000, 2)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (91, N'M27i0H3u5h2Q', 16, 16, 50.0000, 3)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (92, N'Pi7j4BB&s3kt', 17, 16, 45.0000, 4)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (93, N'Pi5f4BB&s3O!', 30, 17, 105.0000, 5)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (94, N'Pi7j4BB&s3kt', 20, 17, 30.0000, 6)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (95, N'Pi7j4BB&s3Hk', 13, 17, 20.0000, 7)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (96, N'Pi7j4BB&s3kt', 11, 17, 45.0000, 8)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (97, N'Pi7j4BB&s3kt', 10, 17, 45.0000, 9)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (98, N'Pi7j4BB&sT5n', 16, 17, 45.0000, 10)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (99, N'Pi7j4BB&s3kt', 17, 17, 45.0000, 11)
GO
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (100, N'Pi7j4BB&s3kt', 29, 18, 10.0000, 12)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (101, N'Pi7jF9u&s3kt', 6, 18, 25.0000, 13)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (102, N'Pi7j4BB&supt', 19, 18, 20.0000, 14)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (103, N'Pi7j4BB&s3kt', 7, 18, 45.0000, 15)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (104, N'6l7j4BB&s3kt', 8, 18, 45.0000, 16)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (105, N'Pi7j4BB&s3kt', 18, 19, 45.0000, 17)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (106, N'Pi7j4BB&s3kt', 1, 19, 35.0000, 18)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (107, N'Pi7j4d/&s3kt', 4, 19, 10.0000, 19)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (108, N'Pi7j4BB&s3kt', 2, 19, 120.0000, 20)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (109, N'Pi7j4BB&s3kt', 5, 19, 45.0000, 21)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (110, N'Pi7jP3O&s3kt', 3, 19, 75.0000, 22)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (111, N'Pi7j4BB&s3kt', 21, 20, 45.0000, 23)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (112, N'Pi7j4BB&s3kt', 22, 20, 45.0000, 24)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (113, N'Pi%D4BB&s3kt', 23, 20, 40.0000, 25)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (114, N'0K7j4BB&s3kt', 24, 20, 90.0000, 26)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (115, N'Pi7j4BB&s3kt', 25, 20, 10.0000, 27)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (116, N'Pi7j4Blll3kt', 26, 20, 75.0000, 28)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (117, N'yi7j4BB&s3kt', 27, 20, 15.0000, 29)
SET IDENTITY_INSERT [dbo].[LTApuestas] OFF
INSERT [dbo].[LTCaballos] ([ID], [Nombre], [FechaNacimiento], [Sexo]) VALUES (1, N'Ciclon', CAST(N'2010-05-16' AS Date), N'M')
INSERT [dbo].[LTCaballos] ([ID], [Nombre], [FechaNacimiento], [Sexo]) VALUES (2, N'Nausica', CAST(N'2010-07-06' AS Date), N'H')
INSERT [dbo].[LTCaballos] ([ID], [Nombre], [FechaNacimiento], [Sexo]) VALUES (3, N'Avalancha', CAST(N'2011-01-04' AS Date), N'M')
INSERT [dbo].[LTCaballos] ([ID], [Nombre], [FechaNacimiento], [Sexo]) VALUES (4, N'Cirene', CAST(N'2009-11-14' AS Date), N'H')
INSERT [dbo].[LTCaballos] ([ID], [Nombre], [FechaNacimiento], [Sexo]) VALUES (5, N'Galatea', CAST(N'2010-10-10' AS Date), N'H')
INSERT [dbo].[LTCaballos] ([ID], [Nombre], [FechaNacimiento], [Sexo]) VALUES (6, N'Chicharito', CAST(N'2009-02-21' AS Date), N'M')
INSERT [dbo].[LTCaballos] ([ID], [Nombre], [FechaNacimiento], [Sexo]) VALUES (7, N'Vetonia', CAST(N'2011-01-30' AS Date), N'H')
INSERT [dbo].[LTCaballos] ([ID], [Nombre], [FechaNacimiento], [Sexo]) VALUES (8, N'Shumookh', CAST(N'2010-03-11' AS Date), N'M')
INSERT [dbo].[LTCaballos] ([ID], [Nombre], [FechaNacimiento], [Sexo]) VALUES (9, N'Anibal', CAST(N'2010-08-28' AS Date), N'M')
INSERT [dbo].[LTCaballos] ([ID], [Nombre], [FechaNacimiento], [Sexo]) VALUES (10, N'Path of Hope', CAST(N'2008-04-10' AS Date), N'M')
INSERT [dbo].[LTCaballos] ([ID], [Nombre], [FechaNacimiento], [Sexo]) VALUES (11, N'Fiona', CAST(N'2009-03-26' AS Date), N'H')
INSERT [dbo].[LTCaballos] ([ID], [Nombre], [FechaNacimiento], [Sexo]) VALUES (12, N'Sigerico', CAST(N'2009-12-15' AS Date), N'M')
INSERT [dbo].[LTCaballos] ([ID], [Nombre], [FechaNacimiento], [Sexo]) VALUES (13, N'Godofredo', CAST(N'2008-11-20' AS Date), N'M')
INSERT [dbo].[LTCaballos] ([ID], [Nombre], [FechaNacimiento], [Sexo]) VALUES (14, N'Agustina II', CAST(N'2011-01-06' AS Date), N'H')
INSERT [dbo].[LTCaballos] ([ID], [Nombre], [FechaNacimiento], [Sexo]) VALUES (15, N'Alarico', CAST(N'2010-06-09' AS Date), N'M')
INSERT [dbo].[LTCaballos] ([ID], [Nombre], [FechaNacimiento], [Sexo]) VALUES (16, N'Desdemona', CAST(N'2011-02-14' AS Date), N'H')
INSERT [dbo].[LTCaballos] ([ID], [Nombre], [FechaNacimiento], [Sexo]) VALUES (17, N'Gorgonia', CAST(N'2010-10-01' AS Date), N'H')
INSERT [dbo].[LTCaballos] ([ID], [Nombre], [FechaNacimiento], [Sexo]) VALUES (18, N'Daphne', CAST(N'2010-07-06' AS Date), N'H')
INSERT [dbo].[LTCaballos] ([ID], [Nombre], [FechaNacimiento], [Sexo]) VALUES (19, N'Witiza', CAST(N'2009-12-15' AS Date), N'M')
INSERT [dbo].[LTCaballos] ([ID], [Nombre], [FechaNacimiento], [Sexo]) VALUES (20, N'Rodrigo', CAST(N'2008-11-20' AS Date), N'M')
INSERT [dbo].[LTCaballos] ([ID], [Nombre], [FechaNacimiento], [Sexo]) VALUES (21, N'Ava', CAST(N'2011-01-06' AS Date), N'H')
INSERT [dbo].[LTCaballos] ([ID], [Nombre], [FechaNacimiento], [Sexo]) VALUES (22, N'Chindasvinto', CAST(N'2010-06-09' AS Date), N'M')
INSERT [dbo].[LTCaballos] ([ID], [Nombre], [FechaNacimiento], [Sexo]) VALUES (23, N'Urraca', CAST(N'2011-02-14' AS Date), N'H')
INSERT [dbo].[LTCaballos] ([ID], [Nombre], [FechaNacimiento], [Sexo]) VALUES (24, N'Malefica', CAST(N'2010-10-01' AS Date), N'H')
INSERT [dbo].[LTCaballos] ([ID], [Nombre], [FechaNacimiento], [Sexo]) VALUES (25, N'Recaredo', CAST(N'2010-04-14' AS Date), N'M')
INSERT [dbo].[LTCaballos] ([ID], [Nombre], [FechaNacimiento], [Sexo]) VALUES (26, N'Circe', CAST(N'2011-12-14' AS Date), N'H')
INSERT [dbo].[LTCaballos] ([ID], [Nombre], [FechaNacimiento], [Sexo]) VALUES (27, N'Ariel', CAST(N'2010-09-15' AS Date), N'H')
INSERT [dbo].[LTCaballos] ([ID], [Nombre], [FechaNacimiento], [Sexo]) VALUES (28, N'Celeste', CAST(N'2010-11-06' AS Date), N'H')
INSERT [dbo].[LTCaballos] ([ID], [Nombre], [FechaNacimiento], [Sexo]) VALUES (29, N'Wamba', CAST(N'2009-02-15' AS Date), N'M')
INSERT [dbo].[LTCaballos] ([ID], [Nombre], [FechaNacimiento], [Sexo]) VALUES (30, N'Sisebuto', CAST(N'2009-01-20' AS Date), N'M')
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (1, 1, 1, 2, CAST(3.3 AS Decimal(4, 1)), CAST(1.1 AS Decimal(4, 1)))
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (1, 11, 1, 1, NULL, NULL)
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (1, 14, 11, NULL, NULL, NULL)
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (1, 19, 11, NULL, NULL, NULL)
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (2, 2, 10, 2, CAST(5.7 AS Decimal(4, 1)), CAST(1.9 AS Decimal(4, 1)))
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (2, 6, 12, 4, CAST(5.4 AS Decimal(4, 1)), CAST(1.8 AS Decimal(4, 1)))
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (2, 10, 12, NULL, NULL, NULL)
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (2, 14, 6, 2, NULL, NULL)
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (2, 19, 6, 5, NULL, NULL)
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (3, 1, 11, 4, CAST(6.6 AS Decimal(4, 1)), CAST(2.2 AS Decimal(4, 1)))
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (3, 11, 11, 2, NULL, NULL)
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (3, 14, 2, 3, NULL, NULL)
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (3, 19, 2, 4, NULL, NULL)
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (4, 2, 12, 4, CAST(1.4 AS Decimal(4, 1)), CAST(0.5 AS Decimal(4, 1)))
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (4, 11, 7, 3, NULL, NULL)
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (4, 14, 7, 4, NULL, NULL)
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (4, 19, 47, 3, NULL, NULL)
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (5, 2, 27, 1, CAST(5.7 AS Decimal(4, 1)), CAST(1.9 AS Decimal(4, 1)))
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (5, 6, 4, NULL, CAST(6.5 AS Decimal(4, 1)), CAST(2.2 AS Decimal(4, 1)))
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (5, 10, 4, NULL, NULL, NULL)
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (5, 14, 12, 5, NULL, NULL)
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (5, 19, 12, 2, NULL, NULL)
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (6, 1, 2, 6, CAST(3.3 AS Decimal(4, 1)), CAST(1.1 AS Decimal(4, 1)))
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (6, 11, 2, 4, NULL, NULL)
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (6, 15, 12, 2, NULL, NULL)
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (6, 18, 12, 1, NULL, NULL)
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (7, 2, 16, 5, CAST(11.4 AS Decimal(4, 1)), CAST(3.8 AS Decimal(4, 1)))
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (7, 12, 16, 4, NULL, NULL)
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (7, 15, 16, 3, NULL, NULL)
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (7, 18, 16, 2, NULL, NULL)
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (8, 2, 2, 3, CAST(1.9 AS Decimal(4, 1)), CAST(0.6 AS Decimal(4, 1)))
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (8, 12, 2, 1, NULL, NULL)
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (8, 15, 2, NULL, NULL, NULL)
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (8, 18, 2, 3, NULL, NULL)
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (9, 3, 3, 2, CAST(7.5 AS Decimal(4, 1)), CAST(2.5 AS Decimal(4, 1)))
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (9, 15, 27, 4, NULL, NULL)
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (10, 1, 7, 1, CAST(3.3 AS Decimal(4, 1)), CAST(1.1 AS Decimal(4, 1)))
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (10, 6, 16, 5, CAST(3.2 AS Decimal(4, 1)), CAST(1.1 AS Decimal(4, 1)))
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (10, 10, 16, NULL, NULL, NULL)
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (10, 16, 4, 4, NULL, NULL)
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (10, 17, 54, NULL, NULL, NULL)
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (11, 1, 12, 3, CAST(3.3 AS Decimal(4, 1)), CAST(1.1 AS Decimal(4, 1)))
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (11, 11, 12, 5, NULL, NULL)
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (11, 16, 16, 5, NULL, NULL)
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (11, 17, 16, NULL, NULL, NULL)
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (12, 3, 12, 4, CAST(7.5 AS Decimal(4, 1)), CAST(2.5 AS Decimal(4, 1)))
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (13, 3, 17, 1, CAST(7.5 AS Decimal(4, 1)), CAST(2.5 AS Decimal(4, 1)))
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (13, 6, 8, 1, CAST(10.8 AS Decimal(4, 1)), CAST(3.6 AS Decimal(4, 1)))
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (13, 10, 8, NULL, NULL, NULL)
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (13, 16, 8, 6, NULL, NULL)
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (13, 17, 8, 1, NULL, NULL)
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (14, 3, 16, 5, CAST(1.5 AS Decimal(4, 1)), CAST(0.5 AS Decimal(4, 1)))
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (14, 12, 12, 2, NULL, NULL)
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (15, 3, 4, NULL, CAST(7.5 AS Decimal(4, 1)), CAST(2.5 AS Decimal(4, 1)))
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (15, 12, 27, NULL, NULL, NULL)
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (16, 3, 33, 3, CAST(3.0 AS Decimal(4, 1)), CAST(1.0 AS Decimal(4, 1)))
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (16, 6, 33, 3, CAST(3.2 AS Decimal(4, 1)), CAST(1.1 AS Decimal(4, 1)))
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (16, 10, 33, NULL, NULL, NULL)
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (16, 16, 33, NULL, NULL, NULL)
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (16, 17, 33, 2, NULL, NULL)
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (17, 3, 50, 6, CAST(7.5 AS Decimal(4, 1)), CAST(2.5 AS Decimal(4, 1)))
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (17, 6, 50, 6, CAST(3.2 AS Decimal(4, 1)), CAST(1.1 AS Decimal(4, 1)))
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (17, 10, 50, NULL, NULL, NULL)
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (17, 16, 50, 1, NULL, NULL)
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (17, 17, 50, 3, NULL, NULL)
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (18, 4, 1, 2, CAST(4.3 AS Decimal(4, 1)), CAST(1.4 AS Decimal(4, 1)))
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (18, 19, 51, 1, NULL, NULL)
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (19, 4, 11, 4, CAST(4.3 AS Decimal(4, 1)), CAST(1.4 AS Decimal(4, 1)))
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (19, 18, 27, 4, NULL, NULL)
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (20, 4, 7, 1, CAST(2.2 AS Decimal(4, 1)), CAST(0.7 AS Decimal(4, 1)))
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (20, 12, 10, 3, NULL, NULL)
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (20, 16, 12, 2, NULL, NULL)
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (20, 17, 12, 4, NULL, NULL)
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (21, 1, 6, 5, CAST(3.3 AS Decimal(4, 1)), CAST(1.1 AS Decimal(4, 1)))
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (21, 11, 6, 6, NULL, NULL)
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (21, 13, 23, 1, NULL, NULL)
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (21, 20, 23, 1, NULL, NULL)
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (22, 4, 6, 5, CAST(2.7 AS Decimal(4, 1)), CAST(0.9 AS Decimal(4, 1)))
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (22, 13, 12, 2, NULL, NULL)
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (22, 20, 12, 6, NULL, NULL)
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (23, 4, 12, 3, CAST(3.6 AS Decimal(4, 1)), CAST(1.2 AS Decimal(4, 1)))
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (23, 13, 8, 3, NULL, NULL)
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (23, 20, 8, 5, NULL, NULL)
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (24, 4, 2, 6, CAST(10.8 AS Decimal(4, 1)), CAST(3.6 AS Decimal(4, 1)))
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (24, 13, 2, 4, NULL, NULL)
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (24, 20, 2, 4, NULL, NULL)
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (25, 5, 10, 2, CAST(3.0 AS Decimal(4, 1)), CAST(1.0 AS Decimal(4, 1)))
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (25, 13, 4, NULL, NULL, NULL)
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (25, 20, 44, NULL, NULL, NULL)
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (26, 5, 12, 4, CAST(3.0 AS Decimal(4, 1)), CAST(1.0 AS Decimal(4, 1)))
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (26, 13, 3, 5, NULL, NULL)
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (26, 20, 3, 3, NULL, NULL)
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (27, 5, 27, 1, CAST(3.0 AS Decimal(4, 1)), CAST(1.0 AS Decimal(4, 1)))
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (27, 13, 5, 6, NULL, NULL)
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (27, 20, 5, 2, NULL, NULL)
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (28, 5, 90, 5, CAST(3.0 AS Decimal(4, 1)), CAST(1.0 AS Decimal(4, 1)))
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (28, 14, 1, 1, NULL, NULL)
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (29, 5, 42, 3, CAST(3.0 AS Decimal(4, 1)), CAST(1.0 AS Decimal(4, 1)))
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (29, 15, 10, 1, NULL, NULL)
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (29, 18, 10, 5, NULL, NULL)
GO
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (30, 6, 3, 2, CAST(3.2 AS Decimal(4, 1)), CAST(1.1 AS Decimal(4, 1)))
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (30, 10, 3, NULL, NULL, NULL)
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (30, 16, 3, 3, NULL, NULL)
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (30, 17, 3, 5, NULL, NULL)
INSERT [dbo].[LTCarreras] ([ID], [Hipodromo], [Fecha], [NumOrden]) VALUES (1, N'Gran Hipodromo de Andalucia', CAST(N'2015-01-20' AS Date), 1)
INSERT [dbo].[LTCarreras] ([ID], [Hipodromo], [Fecha], [NumOrden]) VALUES (2, N'Gran Hipodromo de Andalucia', CAST(N'2015-01-20' AS Date), 2)
INSERT [dbo].[LTCarreras] ([ID], [Hipodromo], [Fecha], [NumOrden]) VALUES (3, N'Gran Hipodromo de Andalucia', CAST(N'2015-01-20' AS Date), 3)
INSERT [dbo].[LTCarreras] ([ID], [Hipodromo], [Fecha], [NumOrden]) VALUES (13, N'Gran Hipodromo de Andalucia', CAST(N'2015-03-08' AS Date), 1)
INSERT [dbo].[LTCarreras] ([ID], [Hipodromo], [Fecha], [NumOrden]) VALUES (14, N'Gran Hipodromo de Andalucia', CAST(N'2015-03-08' AS Date), 2)
INSERT [dbo].[LTCarreras] ([ID], [Hipodromo], [Fecha], [NumOrden]) VALUES (15, N'Gran Hipodromo de Andalucia', CAST(N'2015-03-08' AS Date), 3)
INSERT [dbo].[LTCarreras] ([ID], [Hipodromo], [Fecha], [NumOrden]) VALUES (16, N'Gran Hipodromo de Andalucia', CAST(N'2015-03-08' AS Date), 4)
INSERT [dbo].[LTCarreras] ([ID], [Hipodromo], [Fecha], [NumOrden]) VALUES (21, N'Gran Hipodromo de Andalucia', CAST(N'2015-03-22' AS Date), 1)
INSERT [dbo].[LTCarreras] ([ID], [Hipodromo], [Fecha], [NumOrden]) VALUES (17, N'La Zarzuela', CAST(N'2015-03-15' AS Date), 1)
INSERT [dbo].[LTCarreras] ([ID], [Hipodromo], [Fecha], [NumOrden]) VALUES (18, N'La Zarzuela', CAST(N'2015-03-15' AS Date), 2)
INSERT [dbo].[LTCarreras] ([ID], [Hipodromo], [Fecha], [NumOrden]) VALUES (19, N'La Zarzuela', CAST(N'2015-03-15' AS Date), 3)
INSERT [dbo].[LTCarreras] ([ID], [Hipodromo], [Fecha], [NumOrden]) VALUES (20, N'La Zarzuela', CAST(N'2015-03-15' AS Date), 4)
INSERT [dbo].[LTCarreras] ([ID], [Hipodromo], [Fecha], [NumOrden]) VALUES (4, N'Pineda', CAST(N'2015-02-14' AS Date), 1)
INSERT [dbo].[LTCarreras] ([ID], [Hipodromo], [Fecha], [NumOrden]) VALUES (5, N'Pineda', CAST(N'2015-02-14' AS Date), 2)
INSERT [dbo].[LTCarreras] ([ID], [Hipodromo], [Fecha], [NumOrden]) VALUES (6, N'Pineda', CAST(N'2015-02-14' AS Date), 3)
INSERT [dbo].[LTCarreras] ([ID], [Hipodromo], [Fecha], [NumOrden]) VALUES (10, N'Pineda', CAST(N'2015-02-28' AS Date), 1)
INSERT [dbo].[LTCarreras] ([ID], [Hipodromo], [Fecha], [NumOrden]) VALUES (11, N'Pineda', CAST(N'2015-02-28' AS Date), 2)
INSERT [dbo].[LTCarreras] ([ID], [Hipodromo], [Fecha], [NumOrden]) VALUES (12, N'Pineda', CAST(N'2015-02-28' AS Date), 3)
INSERT [dbo].[LTHipodromos] ([Nombre]) VALUES (N'Argentino de Palermo')
INSERT [dbo].[LTHipodromos] ([Nombre]) VALUES (N'Costa del Sol')
INSERT [dbo].[LTHipodromos] ([Nombre]) VALUES (N'Gran Hipodromo de Andalucia')
INSERT [dbo].[LTHipodromos] ([Nombre]) VALUES (N'La Zarzuela')
INSERT [dbo].[LTHipodromos] ([Nombre]) VALUES (N'Las Mestas')
INSERT [dbo].[LTHipodromos] ([Nombre]) VALUES (N'Lasarte')
INSERT [dbo].[LTHipodromos] ([Nombre]) VALUES (N'Pineda')
INSERT [dbo].[LTHipodromos] ([Nombre]) VALUES (N'Royal Ascott')
INSERT [dbo].[LTHipodromos] ([Nombre]) VALUES (N'Son Pardo')
INSERT [dbo].[LTJugadores] ([ID], [Nombre], [Apellidos], [Direccion], [Telefono], [Ciudad]) VALUES (1, N'Aitor', N'Tilla Perez', N'Calle Japon                                       ', N'954054940', N'Sevilla')
INSERT [dbo].[LTJugadores] ([ID], [Nombre], [Apellidos], [Direccion], [Telefono], [Ciudad]) VALUES (2, N'Armando', N'Bronca Segura', N'Calle Pakistan                                    ', N'954654345', N'Sevilla')
INSERT [dbo].[LTJugadores] ([ID], [Nombre], [Apellidos], [Direccion], [Telefono], [Ciudad]) VALUES (3, N'Cristina', N'Sanchez Salcedo', N'Plaza Redonda, 14                                 ', N'954752006', N'Málaga')
INSERT [dbo].[LTJugadores] ([ID], [Nombre], [Apellidos], [Direccion], [Telefono], [Ciudad]) VALUES (4, N'Jesus', N'Rodriguez Jurado', N'Avda de las Letanias, 19 ', N'954090439', N'Sevilla')
INSERT [dbo].[LTJugadores] ([ID], [Nombre], [Apellidos], [Direccion], [Telefono], [Ciudad]) VALUES (5, N'Javier', N'Rodriguez Pariente', N'Calle Fandango, 5', N'954041392', N'Huelva')
INSERT [dbo].[LTJugadores] ([ID], [Nombre], [Apellidos], [Direccion], [Telefono], [Ciudad]) VALUES (6, N'Borja', N'Monero', N'Av. del Sol, 47                                   ', N'678002451', N'Sevilla')
INSERT [dbo].[LTJugadores] ([ID], [Nombre], [Apellidos], [Direccion], [Telefono], [Ciudad]) VALUES (7, N'Elena', N'Dadora', N'Calle 14 de Abril, 10   ', N'606441980', N'Sevilla')
INSERT [dbo].[LTJugadores] ([ID], [Nombre], [Apellidos], [Direccion], [Telefono], [Ciudad]) VALUES (8, N'Rocio', N'Marin Romero', N'Calle Estadio, 76', N'959654425', N'Córdoba')
INSERT [dbo].[LTJugadores] ([ID], [Nombre], [Apellidos], [Direccion], [Telefono], [Ciudad]) VALUES (9, N'Vicente', N'Mata Gente', N'Calle Afganistan   ', N'954092930', N'Sevilla')
INSERT [dbo].[LTJugadores] ([ID], [Nombre], [Apellidos], [Direccion], [Telefono], [Ciudad]) VALUES (10, N'Joyce', N'Greer', N'Paseo de la Castellana', N'600123945', N'Madrid')
INSERT [dbo].[LTJugadores] ([ID], [Nombre], [Apellidos], [Direccion], [Telefono], [Ciudad]) VALUES (11, N'Armando', N'El Pollo', N'Av. de la República', N'600123958', N'Madrid')
INSERT [dbo].[LTJugadores] ([ID], [Nombre], [Apellidos], [Direccion], [Telefono], [Ciudad]) VALUES (12, N'Rick', N'Hendricks', N'Plaza de la Concordia', N'600123971', N'Salamanca')
INSERT [dbo].[LTJugadores] ([ID], [Nombre], [Apellidos], [Direccion], [Telefono], [Ciudad]) VALUES (13, N'Joa', N'Baker', N'Calle Pi y Margall', N'612123984', N'Girona')
INSERT [dbo].[LTJugadores] ([ID], [Nombre], [Apellidos], [Direccion], [Telefono], [Ciudad]) VALUES (14, N'Clifford', N'Underwood', N'Calle Iturbi, 12', N'600123997', N'Bilbao')
INSERT [dbo].[LTJugadores] ([ID], [Nombre], [Apellidos], [Direccion], [Telefono], [Ciudad]) VALUES (15, N'Juan', N'Ybarra', N'Paseo de la Castellana', N'600124010', N'Madrid')
INSERT [dbo].[LTJugadores] ([ID], [Nombre], [Apellidos], [Direccion], [Telefono], [Ciudad]) VALUES (16, N'Dominique', N'Lyons', N'Calle Larios, 31', N'694124023', N'Málaga')
INSERT [dbo].[LTJugadores] ([ID], [Nombre], [Apellidos], [Direccion], [Telefono], [Ciudad]) VALUES (17, N'Jasmine', N'Callahan', N'47, Regent Crescent', N'600124036', N'Manchester')
INSERT [dbo].[LTJugadores] ([ID], [Nombre], [Apellidos], [Direccion], [Telefono], [Ciudad]) VALUES (18, N'Neil', N'Lynch', N'19, Brunswick Terrace', N'649354049', N'Brighton')
INSERT [dbo].[LTJugadores] ([ID], [Nombre], [Apellidos], [Direccion], [Telefono], [Ciudad]) VALUES (19, N'Kimberly', N'Huerta', N'Almirante Topete, 36', N'600124062', N'Madrid')
INSERT [dbo].[LTJugadores] ([ID], [Nombre], [Apellidos], [Direccion], [Telefono], [Ciudad]) VALUES (20, N'Margarita', N'García', N'Filipinas, 157', N'600124075', N'Santander')
INSERT [dbo].[LTJugadores] ([ID], [Nombre], [Apellidos], [Direccion], [Telefono], [Ciudad]) VALUES (21, N'Kara', N'Cardenas', N'Paseo de la Castellana', N'600124088', N'Cáceres')
INSERT [dbo].[LTJugadores] ([ID], [Nombre], [Apellidos], [Direccion], [Telefono], [Ciudad]) VALUES (22, N'Dustin', N'Torres', N'Av. de la Libertad, 4', N'600124101', N'Madrid')
INSERT [dbo].[LTJugadores] ([ID], [Nombre], [Apellidos], [Direccion], [Telefono], [Ciudad]) VALUES (23, N'Lewis', N'Wagner', N'Plaza Mayor, 87', N'600124114', N'Valladolid')
INSERT [dbo].[LTJugadores] ([ID], [Nombre], [Apellidos], [Direccion], [Telefono], [Ciudad]) VALUES (24, N'Abigail', N'Lowery', N'Calle Ramón y Cajal. 73', N'600124127', N'Utrera')
INSERT [dbo].[LTJugadores] ([ID], [Nombre], [Apellidos], [Direccion], [Telefono], [Ciudad]) VALUES (25, N'Gabriel', N'Sosa', N'Paseo de la Castellana', N'600124140', N'Madrid')
INSERT [dbo].[LTJugadores] ([ID], [Nombre], [Apellidos], [Direccion], [Telefono], [Ciudad]) VALUES (26, N'Teddy', N'Nielsen', N'Recogidas, 48', N'600124153', N'Granada')
INSERT [dbo].[LTJugadores] ([ID], [Nombre], [Apellidos], [Direccion], [Telefono], [Ciudad]) VALUES (27, N'Stephany', N'Knox', N'Plaza de las Monjas, 25', N'600124166', N'Huelva')
INSERT [dbo].[LTJugadores] ([ID], [Nombre], [Apellidos], [Direccion], [Telefono], [Ciudad]) VALUES (28, N'Ethan', N'Booth', N'Rector Esperabé, 114', N'679224179', N'Salamanca')
INSERT [dbo].[LTJugadores] ([ID], [Nombre], [Apellidos], [Direccion], [Telefono], [Ciudad]) VALUES (29, N'Olga', N'Melto', N'Paseo de la Castellana, 112', N'600124192', N'Madrid')
INSERT [dbo].[LTJugadores] ([ID], [Nombre], [Apellidos], [Direccion], [Telefono], [Ciudad]) VALUES (100, N'Juan', N'Tanamera', N'Av. de la República Argentina, 25', N'663124205', N'Sevilla')
INSERT [dbo].[LTJugadores] ([ID], [Nombre], [Apellidos], [Direccion], [Telefono], [Ciudad]) VALUES (101, N'Ana', N'Vegante', N'Calle Pelota', N'600124218', N'Cádiz')
INSERT [dbo].[LTJugadores] ([ID], [Nombre], [Apellidos], [Direccion], [Telefono], [Ciudad]) VALUES (200, N'Esteban', N'Quero', N'Calle Habana', N'600124231', N'Sevilla')
INSERT [dbo].[LTJugadores] ([ID], [Nombre], [Apellidos], [Direccion], [Telefono], [Ciudad]) VALUES (207, N'Fernando', N'Minguero', N'Av. de la Victoria', N'674355989', N'Málaga')
INSERT [dbo].[LTJugadores] ([ID], [Nombre], [Apellidos], [Direccion], [Telefono], [Ciudad]) VALUES (214, N'Elisa', N'Ladita', N'Calle Mediterráneo, 54', N'600124257', N'Sevilla')
INSERT [dbo].[LTJugadores] ([ID], [Nombre], [Apellidos], [Direccion], [Telefono], [Ciudad]) VALUES (220, N'Paco', N'Merselo', N'Calle Pelota', N'600124270', N'Cádiz')
INSERT [dbo].[LTJugadores] ([ID], [Nombre], [Apellidos], [Direccion], [Telefono], [Ciudad]) VALUES (234, N'Simon', N'Toncito', N'Gran Vía, 27', N'600124283', N'Granada')
INSERT [dbo].[LTJugadores] ([ID], [Nombre], [Apellidos], [Direccion], [Telefono], [Ciudad]) VALUES (245, N'Aitor', N'Menta', N'Plaza del Txakolí, 10', N'633874296', N'Bilbao')
INSERT [dbo].[LTJugadores] ([ID], [Nombre], [Apellidos], [Direccion], [Telefono], [Ciudad]) VALUES (307, N'Olga', N'Llinero', N'Calle Pelota, 31', N'600124309', N'Valladolid')
INSERT [dbo].[LTJugadores] ([ID], [Nombre], [Apellidos], [Direccion], [Telefono], [Ciudad]) VALUES (407, N'Jeremias', N'Mas', N'Don Remondo, 38', N'600124322', N'Sevilla')
INSERT [dbo].[LTJugadores] ([ID], [Nombre], [Apellidos], [Direccion], [Telefono], [Ciudad]) VALUES (440, N'Juan Luis', N'Guerra', N'Calle Pelota', N'600124335', N'Cádiz')
INSERT [dbo].[LTJugadores] ([ID], [Nombre], [Apellidos], [Direccion], [Telefono], [Ciudad]) VALUES (507, N'Salud', N'Itos', N'Carrer de Napols', N'600124348', N'Barcelona')
INSERT [dbo].[LTJugadores] ([ID], [Nombre], [Apellidos], [Direccion], [Telefono], [Ciudad]) VALUES (516, N'Ramon', N'Tañero', N'Calle General Riego', N'600124361', N'Málaga')
INSERT [dbo].[LTJugadores] ([ID], [Nombre], [Apellidos], [Direccion], [Telefono], [Ciudad]) VALUES (607, N'Susana', N'Tillas', N'Av. Pablo Picasso', N'600124374', N'Cáceres')
INSERT [dbo].[LTJugadores] ([ID], [Nombre], [Apellidos], [Direccion], [Telefono], [Ciudad]) VALUES (736, N'Pedro', N'Medario', N'Calle Sahara, 14', N'600124387', N'Huelva')
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQNombre]    Script Date: 04/03/2018 20:27:21 ******/
ALTER TABLE [dbo].[LTCaballos] ADD  CONSTRAINT [UQNombre] UNIQUE NONCLUSTERED 
(
	[Nombre] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [UQNumeroUnico]    Script Date: 04/03/2018 20:27:21 ******/
ALTER TABLE [dbo].[LTCaballosCarreras] ADD  CONSTRAINT [UQNumeroUnico] UNIQUE NONCLUSTERED 
(
	[IDCarrera] ASC,
	[Numero] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQDenominacionInformal]    Script Date: 04/03/2018 20:27:21 ******/
ALTER TABLE [dbo].[LTCarreras] ADD  CONSTRAINT [UQDenominacionInformal] UNIQUE NONCLUSTERED 
(
	[Hipodromo] ASC,
	[Fecha] ASC,
	[NumOrden] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LTApuestas]  WITH CHECK ADD  CONSTRAINT [FKApuestasCaballos] FOREIGN KEY([IDCarrera])
REFERENCES [dbo].[LTCarreras] ([ID])
GO
ALTER TABLE [dbo].[LTApuestas] CHECK CONSTRAINT [FKApuestasCaballos]
GO
ALTER TABLE [dbo].[LTApuestas]  WITH CHECK ADD  CONSTRAINT [FKApuestasCarreras] FOREIGN KEY([IDCaballo])
REFERENCES [dbo].[LTCaballos] ([ID])
GO
ALTER TABLE [dbo].[LTApuestas] CHECK CONSTRAINT [FKApuestasCarreras]
GO
ALTER TABLE [dbo].[LTApuestas]  WITH CHECK ADD  CONSTRAINT [FKApuestasJugadores] FOREIGN KEY([IDJugador])
REFERENCES [dbo].[LTJugadores] ([ID])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[LTApuestas] CHECK CONSTRAINT [FKApuestasJugadores]
GO
ALTER TABLE [dbo].[LTCaballosCarreras]  WITH CHECK ADD  CONSTRAINT [FKCaballosCarreras] FOREIGN KEY([IDCaballo])
REFERENCES [dbo].[LTCaballos] ([ID])
GO
ALTER TABLE [dbo].[LTCaballosCarreras] CHECK CONSTRAINT [FKCaballosCarreras]
GO
ALTER TABLE [dbo].[LTCaballosCarreras]  WITH CHECK ADD  CONSTRAINT [FKCarrerasCaballos] FOREIGN KEY([IDCarrera])
REFERENCES [dbo].[LTCarreras] ([ID])
GO
ALTER TABLE [dbo].[LTCaballosCarreras] CHECK CONSTRAINT [FKCarrerasCaballos]
GO
ALTER TABLE [dbo].[LTCarreras]  WITH CHECK ADD  CONSTRAINT [FKCarrerasHipodromos] FOREIGN KEY([Hipodromo])
REFERENCES [dbo].[LTHipodromos] ([Nombre])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[LTCarreras] CHECK CONSTRAINT [FKCarrerasHipodromos]
GO
ALTER TABLE [dbo].[LTApuestas]  WITH CHECK ADD  CONSTRAINT [CK_ImporteApuesta] CHECK  (([Importe]>(1)))
GO
ALTER TABLE [dbo].[LTApuestas] CHECK CONSTRAINT [CK_ImporteApuesta]
GO
ALTER TABLE [dbo].[LTCaballos]  WITH CHECK ADD  CONSTRAINT [CKSexo] CHECK  (([Sexo]='M' OR [Sexo]='H'))
GO
ALTER TABLE [dbo].[LTCaballos] CHECK CONSTRAINT [CKSexo]
GO
Use Ejemplos