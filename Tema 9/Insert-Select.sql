USE Northwind

--Todos los que han comprado "Outback Lager" han comprado cinco años después la misma cantidad de Mecca Cola al mismo vendedor

SELECT * FROM [Order Details]

BEGIN TRANSACTION

INSERT INTO Orders(CustomerID,EmployeeID,OrderDate)
    SELECT O.CustomerID,O.EmployeeID,(DATEADD(YEAR,5,O.OrderDate)) AS [Anno] FROM Orders AS O
    INNER JOIN [Order Details] AS OD ON O.OrderID=OD.OrderID
    WHERE OD.ProductID=70

    INSERT INTO [Order Details](OrderID,ProductID,UnitPrice,Quantity)

    SELECT C1.OrderID,C2.ProductID,C2.UnitPrice, C1.Quantity FROM (
	SELECT MeccaCola.OrderID, OD.Quantity FROM Orders AS OutbackComprado
        INNER JOIN Orders as MeccaCola ON OutbackComprado.CustomerID=MeccaCola.CustomerID AND
                                          OutbackComprado.EmployeeID=MeccaCola.EmployeeID AND
                                          MeccaCola.OrderDate=DATEADD(YEAR,5,OutbackComprado.OrderDate)
        INNER JOIN [Order Details] AS OD ON OutbackComprado.OrderID=OD.OrderID
        WHERE OD.ProductID=70) AS C1
		CROSS JOIN (
		SELECT TOP(1) ProductID, UnitPrice FROM [Order Details] --Salen varios precios por no coger el mismo producto, escogemos uno
			WHERE ProductID=47 --Es otro producto debido a no haber hecho la insercion previa
		) AS C2

		
		SELECT * FROM Orders
		SELECT * FROM [Order Details]
ROLLBACK

		INSERT INTO Products
		VALUES('Mecca Cola',1,1,'6 x 75 cl',7.35,14,0,0,0)