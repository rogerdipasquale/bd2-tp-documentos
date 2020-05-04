--f)audtitoria sobre la tabla version
CREATE TRIGGER trAuditoriaVersion
ON VERSION
FOR UPDATE 
AS
BEGIN
    INSERT INTO version_auditoria
    SELECT id, id_documento, referente, revisor, aprobador, SYSTEM_USER, GETDATE()
    FROM DELETED
END