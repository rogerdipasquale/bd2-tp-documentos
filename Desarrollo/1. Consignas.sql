
/*
* PUNTO B - 
	SP: Cambiar estado de una versión de un documento. Si bien el estado no está
	explícito, podemos decir que un documento tiene fases de revisión y aprobación,
	plasmadas al ser finalizadas en los atributos Revisor y Aprobador de la tabla
	Versión. Si un doc no está aprobado, o revisado, esos atributos están en null. 
	
	No se puede cambiar de estado un documento ya aprobado, y en el momento en el que se
	aprueba, 
	- pasa a dejar de ser borrador, 
	- su fecha de publicación se setea en ese momento, 
	- y por último, el documento pasa a tener como versión actual la aprobada,
	- además de ser la fecha de vencimiento del mismo 6 meses después de la
	aprobación.
*/

CREATE PROCEDURE SP_CAMBIAR_VERSION @id_version int, @version char(8), @usuario_participante int
AS
BEGIN
	/* GUARDA A LOS REVISORES Y APROBADORES ACTUALES */
	DECLARE @revisor_actual int;
	DECLARE @aprobador_actual int;
	SELECT @revisor_actual = revisor FROM VERSION WHERE id = @id_version;
	SELECT @aprobador_actual = aprobador FROM VERSION WHERE id = @id_version;
	/* CUESTIONES DE TIEMPOS */
	DECLARE @fecha_actual datetime;
	SET @fecha_actual = GETDATE();
	Select @fecha_actual = CONVERT(varchar,@fecha_actual,23);
	DECLARE @fecha_6_meses_vencimiento datetime;
	SELECT @fecha_6_meses_vencimiento = DATEADD(month,6,@fecha_actual);
	
	IF (@revisor_actual IS NULL AND @aprobador_actual IS NULL)
	BEGIN
		UPDATE VERSION SET revisor = @usuario_participante WHERE id = @id_version
	    print 'Se ingreso al usuario como revisor.'
	END
	ELSE
	BEGIN
		IF(@revisor_actual IS NOT NULL AND @aprobador_actual IS NULL)
		BEGIN
			DECLARE @id_documento int;
			SELECT @id_documento = id_documento FROM VERSION WHERE id = @id_version;
			UPDATE VERSION SET aprobador = @usuario_participante, borrador = 0, fecha_publicacion = @fecha_actual  WHERE id = @id_version;
			
			UPDATE DOCUMENTO SET version_actual = @version, vencimiento = @fecha_6_meses_vencimiento WHERE id = @id_documento;

			print 'Se ingreso al usuario como aprobador.'
		END
		ELSE
		BEGIN
			print 'El documento ya esta aprobado.'
		END

	END
	
END 

/*
c) Creación de un nuevo documento. 
Debe generar no sólo el documento, sino también una versión inicial asociada a un usuario referente. 
El documento recién generado no se relaciona con otro y la descripción de la versión será ‘borrador’ hasta ser
aprobado; luego cambiará.Los parámetros de crear_documento son: @titulo
varchar(250), @tipo char(1) y @referente int.
*/

CREATE PROCEDURE SP_CREAR_DOCUMENTO @titulo varchar(250), @tipo char(1), @referente int
AS 
BEGIN

INSERT INTO DOCUMENTO(titulo, tipo, version_actual) VALUES (@titulo, @tipo, 'borrador');

INSERT INTO VERSION(id_documento, version, borrador, referente) VALUES (@@Identity, 'borrador', 1, @referente) 

END


/* 
D) Asociación de documentos. Debe crear una relación entre documentos, del tipo
indicado. 

De ser ‘P’ (padre), deber reemplazar, de existir, a una previa relación del
documento origen de tipo padre. 

Los parámetros de crear_documento son:
@documeno_origen int, @documento_destino int, tipo_relación char(1).
 */

CREATE PROCEDURE SP_CREAR_RELACION @documeno_origen int, @documento_destino int, @tipo_relacion char(1)
AS
BEGIN
		DECLARE @Cantidad int;
		SELECT @cantidad = COUNT(id) FROM RELACION WHERE id_documento_destino = @documento_destino AND tipo_relacion = 'P';
	
		IF(@Cantidad = 0)
		BEGIN
			PRINT 'No hay relacion anterior'
			INSERT INTO RELACION(id_documento_origen, id_documento_destino, tipo_relacion) VALUES (@documeno_origen, @documento_destino, @tipo_relacion)
		END
		ELSE 
		BEGIN
			PRINT 'Hay una relacion anterior'
			DECLARE @relacion_anterior int;
			SELECT @relacion_anterior = id FROM RELACION WHERE id_documento_destino = @documento_destino AND tipo_relacion = 'P';
			PRINT @relacion_anterior;
			DELETE FROM RELACION WHERE id = @relacion_anterior;
			INSERT INTO RELACION(id_documento_origen, id_documento_destino, tipo_relacion) VALUES (@documeno_origen, @documento_destino, @tipo_relacion)
		END 		
END

/*
e) Agregar posibilidad de eliminación lógica de todas las entidades. Esto significa un
campo bit llamado “eliminado”, por defecto en 0 en todas las tablas.
*/

ALTER TABLE DOCUMENTO 
ADD eliminado bit not null 
CONSTRAINT C_ADD_COLUMN DEFAULT 0

ALTER TABLE PARTICIPANTE 
ADD eliminado bit not null 
CONSTRAINT C_ADD_COLUMN_PAR DEFAULT 0

ALTER TABLE RELACION 
ADD eliminado bit not null 
CONSTRAINT C_ADD_COLUMN_REL DEFAULT 0

ALTER TABLE VERSION 
ADD eliminado bit not null 
CONSTRAINT C_ADD_COLUMN_VER DEFAULT 0

/*
f) Agregar auditoría sobre la tabla Versión, respecto a Referente, revisor y aprobador.
Esto significa generar una tabla de auditoría y crear el/los artefacto(s) de desarrollo
necesario(s) para que al modificar alguno de los tres nombrados, se guarde el valor
anterior.
*/

CREATE TRIGGER TR_VERSION_FOR_UPDATE on VERSION
FOR UPDATE 
AS
BEGIN
	INSERT INTO AUDITORIA (id_version, referente, revisor, aprobador) SELECT id, referente, revisor, aprobador FROM deleted
END

/*
g) Eliminar participante. La eliminación debe ser lógica, basándose en la posibilidad
implementada anteriormente, y los participantes se tienen que reemplazar en orden
inverso a la promoción. 
Si se elimina al referente, debe ser reemplazado por el revisor. 
El revisor por el autorizador, y si el autorizador es eliminado, se debe utilizar
el referente. El procedimiento eliminar_participante debe tener un único parámetro id
de tipo int.
*/

CREATE PROCEDURE SP_ELIMINAR_PARTICIPANTE @id_a_eliminar int
AS
BEGIN

	declare @id_ingresada int
	set @id_ingresada = @id_a_eliminar;
	declare @id int
	declare @referente int
	declare @revisor int
	declare @aprobador int
	declare @nuevo_referente int
	declare @nuevo_revisor int
	declare @nuevo_aprobador int
	
	/* Elimino si el participante esta en el referente */
	declare CS_ELIMINAR_PARTICIPANTE cursor scroll
	for Select id, referente, revisor, aprobador from VERSION WHERE referente = @id_ingresada

	open CS_ELIMINAR_PARTICIPANTE
	fetch next from CS_ELIMINAR_PARTICIPANTE into @id, @referente, @revisor, @aprobador

	while(@@FETCH_STATUS = 0)
		BEGIN
			print 'Se esta procesando fila - Elimino si el participante esta en el referente'
			
			SELECT @nuevo_referente = revisor FROM VERSION WHERE id=@id
			UPDATE VERSION SET referente = @nuevo_referente WHERE id=@id
			
			fetch next from CS_ELIMINAR_PARTICIPANTE into @id, @referente, @revisor, @aprobador
		END

	close CS_ELIMINAR_PARTICIPANTE
	deallocate CS_ELIMINAR_PARTICIPANTE 
	
	/* Elimino si el participante esta en el revisor */
	
	declare CS_ELIMINAR_PARTICIPANTE cursor scroll
	for Select id, referente, revisor, aprobador from VERSION WHERE revisor = @id_ingresada

	open CS_ELIMINAR_PARTICIPANTE
	fetch next from CS_ELIMINAR_PARTICIPANTE into @id, @referente, @revisor, @aprobador

	while(@@FETCH_STATUS = 0)
		BEGIN
			print 'Se esta procesando fila - Elimino si el participante esta en el revisor'
			
			SELECT @nuevo_revisor = aprobador FROM VERSION WHERE id=@id
			UPDATE VERSION SET revisor = @nuevo_revisor WHERE id=@id
			
			fetch next from CS_ELIMINAR_PARTICIPANTE into @id, @referente, @revisor, @aprobador
		END

	close CS_ELIMINAR_PARTICIPANTE
	deallocate CS_ELIMINAR_PARTICIPANTE
	
		/* Elimino si el participante esta en el aprobador */
	
	declare CS_ELIMINAR_PARTICIPANTE cursor scroll
	for Select id, referente, revisor, aprobador from VERSION WHERE aprobador = @id_ingresada

	open CS_ELIMINAR_PARTICIPANTE
	fetch next from CS_ELIMINAR_PARTICIPANTE into @id, @referente, @revisor, @aprobador

	while(@@FETCH_STATUS = 0)
		BEGIN
			print 'Se esta procesando fila - Elimino si el participante esta en el aprobador'
			
			SELECT @nuevo_aprobador = referente FROM VERSION WHERE id=@id
			UPDATE VERSION SET aprobador = @nuevo_aprobador WHERE id=@id
			
			fetch next from CS_ELIMINAR_PARTICIPANTE into @id, @referente, @revisor, @aprobador
		END

	close CS_ELIMINAR_PARTICIPANTE
	deallocate CS_ELIMINAR_PARTICIPANTE  
	
END

/*
Reporte de futuros vencimientos. 
Generar una tabla futuros_vencimientos con estructura (orden id, id_documento int, vencimiento datetime) 
y un stored procedure informe_vencimientos) sin parámetros que elimine su contenido e inserte en orden
de vencimiento los documentos, teniendo en cuenta que aquéllos documentos que
tengan igual mes (y año) de vencimiento deben tener el mismo valor en orden. Por
ejemplo:
1 120 2020-04-30
2 108 2020-05-11
2 118 2020-05-20
3 124 2020-06-01
3 200 2020-06-21
*/
	CREATE TABLE FUTUROS_VENCIMIENTOS (
	id int identity(1,1),
	orden int, 
	id_documento int,
	vencimiento datetime,
		
	PRIMARY KEY (id)
	)
	
CREATE PROCEDURE SP_FUTUROS_VENCIMIENTOS
AS
BEGIN
	TRUNCATE TABLE FUTUROS_VENCIMIENTOS;
	DECLARE @id int;
	DECLARE @vencimiento datetime;
	DECLARE @orden int;
	SET @orden = 0;
	DECLARE @anio int;
	DECLARE @mes int;
	SET @anio = 1000;
	SET @mes = 0;
	DECLARE @anio_aux int;
	DECLARE @mes_aux int;
	
	declare CS_ORDEN_FECHAS cursor scroll
	for Select id, vencimiento from DOCUMENTO

	open CS_ORDEN_FECHAS
	fetch next from CS_ORDEN_FECHAS into @id, @vencimiento

	while(@@FETCH_STATUS = 0)
		BEGIN
			if(@vencimiento IS NOT NULL) 
				BEGIN
					SELECT @anio_aux = YEAR(@vencimiento);
					SELECT @mes_aux = MONTH(@vencimiento);
					
					IF(@anio = @anio_aux AND @mes = @mes_aux)
					BEGIN
						PRINT 'No se suma'
						SET @anio = @anio_aux;
						SET @mes = @mes_aux;
					END
					ELSE
					BEGIN
						PRINT 'Suma 1 a la orden'
						SET @anio = @anio_aux
						SET @mes = @mes_aux
						SET @orden = @orden + 1
					END
					
					INSERT INTO FUTUROS_VENCIMIENTOS(orden, id_documento, vencimiento) VALUES (@orden, @id, @vencimiento);
					fetch next from CS_ORDEN_FECHAS into @id, @vencimiento;
				END
		END

	close CS_ORDEN_FECHAS
	deallocate CS_ORDEN_FECHAS
END

/*
FIN 
*/


