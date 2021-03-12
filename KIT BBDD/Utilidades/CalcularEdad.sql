-- �Como calcular una edad?

-- �Es buena idea tener una columna "edad"?
-- No

--Primera aproximaci�n
Set Dateformat 'YMD'
-- A�o actual - A�o de nacimiento
Print Year(Current_Timestamp)-Year ('2001-1-13')

--Segunda aproximaci�n
Set Dateformat 'YMD'
Print Year(Current_Timestamp -'2001-10-13')-1900

-- Si la fecha no es SmallDateTime
Set Dateformat 'YMD'
Print Year(Current_Timestamp -CAST('2001-1-13' AS SmallDateTime))-1900

--Con datediff			****DATEDIFF(datepart, satartdate, enddate)****
Print DATEDIFF(YEAR,'2001-1-13',Current_Timestamp)