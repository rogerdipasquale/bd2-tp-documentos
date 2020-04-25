--Revisar Documento
CREATE PROCEDURE revisarDocumento
    @id_doc int,
    @revisor int
AS
BEGIN
    UPDATE VERSION
	SET revisor = @revisor
	WHERE id_documento = @id_doc
END

--Aprobar Documento
CREATE PROCEDURE aprobarDocumento
    @id_doc int,
    @fecha_pub datetime,
    @aprobador int
AS
BEGIN
    UPDATE VERSION
	SET fecha_publicacion = @fecha_pub,borrador = 0,aprobador = @aprobador
	WHERE id_documento = @id_doc
END