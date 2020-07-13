--f) Agregar auditoría sobre la tabla Versión, respecto a Referente, revisor y aprobador. Esto significa generar una tabla de auditoría y crear el/los artefacto(s) de desarrollo
--necesario(s) para que al modificar alguno de los tres nombrados, se guarde el valoranterior

--USE ParcialBD2


CREATE TRIGGER TR_VERSION on VERSION
FOR UPDATE 
AS
BEGIN
	INSERT INTO AUDITORIA_VERSION (id, referente, revisor, aprobador) SELECT id, referente, revisor, aprobador FROM deleted
END

-- prueba -- update VERSION set version='v2' where id=2
-- prueba -- select *  from VERSION