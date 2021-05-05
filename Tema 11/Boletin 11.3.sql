USE LeoMetro
--Ejercicio 1
--Escribe una función escalar a la que se pase como parámetros el ID de un tren y un intervalo de tiempo (inicio y fin) y nos devuelva el número de 
--estaciones por las que ha pasado ese tren (paradas) en dicho intervalo.

--Ejercicio 2
--Escribe una función escalar a la que se pase como parámetros el ID de una estación y un intervalo de tiempo (inicio y fin) y nos devuelva el número de 
--pasajeros que han entrado o salido del metro por esa estación en dicho intervalo.

--Ejercicio 3
--Escribe una función escalar a la que se pase como parámetros el ID de un pasajero y un intervalo de tiempo (inicio y fin) y nos devuelva el total de 
--dinero que ha gastado ese pasajero en dicho intervalo. Ten en cuenta que un pasajero puede usar más de una tarjeta.

--Ejercicio 4
--Utilizando la función creada en el ejercicio anterior, escribe una función de valores de tabla a la que se pase como parámetros un intervalo de tiempo 
--(inicio y fin) y nos devuelva una lista de los pasajeros que han gastado más que la media durante ese intervalo. Las columnas serán ID del pasajero, 
--Nombre, apellidos e importe gastado.

--Recuerda que una función escalar se puede utilizar en distintas partes de una consulta.

--Ejercicio 5
--Escribe una función escalar a la que se pase como parámetros el ID de un tren y un intervalo de tiempo (inicio y fin) y nos devuelva el número de 
--kilómetros recorridos por ese tren en dicho periodo.

--Ejercicio 6
--Escribe una función de valores de tabla a la que se pase como parámetros un intervalo de tiempo (inicio y fin) y nos devuelva, para cada tren, su ID, 
--la fecha de entrada en servicio, el número de kilómetros recorridos, su velocidad media y el número de estaciones por las que ha pasado en dicho 
--intervalo.

--Considera la posibilidad de usar una función de múltiples instrucciones.

--Ejercicio 7
--Escribe una función de valores de tabla a la que se pase como parámetros el ID de una estación y una fecha y nos devuelva una tabla con el número de 
--pasajeros que han entrado o salido del metro por esa estación en cada una de las horas, es decir, entre las 00:00 y las 00:59, entre las 01:00 y las 
--01:59, etc.

--Ejercicio 8
--La empresa del metro está haciendo un estudio sobre los precios de los viajes. En concreto, quiere igualar la cantidad de dinero que ingresa el metro 
--en cada una de las zonas. Tomando como base el precio de la zona 1, queremos una función a la que se pase como parámetro una zona y nos devuelva el 
--precio que deberían tener los billetes de esa zona para recaudar lo mismo que se recauda en la zona 1, teniendo en cuenta el número der pasajeros que 
--terminan sus viajes en esa zona y en la zona 1.

 

--Ejemplo: Supongamos que en la zona 1 terminan sus viajes 5.000 pasajeros y el precio del billete es 1€, con lo que se recaudan 5.000€. Si en la zona 2 
--son sólo 4.000 pasajeros, ¿cuánto tendría que valer el billete de esa zona para igualar la recaudación de 5.000 €?

--Ejercicio 9
--Escribe una función escalar a la que se pase como parámetros el ID de un pasajero y nos devuelva cuál es su estación favorita, por la que más pasa.

--Ejercicio 10 (multiples instrucciones)
--LeoMetro quiere premiar mensualmente a los pasajeros que más utilizan el transporte público. Para ello necesitamos una función que nos devuelva una 
--tabla con los que deben ser premiados.

--Los premios tienen tres categorías: 1: Mayores de 65 años, 2: menores de 25 años y 3: resto. En cada categoría se premia a tres personas. Los elegidos 
--serán los que hayan realizado más viajes en ese mes. En caso de empatar en número de viajes, se dará prioridad al que más dinero se haya gastado.

--Queremos una función que reciba como parámetros un mes (TinyInt) y un año (SmallInt) y nos devuelva una tabla con los premiados de ese mes. Las 
--columnas de la tabla serán: ID del pasajero, nombre, apellidos, número de viajes realizados en el mes, total de dinero gastado, categoría y posición 
--(primero, segundo o tercero) en su categoría.

--La tabla tendrá