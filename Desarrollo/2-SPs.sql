--b) revision y aprobacion de documentos

create procedure revisarDoc
	@id_d int,
	@revisor int
as
if (
	select v.aprobador
	from version v
	where id_documento = @id_d) is not null
return
else
begin
	update version
	set revisor = @revisor
	where id_documento = @id_d
end

------------------------------------

create procedure aprobarDoc
	@id_d int,
	@aprobador int,
	@publicacion datetime,
	@version char (8)
as
if (
	select v.revisor
	from version v
	where id_documento = @id_d) is null
return
if (
	select v.aprobador
	from version v
	where id_documento = @id_d) is not null
return
else
begin
	update version
	set aprobador = @aprobador,
		fecha_publicacion = @publicacion,
		version = @version,
		borrador = 0
	where id_documento = @id_d
	update documento
	set version_actual = @version,
		vencimiento = dateadd (month, 6, getdate())
	where id= @id_d
end


--c) creacion de documento

create procedure crearDoc
	@titulo varchar(250), 
	@tipo char(1),
	@referente int
as
begin
insert into documento (titulo, tipo, version_actual) values (@titulo, @tipo, 'borrador')
insert into version (id_documento, version, fecha_creacion, borrador, referente)
    SELECT d.id, d.version_actual, GETDATE(), 1, @referente
    FROM documento d
    WHERE d.titulo = @titulo
end


--d) asociacion de documentos

create procedure asociarDoc
	@documento_origen int, 
	@documento_destino int, 
	@tipo_relacion char(1)
as
if exists(
		select r.id_documento_destino
		from relacion r
		where r.id_documento_destino = @documento_destino and r.tipo_relacion = 'p') and @tipo_relacion = 'p'
	begin
		update relacion 
			set id_documento_origen = @documento_origen 
			where id_documento_destino = @documento_destino and tipo_relacion = @tipo_relacion
	end
else
begin
    insert into relacion (id_documento_origen,id_documento_destino,tipo_relacion) values (@documento_origen, @documento_destino, @tipo_relacion)
end


--g) elimino participante

create procedure eliminarParticipante
	@id int
as
begin
	update participante
		set eliminado = 0
		where id = @id
	if exists (select referente
				from version
				where referente = @id)
		update version
			set referente = revisor
			where referente = @id
	if exists (select revisor
				from version
				where revisor = @id)
		update version
			set revisor = aprobador
			where revisor = @id
	if exists (select aprobador
				from version
				where aprobador = @id)
		update version
			set aprobador = referente
			where aprobador = @id
end


--h) futuros vencimientos