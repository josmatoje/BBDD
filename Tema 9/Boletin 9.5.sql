USE BicisLeo
--Esta base de datos se utiliza para la facturación de un comercio que vende equipamiento para la práctica del ciclismo. Aparte de las tablas habituales en una aplicación comercial (clientes, productos, pedidos) y sus relaciones, incorpora algunas características avanzadas:

--Los productos pueden devolverse. Para eso existe que tabla devoluciones que se asocia con pedidos (un pedido puede dar lugar a varias devoluciones) y con la tabla de productos a través de LineasPedidos y LineasDevolución. Presta atención a cómo están relacionadas estas tablas para escribir correctamente los JOINS. Recuerda que si la FK es compuesta, el ON ha de incluir todos los pares de columnas.
--Algunos productos tienen asociados uno o varios productos sustitutivos.
--Un producto puede pertenecer a una o más categorías
--Hay categorías genéricas que agrupan a otras categorías específicas
-- Escribe las siguientes consultas sobre la base de datos BicisLeo.

--Pon el enunciado como comentario junta a cada una

--Actividades
--1.    Número de productos vendidos de cada categoría.

--2.    Ejercicio 1 incluyendo las categorías de las que no se ha vendido nada.

--3.    Importe de las ventas de cada categoría.

--4.    Ejercicio 2 considerando también las categorías generales. Es decir, todas las ventas de productos de las categorías 5, 6 o 7 se 
--		considerarán también ventas de la categoría 1, que es la categoría genérica que las agrupa. No utilices los códigos concretos de las 
--		categorías. La consulta tiene que funcionar si cambiamos los códigos de las categorías.

--5.    Número de productos de cada categoría que ha comprado cada cliente.

--6.    Ejercicio 5 considerando también las categorías generales

--7.    Has una consulta que nos permita comprobar si todos los productor pertenecen al menos a una categoría

--8.    Importe bruto de cada venta

--9.    Importe neto de cada venta, descontando los productos devueltos

--10.  Facturación de cada cliente (en dinero).

--11.  Para cada cliente queremos importe de sus compras, importe de sus devoluciones y % que suponen las devoluciones respecto de las 
--		compras

--12.  Facturación neta de cada cliente, descontando las devoluciones.

--13.  Queremos saber quiénes son los clientes (nombre, segundo nombre, apellidos, nombre empresa) que no han comprado nunca productos de la 
--		categoría 3 (Clothing) o alguna de sus categorías derivadas.

--14.  Queremos saber cuántos clientes no han comprado nunca productos de cada categoría.

--15.  Queremos saber cuáles son los productos que se compran juntos más a menudo. Haz una consulta que nos diga cuántas veces se han 
--		comprado juntos (en el mismo pedido) cada pareja de productos, incluyendo los que nunca han coincidido.
--		PISTA: Hay una forma de JOIN que te permite obtener todas las parejas posibles