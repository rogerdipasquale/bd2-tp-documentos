/*Inicializacion de version_type*/

INSERT INTO VERSION_TYPE ( descripcion ) VALUES ('Borrador');
INSERT INTO VERSION_TYPE ( descripcion ) VALUES ('Revisado');
INSERT INTO VERSION_TYPE ( descripcion ) VALUES ('Aprobado');

/*Inicializacion de participante, sin un id de participante valido spCrearDocumento no funciona*/

INSERT INTO PARTICIPANTE ( id_usuario_ldap, nombre ) VALUES (2345,'Carlos');
INSERT INTO PARTICIPANTE ( id_usuario_ldap, nombre ) VALUES (1258,'Manuel');
INSERT INTO PARTICIPANTE ( id_usuario_ldap, nombre ) VALUES (836, 'Martin');
INSERT INTO PARTICIPANTE ( id_usuario_ldap, nombre ) VALUES (6910,'Lucas');
INSERT INTO PARTICIPANTE ( id_usuario_ldap, nombre ) VALUES (3829,'Joaquin');
INSERT INTO PARTICIPANTE ( id_usuario_ldap, nombre ) VALUES (521,'Ramiro');
INSERT INTO PARTICIPANTE ( id_usuario_ldap, nombre ) VALUES (4672,'Juan');

/*Inicializacion DOCUMENTO,VRSION y FUTUROS VENCIMIENTOS*/

INSERT INTO DOCUMENTO (titulo, tipo, version_actual, vencimiento)
	VALUES ( 'Ejemplo1', 'P', 3, DATEADD(DD, -5, CURRENT_TIMESTAMP))

INSERT INTO VRSION (id_documento,version_type, fecha_creacion, referente, revisor, aprobador)
	VALUES (1, 3,  DATEADD(MM, -6, CURRENT_TIMESTAMP), 3, 7, 1)
INSERT INTO FUTUROS_VENCIMIENTOS (orden_id, id_documento, vencimiento)
	VALUES (1,1, DATEADD(DD, -5, CURRENT_TIMESTAMP))

INSERT INTO DOCUMENTO (titulo, tipo, version_actual, vencimiento)
	VALUES ( 'Ejemplo2', 'P', 3, DATEADD(DD, -10, CURRENT_TIMESTAMP))

INSERT INTO VRSION (id_documento,version_type, fecha_creacion, referente, revisor, aprobador)
	VALUES (2, 3,  DATEADD(MM, -6, CURRENT_TIMESTAMP), 1, 5, 7)
INSERT INTO FUTUROS_VENCIMIENTOS (orden_id, id_documento, vencimiento)
	VALUES (1,2, DATEADD(DD, -10, CURRENT_TIMESTAMP))


/*Creacion de Relacion entre ambos documentos*/

EXEC spRelacion_crearRelacion 1,2, 'P'