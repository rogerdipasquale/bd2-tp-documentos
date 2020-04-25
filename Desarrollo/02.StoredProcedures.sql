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
	@aprobador int,
	@version char(8)
AS
IF (SELECT v.revisor FROM VERSION v WHERE id_documento = @id_doc) IS NULL
RETURN
IF (select v.aprobador FROM VERSION v WHERE id_documento =@id_doc) IS NOT NULL 
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
