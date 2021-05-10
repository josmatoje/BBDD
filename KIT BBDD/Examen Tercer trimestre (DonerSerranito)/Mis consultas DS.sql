USE DonerSerranito

--Tablas
SELECT * FROM DSAdicionales
SELECT * FROM DSClientes
SELECT * FROM DSComplementos
SELECT * FROM DSEstablecimientos
SELECT * FROM DSPedidos
SELECT * FROM DSPedidosComplementos
SELECT * FROM DSPlatos
SELECT * FROM DSPlatosAdicionales
SELECT * FROM DSPlatosSalsas
SELECT * FROM DSRepartidores
SELECT * FROM DSTiposCarne
SELECT * FROM DSTiposPan
SELECT * FROM DSTiposSalsa

GO
CREATE OR ALTER FUNCTION FnTotalIngresadoParamentros (@FechaInicio AS datetime, @FechaFin AS datetime) RETURNS TABLE AS
RETURN (SELECT E.Denominacion, E.Ciudad, SUM(P.Importe) AS [Total Ingresado] FROM DSPedidos AS P
	INNER JOIN DSEstablecimientos AS E ON P.IDEstablecimiento=E.ID
	WHERE P.Enviado BETWEEN @FechaInicio AND @FechaFin
	GROUP BY E.Denominacion, E.Ciudad)
GO

DECLARE @INI DATE = DATEFROMPARTS(2018,1,1)
DECLARE @FIN DATE = DATEFROMPARTS(2018,1,31)
SELECT * FROM FnTotalIngresadoParamentros (@INI, @FIN)
GO

SELECT * FROM DSPedidos
WHERE Enviado IS NULL

--Contar Pedidos por combinaciones de pan y carne incluidas las que nunca se han pedido (Luis)
SELECT DP.Pan, DP.Carne, COUNT(P.IDPedido) AS Pedidos FROM DSPlatos AS P
RIGHT JOIN(
	SELECT * FROM DSTiposCarne
	CROSS JOIN DSTiposPan) AS DP 
ON P.TipoCarne = DP.Carne AND P.TipoPan = DP.Pan
GROUP BY DP.Pan, DP.Carne
GO
SELECT * FROM DSPlatos

--Crear procedimiento para insertar un pedido dandole los platos como parametros en la base de datos DonerSerranito

--Nombre: InsertarPedido
--Descripción: Genera un pedido al insertar el Id de un plato
--Entrada:
--Salida:

select * from DSPedidos
select * from DSPlatos


GO

--Carne mas vendida por ciudad