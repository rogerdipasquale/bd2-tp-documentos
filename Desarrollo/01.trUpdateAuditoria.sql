CREATE TRIGGER trVersion_update ON VRSION
	AFTER UPDATE
AS
BEGIN
	SET NOCOUNT ON;
declare @id_v int
declare @referente_d int
declare @revisor_d int
declare @aprobador_d int
declare @referente_i int
declare @revisor_i int
declare @aprobador_i int
declare @mod int 

SELECT @id_v = deleted.id,
	   @referente_d = deleted.referente,
	   @revisor_d = deleted.revisor,
	   @aprobador_d = deleted.aprobador
FROM deleted

SELECT @referente_i = inserted.referente,
	   @revisor_i = inserted.revisor,
	   @aprobador_i = inserted.aprobador
FROM inserted

SET @mod = CASE WHEN @referente_d != @referente_i THEN @referente_i
				WHEN @revisor_d != @revisor_i OR (@revisor_d IS NULL AND @revisor_i IS NOT NULL) THEN @revisor_i
				WHEN @aprobador_d != @aprobador_i OR (@aprobador_d IS NULL AND @aprobador_i IS NOT NULL)THEN @aprobador_i  
				END

IF @mod IS NOT NULL
	BEGIN
		INSERT INTO AUDITORIA_VERSION 
		(id_version, modificador, referente, revisor, aprobador, fecha_modificacion)
		VALUES (@id_v, @mod, @referente_d, @revisor_d, @aprobador_d, CURRENT_TIMESTAMP)
	END
	SET NOCOUNT OFF
END