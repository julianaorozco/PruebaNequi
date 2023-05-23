--------------------------------------------------------------------------------------------------------------
-- Nota: cambiamos el esquema original de las tablas (por un pronombre 'XXXXX') debido a 
-- cuestiones de privacidad de la empresa donde trabajo actualmente
--------------------------------------------------------------------------------------------------------------
--
-- Construiremos el primer query que será la union de las tablas IPS y Departamentos para agregar 
-- las regiones de Colombia a la tabla de IPS
--
--------------------------------------------------------------------------------------------------------------
with ips as (
-- Tomamos las columnas que nos interesan, las convertimos al tipo de dato correcto y renombramos algunas.
-- Hacemos limpieza de datos como quitar tildes, pasar a minúsculas los campos y agrupar para quitar posibles duplicados.
select 
replace (translate(lower(departamento),'áéíóú.','aeiou'),'bogota dc','bogota') as departamento,
replace (translate(lower(municipio),'áéíóú.','aeiou'),'bogota dc','bogota') as municipio,
translate(lower(nombre_prestador),'áéíóú','aeiou') as nombre_prestador,
translate(lower(naturaleza),'áéíóú','aeiou') as naturaleza ,
case 
when num_nivel_atencion = '' then null
else cast(num_nivel_atencion as int) 
end num_nivel_atencion,
translate(lower(nom_sede_ips),'áéíóú','aeiou') as nom_sede_ips,
translate(lower(nom_grupo_capacidad),'áéíóú','aeiou') as nom_grupo_capacidad,
translate(lower(nom_descripcion_capacidad),'áéíóú','aeiou') as nom_descripcion_capacidad,
case 
when num_cantidad_capacidad_instalada = '' then null
else cast(num_cantidad_capacidad_instalada as int) 
end num_cantidad_capacidad_instalada
from XXXXX.ips 
group by 1,2,3,4,5,6,7,8,9
),
-- Hacemos la mimsma limpieza que en la tabla ips
departamentos as (
select 
translate(lower(region),'áéíóú','aeiou') as region,
replace (translate(lower(departamento),'áéíóú.','aeiou'),'bogota dc','bogota') as departamento,
replace (translate(lower(municipio),'áéíóú.','aeiou'),'bogota dc','bogota') as municipio
from XXXXX.departamentos
group by 1,2,3
),
-- Agregamos la region a las IPS haciendo join con los derpartamentos
ips_departamentos as (
select 
b.region,
b.departamento as departamento_ok,
a.departamento ,
a.municipio ,
a.nombre_prestador ,
a.naturaleza ,
a.num_nivel_atencion ,
a.nom_sede_ips ,
a.nom_grupo_capacidad ,
a.num_cantidad_capacidad_instalada 
from ips a
left join departamentos b 
on a.departamento = b.departamento
group by 1,2,3,4,5,6,7,8,9,10
),
-- Ahora el join lo hacemos con otro campo para captar los que en el join pasado quedaran nulos
ips_departamentos_2 as (
select 
b.region,
b.departamento as departamento_ok,
a.departamento ,
a.municipio ,
a.nombre_prestador ,
a.naturaleza ,
a.num_nivel_atencion ,
a.nom_sede_ips ,
a.nom_grupo_capacidad ,
a.num_cantidad_capacidad_instalada 
from ips_departamentos a
left join departamentos b 
on a.departamento = b.municipio 
where a.region is null
group by 1,2,3,4,5,6,7,8,9,10
),
-- Hacemos lo mismo que en el join anterior, los 3 joins se hacen porque identifiqué que a veces 
-- en el campo departamento estan los municipios o los departamentos.
ips_departamentos_3 as (
select 
b.region,
b.departamento as departamento_ok,
a.departamento ,
a.municipio ,
a.nombre_prestador ,
a.naturaleza ,
a.num_nivel_atencion ,
a.nom_sede_ips ,
a.nom_grupo_capacidad ,
a.num_cantidad_capacidad_instalada 
from ips_departamentos_2 a
left join departamentos b 
on a.municipio = b.municipio 
where a.region is null
group by 1,2,3,4,5,6,7,8,9,10
),
-- Unimos los 3 joins anteriores
uniones as (
select * from ips_departamentos where region is not null 
union all
select * from ips_departamentos_2 where region is not null 
union all
select * from ips_departamentos_3 where region is not null 
) 
select * from uniones
;
--------------------------------------------------------------------------------------------------------------
--
-- Construimos el segundo query haciendo la limpieza de la tabla de casos de covid en Colombia 
-- para poder relacionar estos datos con el query anterior en Tableau
--
--------------------------------------------------------------------------------------------------------------
-- Limpiamos la tabla de casos covid, corrigiendo los tipos de datos.
with casos_covid as (
select 
case 
	when fecha_reporte_web = '' then null 
	else cast(fecha_reporte_web as date)
end fecha_reporte_web,
id_de_caso,
fecha_de_notificaci_n::date as fecha_de_notificacion,
replace(
	replace(	
		replace(	
			replace(
				replace(
					translate(lower(departamento_nom), 'áéíóú', 'aeiou')
				, 'valle', 'valle del cauca')
			, 'norte santander', 'norte de santander'),
		'guajira', 'la guajira'),
	'sta marta d.e.', 'santa marta'),
'san andres', 'san andres y providencia')as departamento,
translate(lower(ciudad_municipio_nom),'áéíóú','aeiou') as ciudad_municipio,
edad,
lower(sexo) as sexo,
translate(lower(fuente_tipo_contagio),'áéíóú','aeiou') as fuente_tipo_contagio,
translate(lower(ubicacion),'áéíóú','aeiou') as ubicacion,
translate(lower(estado),'áéíóú','aeiou') as estado,
translate(lower(recuperado),'áéíóú','aeiou') as recuperado,
case 
	when fecha_inicio_sintomas = '' then null 
	else cast(fecha_inicio_sintomas as date)
end fecha_inicio_sintomas,
case 
	when fecha_diagnostico = '' then null 
	else cast(fecha_diagnostico as date)
end fecha_diagnostico,
case 
	when fecha_recuperado = '' then null 
	else cast(fecha_recuperado as date)
end fecha_recuperado,
translate(lower(tipo_recuperacion),'áéíóú','aeiou') as tipo_recuperacion,
translate(lower(nom_grupo_),'áéíóú','aeiou') as  nom_grupo,
case 
	when fecha_muerte = '' then null 
	else cast(fecha_muerte as date)
end fecha_muerte
from XXXXX.casos_covid 
group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17
)
select *
from casos_covid 
;
--------------------------------------------------------------------------------------------------------------