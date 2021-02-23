USE pubs

--1. T�tulo y tipo de todos los libros en los que alguno de los autores vive en California (CA).

SELECT DISTINCT T.title,T.type FROM titles AS T
	INNER JOIN titleauthor AS TA ON T.title_id=TA.title_id
	INNER JOIN authors AS A ON TA.au_id=A.au_id
	WHERE A.state = 'CA'
	ORDER BY T.title

--2. T�tulo y tipo de todos los libros en los que ninguno de los autores vive en California (CA).

SELECT DISTINCT T.title,T.type FROM titles AS T
	LEFT JOIN titleauthor AS TA ON T.title_id=TA.title_id
	LEFT JOIN authors AS A ON TA.au_id=A.au_id
	WHERE ISNULL(A.state,'--') != 'CA' --NULL no se compara con una cadena????
	ORDER BY T.title

	--Comrpobacion
	SELECT * FROM titles
	ORDER BY title

--3. N�mero de libros en los que ha participado cada autor, incluidos los que no han publicado nada.

SELECT A.au_fname, A.au_lname, COUNT(T.title) AS [N� de libros] FROM titles AS T
	INNER JOIN titleauthor AS TA ON T.title_id=TA.title_id
	RIGHT JOIN authors AS A ON TA.au_id=A.au_id
	GROUP BY A.au_id, A.au_fname, A.au_lname

	--Comprobaciones
	SELECT * FROM authors
	BEGIN TRANSACTION
	INSERT INTO authors(au_id,au_lname,au_fname,phone,contract) VALUES ('111-11-1119', 'MATA', 'JOSEMA', '237482246794',0)
	ROLLBACK

--4. N�mero de libros que ha publicado cada editorial, incluidas las que no han publicado ninguno.

SELECT P.pub_name, COUNT(T.title_id) AS [N� de libros] FROM publishers AS P
	LEFT JOIN titles AS T ON P.pub_id=T.pub_id
	GROUP BY P.pub_id, P.pub_name

	--Comprobaciones
	SELECT * FROM publishers

--5. N�mero de empleados de cada editorial.

SELECT P.pub_name, COUNT(E.emp_id) AS [N� de empleado] FROM publishers AS P
	LEFT JOIN employee AS E ON P.pub_id=E.pub_id
	GROUP BY P.pub_id, P.pub_name

	--Comprobaciones
	SELECT * FROM employee

--6. Calcular la relaci�n entre n�mero de ejemplares publicados y n�mero de empleados de cada editorial, incluyendo el nombre de la misma.

SELECT * , C.[N� de libros]/C.[N� de empleado] AS [Relacion de Sech] FROM 
	(SELECT P.pub_name, COUNT(DISTINCT T.title_id) AS [N� de libros], COUNT(DISTINCT E.emp_id) AS [N� de empleado] FROM titles AS T
		RIGHT JOIN publishers AS P ON T.pub_id=P.pub_id
		LEFT JOIN employee AS E ON P.pub_id=E.pub_id
		GROUP BY P.pub_id, P.pub_name) AS C

--SUBCONSULTAS

SELECT CL.pub_name, CL.[N� de libros], CE.[N� de empleado] FROM (
				(SELECT P.pub_name, COUNT(T.title_id) AS [N� de libros] FROM publishers AS P
					LEFT JOIN titles AS T ON P.pub_id=T.pub_id
					GROUP BY P.pub_id, P.pub_name) AS CL
				INNER JOIN
				(SELECT P.pub_name, COUNT(E.emp_id) AS [N� de empleado] FROM publishers AS P
					LEFT JOIN employee AS E ON P.pub_id=E.pub_id
					GROUP BY P.pub_id, P.pub_name) AS CE
				ON CL.pub_name=CE.pub_name)
				
--SUBCONSULTA DE COLUMNA CALCULADA

SELECT * , CAST(C.[N� de libros] AS FLOAT)/NULLIF (C.[N� de empleado],0) AS [Relacion de Sech] FROM 
	(SELECT P.pub_name, COUNT(DISTINCT T.title_id) AS [N� de libros], COUNT(DISTINCT E.emp_id) AS [N� de empleado] FROM titles AS T
		RIGHT JOIN publishers AS P ON T.pub_id=P.pub_id
		LEFT JOIN employee AS E ON P.pub_id=E.pub_id
		GROUP BY P.pub_id, P.pub_name) AS C


--7. Nombre, Apellidos y ciudad de todos los autores que han trabajado para la editorial "Binnet & Hardley� o "Five Lakes Publishing�

SELECT A.au_fname, A.au_lname, A.city FROM publishers AS P
	INNER JOIN titles AS T ON P.pub_id=T.pub_id
	INNER JOIN titleauthor AS TA ON T.title_id=TA.title_id
	INNER JOIN authors AS A ON TA.au_id=A.au_id
	WHERE P.pub_name = 'Binnet & Hardley' OR 
			P.pub_name = 'Five Lakes Publishing'

--8. Empleados que hayan trabajado en alguna editorial que haya publicado alg�n libro en el que alguno de los autores fuera Marjorie Green 
--o Michael O'Leary.

SELECT DISTINCT E.* FROM employee AS E
	INNER JOIN titles AS T ON E.pub_id=T.pub_id --Me he saltado la tabla publishers
	INNER JOIN titleauthor AS TA ON T.title_id=TA.title_id
	INNER JOIN authors AS A ON TA.au_id=A.au_id
	WHERE (A.au_fname= 'Marjorie' AND A.au_lname = 'Green') OR
			(A.au_fname= 'Michael' AND A.au_lname = 'O''Leary')

--9. N�mero de ejemplares vendidos de cada libro, especificando el t�tulo y el tipo.

SELECT T.title, T.type, COUNT(t.title_id) AS [N� DE LIBROS] FROM titles AS T
	LEFT JOIN sales AS S ON T.title_id = S.title_id
	GROUP BY T.title_id, T.title, T.type

--10. N�mero de ejemplares de todos sus libros que ha vendido cada autor.

SELECT A.au_fname, A.au_lname, COUNT(T.title_id) AS [N� DE LIBROS] FROM authors AS A
	LEFT JOIN titleauthor AS TA ON A.au_id=TA.au_id
	LEFT JOIN titles AS T ON TA.title_id=T.title_id
	LEFT JOIN sales AS S ON T.title_id = S.title_id
	GROUP BY A.au_id, A.au_fname, A.au_lname
--Comprobaciones	
SELECT * FROM authors

--11. N�mero de empleados de cada categor�a (jobs).

SELECT J.job_desc, COUNT(E.emp_id) [N� de Empleados] FROM jobs AS J
	LEFT JOIN employee AS E ON J.job_id=E.job_id
	GROUP BY J.job_id,J.job_desc
--Comprobacion
SELECT * FROM jobs

--12. N�mero de empleados de cada categor�a (jobs) que tiene cada editorial, incluyendo aquellas categor�as en las que no haya ning�n 
--empleado.

SELECT P.pub_name, J.job_desc, COUNT (E.emp_id) AS [N� de empleados] FROM publishers AS P
	RIGHT JOIN employee AS E ON P.pub_id=E.pub_id
	CROSS JOIN jobs AS J 
	GROUP BY  J.job_id, J.job_desc, P.pub_id, P.pub_name

--13. Autores que han escrito libros de dos o m�s tipos diferentes



--14. Empleados que no trabajan actualmente en editoriales que han publicado libros cuya columna notes contenga la palabra "and�

SELECT * FROM titles