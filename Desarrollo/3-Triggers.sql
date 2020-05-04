--f) auditoria de version

create trigger tr_verAud
on version
for update
as
begin
	insert into verAuditoria
	select id, id_documento, version, referente, revisor, aprobador
	from deleted
end