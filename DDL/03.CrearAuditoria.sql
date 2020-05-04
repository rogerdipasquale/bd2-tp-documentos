CREATE TABLE AUDITORIA_VERSION
(
	id int IDENTITY(1,1) PRIMARY KEY,
	id_version int NOT NULL,
	modificador int NOT NULL,
	razon varchar(20) NOT NULL,
	referente int NOT NULL,
	revisor int,
	aprobador int,
	fecha_modificacion datetime NOT NULL,
	FOREIGN KEY(id_version) REFERENCES VRSION(id),
	FOREIGN KEY(modificador) REFERENCES PARTICIPANTE(id),
	FOREIGN KEY(referente) REFERENCES PARTICIPANTE(id),
	FOREIGN KEY(revisor) REFERENCES PARTICIPANTE(id),
	FOREIGN KEY(aprobador) REFERENCES PARTICIPANTE(id)
)