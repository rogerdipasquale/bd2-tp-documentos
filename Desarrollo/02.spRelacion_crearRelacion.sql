/*
	Modificación del SP crear relacion para que sea compatible con la eliminacion lógica
*/

ALTER PROCEDURE spRelacion_crearRelacion
	@documento_origen int,
	@documento_destino int,
	@tipo_relacion char(1)
AS
BEGIN
	SET NOCOUNT ON
IF @tipo_relacion = 'P' AND 
	(SELECT COUNT(*) FROM RELACION WHERE id_documento_origen = @documento_origen
	AND tipo_relacion = @tipo_relacion) > 0
	BEGIN
		UPDATE RELACION 
		SET eliminado = 1
		WHERE id_documento_origen = @documento_origen AND tipo_relacion = @tipo_relacion
	END

INSERT INTO RELACION (id_documento_origen, id_documento_destino, tipo_relacion)
	VALUES (@documento_origen, @documento_destino, @tipo_relacion)
	SET NOCOUNT OFF
END