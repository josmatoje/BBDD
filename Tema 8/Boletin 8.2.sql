USE pubs
--1. Numero de libros que tratan de cada tema
SELECT type, COUNT(*) AS [N� de libros] FROM titles
GROUP BY type
--2. N�mero de autores diferentes en cada ciudad y estado
SELECT state,city, COUNT(*) AS [N� de autores] FROM authors
GROUP BY state,city
ORDER BY state,city
--3. Nombre, apellidos, nivel y antig�edad en la empresa de los empleados con un nivel entre 100 y 150.
SELECT fname,lname, job_lvl FROM employee
WHERE job_lvl BETWEEN 100 AND 150
--4. N�mero de editoriales en cada pa�s. Incluye el pa�s.
SELECT ISNULL(state,'--') AS Pais, COUNT(*) AS [N� de paises] FROM publishers
GROUP BY state
--5. N�mero de unidades vendidas de cada libro en cada a�o (title_id, unidades y a�o).
SELECT title_id, SUM(qty) AS Cantidad, YEAR(ord_date) AS A�o FROM sales
GROUP BY title_id, YEAR(ord_date)
SELECT * FROM sales
--6. N�mero de autores que han escrito cada libro (title_id y numero de autores).

--7. ID, Titulo, tipo y precio de los libros cuyo adelanto inicial (advance) tenga un valor superior a $7.000, ordenado por tipo y t�tulo
SELECT title_id, title, type, price FROM titles
WHERE advance>7000
ORDER BY type,title