USE LeoMetro
--Ejercicio 1
--Indica el n�mero de estaciones por las que pasa cada l�nea

SELECT * FROM  LM_Itinerarios AS IIN
	INNER JOIN LM_Itinerarios AS IFI 
	ON IIN.Linea=IFI.Linea AND IIN.NumOrden=IFI.NumOrden


--Ejercicio 2
--Indica el n�mero de trenes diferentes que han circulado en cada l�nea


--Ejercicio 3
--Indica el n�mero medio de trenes de cada clase que pasan al d�a por cada estaci�n.

--Ejercicio 4
--Calcula el tiempo necesario para recorrer una l�nea completa, contando con el tiempo estimado de cada itinerario y considerando que cada 
--parada en una estaci�n dura 30 s.

--Ejercicio 5
--Indica el n�mero total de pasajeros que entran (a pie) cada d�a por cada estaci�n y los que salen del metro en la misma.

--Ejercicio 6
--Calcula la media de kil�metros al d�a que hace cada tren. Considera �nicamente los d�as que ha estado en servicio

--Ejercicio 7
--Calcula cu�l ha sido el intervalo de tiempo en que m�s personas registradas han estado en el metro al mismo tiempo. Considera intervalos de una 
--hora (de 12:00 a 12:59, de 13:00 a 13:59, etc). Si hay varios momentos con el n�mero m�ximo de personas, muestra el m�s reciente.

--Ejercicio 8
--Calcula el dinero gastado por cada usuario en el mes de febrero de 2017. El precio de un viaje es el de la zona m�s cara que incluya. Incluye a 
--los que no han viajado.

--Ejercicio 9
--Calcula el tiempo medio diario que cada pasajero pasa en el sistema de metro y el n�mero de veces que accede al mismo.

