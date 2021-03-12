USE Bichos
GO
--1. Nombre de la mascota, raza, especie y fecjha de nacimiento de aquellos que hayan sufrido leucemia, moquillo o toxoplasmosis

--2. Nombre, raza y especie de las mascotas que hayan ido a alguna visita en primavera (del 20 de marzo al 20 de Junio)

--3. Nombre y teléfono de los propietarios de mascotas que hayan sufrido rabia, sarna, artritis o filariosis y hayan tardado más de 
--10 días en curarse. Los que no tienen fecha de curación, considera la fecha actual para calcular la duración del tratamiento.

--4. Nombre y especie de las mascotas que hayan ido alguna vez a consulta mientras estaban enfermas. Incluye el nombre de la 
--enmfermedad que sufrían y la fecha de la visita.
SELECT M.Alias, M.Especie, E.Nombre, V.Fecha FROM BI_Visitas AS V
	INNER JOIN BI_Mascotas AS M ON V.Mascota=M.Codigo
	INNER JOIN BI_Mascotas_Enfermedades AS ME ON M.Codigo=ME.Mascota
	INNER JOIN BI_Enfermedades AS E ON ME.IDEnfermedad=E.ID
WHERE V.Fecha BETWEEN ME.FechaInicio AND ISNULL(ME.FechaCura, CURRENT_TIMESTAMP)
--5. Nombre, dirección y teléfono de los clientes que tengan mascotas de al menos dos especies diferentes
SELECT C.Nombre, C.Direccion, C.Telefono FROM BI_Clientes AS C
	INNER JOIN BI_Mascotas AS M ON C.Codigo=M.CodigoPropietario
GROUP BY C.Codigo, C.Nombre, C.Direccion, C.Telefono
HAVING COUNT(DISTINCT M.Especie)>=2

--6. Nombre, teléfono y número de mascotas de cada especie que tiene cada cliente.

--7. Nombre, especie y nombre del propietario de aquellas mascotas que hayan sufrido una enfermedad de tipo infeccioso (IN) o 
--genético (GE) más de una vez.
