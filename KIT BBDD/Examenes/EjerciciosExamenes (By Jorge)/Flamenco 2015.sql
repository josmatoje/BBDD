--Ejercicio 1
--N�mero de veces que ha actuado cada cantaor en cada festival de la provincia de C�diz,
--incluyendo a los que no han actuado nunca


select CA.Nombre_Artistico, [Numero de veces] from F_Cantaores as CA
left join (select count( C.Nombre_Artistico) as [Numero de veces], C.Nombre_Artistico,  F.Provincia  from F_Cantaores as C
			inner join F_Festivales_Cantaores as FC
			on C.Codigo=FC.Cod_Cantaor
			inner join F_Festivales as F
			on FC.Cod_Festival=F.Cod 
			where F.Provincia ='CA'
			group by C.Nombre_Artistico, F.Provincia) as SUB

on CA.Nombre_Artistico=SUB.Nombre_Artistico



--Ejercicio 2
--Crea un nuevo palo llamado �Ton�.
--Haz que todos los cantaores que cantaban Bamberas o Peteneras canten Ton�s. No utilices
--los c�digos de los palos, sino sus nombres.

select * from F_Palos


--insert into F_Palos values('PI','Pixipilingui')

--insert into F_Palos_Cantaor 
--select Codigo, 'PI' from F_Cantaores as C
--inner join F_Palos_Cantaor as PC
--on C.Codigo=PC.Cod_cantaor
--inner join F_Palos as P
--on PC.Cod_Palo=P.Cod_Palo
--where P.Palo in ('Ton�')

insert into F_Palos values('TO','Ton�')

begin transaction prueba


insert into F_Palos_Cantaor 
select Codigo, 'TO' from F_Cantaores as C
inner join F_Palos_Cantaor as PC
on C.Codigo=PC.Cod_cantaor
inner join F_Palos as P
on PC.Cod_Palo=P.Cod_Palo
where P.Palo in ('Peteneras','Bamberas')

rollback

commit transaction prueba

select * from F_Palos_Cantaor





--Ejercicio 3
--N�mero de cantaores mayores de 30 a�os que han actuado cada a�o en cada pe�a. Se
--contar� la edad que ten�an en el a�o de la actuaci�n.



select count(*) as [Numero de cantaores], P.Nombre, year(A.Fecha) as [Anno] from F_Cantaores as C
inner join F_Actua as A
on C.Codigo=A.Cod_Cantaor
inner join F_Penhas as P
on A.Cod_Penha=P.Codigo
where 30>= (year(A.Fecha)-Anno)
group by P.Nombre, year(A.Fecha)



--Ejercicio 4
--Cantaores (nombre, apellidos y nombre art�stico) que hayan actuado m�s de dos veces en
--pe�as de la provincia de Sevilla y canten Fandangos o Buler�as. S�lo se incluyen las
--actuaciones directas en Pe�as, no los festivales.


select C.Nombre, C.Apellidos, C.Nombre_Artistico  from F_Cantaores as C
inner join F_Provincias as P
on C.Cod_Provincia=P.Cod_Provincia
inner join F_Penhas as PE
on P.Cod_Provincia = PE.Cod_provincia
inner join F_Palos_Cantaor as PC
on C.Codigo=PC.Cod_cantaor
inner join F_Palos as PA
on PC.Cod_Palo=PA.Palo
where PA.Palo in ('Buler�as','Fandangos de Huelva')





--Ejercicio 5
--N�mero de actuaciones que se han celebrado en cada pe�a, incluyendo actuaciones directas
--y en festivales. Incluye el nombre de la pe�a y la localidad.