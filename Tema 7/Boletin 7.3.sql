USE pubs
--1. T�tulo, precio y notas de los libros (titles) que tratan de cocina, ordenados de mayor a menor precio.
SELECT title, price, notes FROM titles AS T
WHERE T.type LIKE 'mod_cook'

--2. ID, descripci�n y nivel m�ximo y m�nimo de los puestos de trabajo (jobs) que pueden tener un nivel 110.

--3. T�tulo, ID y tema de los libros que contengan la palabra "and� en las notas

--4. Nombre y ciudad de las editoriales (publishers) de los Estados Unidos que no est�n en California ni en Texas

--5. T�tulo, precio, ID de los libros que traten sobre psicolog�a o negocios y cuesten entre diez y 20 d�lares.

--6. Nombre completo (nombre y apellido) y direcci�n completa de todos los autores que no viven en California ni en Oreg�n.

--7. Nombre completo y direcci�n completa de todos los autores cuyo apellido empieza por D, G o S.

--8. ID, nivel y nombre completo de todos los empleados con un nivel inferior a 100, ordenado alfab�ticamente

