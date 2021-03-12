USE BicisLeo
--Esta base de datos se utiliza para la facturaci�n de un comercio que vende equipamiento para la pr�ctica del ciclismo. Aparte de las tablas habituales en una aplicaci�n comercial (clientes, productos, pedidos) y sus relaciones, incorpora algunas caracter�sticas avanzadas:

--Los productos pueden devolverse. Para eso existe que tabla devoluciones que se asocia con pedidos (un pedido puede dar lugar a varias devoluciones) y con la tabla de productos a trav�s de LineasPedidos y LineasDevoluci�n. Presta atenci�n a c�mo est�n relacionadas estas tablas para escribir correctamente los JOINS. Recuerda que si la FK es compuesta, el ON ha de incluir todos los pares de columnas.
--Algunos productos tienen asociados uno o varios productos sustitutivos.
--Un producto puede pertenecer a una o m�s categor�as
--Hay categor�as gen�ricas que agrupan a otras categor�as espec�ficas
-- Escribe las siguientes consultas sobre la base de datos BicisLeo.

--Pon el enunciado como comentario junta a cada una

--Actividades
--1.    N�mero de productos vendidos de cada categor�a.

--2.    Ejercicio 1 incluyendo las categor�as de las que no se ha vendido nada.

--3.    Importe de las ventas de cada categor�a.

--4.    Ejercicio 2 considerando tambi�n las categor�as generales. Es decir, todas las ventas de productos de las categor�as 5, 6 o 7 se 
--		considerar�n tambi�n ventas de la categor�a 1, que es la categor�a gen�rica que las agrupa. No utilices los c�digos concretos de las 
--		categor�as. La consulta tiene que funcionar si cambiamos los c�digos de las categor�as.

--5.    N�mero de productos de cada categor�a que ha comprado cada cliente.

--6.    Ejercicio 5 considerando tambi�n las categor�as generales

--7.    Has una consulta que nos permita comprobar si todos los productor pertenecen al menos a una categor�a

--8.    Importe bruto de cada venta

--9.    Importe neto de cada venta, descontando los productos devueltos

--10.  Facturaci�n de cada cliente (en dinero).

--11.  Para cada cliente queremos importe de sus compras, importe de sus devoluciones y % que suponen las devoluciones respecto de las 
--		compras

--12.  Facturaci�n neta de cada cliente, descontando las devoluciones.

--13.  Queremos saber qui�nes son los clientes (nombre, segundo nombre, apellidos, nombre empresa) que no han comprado nunca productos de la 
--		categor�a 3 (Clothing) o alguna de sus categor�as derivadas.

--14.  Queremos saber cu�ntos clientes no han comprado nunca productos de cada categor�a.

--15.  Queremos saber cu�les son los productos que se compran juntos m�s a menudo. Haz una consulta que nos diga cu�ntas veces se han 
--		comprado juntos (en el mismo pedido) cada pareja de productos, incluyendo los que nunca han coincidido.
--		PISTA: Hay una forma de JOIN que te permite obtener todas las parejas posibles