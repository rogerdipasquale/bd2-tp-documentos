CREATE PROCEDURE spDocumento_crearDocumento
	@titulo varchar(250),
	@tipo char(1),
	@referente int
AS
BEGIN
	SET NOCOUNT ON
	declare @id_documento int

	IF(SELECT id FROM PARTICIPANTE WHERE id=@referente) = 1 
		BEGIN
		INSERT INTO DOCUMENTO (titulo, tipo) VALUES (@titulo, @tipo)

		SELECT @id_documento = IDENT_CURRENT('DOCUMENTO')
	
		INSERT INTO VRSION (id_documento, fecha_creacion, referente) 
		VALUES (@id_documento, CURRENT_TIMESTAMP, @referente)
		END
	ELSE
		BEGIN
			PRINT 'Id_Participante no es valido, insercion no realizada'
		END
	SET NOCOUNT OFF
END