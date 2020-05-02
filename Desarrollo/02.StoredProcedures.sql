--b)Revisar Documento
CREATE PROCEDURE revisarDocumento
    @id_doc int,
    @revisor int
AS
IF(SELECT v.aprobador
FROM VERSION v
WHERE id_documento = @id_doc )IS NOT NULL 
RETURN 
ELSE
BEGIN
    UPDATE VERSION
	SET revisor = @revisor
	WHERE id_documento = @id_doc
END



--b)Aprobar Documento
CREATE PROCEDURE aprobarDocumento
    @id_doc int,
    @fecha_pub datetime,
    @aprobador int,
    @version char(8)
AS
IF (SELECT v.revisor
FROM VERSION v
WHERE id_documento = @id_doc) IS NULL
RETURN
IF (select v.aprobador
FROM VERSION v
WHERE id_documento =@id_doc) IS NOT NULL 
RETURN
ELSE
BEGIN
    UPDATE VERSION
	SET fecha_publicacion = @fecha_pub,borrador = 0,aprobador = @aprobador,version = @version
	WHERE id_documento = @id_doc
    UPDATE DOCUMENTO 
	SET version_actual = @version,vencimiento = DATEADD(MONTH,6,GETDATE())
	WHERE id = @id_doc
END



--c)Crear Documento
CREATE PROCEDURE crear_documento
    @titulo varchar(250),
    @tipo char(1),
    @referente int
AS
BEGIN
    INSERT INTO DOCUMENTO
        (titulo,tipo,version_actual)
    VALUES
        (@titulo, @tipo, 'borrador')
    INSERT INTO VERSION
        (id_documento,version,fecha_creacion,borrador,referente)
    SELECT d.id, 'borrador', GETDATE(), 1, @referente
    FROM DOCUMENTO d
    WHERE d.titulo = @titulo
END



--d_Asociar Documento
CREATE PROCEDURE asociar_documento
    @documento_origen int,
    @documento_destino int,
    @tipo_relacion char(1)
AS
IF EXISTS(SELECT r.id_documento_destino
    FROM RELACION r
    WHERE r.id_documento_destino = @documento_destino AND r.tipo_relacion = 'P') AND @tipo_relacion = 'P'
	BEGIN
    UPDATE RELACION 
		SET id_documento_origen = @documento_origen 
		WHERE id_documento_destino = @documento_destino
        AND tipo_relacion = @tipo_relacion
END
ELSE
BEGIN
    INSERT INTO RELACION
        (id_documento_origen,id_documento_destino,tipo_relacion)
    VALUES(@documento_origen, @documento_destino, @tipo_relacion)
END



--g)Eliminar participante
CREATE PROCEDURE eliminar_participante
    @id int
AS
BEGIN
    UPDATE PARTICIPANTE
	SET eliminado = 0
	WHERE id = @id
    IF EXISTS(SELECT referente
    FROM VERSION
    WHERE referente = @id)
		UPDATE VERSION
		SET referente = revisor
		WHERE referente = @id
    IF EXISTS(SELECT revisor
    FROM VERSION
    WHERE revisor = @id)
		UPDATE VERSION
		SET revisor = aprobador
		WHERE revisor = @id
    IF EXISTS (SELECT aprobador
    FROM VERSION
    WHERE aprobador = @id)
		UPDATE VERSION
		SET aprobador = referente
		WHERE aprobador = @id
END



--h)Informe Vencimientos
CREATE PROCEDURE informe_vencimientos
AS
BEGIN
    DECLARE @vencimiento DATETIME
    DECLARE @id_doc INT
    DECLARE @orden INT
    DECLARE @id_anterior INT
    DECLARE @vencimiento_anterior DATETIME
    SET @orden = 1

    TRUNCATE TABLE futuros_vencimientos

    DECLARE cursorVenc CURSOR FOR
		SELECT id, vencimiento
    FROM DOCUMENTO
    WHERE vencimiento IS NOT NULL
    ORDER BY vencimiento ASC
    OPEN cursorVenc
    FETCH NEXT from cursorVenc into @id_anterior,@vencimiento_anterior
    INSERT INTO futuros_vencimientos
        (orden,id_documento,vencimiento)
    SELECT @orden, @id_anterior, @vencimiento_anterior
    WHILE @@fetch_status = 0
		BEGIN
        FETCH NEXT FROM cursorVenc into @id_doc,@vencimiento
        IF((DATEPART(year,@vencimiento_anterior) = DATEPART(year,@vencimiento)) AND (DATEPART(month,@vencimiento_anterior) = DATEPART(month,@vencimiento)))
				BEGIN
            SET @id_anterior = @id_doc
            SET @vencimiento_anterior = @vencimiento
            INSERT INTO futuros_vencimientos
                (orden,id_documento,vencimiento)
            SELECT @orden, @id_anterior, @vencimiento_anterior
        END
			ELSE
				BEGIN
            SET @id_anterior = @id_doc
            SET @vencimiento_anterior = @vencimiento
            SET @orden = @orden + 1
            INSERT INTO futuros_vencimientos
                (orden,id_documento,vencimiento)
            SELECT @orden, @id_anterior, @vencimiento_anterior
        END
    END
    CLOSE cursorVenc
    DEALLOCATE cursorVenc
END