--Bolet�n 11.2
Use AirLeo
set dateformat 'ymd'
/*Ejercicio 1
Escribe un procedimiento que cancele un pasaje y las tarjetas de embarque asociadas.
Recibir� como par�metros el ID del pasaje.*/

go
Create Procedure CancelarPasaje @Id int as
Begin
Delete From AL_Tarjetas
where Numero_Pasaje=@Id
Delete From AL_Vuelos_Pasajes
where Numero_Pasaje=@Id
Delete From AL_Pasajes
where Numero=@Id
End
Go
Begin Transaction
Execute CancelarPasaje 5
Rollback
/*Ejercicio 2
Escribe un procedimiento almacenado que reciba como par�metro el ID de un pasajero y devuelva en un par�metro de salida el n�mero 
de vuelos diferentes que ha tomado ese pasajero.*/
go
alter Procedure DevuelveVuelos @Id char(9),
								@vuelos int OUTPUT as --Muy importante: El Id es una cadena!!
Begin
Select @vuelos=count(distinct VP.Codigo_Vuelo) From AL_Vuelos_Pasajes as VP
inner join AL_Pasajes as P
on VP.Numero_Pasaje=P.Numero
Where P.ID_Pasajero=@Id
return @vuelos
end
go


Declare @Vuelos int
Execute DevuelveVuelos 'A003',@Vuelos OUTPUT
print 'N�mero de Vuelos: '+ cast(@Vuelos as varchar(5))


/*Ejercicio 3
Escribe un procedimiento almacenado que reciba como par�metro el ID de un pasajero y dos fechas y nos devuelva en otro par�metro 
(de salida) el n�mero de horas que ese pasajero ha volado durante ese intervalo de fechas.*/
set dateformat ymd
go
alter Procedure VuelaPasajero @Id varchar(9),
							  @empieza smalldatetime,
							  @acaba smalldatetime,
							  @tiempo int OutPut AS --Horas
Begin

Select @tiempo=(sum(DATEDIFF(MINUTE,Salida,Llegada))/60)
From AL_Pasajeros as Ps
inner join AL_Pasajes as P
on Ps.ID=P.ID_Pasajero
inner join AL_Vuelos_Pasajes as VP
on P.Numero=VP.Numero_Pasaje
inner join Al_Vuelos as V
on VP.Codigo_Vuelo=V.Codigo
where ID_Pasajero=@Id and Salida>=@empieza and Llegada<=@acaba 

End
go
Declare @tiempo int
Execute VuelaPasajero 'A007','2012-01-14 14:05:00','2013-01-14 14:05:00',@tiempo OUTPUT
print 'Horas de vuelo: '+ cast(@tiempo as varchar(5))
go
/*Ejercicio 4
Escribe un procedimiento que reciba como par�metro todos los datos de un pasajero y un n�mero 
de vuelo y realice el siguiente proceso:
En primer lugar, comprobar� si existe el pasajero. Si no es as�, lo dar� de alta.
A continuaci�n comprobar� si el vuelo tiene plazas disponibles (hay que consultar 
la capacidad del avi�n) y en caso afirmativo 
crear� un nuevo pasaje para ese vuelo.*/

--Devolver�: -2 si crea el pasajero pero no hay plazas disponibles,
--			 -1 si el pasajero existe pero no hay plazas disponibles
--            0 si crea el pasajero y le asigna el vuelo
--            1 si el pasajero existe y le asigna el vuelo
alter procedure asignaVuelo @ID varchar(9)    --se ve mejor as�
           ,@Nombre varchar(20)
           ,@Apellidos varchar(50)
           ,@Direccion varchar(60)
           ,@Fecha_Nacimiento date
           ,@Nacionalidad varchar(30)
		   ,@Codigo_vuelo int
		   ,@Salida int output AS
	Begin
	--Creamos el nuevo n�mero para la tabla pasaje
	Declare @NumeroPasaje int
	--Primero miramos si el pasajero existe, y de no existir lo creamos
	If @Id not in (Select ID from AL_Pasajeros)
		Begin
		SET @Salida=-2 --Si el pasajero no existe le damos este valor, si hay 
						--plaza le sumaremos dos, sino, lo dejaremos tal como est�
		INSERT INTO [dbo].[AL_Pasajeros]
				   ([ID]
				   ,[Nombre]
				   ,[Apellidos]
				   ,[Direccion]
				   ,[Fecha_Nacimiento]
				   ,[Nacionalidad])
			 VALUES
				   (@ID
				   ,@Nombre
				   ,@Apellidos
				   ,@Direccion
				   ,@Fecha_Nacimiento
				   ,@Nacionalidad)
		End
	ELSE
		Begin
		SET @Salida=-1
		End
	--Si el numero de plazas ocupadas es menor que el n�mero de plazas totales del avi�n
	IF (Select count(Codigo_vuelo) from AL_Tarjetas
		where Codigo_Vuelo=@Codigo_vuelo
		)         
		< 
		(Select Asientos_x_Fila*Filas from AL_Aviones as A
			inner join AL_Vuelos as V
			on A.Matricula=V.Matricula_Avion
		 where V.Codigo=@Codigo_vuelo)

		Begin
			--Actualizamos el valor de la salida
			SET @Salida=@Salida+2
			Begin transaction
			Set @NumeroPasaje=(Select max(Numero) from AL_Pasajes)+1
			--insertamos
			INSERT INTO [dbo].[AL_Pasajes]
				([Numero]
				,[ID_Pasajero])
			VALUES
				(@NumeroPasaje
				,@ID)
			commit transaction
			INSERT INTO [dbo].[AL_Vuelos_Pasajes]
					   ([Codigo_Vuelo]
					   ,[Numero_Pasaje]
					   ,[Embarcado])
				 VALUES
					   (@Codigo_vuelo
					   ,@NumeroPasaje
					   ,'N')

		End
	--En caso de que no exsiten plazas, se devovler� el n�mero correspondiente, sin tener que hacer nada m�s
	End
go
Declare @Resultado int
Execute asignaVuelo 1500,'Tomas','yokse','Ercole','1999-11-19','Espa�a',23,@Resultado OUTPUT
print @Resultado
/*Ejercicio 5
Escribe un procedimiento almacenado que cancele un vuelo y reubique a sus pasajeros en otro. Se ocupar�n los asientos libres en el 
vuelo sustituto. Se comprobar� que ambos vuelos realicen el mismo recorrido. Se borrar�n todos los pasajes y las tarjetas de embarque 
y se generar�n nuevos pasajes. No se generar�n nuevas tarjetas de embarque. El vuelo a cancelar y el sustituto se pasar�n como par�metros. 
Si no se pasa el vuelo sustituto, se buscar� el primer vuelo inmediatamente posterior al cancelado que realice el mismo recorrido.*/
go
create Procedure ReubicaPasajeros @cancelar int, @sustituto int as 


go
/*Ejercicio 6
Escribe un procedimiento al que se pase como par�metros un c�digo de un avi�n y un momento (dato fecha-hora) y nos escriba un mensaje 
que indique d�nde se encontraba ese avi�n en ese momento. El mensaje puede ser "En vuelo entre los aeropuertos de NombreAeropuertoSalida 
y NombreaeropuertoLlegada� si el avi�n estaba volando en ese momento, o "En tierra en el aeropuerto NombreAeropuerto� si no est� volando. 
Para saber en qu� aeropuerto se encuentra el avi�n debemos consultar el �ltimo vuelo que realiz� antes del momento indicado.
Si se omite el segundo par�metro, se tomar� el momento actual.*/