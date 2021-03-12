Use TeleMostachon
Go

    /*******************************************************************************************/
   /*                                                                                         */
  /*	                                  Ejercicio 1                                        */
 /*                                                                                         */
/*******************************************************************************************/
--Obt�n el precio medio de los pedidos de cada mes de cada establecimiento, as� como el precio del m�s caro. La consulta tendr� cinco columnas: Nombre del establecimiento, ciudad, nombre (o n�mero) del mes, Precio medio de los pedidos y precio del m�s caro.
--Los meses que se llaman igual de cada a�o se consideran diferentes, es decir, enero de 2015 es un mes y enero de 2016 es otro.

SELECT E.Denominacion, E.Ciudad, YEAR(P.Recibido) AS [A�o], MONTH (P.Recibido) AS Mes, AVG(P.Importe) AS ImporteMedio, MAX(P.Importe) AS ImporteMayor FROM TMPedidos AS P
	INNER JOIN TMEstablecimientos AS E ON P.IDEstablecimiento = E.ID
	GROUP BY E.ID,E.Denominacion, E.Ciudad, YEAR(P.Recibido), MONTH (P.Recibido)
	Order By E.Ciudad, E.Denominacion, YEAR(P.Recibido), MONTH (P.Recibido)

    /*******************************************************************************************/
   /*                                                                                         */
  /*	                                  Ejercicio 2                                        */
 /*                                                                                         */
/*******************************************************************************************/
--Queremos saber cu�l es el tipo de mostach�n y el topping favoritos de cada cliente. Nombre y apellidos del cliente, ciudad, tipo de mostach�n favorito y topping favorito

--N�mero de veces que cada cliente ha pedido cada tipo
SELECT P.IDCliente, M.Harina, Count(*) As Veces FROM TMPedidos AS P
	INNER JOIN TMMostachones AS M ON P.ID = M.IDPedido
	Group By P.IDCliente, M.Harina

--N�mero de mayor de veces que cada cliente ha pedido el tipo favorito
Select MAX(Veces), IDCliente FROM
(SELECT P.IDCliente, M.Harina, Count(*) As Veces FROM TMPedidos AS P
	INNER JOIN TMMostachones AS M ON P.ID = M.IDPedido
	Group By P.IDCliente, M.Harina) AS TipoHarina
	Group By IDCliente

-- Uni�n de las dos consultas 
Select MaximaHarina.IDCliente, MaximaHarina.HarinaMaxima, TipoHarina.Harina FROM
	(Select MAX(Veces) AS HarinaMaxima, IDCliente FROM
	(SELECT P.IDCliente, M.Harina, Count(*) As Veces FROM TMPedidos AS P
		INNER JOIN TMMostachones AS M ON P.ID = M.IDPedido
		Group By P.IDCliente, M.Harina) AS TipoHarina
		Group By IDCliente) As MaximaHarina
	INNER Join
	(SELECT P.IDCliente, M.Harina, Count(*) As Veces FROM TMPedidos AS P
		INNER JOIN TMMostachones AS M ON P.ID = M.IDPedido
		Group By P.IDCliente, M.Harina) AS TipoHarina
	ON MaximaHarina.IDCliente = TipoHarina.IDCliente AND MaximaHarina.HarinaMaxima = TipoHarina.Veces

-- Ahora lo mismo con los toppings
--N�mero de veces que cada cliente ha pedido cada topping
SELECT P.IDCliente, MT.IDTopping, Count(*) As Veces FROM TMPedidos AS P
	INNER JOIN TMMostachones AS M ON P.ID = M.IDPedido
	INNER JOIN TMMostachonesToppings AS MT ON M.ID = MT.IDMostachon
	Group By P.IDCliente, MT.IDTopping

--N�mero de mayor de veces que cada cliente ha pedido el topping favorito
Select MAX(Veces) As ToppingMaximo, IDCliente FROM
(SELECT P.IDCliente, MT.IDTopping, Count(*) As Veces FROM TMPedidos AS P
	INNER JOIN TMMostachones AS M ON P.ID = M.IDPedido
	INNER JOIN TMMostachonesToppings AS MT ON M.ID = MT.IDMostachon
	Group By P.IDCliente, MT.IDTopping) AS Toppings
	Group By IDCliente

-- Uni�n de las dos consultas 
Select MaximoTopping.IDCliente, MaximoTopping.ToppingMaximo, TipoTopping.IDTopping FROM
	(Select MAX(Veces) As ToppingMaximo, IDCliente FROM
(SELECT P.IDCliente, MT.IDTopping, Count(*) As Veces FROM TMPedidos AS P
	INNER JOIN TMMostachones AS M ON P.ID = M.IDPedido
	INNER JOIN TMMostachonesToppings AS MT ON M.ID = MT.IDMostachon
	Group By P.IDCliente, MT.IDTopping) AS Toppings
	Group By IDCliente) As MaximoTopping
	INNER Join
	(SELECT P.IDCliente, MT.IDTopping, Count(*) As Veces FROM TMPedidos AS P
	INNER JOIN TMMostachones AS M ON P.ID = M.IDPedido
	INNER JOIN TMMostachonesToppings AS MT ON M.ID = MT.IDMostachon
	Group By P.IDCliente, MT.IDTopping) AS TipoTopping
	ON MaximoTopping.IDCliente = TipoTopping.IDCliente AND MaximoTopping.ToppingMaximo = TipoTopping.Veces

-- Uni�n de todo y con la tabla Clientes para tener su nombre
SELECT C.Nombre, C.Apellidos, Harina.Harina, Harina.HarinaMaxima, T.Topping, Toppings.ToppingMaximo FROM
	(Select MaximaHarina.IDCliente, MaximaHarina.HarinaMaxima, TipoHarina.Harina FROM
		(Select MAX(Veces) AS HarinaMaxima, IDCliente FROM
		(SELECT P.IDCliente, M.Harina, Count(*) As Veces FROM TMPedidos AS P
			INNER JOIN TMMostachones AS M ON P.ID = M.IDPedido
			Group By P.IDCliente, M.Harina) AS TipoHarina
			Group By IDCliente) As MaximaHarina
		INNER Join
		(SELECT P.IDCliente, M.Harina, Count(*) As Veces FROM TMPedidos AS P
			INNER JOIN TMMostachones AS M ON P.ID = M.IDPedido
			Group By P.IDCliente, M.Harina) AS TipoHarina
		ON MaximaHarina.IDCliente = TipoHarina.IDCliente AND MaximaHarina.HarinaMaxima = TipoHarina.Veces) As Harina
	INNER JOIN
	(Select MaximoTopping.IDCliente, MaximoTopping.ToppingMaximo, TipoTopping.IDTopping FROM
		(Select MAX(Veces) As ToppingMaximo, IDCliente FROM
	(SELECT P.IDCliente, MT.IDTopping, Count(*) As Veces FROM TMPedidos AS P
		INNER JOIN TMMostachones AS M ON P.ID = M.IDPedido
		INNER JOIN TMMostachonesToppings AS MT ON M.ID = MT.IDMostachon
		Group By P.IDCliente, MT.IDTopping) AS Toppings
		Group By IDCliente) As MaximoTopping
		INNER Join
		(SELECT P.IDCliente, MT.IDTopping, Count(*) As Veces FROM TMPedidos AS P
		INNER JOIN TMMostachones AS M ON P.ID = M.IDPedido
		INNER JOIN TMMostachonesToppings AS MT ON M.ID = MT.IDMostachon
		Group By P.IDCliente, MT.IDTopping) AS TipoTopping
		ON MaximoTopping.IDCliente = TipoTopping.IDCliente AND MaximoTopping.ToppingMaximo = TipoTopping.Veces) As Toppings
	ON Harina.IDCliente = Toppings.IDCliente
	JOIN TMClientes AS C ON Harina.IDCliente = C.ID
	JOIN TMToppings AS T ON Toppings.IDTopping = T.ID

    /*******************************************************************************************/
   /*                                                                                         */
  /*	                                  Ejercicio 3                                        */
 /*                                                                                         */
/*******************************************************************************************/

--Queremos saber los establecimientos que aumentan o disminuyen el n�mero de mostachones que venden, para ello queremos una consulta que nos diga el nombre y ciudad del establecimiento, el n�mero de mostachones vendidos en el a�o actual, en el a�o anterior (si existe) y su aumento o disminuci�n en tanto por ciento

--N�mero de mostachones vendidos por cada establecimiento cada a�o
SELECT P.IDEstablecimiento, Year(P.Recibido) As Anno, Count(*) As NumeroMostachones 
	From TMPedidos AS P
	Inner JOIN TMMostachones AS M ON P.ID = M.IDPedido
	GROUP BY P.IDEstablecimiento, Year(P.Recibido)
	
-- Hacemos JOIN de esa consulta consigo misma y con la tabla TMEstablecimientos
SELECT E.Denominacion, E.Ciudad, Actual.Anno, Actual.NumeroMostachones AS Ventas, Anterior.NumeroMostachones AS  A�oAnterior,
	(CAST((Actual.NumeroMostachones-Anterior.NumeroMostachones) AS Decimal (8,3))/Anterior.NumeroMostachones)*100 AS Variacion 
	FROM (SELECT P.IDEstablecimiento, Year(P.Recibido) As Anno, Count(*) As NumeroMostachones 
		From TMPedidos AS P
		Inner JOIN TMMostachones AS M ON P.ID = M.IDPedido
		GROUP BY P.IDEstablecimiento, Year(P.Recibido)) AS Actual
	JOIN (SELECT P.IDEstablecimiento, Year(P.Recibido) As Anno, Count(*) As NumeroMostachones 
		From TMPedidos AS P
		Inner JOIN TMMostachones AS M ON P.ID = M.IDPedido
		GROUP BY P.IDEstablecimiento, Year(P.Recibido)) AS Anterior
	ON Actual.IDEstablecimiento = Anterior.IDEstablecimiento AND Actual.Anno = Anterior.Anno + 1
	JOIN TMEstablecimientos As E ON Actual.IDEstablecimiento = E.ID
	Order By E.Ciudad,E.Denominacion,Actual.Anno

    /*******************************************************************************************/
   /*                                                                                         */
  /*	                                  Ejercicio 4                                        */
 /*                                                                                         */
/*******************************************************************************************/
--Una auditor�a interna ha descubierto que las instrucciones enviadas al establecimiento de Jap�n ten�an errores de traducci�n y los pedidos en los que se ha pedido topping de jalape�o los han servido con wasabi. Adem�s en lugar de la base tradicional han utilizado bamb�.
--Inserta ese topping y esa base si no aparecen en la base de datos y actualiza los pedidos del establecimiento de Jap�n para que la informaci�n sea correcta.

-- Insertamos la base que falta
INSERT INTO TMBases (Base) VALUES ('Bamb�')

-- Insertamos el topping
INSERT INTO TMToppings (ID,Topping) VALUES (15, Wasabi)

GO
--Primero vamos a ver los mostachones que tenemos que cambiar: Todos los servidos por el establecimiento de Jap�n con base Tradicional
Select * FROM TMMostachones AS M
	INNER Join TMPedidos AS P ON M.IDPedido = P.ID
	INNER Join TMEstablecimientos AS E ON P.IDEstablecimiento = E.ID
	Where E.Ciudad = 'Tokyo' AND M.TipoBase = 'Tradicional        '

--Forma sencilla: Con una subconsulta
Begin transaction
UPDATE TMMostachones 
	Set TipoBase = 'Bamb�'
		Where ID IN (
		Select M.ID FROM TMMostachones AS M
		INNER Join TMPedidos AS P ON M.IDPedido = P.ID
		INNER Join TMEstablecimientos AS E ON P.IDEstablecimiento = E.ID
		Where E.Ciudad = 'Tokyo' AND M.TipoBase = 'Tradicional         ')
Rollback
-- Relacionando tablas
UPDATE TMMostachones 
		Set TipoBase = 'Bamb�'
		From TMPedidos AS P
		INNER Join TMEstablecimientos AS E ON P.IDEstablecimiento = E.ID
		Where (TMMostachones.IDPedido = P.ID) AND (E.Ciudad = 'Tokyo' AND TipoBase = 'Tradicional         ')

-- O tambi�n
UPDATE TMMostachones
	Set TipoBase = 'Bamb�'
	FROM TMMostachones AS M
	INNER Join TMPedidos AS P ON M.IDPedido = P.ID
	INNER Join TMEstablecimientos AS E ON P.IDEstablecimiento = E.ID
	Where E.Ciudad = 'Tokyo' AND M.TipoBase = 'Tradicional         '

--Ahora lo mismo con los toppings
-- Mostachones que hay que cambiar
Select * FROM TMMostachones AS M
	INNER Join TMPedidos AS P ON M.IDPedido = P.ID
	INNER Join TMEstablecimientos AS E ON P.IDEstablecimiento = E.ID
	INNER Join TMMostachonesToppings As MT ON M.ID = MT.IDMostachon
	INNER Join TMToppings AS T ON MT.IDTopping = T.ID
	Where E.Ciudad = 'Tokyo' AND T.Topping = 'Jalape�o'

--Con una subconsulta
UPDATE TMMostachonesToppings 
	Set IDTopping = 15
	FROM TMToppings AS T
	Where IDMostachon IN (
		Select M.ID FROM TMMostachones AS M
			INNER Join TMPedidos AS P ON M.IDPedido = P.ID
			INNER Join TMEstablecimientos AS E ON P.IDEstablecimiento = E.ID
			INNER Join TMMostachonesToppings As MT ON M.ID = MT.IDMostachon
			INNER Join TMToppings AS T ON MT.IDTopping = T.ID
			Where E.Ciudad = 'Tokyo' AND T.Topping = 'Jalape�o'
	) AND IDTopping = T.ID AND T.Topping = 'Jalape�o'

    /*******************************************************************************************/
   /*                                                                                         */
  /*	                                  Ejercicio 5                                        */
 /*                                                                                         */
/*******************************************************************************************/
--Nuestra cliente Olga Llinero de Madrid ha hecho un pedido ahora mismo al establecimiento Sol Naciente. El pedido est� formado por dos mostachones, uno de Ma�z sobre base de papel reciclado con topping de mermelada y otro de espelta sobre base de cartulina con toppings de nata y almendras picadas. Adem�s se a�ade un caf�.
--Se valorar� positivamente si se crea ese pedido insertando las nuevas filas que correspondan con instrucciones INSERT-SELECT para cada tabla sin usar m�s datos que los que se te han proporcionado o los que tu a�adas (ID del pedido e ID del mostach�n). Cada mostach�n vale 2� y cada topping 0,60�. El repartidor y la fecha de env�o se dejan a NULL.

-- Primero creamos el pedido
Insert INTO TMPedidos (ID,Recibido,Enviado,IDCliente,IDEstablecimiento,IDRepartidor,Importe)
	SELECT 1001,CURRENT_TIMESTAMP,Null,C.ID,E.ID,Null, 2*2+3*0.6+Co.Importe
		FROM TMClientes AS C
		CROSS JOIN TMEstablecimientos AS E
		CROSS JOIN TMComplementos AS Co
		Where C.Apellidos = 'Llinero' AND C.Nombre = 'Olga' AND E.Denominacion = 'Sol Naciente' AND Co.Complemento = 'Caf�'

-- Ahora los mostachones
Insert INTO TMMostachones(ID,IDPedido,TipoBase,Harina)
	VALUES (1001, 1001, 'Reciclado', 'Ma�z'),(1002, 1001,'Cartulina', 'Espelta')

-- A�adimos el caf�

-- Y los toppings