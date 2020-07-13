cambios comiteados


# bd2-tp-documentos
# BD II - Trabajo Práctico de Versionado de Documentos - 2020

Este repositorio contiene la estructura de directorios base para el trabajo práctico.

## Esquema de Base a crear

Se pueden agregar objetos al esquema, pero lo básico que debe contener es:

![Esquema](/esquema.png)

## Script de Instalación ##

Para poder instalar su desarrollo propio en la estructura, pueden utilizar instalar.bat, que va a generar una nueva base de datos, ejecutará en orden los scripts de la carpeta DDL y luego los de la carpeta Desarrollo.

Modo de uso:

instalar [carpetaProyecto] [server] [usuario] [password] [baseDeDatos]

Se intentará conectar a una instancia [server]\sqlexpress , suponiendo que estamos trabajando con un SQL Express. Si es distinta, pueden cambiar el .bat a su conveniencia.


