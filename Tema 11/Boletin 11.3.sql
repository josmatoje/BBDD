USE LeoMetro
--Ejercicio 1
--Escribe una funci�n escalar a la que se pase como par�metros el ID de un tren y un intervalo de tiempo (inicio y fin) y nos devuelva el n�mero de 
--estaciones por las que ha pasado ese tren (paradas) en dicho intervalo.

--Ejercicio 2
--Escribe una funci�n escalar a la que se pase como par�metros el ID de una estaci�n y un intervalo de tiempo (inicio y fin) y nos devuelva el n�mero de 
--pasajeros que han entrado o salido del metro por esa estaci�n en dicho intervalo.

--Ejercicio 3
--Escribe una funci�n escalar a la que se pase como par�metros el ID de un pasajero y un intervalo de tiempo (inicio y fin) y nos devuelva el total de 
--dinero que ha gastado ese pasajero en dicho intervalo. Ten en cuenta que un pasajero puede usar m�s de una tarjeta.

--Ejercicio 4
--Utilizando la funci�n creada en el ejercicio anterior, escribe una funci�n de valores de tabla a la que se pase como par�metros un intervalo de tiempo 
--(inicio y fin) y nos devuelva una lista de los pasajeros que han gastado m�s que la media durante ese intervalo. Las columnas ser�n ID del pasajero, 
--Nombre, apellidos e importe gastado.

--Recuerda que una funci�n escalar se puede utilizar en distintas partes de una consulta.

--Ejercicio 5
--Escribe una funci�n escalar a la que se pase como par�metros el ID de un tren y un intervalo de tiempo (inicio y fin) y nos devuelva el n�mero de 
--kil�metros recorridos por ese tren en dicho periodo.

--Ejercicio 6
--Escribe una funci�n de valores de tabla a la que se pase como par�metros un intervalo de tiempo (inicio y fin) y nos devuelva, para cada tren, su ID, 
--la fecha de entrada en servicio, el n�mero de kil�metros recorridos, su velocidad media y el n�mero de estaciones por las que ha pasado en dicho 
--intervalo.

--Considera la posibilidad de usar una funci�n de m�ltiples instrucciones.

--Ejercicio 7
--Escribe una funci�n de valores de tabla a la que se pase como par�metros el ID de una estaci�n y una fecha y nos devuelva una tabla con el n�mero de 
--pasajeros que han entrado o salido del metro por esa estaci�n en cada una de las horas, es decir, entre las 00:00 y las 00:59, entre las 01:00 y las 
--01:59, etc.

--Ejercicio 8
--La empresa del metro est� haciendo un estudio sobre los precios de los viajes. En concreto, quiere igualar la cantidad de dinero que ingresa el metro 
--en cada una de las zonas. Tomando como base el precio de la zona 1, queremos una funci�n a la que se pase como par�metro una zona y nos devuelva el 
--precio que deber�an tener los billetes de esa zona para recaudar lo mismo que se recauda en la zona 1, teniendo en cuenta el n�mero der pasajeros que 
--terminan sus viajes en esa zona y en la zona 1.

 

--Ejemplo: Supongamos que en la zona 1 terminan sus viajes 5.000 pasajeros y el precio del billete es 1�, con lo que se recaudan 5.000�. Si en la zona 2 
--son s�lo 4.000 pasajeros, �cu�nto tendr�a que valer el billete de esa zona para igualar la recaudaci�n de 5.000 �?

--Ejercicio 9
--Escribe una funci�n escalar a la que se pase como par�metros el ID de un pasajero y nos devuelva cu�l es su estaci�n favorita, por la que m�s pasa.

--Ejercicio 10 (multiples instrucciones)
--LeoMetro quiere premiar mensualmente a los pasajeros que m�s utilizan el transporte p�blico. Para ello necesitamos una funci�n que nos devuelva una 
--tabla con los que deben ser premiados.

--Los premios tienen tres categor�as: 1: Mayores de 65 a�os, 2: menores de 25 a�os y 3: resto. En cada categor�a se premia a tres personas. Los elegidos 
--ser�n los que hayan realizado m�s viajes en ese mes. En caso de empatar en n�mero de viajes, se dar� prioridad al que m�s dinero se haya gastado.

--Queremos una funci�n que reciba como par�metros un mes (TinyInt) y un a�o (SmallInt) y nos devuelva una tabla con los premiados de ese mes. Las 
--columnas de la tabla ser�n: ID del pasajero, nombre, apellidos, n�mero de viajes realizados en el mes, total de dinero gastado, categor�a y posici�n 
--(primero, segundo o tercero) en su categor�a.

--La tabla tendr�