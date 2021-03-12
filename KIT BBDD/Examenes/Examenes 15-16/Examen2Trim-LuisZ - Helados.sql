-- Examen Luis Zum�rraga

USE ICOTR
GO
--INSERT ICComplementos (ID, Complemento, Importe) VALUES (111,'Descatalogado', NULL)

--Ejercicio 1
--Escribe una consulta que nos devuelva el importe total de los pedidos que ha
--transportado cada repartidor en el a�o 2014 y el tiempo medio que ha
--transcurrido entre que se hicieron los pedidos hasta que se sirvieron (en
--segundos). Incluye tambi�n nombre, apellidos e ID del repartidor

SELECT
	R.Nombre,
	R.Apellidos,
	R.ID,
	SUM(P.Importe) AS TOTAL
	--,DATEDIFF(MINUTE,P.Recibido,P.Enviado) AS [Diferencia temporal]	-- Si se usa esta instrucci�n hay que afrupar por recibido y enviado
	,AVG (DATEDIFF(MINUTE,P.Recibido,P.Enviado)) AS [Tiempo Medio]		--Hemos usado DATEDIFF para que devolviera un entero
FROM																	--Porque AVG no trabaja con fechas
	ICRepartidores AS R
	JOIN
	ICPedidos AS P
	ON R.ID = P.IDRepartidor
WHERE YEAR(P.Enviado) = 2014	--Solo los pedido hechos en 2014
GROUP BY
	R.ID, R.Nombre, R.Apellidos

GO
--Ejercicio 2
--Para optimizar nuestro servicio, queremos borrar los 3 complementos que menos
--se hayan vendido entre el 17 de marzo de 2013 y el 8 de septiembre de 2014.
--Como eso implicar�a violar la restricci�n FKPedidosComplementosHelados de la
--tabla ICPedidosComplementos, previamente hemos de cambiar las filas donde
--aparezcan sus IDs por el valor 111.1

BEGIN TRAN

UPDATE ICPedidosComplementos
	SET IDComplemento = 111.1
	WHERE IDPedido IN (
		SELECT 
			IDPedido
		FROM 
			ICPedidosComplementos AS PC
		JOIN
			ICPedidos AS P
		ON P.ID = PC.IDPedido
		WHERE (YEAR(P.Enviado) BETWEEN 2013 AND 2014) 
			AND (MONTH(P.Enviado)BETWEEN 03 AND 09)		
				AND (DAY(P.Enviado) BETWEEN 8 AND 17)
	)

--ROLLBACK TRAN
--BEGIN TRAN
DELETE 
	FROM 
		ICComplementos
	WHERE ID IN (
		SELECT	
			P.Enviado AS Fecha
		FROM ICPedidos AS P
		-- Pedidos entre 17/03/2013 y 08/09/2014 (Un m�todo un poco �chapucero?)
		WHERE (YEAR(P.Enviado) BETWEEN 2013 AND 2014) 
			AND (MONTH(P.Enviado)BETWEEN 03 AND 09)		
				AND (DAY(P.Enviado) BETWEEN 8 AND 17)	
	)

GO
--Ejercicio 3
--Nuestro cliente Ram�n Ta�ero de M�laga ha hecho un pedido ahora mismo al
--establecimiento Atrac�n. El pedido est� formado por dos helados, uno de caramelo
--con topping de nata y otro de alcachofa con topping de gominolas y lacasitos,
--ambos en un contenedor de tarrina cer�mica. Adem�s se a�ade un caf�.
--Crea ese pedido insertando las nuevas filas que correspondan con una sola
--instrucci�n INSERT-SELECT para cada tabla sin usar m�s datos que los que se te
--han proporcionado o los que tu a�adas (ID del pedido e ID del helado). Cada
--helado vale 4� y cada topping 0,60�. El repartidor y la fecha de env�o se dejan a NULL.
INSERT INTO ICPedidos ()

GO
--Ejercicio 4
--Crea una vista que nos muestre, para cada establecimiento, nombre, direcci�n,
--n�mero de pedidos servidos en el a�o 2014, total facturado en el mismo a�o y
--n�mero de repartidores diferentes que han trabajado en �l.

BEGIN TRAN
GO
CREATE VIEW [V-Establecimientos-2014] AS
	SELECT DISTINCT
		E.Denominacion AS Nombre ,
		E.Direccion,
		COUNT(P.IDEstablecimiento) AS [Numero Pedidos],
		COUNT (R.ID) AS [Trabajadores distintos]			---no funciona de la manera esperada :S
	FROM	
		ICEstablecimientos AS E
	JOIN 
		ICRepartidores AS R
	ON 
		E.ID=R.IDEstablecimiento
	JOIN
		ICPedidos AS P
	ON
		E.ID = P.IDEstablecimiento
	WHERE YEAR(P.Enviado)=2014			--Tambien podr�a hacerse con un Having, pero puede ser m�s lioso
	GROUP BY 
		E.Denominacion, E.Direccion

--ROLLBACK TRAN
--COMMIT TRAN

--SELECT * FROM [V-Establecimientos-2014]

GO
--Ejercicio 5
--Haz una vista que nos muestre la popularidad de cada sabor de helado en %. Para
--calcularlo tienes que contar el n�mero de helados de cada sabor, dividirlo entre el
--n�mero total de helados y multiplicarlo por 100. El resultado debe ser un Decimal
--con un decimal. 

CREATE VIEW [V_Popularidad] AS
	SELECT
		COUNT(H.Sabor) AS [VecesPedido],
		TH.Sabor
		,(COUNT(H.Sabor)*100/6235) AS [�Popularidad?]
	FROM
		ICHelados AS H
	JOIN
		ICTiposHelado AS TH
	ON H.Sabor=TH.Sabor
	GROUP BY TH.Sabor

GO
--SELECT Sabor FROM ICHelados