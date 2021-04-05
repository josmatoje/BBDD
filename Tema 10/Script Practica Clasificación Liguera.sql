-- Resultados de una liga deportiva
-- Autor: Leo
-- 19/03/2020 Quinto d�a de confinamiento
Use master
GO
Create Database LeoChampionsLeague
GO
Use LeoChampionsLeague
GO
Create Table Equipos (
	ID Char(4) Not NULL,
	Nombre VarChar(20) Not NULL,
	Ciudad VarChar(25) NULL,
	Pais VarChar (20) NULL,
	Constraint PKEquipos Primary Key (ID)
)
GO
Create Table Partidos (
	ID Int Not NULL Identity,
	ELocal Char(4) Not NULL,
	EVisitante Char(4) Not NULL,
	GolesLocal TinyInt Not NULL Default 0,
	GolesVisitante TinyInt Not NULL Default 0,
	Finalizado Bit Not NULL Default 0,
	Fecha SmallDateTime NULL,
	Constraint PKPartidos Primary Key (ID),
	Constraint FKPartidoLocal Foreign Key (ELocal) REFERENCES Equipos (ID),
	Constraint FKPartidoVisitante Foreign Key (EVisitante) REFERENCES Equipos (ID)
)
GO
Create Table Clasificacion(
	IDEquipo Char(4) Not NULL,
	NombreEquipo VarChar(20) Not NULL,
	PartidosJugados TinyInt Not NULL Default 0,
	PartidosGanados TinyInt Not NULL Default 0,
	PartidosEmpatados TinyInt Not NULL Default 0,
	PartidosPerdidos AS PartidosJugados - (PartidosGanados + PartidosEmpatados),
	Puntos AS PartidosGanados * 3 + PartidosEmpatados,
	GolesFavor SmallInt Not NULL Default 0,
	GolesContra SmallInt Not NULL Default 0,
	Constraint PKClasificacion Primary Key (IDEquipo),
	Constraint FKClasificacionEquipo Foreign Key (IDEquipo) REFERENCES Equipos (ID)
)
-- Equipos participantes 
INSERT INTO Equipos (ID,Nombre,Ciudad,Pais)
     VALUES ('RBET','Real Betis','Sevilla','Espa�a'),('LIVL','Liverpool FC','Liverpool','Reino Unido'),('ESRO','Estrella Roja','Belgrado','Serbia'),
	 ('AJAX','Ajax','Amsterdam','Holanda'),('MANC','Manchester City','Manchester','Reino Unido'),('ARAR','Ararat','Erevan','Armenia'),
	 ('BODO','Borussia Dortmund','Dortmund','Alemania'),('BARC','FC Barcelona','Barcelona','Espa�a'),('PASG','Paris Saint Germain','Paris','Francia'),
	 ('OLYM','Olympiacos','Atenas','Grecia'),('MANU','Manchester United','Manchester','Reino Unido'),('OLYL','Olympique de Lion','Lion','Francia'),
	 ('INTM','Inter','Milan','Italia'),('BENF','Benfica','Lisboa','Portugal'),('BAYM','Bayern','Munich','Alemania'),('JUVT','Juventus','Turin','Italia'),
	 ('ZENR','Zenit','San Petesburgo','Rusia'), ('RMAD','Real Madrid','Madrid','Espa�a')
GO

-- Poblamos la tabla Partidos

Insert Into Partidos (ELocal ,EVisitante)
SELECT L.ID, V.ID FROM Equipos AS L CROSS JOIN Equipos AS V Where L.ID <> V.ID
GO
DECLARE @GolesL TinyInt, @GolesV TinyInt, @Partido SmallInt
DECLARE CPartidos CURSOR FOR Select ID From Partidos
Open Cpartidos
Fetch Next FROM Cpartidos INTO @Partido
While @@FETCH_STATUS = 0
Begin
	If @Partido % 15 <> 0
	Begin
		SET @GolesL = Floor(rand()*4)
		SET @GolesV = Floor(rand()*3)
		Update Partidos Set GolesLocal = @GolesL, GolesVisitante = @GolesV, Finalizado = 1
			Where Current Of Cpartidos
	End -- If
	Fetch Next FROM Cpartidos INTO @Partido
End -- While
Close Cpartidos
Deallocate CPartidos

-- Mucho Betis!
-- El factor Villamarin
Update Partidos Set GolesLocal = GolesLocal + 1
	Where ELocal ='RBET'

Select * From Partidos