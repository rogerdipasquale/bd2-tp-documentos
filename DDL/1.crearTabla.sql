CREATE TABLE DOCUMENTO (
	id int identity(1,1),
	titulo varchar(250) null,
	tipo char(1),
	version_actual char(8),
	vencimiento_actual datetime null,
	
	PRIMARY KEY(id)
)

CREATE TABLE RELACION (
	id int identity(1,1),
	id_documento_origen int,
	id_documento_destino int,
	tipo_relacion char(1),
	
	PRIMARY KEY (id),
	FOREIGN KEY (id_documento_origen) REFERENCES DOCUMENTO(id),
	FOREIGN KEY (id_documento_origen) REFERENCES DOCUMENTO(id)
	)
	
	CREATE TABLE PARTICIPANTE (
	id int identity(1,1), 
	id_usuario_ldap bigint,
	nombre varchar(255) null,
	
	PRIMARY KEY (id)
)

CREATE TABLE VERSION (
	id int identity(1,1), 
	id_documento int,
	version char(8),
	fecha_creacion datetime null,
	fecha_publicacion datetime null,
	borrador bit,
	link_documento varchar(255) null,
	referente int,
	revisor int null, 
	aprobador int null, 
	
	PRIMARY KEY (id),
	FOREIGN KEY (id_documento) REFERENCES DOCUMENTO(id),
	FOREIGN KEY (referente) REFERENCES PARTICIPANTE(id),
	FOREIGN KEY (revisor) REFERENCES PARTICIPANTE(id),
	FOREIGN KEY (aprobador) REFERENCES PARTICIPANTE(id),
)

CREATE TABLE AUDITORIA (
	id int identity(1,1),
	id_version int,
	referente int,
	revisor int,
	aprobador int,
		
	PRIMARY KEY (id),
	FOREIGN KEY (id_version) REFERENCES VERSION (id),
	FOREIGN KEY (referente) REFERENCES PARTICIPANTE(id),
	FOREIGN KEY (revisor) REFERENCES PARTICIPANTE(id),
	FOREIGN KEY (aprobador) REFERENCES PARTICIPANTE(id),
	)
