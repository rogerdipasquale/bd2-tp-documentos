--a)Creacion de Tablas
CREATE TABLE DOCUMENTO
(
    id INT IDENTITY PRIMARY KEY,
    titulo varchar(50) NULL,
    tipo char(1),
    version_actual char(8),
    vencimiento datetime NULL
)


CREATE TABLE PARTICIPANTE
(
    id int PRIMARY KEY,
    id_usuario_ldap bigint,
    nombre varchar(255) NULL
)


CREATE TABLE RELACION
(
    id int IDENTITY PRIMARY KEY,
    id_documento_origen int,
    id_documento_destino int,
    tipo_relacion char(1),
    FOREIGN KEY (id_documento_origen) REFERENCES DOCUMENTO(id),
    FOREIGN KEY (id_documento_destino) REFERENCES DOCUMENTO(id)
)


CREATE TABLE VERSION
(
    id int IDENTITY PRIMARY KEY,
    id_documento int,
    version char(8),
    fecha_creacion datetime NULL,
    fecha_publicacion datetime NULL,
    borrador bit,
    link_documento varchar(255),
    referente int NULL,
    revisor int NULL,
    aprobador int NULL,
    FOREIGN KEY (referente) REFERENCES PARTICIPANTE(id),
    FOREIGN KEY (revisor) REFERENCES PARTICIPANTE(id),
    FOREIGN KEY (aprobador) REFERENCES PARTICIPANTE(id),
    FOREIGN KEY (id_documento) REFERENCES DOCUMENTO (id)
)

--Tabla de auditoria sobre la tabla version
CREATE TABLE version_auditoria
(
    id int,
    id_documento int,
    referente int,
    revisor int,
    aprobador int
)

--Tabla de futuros vencimientos
CREATE TABLE futuros_vencimientos
(
    orden INT IDENTITY(1,1),
    id_documento INT,
    vencimiento datetime
)