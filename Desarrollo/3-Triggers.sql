--f) auditoria de version

create trigger tr_verAud
on version
for delete
as
begin
	insert into verAuditoria
	select id, id_documento, version, referente, revisor, aprobador, SYSTEM_USER, getdate()
	from deleted
end