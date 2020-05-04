CREATE PROCEDURE spVrsion_UpdateEstado 
	@DocId int
AS
BEGIN
	SET NOCOUNT ON
IF (SELECT version_type FROM VRSION WHERE id_documento = @DocId) < 3
	BEGIN
	UPDATE VRSION 
	SET version_type = (CASE
				WHEN revisor IS NOT NULL AND aprobador IS NULL THEN 2
				WHEN aprobador IS NOT NULL AND revisor IS NOT NULL THEN 3
				ELSE 1
				END),
		borrador = (CASE
				WHEN aprobador IS NOT NULL THEN 0
				ELSE 1
				END), 
		fecha_publicacion = (CASE
				WHEN aprobador IS NOT NULL THEN CURRENT_TIMESTAMP
				END)
	WHERE id_documento = @DocId

	IF (SELECT version_actual FROM DOCUMENTO WHERE id = @DocId) = 1
		BEGIN
		UPDATE DOCUMENTO 
		SET version_actual = (CASE
				WHEN (SELECT version_type FROM VRSION WHERE VRSION.id_documento = @DocId) = 3
				THEN 3
				ELSE version_actual
				END),
			vencimiento = (CASE
				WHEN (SELECT version_type FROM VRSION WHERE VRSION.id_documento = @DocId) = 3
				THEN DATEADD(MM, 6, CURRENT_TIMESTAMP)
				END)
		WHERE id = @DocId
		END
	END
	SET NOCOUNT OFF
END
GO

