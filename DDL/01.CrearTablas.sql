CREATE TABLE VERSION_TYPE /*tabla creada para tener los 3 tipos de versiones separadas y no repetir informacion*/
(
	id int IDENTITY(1,1) PRIMARY KEY,
	descripcion char(8) NOT NULL
)

CREATE TABLE DOCUMENTO
(
	id int IDENTITY(1,1) PRIMARY KEY,
	titulo varchar(250),
	tipo char(1) NOT NULL,
	version_actual int default 1 NOT NULL,
	FOREIGN KEY(version_actual) REFERENCES VERSION_TYPE(id),
	vencimiento datetime
)

CREATE TABLE RELACION
(
	id int IDENTITY(1,1) PRIMARY KEY,
	id_documento_origen int NOT NULL,
	id_documento_destino int NOT NULL,
	tipo_relacion char(1) NOT NULL,
	FOREIGN KEY(id_documento_origen) REFERENCES DOCUMENTO (id),
	FOREIGN KEY(id_documento_destino) REFERENCES DOCUMENTO (id)
)

CREATE TABLE PARTICIPANTE
(
	id int IDENTITY(1,1) PRIMARY KEY,
	id_usuario_ldap bigint UNIQUE NOT NULL,
	nombre varchar(255)
)

CREATE TABLE VRSION
(
	id int IDENTITY(1,1) PRIMARY KEY,
	id_documento int NOT NULL,
	version_type int default 1 NOT NULL,
	fecha_creacion datetime,
	fecha_publicacion datetime,
	borrador bit default 1 NOT NULL,
	link_documento varchar(255),
	referente int NOT NULL,
	revisor int,
	aprobador int,
	FOREIGN KEY(version_type) REFERENCES VERSION_TYPE (id),
	FOREIGN KEY(id_documento) REFERENCES DOCUMENTO (id),
	FOREIGN KEY(referente) REFERENCES PARTICIPANTE (id),
	FOREIGN KEY(revisor) REFERENCES PARTICIPANTE (id),
	FOREIGN KEY(aprobador) REFERENCES PARTICIPANTE (id)
)