USE pubs
--1. Numero de libros que tratan de cada tema
SELECT type, COUNT(*) AS [Nº de libros] FROM titles
GROUP BY type
--2. Número de autores diferentes en cada ciudad y estado
SELECT state,city, COUNT(*) AS [Nº de autores] FROM authors
GROUP BY state,city
ORDER BY state,city
--3. Nombre, apellidos, nivel y antigüedad en la empresa de los empleados con un nivel entre 100 y 150.
SELECT fname,lname, job_lvl FROM employee
WHERE job_lvl BETWEEN 100 AND 150
--4. Número de editoriales en cada país. Incluye el país.
SELECT ISNULL(state,'--') AS Pais, COUNT(*) AS [Nº de paises] FROM publishers
GROUP BY state
--5. Número de unidades vendidas de cada libro en cada año (title_id, unidades y año).
SELECT title_id, SUM(qty) AS Cantidad, YEAR(ord_date) AS Año FROM sales
GROUP BY title_id, YEAR(ord_date)
SELECT * FROM sales
--6. Número de autores que han escrito cada libro (title_id y numero de autores).

--7. ID, Titulo, tipo y precio de los libros cuyo adelanto inicial (advance) tenga un valor superior a $7.000, ordenado por tipo y título
SELECT title_id, title, type, price FROM titles
WHERE advance>7000
ORDER BY type,title