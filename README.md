# PruebaNequi
En este repositorio vamos a realizar la prueba técnica de Nequi para el puesto de ingeniera de datos.

IMPORTANTE:
Para la solución de esta prueba, utilicé las herramientas que me brinda la empresa en la que trabajo actualmente, por motivos de seguridad de la información no agregaré los archivos originales pero sí pantallazos del paso a paso de cómo realicé el proyecto y en este archivo explicaré cada imágen. 
El archivo SQL si está tal cual lo construí en DBeaver pero con el esquema de la tabla censurado (con el pronombre ‘XXXXX’).


Paso 1: Alcance del proyecto y captura de datos.

El alcance de este proyecto es poder llegar a construir un tablero de visualización con el cual podamos hacer análisis de datos a partir de los 3 conjuntos de datos seleccionados.

Los datos los vamos a capturar con python por medio de la API de la página datos.gov.co, luego de convertirlos en dataframe los vamos a cargar al repositorio de AWS en S3 y finalmente con estos archivos en S3, creamos 3 tablas en Amazon Redshift correspondientes a cada uno de los archivos.

Imagen_1:
	Repositorio donde tenemos los archivos necesarios para que todo corra exitosamente.
config.json es el archivo donde se encuentran las credenciales para hacer la conexión a Amazon Redshift y S3.
principal.py es el archivo principal donde está el código que trae los datos por medio de la API, carga a S3 y luego a Amazon Redshift.
redshift.py librería creada con algunas funciones para poder hacer los pasos correspondientes con Redshift.
s3.py librería creada para hacer la carga de los dataframe como csv a S3.

Imagen_2: 
	Archivo de configuración con las credenciales correspondientes.

Imagen_3:
	Archivo principal.py
	Parte del código donde se establece la ruta de los archivos y se crean unas variables necesarias para después.

Imagen_4:
	Archivo principal.py
	Parte del código donde traemos los datos por medio de la API y convertimos en dataframe cada archivo.

Imagen_5:
	Archivo principal.py
	Parte del código donde hacemos la carga de los archivos como csv a S3, luego hacemos la conexión a Amazon Redshift y finalmente creamos las tablas.

Imagen_6:
	Archivos csv cargados en S3.

Imagen_7:
	Ejecución exitosa en Jenkins del archivo ‘principal.py’, aquí se evidencia el paso a paso de la carga de los archivos a S3 y finalmente la creación de las tablas en Amazon Redshift.

Parte 2: Explorar y evaluar los datos, el EDA.
	
Después de tener las tablas en Redshift con ayuda de DBeaver exploramos los datos y comenzamos la construcción de dos queries haciendo limpieza de datos y transformación de los campos.

Imagen_8: 
	Limpieza y transformación de los campos de la tabla ‘casos_covid’, en la parte inferior vamos verificando que los campos queden como queremos al ir ejecutando la consulta sql.

Para la limpieza de datos tuve que cambiar el formato de los campos que eran fecha, también los que son numéricos a tipo entero y hacer limpieza de tildes y pasar los campos tipo texto a minúscula para facilitar los cruces con las otras tablas más adelante. Esto debido a que las tablas se crearon con todos los campos con tipo texto para facilitar la creación de las tablas.

Creamos 2 Queries que luego usaremos para la creación del tablero en Tableau.
El primer query tiene la información de los dos conjuntos de datos más pequeños, acá realizamos el cruce entre ambas tablas después de la limpieza y modificación de cada una.
El segundo query es la tabla de los casos de covid con los campos necesarios, limpios y con el tipo de dato correcto.
En ambos queries me aseguro que no queden duplicados por medio de la función ‘group by‘ de sql.

PruebaJuliana.sql es el archivo donde están los dos queries mencionados anteriormente pero con el esquema de las tablas censurado.
