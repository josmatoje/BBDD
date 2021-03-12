USE pubs

/*1. Numero de libros que tratan de cada tema*/
SELECT * FROM titles

SELECT COUNT(title_id) AS [Numero de libros por tema], type FROM titles
	GROUP BY type

/*2. N�mero de autores diferentes en cada ciudad y estado*/
SELECT * FROM authors

SELECT COUNT(au_id), city, state FROM authors
	GROUP BY city, state
	ORDER BY state

/*3. Nombre, apellidos, nivel y antig�edad en la empresa de los empleados con un nivel entre 100 y 150.*/
SELECT * FROM employee

SELECT fname, lname, job_lvl, Year(Current_Timestamp - hire_date)-1900 AS [A�os de antig�edad] FROM employee
	WHERE job_lvl BETWEEN 100 AND 150

/*4. N�mero de editoriales en cada pa�s. Incluye el pa�s.*/
SELECT * FROM publishers

SELECT country, COUNT(pub_id) AS [N�mero de editoriales] FROM publishers
	GROUP BY country

/*5. N�mero de unidades vendidas de cada libro en cada a�o (title_id, unidades y a�o).*/
SELECT * FROM sales

SELECT title_id, SUM(qty) AS [N�mero de unidades vendidas], YEAR(ord_date) AS [A�o de pedido] FROM sales
	GROUP BY title_id, YEAR(ord_date)

/*6. N�mero de autores que han escrito cada libro (title_id y numero de autores).*/
SELECT * FROM titleauthor

SELECT title_id, COUNT(au_ord) AS [N�mero de autores por libro] FROM titleauthor
	group by title_id

/*7. ID, Titulo, tipo y precio de los libros cuyo adelanto inicial (advance) tenga un valor superior a $7.000, ordenado por tipo y t�tulo*/
SELECT * FROM titles

SELECT title_id, title, [type], price FROM titles
	WHERE advance > 7000
	ORDER BY [type], title