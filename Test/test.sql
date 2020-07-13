USE ParcialBD2


insert into PARTICIPANTE values (1,565656,'Arturo',0)
insert into PARTICIPANTE values (2,5644456,'Marta',0)
insert into PARTICIPANTE values (3,5644456,'Jose',0)
insert into PARTICIPANTE values (4,5644456,'Rodolfo',0)
insert into PARTICIPANTE values (5,5644456,'Yolanda',0)


insert into DOCUMENTO values('la mancha','a','v1','2021-13-02',0)
insert into DOCUMENTO values('la mancha 2','a','v1','2021-11-05',0)
insert into DOCUMENTO values('libro loco','b','v1','2021-12-07',0)
insert into DOCUMENTO values('otro libro','b','v1','2021-27-08',0)
insert into DOCUMENTO values('librazo','c','v1','2021-25-01',0)


insert into VERSION values(1,'v1','2019-01-01','2019-01-01',0,null,1,null,null,0)
insert into VERSION values(2,'v1','2019-01-01','2019-01-01',0,null,1,null,null,0)
insert into VERSION values(3,'v1','2019-01-01','2019-01-01',0,null,1,null,null,0)
insert into VERSION values(4,'v1','2019-01-01','2019-01-01',0,null,1,null,null,0)
insert into VERSION values(5,'v1','2019-01-01','2019-01-01',0,null,1,null,null,0)

insert into futuros_vencimientos values(4,GETDATE())
insert into futuros_vencimientos values(3,GETDATE())
insert into futuros_vencimientos values(2,GETDATE())
insert into futuros_vencimientos values(1,GETDATE())


--PRUEBA -- 
EXEC SP_APROBACION @ID_DOCUMENTO=4, @FECHA_PUBLICACION= '2020-03-01', @VERSION='V3', @APROBADOR=1;

--PRUEBA -- 
EXEC SP_CREAR_DOCUMENTO 'MODELO', 1, 1 

--PRUEBA -- 
EXEC SP_ASOCIAR_DOCUMENTO @DOCUMENTO_ORIGEN=3, @DOCUMENTO_DESTINO=4 , @TIPO_RELACION=p

--PRUEBA --
EXEC SP_ELIMINAR_PARTICIPANTE @id_eliminar = 2

--PRUEBA  --
EXEC  SP_INFORME_VENCIMIENTOS



select * from PARTICIPANTE
select * from VERSION
select * from DOCUMENTO
SELECT * FROM RELACION
select * from AUDITORIA_VERSION
select * from futuros_vencimientos
