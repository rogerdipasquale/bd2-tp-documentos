---- agrego datos

insert into documento (titulo, tipo, version_actual) values ('parcial', 'a', 'draft')
insert into documento (titulo, tipo, version_actual, vencimiento) values ('parcial 2', 'b', 'draft', DATEADD(month, 6, getdate()))

select * from documento


insert into participante (id,id_usuario_ldap,nombre) values (1, 1, 'revisor')
insert into participante (id,id_usuario_ldap,nombre) values (2, 2, 'aprobador')
insert into participante (id,id_usuario_ldap,nombre) values (3, 3, 'referente')
insert into participante (id,id_usuario_ldap,nombre) values (4, 4, 'creador')

select * from participante


insert into version (id_documento,version,fecha_creacion,borrador,referente)
select  d.id, d.version_actual, getdate(), 1, p.id
from documento d, participante p
where p.id = 4

select * from version

------------------------------------------------------------------

--ejecucion stored procedures

exec crearDoc 'parcial 3', 'c', '3'

exec asociarDoc 1, 2, 'p'

select * from relacion

-----------------------------------------------------------------
--trigger

delete from version
where id = 2

select * from verAuditoria