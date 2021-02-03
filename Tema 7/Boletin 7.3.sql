USE pubs

--1. Título, precio y notas de los libros (titles) que tratan de cocina, ordenados de mayor a menor precio.
SELECT title, price, notes FROM titles AS T
WHERE T.type LIKE 'mod_cook'

--2. ID, descripción y nivel máximo y mínimo de los puestos de trabajo (jobs) que pueden tener un nivel 110.
SELECT * FROM jobs
WHERE 110 BETWEEN min_lvl AND max_lvl

--3. Título, ID y tema de los libros que contengan la palabra "and” en las notas
SELECT title, title_id, type,* FROM titles
WHERE notes LIKE'% and[ ,]%'

--4. Nombre y ciudad de las editoriales (publishers) de los Estados Unidos que no estén en California ni en Texas
SELECT pub_name, city FROM publishers
WHERE country LIKE 'USA' AND
		state NOT LIKE 'CA' AND
		state NOT LIKE 'TX'

--5. Título, precio, ID de los libros que traten sobre psicología o negocios y cuesten entre diez y 20 dólares.
SELECT title, price, title_id FROM titles
WHERE (type LIKE 'psychology' OR
		type LIKE 'business') AND
		price >10 AND price<20

--6. Nombre completo (nombre y apellido) y dirección completa de todos los autores que no viven en California ni en Oregón.
SELECT au_fname, au_lname, address FROM authors
WHERE state NOT LIKE 'CA' AND
		state NOT LIKE 'OR'

--7. Nombre completo y dirección completa de todos los autores cuyo apellido empieza por D, G o S.
SELECT au_fname, au_lname, address FROM authors
WHERE au_lname LIKE '[DGS]%'
		
--8. ID, nivel y nombre completo de todos los empleados con un nivel inferior a 100, ordenado alfabéticamente
SELECT emp_id, job_lvl, fname, lname FROM employee
WHERE job_lvl<100
ORDER BY fname, lname

--Modificaciones de datos
--1. Inserta un nuevo autor.
BEGIN TRANSACTION
INSERT INTO authors VALUES
	('999-99-9999','el Chocolatero','Paquito', 'el numero','la direccion', 'Sevilla', 'Es', '98547',1)
COMMIT
--SELECT * FROM authors
--2. Inserta dos libros, escritos por el autor que has insertado antes y publicados por la editorial "Ramona publishers”.

--3. Modifica la tabla jobs para que el nivel mínimo sea 90.

BEGIN TRANSACTION
UPDATE jobs SET min_lvl=90
WHERE min_lvl<90
COMMIT

--SELECT * FROM jobs

--4. Crea una nueva editorial (publihers) con ID 9908, nombre Mostachon Books y sede en Utrera.

--5. Cambia el nombre de la editorial con sede en Alemania para que se llame "Machen Wücher" y traslasde su sede a Stuttgart
SELECT MAX (LEN(job_desc)) FROM jobs