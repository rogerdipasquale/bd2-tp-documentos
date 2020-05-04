--Inserción de documentos
INSERT INTO DOCUMENTO
    (titulo,tipo,version_actual,vencimiento)
VALUES
    ('Documento 1', 'a', 'borrador', '2020-05-22 00:00:00')

SELECT *
FROM DOCUMENTO

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

SELECT *
FROM PARTICIPANTE

--Inserción de Versión inicial de documento
INSERT INTO VERSION
    (id_documento,version,fecha_creacion,borrador,referente)
SELECT d.id, d.version_actual, GETDATE(), 1, p.id
FROM DOCUMENTO d, PARTICIPANTE p
WHERE p.id = 3

SELECT *
FROM DOCUMENTO

--Ejecución de Stored Procedure Revisar Documento
DECLARE @id_d int
DECLARE @rev int
SET @id_d = 1
SET @rev = 1
EXEC revisarDocumento
@id_doc = @id_d,
@revisor = @rev

DECLARE @id_d int
DECLARE @rev int
SET @id_d = 4
SET @rev = 2
EXEC revisarDocumento
@id_doc = @id_d,
@revisor = @rev

SELECT *
FROM VERSION

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

DECLARE @id_d int
DECLARE @fec_p datetime
DECLARE @apr int
DECLARE @ver char(8)
SET @id_d = 4
SET @fec_p = GETDATE()
SET @apr = 3
SET @ver = 'final'
EXEC aprobarDocumento
@id_doc = @id_d,
@fecha_pub = @fec_p,
@aprobador = @apr,
@version = @ver

SELECT *
FROM VERSION

--Ejecucion de Stored Procedure Crear Documento
DECLARE @tit varchar(250)
DECLARE @tip char(1)
DECLARE @refe int
SET @tit = 'Ejercicio c'
SET @tip = 'c'
SET @refe = 3
EXEC crear_documento
@titulo = @tit,
@tipo = @tip,
@referente = @refe

DECLARE @tit varchar(250)
DECLARE @tip char(1)
DECLARE @refe int
SET @tit = 'Doc Prueba'
SET @tip = 'c'
SET @refe = 1
EXEC crear_documento
@titulo = @tit,
@tipo = @tip,
@referente = @refe

DECLARE @tit varchar(250)
DECLARE @tip char(1)
DECLARE @refe int
SET @tit = 'Doc Prueba2'
SET @tip = 'a'
SET @refe = 3
EXEC crear_documento
@titulo = @tit,
@tipo = @tip,
@referente = @refe

SELECT *
FROM DOCUMENTO
SELECT *
FROM VERSION

--Ejecución de Stored Procedure Asociar Documento
DECLARE @id_o int
DECLARE @id_d int
DECLARE @tipo_r char(1)
SET @id_o = 1
SET @id_d = 2
SET @tipo_r = 'P'
EXEC asociar_documento
@documento_origen = @id_o, 
@documento_destino = @id_d,
@tipo_relacion = @tipo_r

DECLARE @id_o int
DECLARE @id_d int
DECLARE @tipo_r char(1)
SET @id_o = 1
SET @id_d = 3
SET @tipo_r = 'P'
EXEC asociar_documento
@documento_origen = @id_o, 
@documento_destino = @id_d,
@tipo_relacion = @tipo_r

DECLARE @id_o int
DECLARE @id_d int
DECLARE @tipo_r char(1)
SET @id_o = 3
SET @id_d = 2
SET @tipo_r = 'P'
EXEC asociar_documento
@documento_origen = @id_o, 
@documento_destino = @id_d,
@tipo_relacion = @tipo_r

DECLARE @id_o int
DECLARE @id_d int
DECLARE @tipo_r char(1)
SET @id_o = 1
SET @id_d = 2
SET @tipo_r = 'R'
EXEC asociar_documento
@documento_origen = @id_o, 
@documento_destino = @id_d,
@tipo_relacion = @tipo_r

SELECT *
FROM RELACION

--Ejecucion Stored Procedure Eliminar Participante
DECLARE @refe int
SET @refe = 1
EXEC eliminar_participante
@id = @refe

DECLARE @refe int
SET @refe = 2
EXEC eliminar_participante
@id = @refe

DECLARE @refe int
SET @refe = 3
EXEC eliminar_participante
@id = @refe

SELECT *
FROM PARTICIPANTE

--Stored Procedure futuros vencimientos
EXEC informe_vencimientos
SELECT *
FROM futuros_vencimientos
