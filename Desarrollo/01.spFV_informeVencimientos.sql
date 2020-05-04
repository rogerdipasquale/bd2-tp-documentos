CREATE PROCEDURE spFV_informeVencimientos
AS
BEGIN
	SET NOCOUNT ON
declare @fecha datetime
declare @fechaAcomparar datetime
declare @id_d int
declare @ctdr int = 1

DELETE FUTUROS_VENCIMIENTOS WHERE DATEDIFF(DD, vencimiento, CURRENT_TIMESTAMP) < 0

DECLARE csVencimiento CURSOR
	FOR SELECT id, vencimiento FROM DOCUMENTO WHERE vencimiento IS NOT NULL ORDER BY vencimiento ASC
OPEN csVencimiento

FETCH NEXT FROM csVencimiento into @id_d, @fechaAcomparar

INSERT INTO FUTUROS_VENCIMIENTOS (orden_id, id_documento, vencimiento)
VALUES (@ctdr, @id_d, @fechaAcomparar)

WHILE(@@FETCH_STATUS = 0)
 BEGIN
	FETCH NEXT FROM csVencimiento into @id_d, @fecha

	IF (DATEDIFF(MM, @fechaAcomparar, @fecha) > 0)
	BEGIN
		SET @ctdr = @ctdr + 1
	END

	IF (SELECT COUNT(id_documento) FROM FUTUROS_VENCIMIENTOS WHERE id_documento = @id_d) = 0
	BEGIN 
	INSERT INTO FUTUROS_VENCIMIENTOS (orden_id, id_documento, vencimiento)
	VALUES (@ctdr, @id_d, @fecha)
	END
	
	SET @fechaAcomparar = @fecha
 END

 CLOSE csVencimiento
 DEALLOCATE csVencimiento
	SET NOCOUNT OFF
END