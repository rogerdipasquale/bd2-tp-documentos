/* b) SP: Cambiar estado de una versión de un documento. 
Si bien el estado no está explícito, podemos decir que un documento tiene fases de revisión y aprobación,
plasmadas al ser finalizadas en los atributos Revisor y Aprobador de la tabla Versión. 

Si un doc no está aprobado, o revisado, esos atributos están en null.

No sepuede cambiar de estado un documento ya aprobado, y en el momento en el que se aprueba, pasa a dejar de ser borrador, 
su fecha de publicación se setea en esemomento, y por último, el documento pasa a tener como versión actual la aprobada,
además de ser la fecha de vencimiento del mismo 6 meses después de laaprobación */

CREATE PROCEDURE SP_REVISION @ID_DOCUMENTO INT, @REVISOR INT --  CREAMOS SP CON DOS VARIABLES
AS 
IF (SELECT APROBADOR FROM VERSION WHERE ID_DOCUMENTO = @ID_DOCUMENTO) IS NOT NULL  -- REIVSAMOS SI EL CAMPO ES NOT NULL
RETURN -- RETORNAMOS LO QUE TENEMOS EN EL CAMPO
ELSE --- SI ES NULL 
BEGIN -- INCIAMOS EL SP
UPDATE VERSION SET REVISOR= @REVISOR WHERE ID_DOCUMENTO=@ID_DOCUMENTO --SETEAMOS UN REVISOR 
END;


CREATE PROCEDURE SP_APROBACION @ID_DOCUMENTO INT, @FECHA_PUBLICACION DATETIME, @VERSION CHAR(8), @APROBADOR INT
AS
IF (SELECT REVISOR FROM VERSION WHERE ID_DOCUMENTO = @ID_DOCUMENTO) IS NULL
RETURN
IF (SELECT APROBADOR FROM VERSION WHERE ID_DOCUMENTO = @ID_DOCUMENTO) IS NOT NULL
RETURN
ELSE
BEGIN 
UPDATE VERSION SET FECHA_PUBLICACION = @FECHA_PUBLICACION, BORRADOR = 0, APROBADOR = @APROBADOR, VERSION = @VERSION WHERE ID=@ID_DOCUMENTO
UPDATE DOCUMENTO SET VERSION_ACTUAL=@VERSION, VENCIMIENTO= DATEADD(MONTH,6,GETDATE()) WHERE ID=@ID_DOCUMENTO
END

--Prueba --EXEC SP_APROBACION @ID_DOCUMENTO=1, @FECHA_PUBLICACION= '2020-03-01', @VERSION='V3', @APROBADOR=1;

