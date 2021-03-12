/*1.N�mero de mascotas que han sufrido cada enfermedad.*/
SELECT * FROM BI_Enfermedades
SELECT * FROM BI_Mascotas_Enfermedades
SELECT * FROM BI_Mascotas

SELECT e.Nombre, COUNT(m.Codigo) AS [Cantidad de mascotas]
	FROM BI_Enfermedades AS e
	INNER JOIN BI_Mascotas_Enfermedades AS me
	ON e.ID = me.IDEnfermedad
	INNER JOIN BI_Mascotas AS m
	ON me.Mascota = m.Codigo
		GROUP BY e.Nombre

/*2.N�mero de mascotas que han sufrido cada enfermedad incluyendo las enfermedades que no ha sufrido ninguna mascota.*/
SELECT * FROM BI_Enfermedades
SELECT * FROM BI_Mascotas_Enfermedades
SELECT * FROM BI_Mascotas

SELECT Enfermedades.Nombre, MascotasEnfermedades.[Cantidad de mascotas]
	FROM BI_Enfermedades AS [Enfermedades]
	LEFT JOIN (SELECT e.Nombre, COUNT(m.Codigo) AS [Cantidad de mascotas]
					FROM BI_Enfermedades AS e
					INNER JOIN BI_Mascotas_Enfermedades AS me
					ON e.ID = me.IDEnfermedad
					INNER JOIN BI_Mascotas AS m
					ON me.Mascota = m.Codigo
						GROUP BY e.Nombre) AS [MascotasEnfermedades]
	ON Enfermedades.Nombre = MascotasEnfermedades.Nombre

/*3.N�mero de mascotas de cada cliente. Incluye nombre completo y direcci�n del cliente.*/
SELECT * FROM BI_Mascotas
SELECT * FROM BI_Clientes

SELECT Count(m.Codigo) AS [N�mero de mascotas], c.Nombre, c.Direccion
	FROM BI_Mascotas AS m
	INNER JOIN BI_Clientes AS c
	ON m.CodigoPropietario = c.Codigo
		GROUP BY c.Nombre, c.Direccion

/*4.N�mero de mascotas de cada especie de cada cliente. Incluye nombre completo y direcci�n del cliente.*/
SELECT * FROM BI_Mascotas
SELECT * FROM BI_Clientes

SELECT Count(m.Codigo) AS [N�mero de mascotas], m.Especie, c.Nombre, c.Direccion
	FROM BI_Mascotas AS m
	INNER JOIN BI_Clientes AS c
	ON m.CodigoPropietario = c.Codigo
		GROUP BY m.Especie, c.Nombre, c.Direccion

/*5.N�mero de mascotas de cada especie que han sufrido cada enfermedad.*/
SELECT * FROM BI_Enfermedades
SELECT * FROM BI_Mascotas_Enfermedades
SELECT * FROM BI_Mascotas

SELECT Count(m.Codigo) AS [N�mero de mascotas], m.Especie
	FROM BI_Mascotas AS m
	INNER JOIN BI_Mascotas_Enfermedades AS me
	ON m.Codigo = me.Mascota
	INNER JOIN BI_Enfermedades AS e
	ON e.ID = me.IDEnfermedad
		GROUP BY m.Especie

/*6.N�mero de mascotas de cada especie que han sufrido cada enfermedad incluyendo las enfermedades que no ha sufrido ninguna mascota de alguna especie.*/
--MIRAR BIEN LA PARTE DE ESPECIES
SELECT * FROM BI_Enfermedades
SELECT * FROM BI_Mascotas_Enfermedades
SELECT * FROM BI_Mascotas

SELECT NumeroMascotas.[N�mero de mascotas], NumeroMascotas.Especie, Enfermedades.Nombre
	FROM BI_Enfermedades AS [Enfermedades]
	LEFT JOIN (SELECT Count(m.Codigo) AS [N�mero de mascotas], m.Especie, e.Nombre
					FROM BI_Mascotas AS m
					INNER JOIN BI_Mascotas_Enfermedades AS me
					ON m.Codigo = me.Mascota
					INNER JOIN BI_Enfermedades AS e
					ON e.ID = me.IDEnfermedad
						GROUP BY m.Especie, e.Nombre) AS [NumeroMascotas]
	ON Enfermedades.Nombre = NumeroMascotas.Nombre

/*7.Queremos saber cu�l es la enfermedad m�s com�n en cada especie. Incluye cuantos casos se han producido*/  --PREGUNTAR
SELECT * FROM BI_Enfermedades
SELECT * FROM BI_Mascotas_Enfermedades
SELECT * FROM BI_Mascotas

GO
CREATE VIEW CantidadEnfermedadesEspecies AS
SELECT COUNT(e.Nombre) AS [CantidadEnfermedadesEspecies], m.Especie
	FROM BI_Enfermedades AS e
	RIGHT JOIN BI_Mascotas_Enfermedades AS me
	ON e.ID = me.IDEnfermedad
	RIGHT JOIN BI_Mascotas AS m
	ON me.Mascota = m.Codigo
		GROUP BY m.Especie, e.ID
GO

GO
CREATE VIEW SuperEnfermedad AS
SELECT MAX(a.CantidadEnfermedadesEspecies) AS , a.Especie
FROM (SELECT COUNT(e.Nombre) AS [CantidadEnfermedadesEspecies], m.Especie
		FROM BI_Enfermedades AS e
		RIGHT JOIN BI_Mascotas_Enfermedades AS me
		ON e.ID = me.IDEnfermedad
		RIGHT JOIN BI_Mascotas AS m
		ON me.Mascota = m.Codigo
			GROUP BY m.Especie, e.ID) AS a
	GROUP BY a.Especie
GO

GO
ALTER VIEW EnfermedadesPorEspecie AS
SELECT COUNT(e.Nombre) AS [Cantidad de cada enfermedad], e.Nombre, m.Especie
	FROM BI_Enfermedades AS e
	LEFT JOIN BI_Mascotas_Enfermedades AS me
	ON e.ID = me.IDEnfermedad
	LEFT JOIN BI_Mascotas AS m
	ON me.Mascota = m.Codigo
		GROUP BY m.Especie, e.Nombre
GO

GO
ALTER VIEW SuperEnfermedad AS 
SELECT MAX(EnfermedadesPorEspecie.[Cantidad de cada enfermedad]) AS [Enfermedad m�s com�n]
	FROM EnfermedadesPorEspecie
GO

SELECT se.[Enfermedad m�s com�n], exe.Nombre, exe.Especie
	FROM EnfermedadesPorEspecie AS exe
	INNER JOIN SuperEnfermedad AS se
	ON exe.[Cantidad de cada enfermedad] = se.[Enfermedad m�s com�n]

/*8.Duraci�n media, en d�as, de cada enfermedad, desde que se detecta hasta que se cura. Incluye solo los casos en que el animal se haya curado.
Se entiende que una mascota se ha curado si tiene fecha de curaci�n y est� viva o su fecha de fallecimiento es posterior a la fecha de curaci�n.*/
  --PREGUNTAR
SELECT * FROM BI_Mascotas
SELECT * FROM BI_Mascotas_Enfermedades


/*9.N�mero de veces que ha acudido a consulta cada cliente con alguna de sus mascotas. Incluye nombre y apellidos del cliente.*/
SELECT * FROM BI_Clientes
SELECT * FROM BI_Mascotas
SELECT * FROM BI_Visitas

SELECT c.Nombre, COUNT(v.IDVisita) AS [N�mero de visitas]
	FROM BI_Clientes AS c
	INNER JOIN BI_Mascotas AS m
	ON c.Codigo = m.CodigoPropietario
	INNER JOIN BI_Visitas AS v
	ON m.Codigo = v.Mascota
		GROUP BY c.Nombre

/*10.N�mero de visitas a las que ha acudido cada mascota, fecha de su primera y de su �ltima visita*/
SELECT * FROM BI_Mascotas
SELECT * FROM BI_Visitas

GO
ALTER VIEW VisitasPorMascota AS 
SELECT COUNT(v.IDVisita) AS [N�mero de visitas], m.Alias
	FROM BI_Mascotas AS m
	INNER JOIN BI_Visitas AS v
	ON m.Codigo = v.Mascota
		GROUP BY m.Alias
GO

GO
ALTER VIEW PrimeraUltimaVisita AS
SELECT m.Alias, MIN(v.Fecha) AS [Primera visita], MAX(v.Fecha) AS [�ltima visita]
	FROM BI_Mascotas AS m
	INNER JOIN BI_Visitas AS v
	ON m.Codigo = v.Mascota
		GROUP BY m.Alias
GO

SELECT vxm.Alias, vxm.[N�mero de visitas], puv.[Primera visita], puv.[�ltima visita]
	FROM VisitasPorMascota AS [vxm]
	INNER JOIN PrimeraUltimaVisita AS [puv]
	ON vxm.Alias = puv.Alias


/*11.Incremento (o disminuci�n) de peso que ha experimentado cada mascota entre cada dos consultas sucesivas.
Incluye nombre de la mascota, especie, fecha de las dos consultas sucesivas e incremento o disminuci�n de peso.*/