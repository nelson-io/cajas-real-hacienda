## Introducción
Este proyecto tiene por finalidad sumarle valor a los datos disponibilizados en  [Cajas de la Real Hacienda](https://realhacienda.colmex.mx/) 
que reúnen la información de las Cajas Reales de la Real Hacienda para la América hispánica entre el siglo XVI y 1824.

El presente repositorio cuenta con los siguientes recursos:

# :open_file_folder:[data](https://github.com/nelson-io/cajas-real-hacienda/tree/master/data)
Contenedor de los los datos crudos disponibilizados por el sitio web indicado, estos se encuentran en un formato de consumo para personas y poseen la siguiente estructura
donde cada ruta refiere a una región y se encuentran múltiples documentos de extensión '.xls' integrando cada una:

* [alto_peru](https://github.com/nelson-io/cajas-real-hacienda/tree/master/data/alto_peru)
* [chile](https://github.com/nelson-io/cajas-real-hacienda/tree/master/data/chile)
* [ecuador](https://github.com/nelson-io/cajas-real-hacienda/tree/master/data/ecuador) 
* [nueva_espana](https://github.com/nelson-io/cajas-real-hacienda/tree/master/data/nueva_espana)
* [peru](https://github.com/nelson-io/cajas-real-hacienda/tree/master/data/peru)
* [rio_de_la_plata](https://github.com/nelson-io/cajas-real-hacienda/tree/master/data/rio_de_la_plata)

 


# :open_file_folder:[out](https://github.com/nelson-io/cajas-real-hacienda/tree/master/out)
Contiene al documento de salida del proyecto:
* **cajas_df.csv**: Datos consolidados de todos los registros crudos ya procesados y en un formato eficiente y apto para ser consumido por máquinas. <br />
Se encuentra conformada por las siguientes features:
  * *start_date*: Fecha de inicio del período para el registro asociado
  * *end_date*: Fecha de finalización del período para el registro asociado
  * *concepto*: Concepto al cual se le atribuyen entradas o salidas de dinero. Esencialmente consituido por servicios, bienes, tributos, etc.
  * *value*: valor asociado al registro, este se expresa en unidades monetarias
  * *class*: Variable dicotómica que toma los valores 'debe' y 'haber'. Originalmente asociada a 'CARGO' y 'DATA'. Ver [glosario](https://realhacienda.colmex.mx/index.php/glosario)
  * *region_1*: Variable categórica que identifica a qué región general corresponde la observación
  * *region_2*: Variable categórica que identifica a qué región específica corresponde la observación



# :open_file_folder:[scripts](https://github.com/nelson-io/cajas-real-hacienda/tree/master/scripts)
Contenedor de todo el código del proyecto. Se encuentra dividido en 2 archivos:
* **import_data.R**: Genera directorios temporales, descargando todos los zips disponibles en el [sitio web](https://realhacienda.colmex.mx/) y descomprimiéndolos de manera ordenada dentro de la carpeta [data](https://github.com/nelson-io/cajas-real-hacienda/tree/master/data).
* **clean_data.R**: Define múltiples funciones y permite iterar por cada uno de los documentos crudos, deconstruyendo el formato y reorganizándolos en un formato tabular amigable, lidia con asignaciones de fechas a través de imputaciones e identificación de patrones de construcción con *regex*.





