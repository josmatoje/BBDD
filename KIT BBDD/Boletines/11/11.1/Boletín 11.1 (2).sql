use Northwind
go

/*
1. Deseamos incluir un producto en la tabla Products llamado "Cruzcampo botell�n� pero no estamos seguros si
se ha insertado o no.
El precio son 2,40, el proveedor es el 16, la categor�a 1 y la cantidad por unidad son
"Pack de seis botellines� El resto de columnas se dejar�n a NULL.
Escribe un script que compruebe si existe un producto con ese nombre.
En caso afirmativo, actualizar� el precio y en caso negativo insertarlo.
*/
BEGIN TRANSACTION
BEGIN
IF EXISTS (SELECT Products.ProductName FROM Products WHERE ProductName='Cruzcampo botell�n')
	UPDATE Products
	SET UnitPrice = 2.40
	WHERE ProductName='Cruzcampo botell�n'
ELSE
	INSERT INTO Products
	VALUES('Cruzcampo botell�n',16,1,'Pack 6 botellines',2.40,NULL,NULL,NULL,0)
END
ROLLBACK
/*
2. Comprueba si existe una tabla llamada ProductSales.
Esta tabla ha de tener de cada producto el ID, el Nombre, el Precio unitario,
el n�mero total de unidades vendidas y el total de dinero facturado con ese producto. Si no existe, cr�ala.
*/
BEGIN TRANSACTION
BEGIN
IF NOT EXISTS (SELECT * FROM sysobjects WHERE NAME='Product Sales')
	CREATE TABLE [Product Sales](
	ID INT NOT NULL
	,ProductName NVARCHAR(40) NOT NULL
	,UnitPrice MONEY
	,[Unidades Vendidas] INT
	,[Total Facturado] MONEY
	,CONSTRAINT PK_PRODUCTSALES PRIMARY KEY (ID)
	,CONSTRAINT FK_IDPRODUCTS FOREIGN KEY (ID) REFERENCES PRODUCTS(PRODUCTID) ON UPDATE CASCADE ON DELETE NO ACTION
	)
	INSERT INTO [Product Sales]
	SELECT OD.ProductID,P.ProductName, P.UnitPrice, SUM(OD.Quantity) AS [UNIDADES VENDIDAS], SUM(OD.Quantity*OD.UnitPrice) AS [TOTAL FACTURADO] FROM Products AS P
	INNER JOIN [Order Details] AS OD ON OD.ProductID = P.ProductID
	INNER JOIN Orders AS O ON O.OrderID = OD.OrderID
	--WHERE
	GROUP BY OD.ProductID, P.ProductName, P.UnitPrice

END
ROLLBACK
/*
3. Comprueba si existe una tabla llamada ShipShip. Esta tabla ha de tener de cada Transportista el ID, el Nombre de la compa��a, el n�mero total de env�os que ha efectuado y el n�mero de pa�ses diferentes a los que ha llevado cosas. Si no existe, cr�ala.
*/
BEGIN TRANSACTION
IF NOT EXISTS (SELECT * FROM sysobjects WHERE NAME='ShipShip')
BEGIN
	CREATE TABLE ShipShip(
	ID INT PRIMARY KEY CONSTRAINT FK_IDSHIPPERS REFERENCES Shippers(ShipperID) ON UPDATE CASCADE ON DELETE NO ACTION
	,CompanyName NVARCHAR(40)
	,Env�os INT
	,PA�SES INT
	)
	INSERT INTO ShipShip
	SELECT S.ShipperID, S.CompanyName, COUNT(O.ShipVia) AS [N�MERO TOTAL DE ENV�OS], (COUNT(DISTINCT O.ShipCountry)) AS [N�MERO PA�SES DIFERENTES] FROM Shippers AS S
	INNER JOIN Orders AS O ON O.ShipVia = S.ShipperID
	--WHERE
	GROUP BY S.ShipperID, S.CompanyName
END
ROLLBACK
COMMIT
/*
4. Comprueba si existe una tabla llamada EmployeeSales. Esta tabla ha de tener de cada empleado su ID, el Nombre completo, el n�mero de ventas totales que ha realizado, el n�mero de clientes diferentes a los que ha vendido y el total de dinero facturado. Si no existe, cr�ala
*/
IF NOT EXISTS(SELECT * FROM sysobjects WHERE NAME='EmployeeSales')
	BEGIN
	CREATE TABLE EmployeeSales(
		ID INT PRIMARY KEY CONSTRAINT FK_IDEMPLOYEES REFERENCES EMPLOYEES(EMPLOYEEID) ON UPDATE CASCADE ON DELETE NO ACTION
		,LastName NVARCHAR(20)
		,FirstName NVARCHAR(10)
		,Ventas INT
		,Clientes INT
		,Dinero MONEY
	)
	INSERT INTO EmployeeSales
	SELECT E.EmployeeID, E.LastName, E.FirstName, COUNT(O.EmployeeID) AS [N�MERO DE VENTAS], COUNT(DISTINCT O.CustomerID) [N�MERO DE CLIENTES DIFERENTES], SUM(OD.Quantity*OD.UnitPrice) AS [TOTAL FACTURADO] FROM Employees AS E
	INNER JOIN Orders AS O ON O.EmployeeID = E.EmployeeID
	INNER JOIN [Order Details] AS OD ON OD.OrderID = O.OrderID
	--WHERE
	GROUP BY E.EmployeeID, E.LastName, E.FirstName
	END

/*5. Entre los a�os 96 y 97 hay productos que han aumentado sus ventas y otros que las han disminuido. Queremos cambiar el precio unitario seg�n la siguiente tabla*/
 /*INCREMENTO DE VENTAS ---INCREMENTO DE PRECIO*/
 --  NEGATIVO			--- -10%
 --	 entre 0 y 10%		---	No varia
 --  entre 10% y 50%    ---	+5%
 --	 Mayor del 50%		--- 10% co un un maximo de 2.25
 
 -- Acutualizamos en la tabla productos
 UPDATE Products
 SET unitPrice = 
 CASE 
    -- cuando las ventas del 97 son negativas 
	when ventas9697 < 0                   
		then (UnitPrice-(UnitPrice*0.10))   -- entonces actualizamos su precio en un 10% menos 

	-- cuando las ventas del 97 son entre el 0 y 10%
	when ventas9697 >= 0 and ventas9697<(Vendido96*0.10) 
		then (UnitPrice = UnitPrice)	    -- entonces actualizamos su precio en un 10% menos 
																			
	when ventas9697>=(Vendido96*0.10) and ventas9697<(vendido96*0.50) 
	then (UnitPrice*1.05)
	
	when ventas9697>=(Vendido96*0.50) then 
		Case
			when (UnitPrice*0.10)<2.25 then
			(UnitPrice+ (UnitPrice*0.10))
			else 
			(UnitPrice+ 2.25)
			end
																
			end
	from ventasEntre9697
	where Products.ProductID=VentasEntre9697.ProductID		--FALTA PONER PARA LOS VALORES 