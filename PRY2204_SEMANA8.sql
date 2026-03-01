-- ======================================================== --
-- 1. LIMPIEZA: Borrado de objetos
-- ======================================================== --
DROP TABLE DETALLE_SERVICIO CASCADE CONSTRAINTS;
DROP TABLE MANTENCION CASCADE CONSTRAINTS;
DROP TABLE MECANICO CASCADE CONSTRAINTS;
DROP TABLE AUTOMOVIL CASCADE CONSTRAINTS;
DROP TABLE MODELO CASCADE CONSTRAINTS;
DROP TABLE MARCA CASCADE CONSTRAINTS;
DROP TABLE TIPO_AUTOMOVIL CASCADE CONSTRAINTS;
DROP TABLE SUCURSAL CASCADE CONSTRAINTS;
DROP TABLE CIUDAD CASCADE CONSTRAINTS;
DROP TABLE PAIS CASCADE CONSTRAINTS;
DROP TABLE ESTANDAR CASCADE CONSTRAINTS;
DROP TABLE PREMIUM CASCADE CONSTRAINTS;
DROP TABLE CLIENTE CASCADE CONSTRAINTS;
DROP TABLE SERVICIO CASCADE CONSTRAINTS;

-- ========================================================= --
-- 2. CASO 1: CREACIÓN DE TABLAS
-- ========================================================= --

-- Tabla PAIS: El ID inicia en 9 e incrementa de 3 en 3
CREATE TABLE PAIS 
(
id_pais NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 9 INCREMENT BY 3),
nom_pais VARCHAR2(30) NOT NULL,
CONSTRAINT PAIS_PK PRIMARY KEY (id_pais)
);

-- Tabla TIPO_AUTOMOVIL
CREATE TABLE TIPO_AUTOMOVIL 
(
id_tipo CHAR(3) NOT NULL,
descripcion VARCHAR2(20) NOT NULL,
CONSTRAINT PK_TIPO_AUTOMOVIL PRIMARY KEY (id_tipo)
);

-- Tabla MARCA
CREATE TABLE MARCA
(
id_marca NUMBER(2) NOT NULL,
descripcion VARCHAR2(20) NOT NULL,
CONSTRAINT PK_MARCA PRIMARY KEY (id_marca)
);

-- Tabla SERVICIO
CREATE TABLE SERVICIO
(
id_servicio NUMBER(3) NOT NULL,
descripcion VARCHAR2(100) NOT NULL,
costo NUMBER(7) NOT NULL,
CONSTRAINT PK_SERVICIO PRIMARY KEY (id_servicio)
);

-- Tabla CLIENTE
CREATE TABLE CLIENTE
(
rut NUMBER(8) NOT NULL,
dv CHAR(1) NOT NULL,
pnombre VARCHAR2(20) NOT NULL,
snombre VARCHAR2(20),
apaterno VARCHAR2(20) NOT NULL,
amaterno VARCHAR2(20) NOT NULL,
telefono VARCHAR2(40),
email VARCHAR2(40),
tipo_cli CHAR(1) NOT NULL,
CONSTRAINT PK_CLIENTE PRIMARY KEY (rut)
);

-- Tabla CIUDAD
CREATE TABLE CIUDAD
(
id_ciudad NUMBER(3) NOT NULL,
nombre_ciudad VARCHAR2(30) NOT NULL,
id_pais NUMBER(3) NOT NULL,
CONSTRAINT PK_CIUDAD PRIMARY KEY (id_ciudad),
CONSTRAINT CIUDAD_FK_PAIS FOREIGN KEY (id_pais) REFERENCES PAIS (id_pais)
);

--Tabla SUCURSAL
CREATE TABLE SUCURSAL
(
id_sucursal CHAR(3) NOT NULL,
nom_sucursal VARCHAR2(20) NOT NULL,
calle VARCHAR2(20) NOT NULL,
num_calle NUMBER (4) NOT NULL,
id_ciudad NUMBER(3) NOT NULL,
CONSTRAINT PK_SUCURSAL PRIMARY KEY (id_sucursal),
CONSTRAINT SUCURSAL_FK_CIUDAD FOREIGN KEY (id_ciudad) REFERENCES CIUDAD (id_ciudad)
);

-- Tabla MODELO
CREATE TABLE MODELO
(
id_modelo NUMBER(5) NOT NULL,
descripcion VARCHAR2(20) NOT NULL,
id_marca NUMBER(2) NOT NULL,
CONSTRAINT PK_MODELO PRIMARY KEY (id_modelo, id_marca),
CONSTRAINT MODELO_FK_MARCA FOREIGN KEY (id_marca) REFERENCES MARCA (id_marca)
);

--Tabla AUTOMOVIL
CREATE TABLE AUTOMOVIL
(
patente CHAR(8) NOT NULL,
annio NUMBER(4) NOT NULL,
cant_puertas NUMBER(1) NOT NULL,
km NUMBER(6) NOT NULL,
color VARCHAR2(30) NOT NULL,
id_modelo NUMBER(5) NOT NULL,
cl_rut NUMBER(8) NOT NULL,
id_marca NUMBER(2) NOT NULL,
id_tipo_auto CHAR(3) NOT NULL,
CONSTRAINT PK_AUTOMOVIL PRIMARY KEY (patente),
CONSTRAINT AUTO_FK_CLIENTE FOREIGN KEY (cl_rut) REFERENCES CLIENTE (rut),
CONSTRAINT AUTO_FK_MODELO FOREIGN KEY (id_modelo, id_marca) REFERENCES MODELO (id_modelo, id_marca),
CONSTRAINT AUTO_FK_TIPO FOREIGN KEY (id_tipo_auto) REFERENCES TIPO_AUTOMOVIL (id_tipo)
);

--Tabla MECANICO: El ID inicia en 460 e incrementa de 7 en 7
CREATE TABLE MECANICO
(
cod_mecanico NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 460 INCREMENT BY 7),
pnombre VARCHAR2(20) NOT NULL,
snombre VARCHAR2(20),
apaterno VARCHAR2(20) NOT NULL,
amaterno VARCHAR2(20) NOT NULL,
bono_jefatura NUMBER(10),
sueldo NUMBER(10) NOT NULL,
monto_impuestos NUMBER(10) NOT NULL,
cod_supervisor NUMBER(5),
CONSTRAINT PK_MECANICO PRIMARY KEY (cod_mecanico),
CONSTRAINT MECANICO_FK_MECANICO FOREIGN KEY (cod_supervisor) REFERENCES MECANICO (cod_mecanico)
);

-- Tabla MANTENCION
CREATE TABLE MANTENCION
(
num_mantencion NUMBER(4) NOT NULL,
fecha_ingreso DATE NOT NULL,
fecha_salida DATE,
costo_total NUMBER(7) NOT NULL,
estado VARCHAR2(15) NOT NULL,
id_sucursal CHAR(3) NOT NULL,
patente_auto CHAR(8),
cod_mecanico NUMBER(5) NOT NULL,
CONSTRAINT PK_MANTENCION PRIMARY KEY (num_mantencion),
CONSTRAINT MANT_FK_AUTO FOREIGN KEY (patente_auto) REFERENCES AUTOMOVIL (patente),
CONSTRAINT MANT_FK_MECANICO FOREIGN KEY (cod_mecanico) REFERENCES MECANICO (cod_mecanico),
CONSTRAINT MANT_FK_SUCURSAL FOREIGN KEY (id_sucursal) REFERENCES SUCURSAL (id_sucursal)
);

-- Tabla DETALLE_SERVICIO
CREATE TABLE DETALLE_SERVICIO
(
num_mantencion NUMBER(4) NOT NULL,
id_servicio NUMBER(3) NOT NULL,
descuento_serv NUMBER(4,3) NOT NULL,
cantidad NUMBER(3) NOT NULL,
CONSTRAINT PK_DETALLE_SERVICIO PRIMARY KEY (num_mantencion, id_servicio),
CONSTRAINT DET_FK_MANTENCION FOREIGN KEY (num_mantencion) REFERENCES MANTENCION (num_mantencion),
CONSTRAINT DET_FK_SERVICIO FOREIGN KEY (id_servicio) REFERENCES SERVICIO (id_servicio)
);

-- Tabla ESTANDAR
CREATE TABLE ESTANDAR
(
cl_rut NUMBER(8) NOT NULL,
puntaje_fidelidad NUMBER(10) NOT NULL,
CONSTRAINT PK_ESTANDAR PRIMARY KEY (cl_rut),
CONSTRAINT ESTANDAR_FK_CLIENTE FOREIGN KEY (cl_rut) REFERENCES CLIENTE (rut)
);

-- Tabla PREMIUM
CREATE TABLE PREMIUM
(
cl_rut NUMBER(8) NOT NULL,
pesos_clientes NUMBER(10) NOT NULL,
monto_credito NUMBER(10),
CONSTRAINT PK_PREMIUM PRIMARY KEY (cl_rut),
CONSTRAINT PREMIUM_FK_CLIENTE FOREIGN KEY (cl_rut) REFERENCES CLIENTE (rut)
);


-- ============================================================== --
-- 3. CASO 2: MODIFICACION DEL MODELO
-- ============================================================== --
-- Eliminacion de atributo
ALTER TABLE MANTENCION DROP COLUMN costo_total;

-- Modificacion de claves (PK y FK)
-- Primero, se elimina la FK en la tabla hija
ALTER TABLE DETALLE_SERVICIO DROP CONSTRAINT DET_FK_MANTENCION;

-- Segundo, se elimina la PF actual de mantencion
ALTER TABLE MANTENCION DROP CONSTRAINT PK_MANTENCION;

-- Tercero, se crea la nueva PK compuesta en MANTENCION
ALTER TABLE MANTENCION ADD CONSTRAINT PK_MANTENCION PRIMARY KEY (num_mantencion, id_sucursal);

-- Cuarto, se agrega la columna id_sucursal a DETALLE_SERVICIO para que coincida con la nueva PK
ALTER TABLE DETALLE_SERVICIO ADD id_sucursal CHAR(3) NOT NULL;

-- Quinto, se crea la FK en DETALLE_SERVICIO con la nueva PK compuesta
ALTER TABLE DETALLE_SERVICIO 
ADD CONSTRAINT DET_FK_MANTENCION
FOREIGN KEY (num_mantencion, id_sucursal)
REFERENCES MANTENCION (num_mantencion, id_sucursal);

-- Restriccion de unicidad para email
ALTER TABLE CLIENTE ADD CONSTRAINT UNQ_CLIENTE_EMAIL UNIQUE (email);

-- Validacion de DV
ALTER TABLE CLIENTE
ADD CONSTRAINT CK_CLIENTE_DV
CHECK (dv IN ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'K', 'k'));

-- Sueldo minimo mecanico
ALTER TABLE MECANICO
ADD CONSTRAINT CK_MECANICO_SUELDO
CHECK (sueldo >= 510000);

-- Control de estado de una mantencion
ALTER TABLE MANTENCION
ADD CONSTRAINT CK_MANTENCION_ESTADO
CHECK (estado IN ('Reserva', 'Ingresado', 'Entregado', 'Anulado'));

-- ============================================================ --
-- 4. CASO 3: POBLAMIENTO DEL MODELO
-- ============================================================ --

-- CREACION DE OBJETOS DE SECUENCIA

-- Secuencia para SERVICIO: inicia en 400, incrementa en 2
CREATE SEQUENCE seq_servicio
START WITH 400
INCREMENT BY 2;

-- Secuencia para CIUDAD: inicia en 165, incrementa en 5
CREATE SEQUENCE seq_ciudad
START WITH 165
INCREMENT BY 5;

-- INSERCION DE DATOS

-- Insercion datos PAIS (El ID es IDENTITY, inicia en 9, incrementa en 3)
INSERT INTO PAIS (nom_pais) VALUES ('Chile');
INSERT INTO PAIS (nom_pais) VALUES ('Peru');
INSERT INTO PAIS (nom_pais) VALUES ('Colombia');


-- Insercion datos CIUDAD (Se utiliza la secuencia seq_ciudad (Inicia 165, incremente 5)
INSERT INTO CIUDAD (id_ciudad, nombre_ciudad, id_pais)
VALUES (seq_ciudad.NEXTVAL, 'Santiago', 9); -- Genera ID: 165

INSERT INTO CIUDAD (id_ciudad, nombre_ciudad, id_pais)
VALUES (seq_ciudad.NEXTVAL, 'Lima', 12); -- Genera ID: 170

INSERT INTO CIUDAD (id_ciudad, nombre_ciudad, id_pais)
VALUES (seq_ciudad.NEXTVAL, 'Bogota', 15); -- Genera ID: 175


-- Insercion datos SUCURSAL 
INSERT INTO SUCURSAL (id_sucursal, nom_sucursal, calle, num_calle, id_ciudad)
VALUES ('S01', 'Providencia', 'Av. A. Varas', 234, 165);

INSERT INTO SUCURSAL (id_sucursal, nom_sucursal, calle, num_calle, id_ciudad)
VALUES ('S02', 'Las 4 esquinas', 'Av. Latina', 669, 170);

INSERT INTO SUCURSAL (id_sucursal, nom_sucursal, calle, num_calle, id_ciudad)
VALUES ('S03', 'El cafetero', 'Av. El Faro', 900, 175);


-- Insercion datos SERVICIO (Se utiliza la secuencia seq_servicio (Inicia 400, incrementa 2)
INSERT INTO SERVICIO (id_servicio, descripcion, costo)
VALUES (seq_servicio.NEXTVAL, 'Cambio Luces', 45000);

INSERT INTO SERVICIO (id_servicio, descripcion, costo)
VALUES (seq_servicio.NEXTVAL, 'Desabolladura', 67000);

INSERT INTO SERVICIO (id_servicio, descripcion, costo)
VALUES (seq_servicio.NEXTVAL, 'Revision Frenos', 30000);

INSERT INTO SERVICIO (id_servicio, descripcion, costo)
VALUES (seq_servicio.NEXTVAL, 'Cambio Puerta Trasera', 50000);


-- Insercion datos MECANICO (El ID es IDENTITY, inicia en 460, incrementa en 7)
INSERT INTO MECANICO (pnombre, snombre, apaterno, amaterno, bono_jefatura, sueldo, monto_impuestos, cod_supervisor)
VALUES ('Jorge', 'Pablo', 'Soto', 'Sierpe', 5400000, 2759000, 223580, NULL);

INSERT INTO MECANICO (pnombre, snombre, apaterno, amaterno, bono_jefatura, sueldo, monto_impuestos, cod_supervisor)
VALUES ('Pedro', 'Jose', 'Manriquez', 'Corral', NULL, 759000, 23980, NULL);

INSERT INTO MECANICO (pnombre, snombre, apaterno, amaterno, bono_jefatura, sueldo, monto_impuestos, cod_supervisor)
VALUES ('Sandra', 'Josefa', 'Letelier', 'S.', 0, 659000, 22358, 460);

INSERT INTO MECANICO (pnombre, snombre, apaterno, amaterno, bono_jefatura, sueldo, monto_impuestos, cod_supervisor)
VALUES ('Felipe', 'M.', 'Vidal', 'A.', NULL, 759000, 23580, 460);

INSERT INTO MECANICO (pnombre, snombre, apaterno, amaterno, bono_jefatura, sueldo, monto_impuestos, cod_supervisor)
VALUES ('Jose', 'Miguel', 'Troncoso', 'B.', NULL, 659000, 44580, 474);

INSERT INTO MECANICO (pnombre, snombre, apaterno, amaterno, bono_jefatura, sueldo, monto_impuestos, cod_supervisor)
VALUES ('Juan', 'Pablo', 'Sanchez', 'R.', NULL, 859000, 23380, 474);

INSERT INTO MECANICO (pnombre, snombre, apaterno, amaterno, bono_jefatura, sueldo, monto_impuestos, cod_supervisor)
VALUES ('Carlos', 'Felipe', 'Soto', 'J.', 0, 597000, 23580, 474);

INSERT INTO MECANICO (pnombre, snombre, apaterno, amaterno, bono_jefatura, sueldo, monto_impuestos, cod_supervisor)
VALUES ('Alberto', 'P.', 'Cerda', 'Ramirez', NULL, 559000, 22380, 460);

INSERT INTO MECANICO (pnombre, snombre, apaterno, amaterno, bono_jefatura, sueldo, monto_impuestos, cod_supervisor)
VALUES ('Alejandra', 'Gabriela', 'Infanti', 'R.', NULL, 659000, 22380, 460);

INSERT INTO MECANICO (pnombre, snombre, apaterno, amaterno, bono_jefatura, sueldo, monto_impuestos, cod_supervisor)
VALUES ('Roberto', 'Patricio', 'Gutierrez', 'Sosa', NULL, 859000, 22380, 460);


-- Insercion datos MANTENCION
INSERT INTO MANTENCION (num_mantencion,id_sucursal, fecha_ingreso, fecha_salida, patente_auto, cod_mecanico, estado)
VALUES (101, 'S01', TO_DATE('12-04-2023', 'DD-MM-YYYY'), NULL, NULL, 481, 'Reserva');

INSERT INTO MANTENCION (num_mantencion,id_sucursal, fecha_ingreso, fecha_salida, patente_auto, cod_mecanico, estado)
VALUES (102, 'S02', TO_DATE('21-02-2023', 'DD-MM-YYYY'), TO_DATE('21-02-2023', 'DD-MM-YYYY'), NULL, 502, 'Entregado');

INSERT INTO MANTENCION (num_mantencion,id_sucursal, fecha_ingreso, fecha_salida, patente_auto, cod_mecanico, estado)
VALUES (103, 'S02', TO_DATE('09-10-2023', 'DD-MM-YYYY'), NULL, NULL, 502, 'Anulado');

INSERT INTO MANTENCION (num_mantencion,id_sucursal, fecha_ingreso, fecha_salida, patente_auto, cod_mecanico, estado)
VALUES (104, 'S03', TO_DATE('11-08-2023', 'DD-MM-YYYY'), TO_DATE('18-08-2023', 'DD-MM-YYYY'), NULL, 509, 'Entregado');

INSERT INTO MANTENCION (num_mantencion,id_sucursal, fecha_ingreso, fecha_salida, patente_auto, cod_mecanico, estado)
VALUES (105, 'S03', TO_DATE('03-12-2023', 'DD-MM-YYYY'), NULL, NULL, 509, 'Ingresado');

COMMIT;


-- ================================================================================================================== --
-- 5. CASO 4: RECUPERACION DE DATOS
-- ================================================================================================================== --

-- INFORME 1: SIMULACION DE REBAJA SELECTIVA DE IMPUESTOS
SELECT
cod_mecanico AS "ID MECANICO",
pnombre || ' ' || apaterno AS "NOMBRE MECANICO",
sueldo AS "SALARIO",
monto_impuestos AS "IMPUESTO ACTUAL",
monto_impuestos * 0.8 AS "IMPUESTO REBAJADO",
sueldo - (monto_impuestos * 0.8) AS "SUELDO CON REBAJA IMPUESTOS"
FROM MECANICO
WHERE bono_jefatura IS NULL
AND monto_impuestos < 40000
ORDER BY "IMPUESTO ACTUAL" DESC, apaterno ASC;


-- INFORME 2: LISTADO DE CALCULO DE REAJUSTES DE SUELDOS DE LOS MECANICOS
SELECT
cod_mecanico AS "IDENTIFICADOR",
pnombre || ' ' || snombre || ' ' || apaterno AS "MECANICO",
sueldo AS "SALARIO ACTUAL",
sueldo * 0.05 AS "AJUSTE",
sueldo + (sueldo * 0.05) AS "SUELDO_REAJUSTADO"
FROM MECANICO
WHERE (sueldo BETWEEN 600000 AND 900000) OR cod_supervisor IS NULL
ORDER BY "SALARIO ACTUAL" ASC, "MECANICO" DESC;















