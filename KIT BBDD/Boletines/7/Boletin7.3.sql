SELECT * FROM Production.Product

--1. Nombre, numero de producto, precio y color de los productos de color rojo o amarillo cuyo precio est� comprendido entre 50 y 500.
SELECT Name, ProductNumber, ListPrice, Color FROM Production.Product WHERE (Color in ('Red', 'Yellow')) AND (ListPrice BETWEEN 50 AND 500)

--2. Nombre, n�mero de producto, precio de coste,  precio de venta, margen de beneficios total y margen de beneficios en % del precio de venta de los productos de categor�as inferiores a 16.
SELECT Name, ProductNumber, StandardCost, ListPrice, (ListPrice - StandardCost) AS Beneficios, ((ListPrice - StandardCost)/(StandardCost/100)) AS [Beneficios(%)]  FROM Production.Product WHERE ProductModelId < 16

--3. Empleados cuyo nombre o apellidos contenga la letra "r". Los empleados son los que tienen el valor "EM" en la columna PersonType de la tabla Person.
SELECT FirstName, LastName, PersonType FROM Person.Person WHERE LastName like '%r%' AND PersonType = 'EM'

--4. LoginID, nationalIDNumber, edad y puesto de trabajo (jobTitle) de los empleados (tabla Employees) de sexo femenino que tengan m�s de cinco a�os de antig�edad.
SELECT * FROM HumanResources.Employee

SELECT LoginID, NationalIDNumber, ((YEAR(CURRENT_TIMESTAMP-CAST(BirthDate AS DATETIME))-1900)) AS Edad, ((YEAR(CURRENT_TIMESTAMP-CAST(HireDate AS DATETIME))-1900)) AS Antig�edad, JobTitle, Gender
	FROM HumanResources.Employee 
	WHERE Gender = 'F' AND ((YEAR(CURRENT_TIMESTAMP-CAST(HireDate AS DATETIME))-1900)) > 5

--5. Ciudades correspondientes a los estados 11, 14, 35 o 70, sin repetir. Usar la tabla Person.Address.
SELECT Distinct City, StateProvinceID
	FROM Person.Address
	WHERE StateProvinceID IN ('11', '14', '35', '70')
	ORDER BY StateProvinceID DESC, City DESC
