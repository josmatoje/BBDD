--Ejercicio 3 (3 points)
--A algunos clientes les gusta repetir sus pedidos. Crea un procedimiento al que se
--pase el ID de un cliente, el nombre de un establecimiento y una fecha/hora y busque 
--el último pedido de ese cliente anterior a esa fecha/hora (puede haber un margen de error)
--y duplique el pedido con los mismos serranitos, salsas y complementos, en el mismo establecimiento,
--pero asignándole la fecha/hora actual. La fecha de envío serán 20' más de la hora actual y deja el repartidor a NULL.
GO
CREATE OR ALTER PROCEDURE [RepetirPedido] (@IDCliente int, @NombreEstablecimiento varchar (30), @Fecha smalldatetime)
AS
	BEGIN 

		DECLARE @IDPedido smallint
		DECLARE @IDEstablecimiento smallint
		DECLARE @IDPedidoIntroducido smallint
		DECLARE @ContenedorID AS TABLE 
		(
			ID smallint
		)

		SELECT @IDPedido = P.ID, @IDEstablecimiento = P.IDEstablecimiento FROM DSPedidos AS P 
		INNER JOIN DSEstablecimientos AS E ON P.IDEstablecimiento = E.ID
		WHERE P.IDCliente = @IDCliente AND E.Denominacion = @NombreEstablecimiento AND P.Recibido IN
																	(
																		SELECT MAX (Recibido) FROM DSPedidos AS P 
																		INNER JOIN DSEstablecimientos AS E ON P.IDEstablecimiento = E.ID
																		WHERE P.IDCliente = @IDCliente AND E.Denominacion = @NombreEstablecimiento AND P.Recibido <= @Fecha
																	)												
		INSERT DSPedidos 
		SELECT GETDATE(), DATEADD(MINUTE, 20, GETDATE()), @IDCliente, @IDEstablecimiento, NULL, Importe FROM DSPedidos WHERE ID = @IDPedido
		
		SET @IDPedidoIntroducido = @@IDENTITY

		INSERT DSPedidosComplementos
		SELECT @IDPedidoIntroducido, IDComplemento, Cantidad FROM DSPedidosComplementos WHERE IDPedido = @IDPedido

		INSERT DSPlatos
		OUTPUT INSERTED.ID INTO @ContenedorID
		SELECT @IDPedidoIntroducido, TipoPan, TipoCarne FROM DSPlatos WHERE IDPedido = @IDPedido

		INSERT DSPlatosAdicionales
		SELECT PL1.ID, PA.IDAdicional FROM DSPlatos AS PL 
		INNER JOIN DSPlatos AS PL1 ON PL.TipoCarne = PL1.TipoCarne AND PL.TipoPan = PL1.TipoPan
		INNER JOIN DSPlatosAdicionales AS PA ON PL.ID = PA.IDPlato
		WHERE PL.IDPedido = @IDPedido AND PL1.IDPedido = @IDPedidoIntroducido

		INSERT DSPlatosSalsas
		SELECT PL1.ID, PS.IDSalsa FROM DSPlatos AS PL 
		INNER JOIN DSPlatos AS PL1 ON PL.TipoCarne = PL1.TipoCarne AND PL.TipoPan = PL1.TipoPan
		INNER JOIN DSPlatosSalsas AS PS ON PL.ID = PS.IDPlato
		WHERE PL.IDPedido = @IDPedido AND PL1.IDPedido = @IDPedidoIntroducido

	END
GO
SELECT * FROM DSPlatos