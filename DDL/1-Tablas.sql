--a) generacion de tablas

create table documento 
(
	id int identity primary key,
	titulo varchar (250) NULL,
	tipo char (1),
	version_actual char (8),
	vencimiento datetime NULL
)

create table participante
(
	id int primary key,
	id_usuario_ldap bigint,
	nombre varchar (255) NULL
)

create table relacion
(
	id int identity primary key,
	id_documento_origen int,
	id_documento_destino int,
	tipo_relacion char(1),
	foreign key (id_documento_origen) references documento (id),
	foreign key (id_documento_destino) references documento (id)
)

create table version
(
	id int identity primary key,
	id_documento int,
	version char (8),
	fecha_creacion datetime NULL,
	fecha_publicacion datetime NULL,
	borrador bit,
	link_documento varchar (255) NULL,
	referente int,
	revisor int NULL,
	aprobador int NULL,
	foreign key (id_documento) references documento (id),
	foreign key (referente) references participante (id),
	foreign key (revisor) references participante (id),
	foreign key (aprobador) references participante (id)
)



--e) eliminacion logica

alter table documento
	add eliminado bit not null default 0

alter table participante
	add eliminado bit not null default 0

alter table version
	add eliminado bit not null default 0

alter table relacion
	add eliminado bit not null default 0


--h) tabla de vencimientos

create table futVencimientos
(
	orden int identity (1,1),
	id_documento int,
	vencimiento datetime
)

------------------------------

create table verAuditoria
(
	id int,
	id_documento int, 
	version char (8), 
	referente int, 
	revisor int, 
	aprobador int, 
	usuario varchar (255), 
	fechaUpdate datetime
)