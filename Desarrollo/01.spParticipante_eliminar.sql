CREATE PROCEDURE spParticipante_eliminar
	@id_participante int 
AS
BEGIN
	SET NOCOUNT ON
UPDATE PARTICIPANTE SET eliminado = 1 WHERE id = @id_participante
UPDATE VRSION 
	SET 
		referente = CASE 
						WHEN referente = @id_participante THEN revisor
						ELSE referente
					END,
		revisor = CASE
						WHEN revisor = @id_participante THEN aprobador
						ELSE revisor
					END,
		aprobador = CASE 
						WHEN aprobador = @id_participante THEN referente
						ELSE aprobador
					END
	WHERE referente = @id_participante 
	OR revisor = @id_participante
	OR aprobador = @id_participante	
	SET NOCOUNT OFF
END