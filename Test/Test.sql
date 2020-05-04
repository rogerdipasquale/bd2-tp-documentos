EXEC SP_CREAR_DOCUMENTO 'Documento de prueba 1', 'P', 'HTTPS://direprueba.com/prueba1', 2;
EXEC SP_CREAR_DOCUMENTO 'Documento de prueba 2', 'P', 'HTTPS://direprueba.com/prueba2', 2;
EXEC SP_CREAR_DOCUMENTO 'Documento de prueba 3', 'P', 'HTTPS://direprueba.com/prueba3', 2;
EXEC SP_CREAR_DOCUMENTO 'Documento de prueba 4', 'P', 'HTTPS://direprueba.com/prueba4', 2;
EXEC SP_CREAR_DOCUMENTO 'Documento de prueba 5', 'P', 'HTTPS://direprueba.com/prueba5', 2;
EXEC SP_CREAR_DOCUMENTO 'Documento de prueba 6', 'P', 'HTTPS://direprueba.com/prueba6', 2;
EXEC SP_CREAR_DOCUMENTO 'Documento de prueba 7', 'P', 'HTTPS://direprueba.com/prueba7', 2;
EXEC SP_CREAR_DOCUMENTO 'Documento de prueba 8', 'P', 'HTTPS://direprueba.com/prueba8', 2;
EXEC SP_CREAR_DOCUMENTO 'Documento de prueba 9', 'P', 'HTTPS://direprueba.com/prueba9', 2;
EXEC SP_CREAR_DOCUMENTO 'Documento de prueba 10', 'P', 'HTTPS://direprueba.com/prueba10', 2;


INSERT INTO PARTICIPANTE(id_usuario_ldap, nombre) VALUES (456456456, 'Pedro Lopez');
INSERT INTO PARTICIPANTE(id_usuario_ldap, nombre) VALUES (324234234, 'Juan Perez');
INSERT INTO PARTICIPANTE(id_usuario_ldap, nombre) VALUES (67657567, 'Facundo Cersosimo');
INSERT INTO PARTICIPANTE(id_usuario_ldap, nombre) VALUES (345345435, 'Francisco Alonzo');
INSERT INTO PARTICIPANTE(id_usuario_ldap, nombre) VALUES (345345435, 'Juan Fa');


EXEC SP_CAMBIAR_VERSION 1 '1.3', 3;
EXEC SP_CAMBIAR_VERSION 1, '135', 3;
EXEC SP_CAMBIAR_VERSION 2, '1.3', 3;
EXEC SP_CAMBIAR_VERSION 2, '1.7', 3;
EXEC SP_CAMBIAR_VERSION 3, '1.8', 3;
EXEC SP_CAMBIAR_VERSION 4, '1.2', 3;
EXEC SP_CAMBIAR_VERSION 5, '1.9', 3;
EXEC SP_CAMBIAR_VERSION 7, '1.1', 3;
EXEC SP_CAMBIAR_VERSION 8, '1.7', 3;


EXEC SP_ELIMINAR_PARTICIPANTE 1;
EXEC SP_ELIMINAR_PARTICIPANTE 2;
EXEC SP_ELIMINAR_PARTICIPANTE 3;

EXEC SP_CREAR_RELACION 1, 3, 'P';
EXEC SP_CREAR_RELACION 4, 5, 'P';
EXEC SP_CREAR_RELACION 2, 5, 'H';
EXEC SP_CREAR_RELACION 9, 6, 'P';
EXEC SP_CREAR_RELACION 3, 5, 'P';
