--Inserción de documentos
INSERT INTO DOCUMENTO
    (titulo,tipo,version_actual,vencimiento)
VALUES
    ('Documento 1', 'a', 'borrador', '2020-05-22 00:00:00')

--Inserción de Participantes
INSERT INTO PARTICIPANTE
    (id,id_usuario_ldap,nombre)
VALUES(1, 1, 'Usuario Revisor')

INSERT INTO PARTICIPANTE
    (id,id_usuario_ldap,nombre)
VALUES(2, 2, 'Usuario Aprobador')

INSERT INTO PARTICIPANTE
    (id,id_usuario_ldap,nombre)
VALUES(3, 3, 'Usuario Creador')

--Inserción de Versión inicial del 
INSERT INTO VERSION
    (id_documento,version,fecha_creacion,borrador,referente)
SELECT d.id, d.version_actual, GETDATE(), 1, p.id
FROM DOCUMENTO d, PARTICIPANTE p
WHERE p.id = 3

--Ejecución de Stored Procedure Revisar Documento
DECLARE @id_d int
DECLARE @rev int
SET @id_d = 1
SET @rev = 1
EXEC revisarDocumento
@id_doc = @id_d,
@revisor = @rev

--Ejecución de Stored Procedure Aprobar Documento
DECLARE @id_d int
DECLARE @fec_p datetime
DECLARE @apr int
DECLARE @ver char(8)
SET @id_d = 3
SET @fec_p = GETDATE()
SET @apr = 2
SET @ver = 'ver3'
EXEC aprobarDocumento
@id_doc = @id_d,
@fecha_pub = @fec_p,
@aprobador = @apr,
@version = @ver