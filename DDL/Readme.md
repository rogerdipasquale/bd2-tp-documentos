# Archivos DDL #

Esta carpeta debe contener los archivos de creación de objetos de base de datos a utilizar para el práctico.

Se sugiere que los archivos de esta carpeta tengan una única versión y ser incrementales. Es decir, si el archivo 02.crearTablaServicio.sql tiene la instrucción de crear esta tabla, y, en un momento del desarrollo del proyecto se necesita modificar esa tabla, se creará un archivo con numeración correlativa al último existente (por ejemplo, t), y t.modificarTablaServicio.sql ejecutará una actualización de tal tabla, con el correspondiente comando alter table.

¿Por qué?

Si el desarrollo estaba en otros ambientes hasta un cierto punto, y contenían datos, o incluso soportan al ambiente productivo, no se podrán crear las tablas desde cero, sino que se tendrá que trabajar incrementalmente. 
Se puede mantener una estructura que conozca en cada ambiente hasta qué número de archivo se ejecutó anteriormente, para realizar el incremento debidamente.

