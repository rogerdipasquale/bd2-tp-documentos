CREATE TABLE FUTUROS_VENCIMIENTOS
(
	orden_id int NOT NULL,
	id_documento int NOT NULL,
	vencimiento datetime NOT NULL,
	FOREIGN KEY(id_documento) REFERENCES DOCUMENTO(id)
)