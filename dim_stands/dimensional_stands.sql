--CREATE DATABASE STANDS
DROP SCHEMA IF EXISTS dimensional_eventos CASCADE;
-- Crear esquema dimensional_eventos

CREATE SCHEMA dimensional_eventos;

-- Cambiar al esquema
SET search_path TO dimensional_eventos;

-- Crear tabla SEDE
CREATE TABLE dimensional_eventos.dim_sede (
    sk_sede NUMERIC PRIMARY KEY,
    cod_pais NUMERIC NOT NULL,
	nb_pais  VARCHAR(100) NOT NULL,
	cod_ciudad NUMERIC NOT NULL, 
	nb_ciudad VARCHAR(100) NOT NULL, 
	cod_sede NUMERIC NOT NULL,
	nb_sede VARCHAR(100) NOT NULL
);

-- Crear tabla LEYENDA
CREATE TABLE dimensional_eventos.dim_leyenda (
    sk_leyenda NUMERIC PRIMARY KEY,
    cod_leyenda NUMERIC NOT NULL,
	nb_leyenda  VARCHAR(100) NOT NULL
);

-- Crear tabla visitante
CREATE TABLE dimensional_eventos.dim_visitante (
    sk_visitante NUMERIC PRIMARY KEY,
    cod_visitante NUMERIC NOT NULL,
	cedula NUMERIC NOT NULL,
	nb_visitante  VARCHAR(100) NOT NULL,
	sexo VARCHAR(100) NOT NULL,
	email VARCHAR(100) NOT NULL
);

-- Crear tabla EVENTO
CREATE TABLE dimensional_eventos.dim_evento (
    sk_evento NUMERIC PRIMARY KEY,
    cod_tipo_evento NUMERIC NOT NULL,
	nb_tipo_evento  VARCHAR(100) NOT NULL,
	cod_evento NUMERIC NOT NULL, 
	nb_evento VARCHAR(100) NOT NULL, 
	descripcion VARCHAR(100) NOT NULL
);

-- Crear tabla TIPO_STAND
CREATE TABLE dimensional_eventos.dim_tipo_stand (
    sk_tipo_stand NUMERIC PRIMARY KEY,
    cod_tipo_stand NUMERIC NOT NULL,
	nb_tipo_stand  VARCHAR(100) NOT NULL
);


-- Crear tabla CATEGORIA
CREATE TABLE dimensional_eventos.dim_categoria (
    sk_categoria NUMERIC PRIMARY KEY,
    cod_subcategoria NUMERIC NOT NULL,
	nb_subcategoria  VARCHAR(100) NOT NULL,
	cod_categoria NUMERIC NOT NULL, 
	nb_categoria VARCHAR(100) NOT NULL
);


-- Crear tabla CLIENTE
CREATE TABLE dimensional_eventos.dim_cliente (
    sk_cliente NUMERIC PRIMARY KEY,
    cod_cliente NUMERIC NOT NULL,
	ci_rif VARCHAR(100) NOT NULL,
	nb_cliente  VARCHAR(100) NOT NULL,
	telefono VARCHAR(100) NOT NULL,
	direccion VARCHAR(100) NOT NULL,
	email VARCHAR(100) NOT NULL
);

-- Crear tabla TIEMPO
CREATE TABLE dimensional_eventos.dim_tiempo (
    sk_tiempo NUMERIC PRIMARY KEY,
    cod_anio NUMERIC NOT NULL,
	cod_trimestre NUMERIC NOT NULL,
	des_trimestre VARCHAR(100) NOT NULL,
	cod_mes NUMERIC NOT NULL,
	desc_mes VARCHAR(100) NOT NULL,
	desc_mes_corta VARCHAR(100) NOT NULL,
	cod_semana NUMERIC NOT NULL,
	cod_dia_anio NUMERIC NOT NULL,
	cod_dia_mes NUMERIC NOT NULL,
	cod_dia_semana NUMERIC NOT NULL,
	desc_dia_semana VARCHAR(100) NOT NULL,
	fecha DATE NOT NULL
);


-- Crear tabla FACT_EVENTO
CREATE TABLE dimensional_eventos.fact_evento (
    sk_evento NUMERIC,
	sk_sede NUMERIC,
	sk_fec_evento NUMERIC,
    cantidad_evento NUMERIC NOT NULL,
	cantidad_estim_visitantes NUMERIC NOT NULL,
	meta_ingreso NUMERIC(10,4) NOT NULL,
	PRIMARY KEY (sk_evento, sk_sede,sk_fec_evento),
	FOREIGN KEY (sk_evento) REFERENCES dimensional_eventos.dim_evento(sk_evento),
	FOREIGN KEY (sk_sede) REFERENCES dimensional_eventos.dim_sede(sk_sede),
	FOREIGN KEY (sk_fec_evento) REFERENCES dimensional_eventos.dim_tiempo(sk_tiempo)
);


-- Crear tabla FACT_EVENTO_STAND
CREATE TABLE dimensional_eventos.fact_evento_stand (
    sk_evento NUMERIC,
	sk_tipo_stand NUMERIC,
    cantidad_estimada NUMERIC NOT NULL,
	mt2 NUMERIC(10,4) NOT NULL,
	precio NUMERIC(10,4) NOT NULL,
	PRIMARY KEY (sk_evento, sk_tipo_stand),
	FOREIGN KEY (sk_evento) REFERENCES dimensional_eventos.dim_evento(sk_evento),
	FOREIGN KEY (sk_tipo_stand) REFERENCES dimensional_eventos.dim_tipo_stand(sk_tipo_stand)
);

-- Crear tabla FACT_VISITA
CREATE TABLE dimensional_eventos.fact_visita (
    sk_evento NUMERIC,
	sk_visitante NUMERIC,
	sk_fec_entrada NUMERIC,
	sk_leyenda_estrellas NUMERIC,
	num_entrada NUMERIC,
	hora_entrada TIMESTAMP NOT NULL,
	cantidad_visita NUMERIC NOT NULL,
	calificacion VARCHAR(10) NOT NULL,
	recomienda_amigo VARCHAR(100) NOT NULL,
	PRIMARY KEY (sk_evento, sk_visitante, sk_fec_entrada, sk_leyenda_estrellas, num_entrada),
	FOREIGN KEY (sk_evento) REFERENCES dimensional_eventos.dim_evento(sk_evento),
	FOREIGN KEY (sk_visitante) REFERENCES dimensional_eventos.dim_visitante(sk_visitante),
	FOREIGN KEY (sk_fec_entrada) REFERENCES dimensional_eventos.dim_tiempo(sk_tiempo),
	FOREIGN KEY (sk_leyenda_estrellas) REFERENCES dimensional_eventos.dim_leyenda(sk_leyenda)
);


-- Crear tabla FACT_ALQUILER
CREATE TABLE dimensional_eventos.fact_alquiler (
    sk_evento NUMERIC,
	sk_cliente NUMERIC,
	sk_fec_alquiler NUMERIC,
	sk_tipo_stand NUMERIC,
	sk_categoria NUMERIC,
	num_contrato NUMERIC,
	num_stand NUMERIC,
	mt2 NUMERIC(10,4) NOT NULL,
	monto NUMERIC(10,2) NOT NULL,
	cantidad NUMERIC NOT NULL,
	PRIMARY KEY (sk_evento, sk_cliente, sk_fec_alquiler, sk_tipo_stand, sk_categoria, num_contrato, num_stand),
	FOREIGN KEY (sk_evento) REFERENCES dimensional_eventos.dim_evento(sk_evento),
	FOREIGN KEY (sk_cliente) REFERENCES dimensional_eventos.dim_cliente(sk_cliente),
	FOREIGN KEY (sk_fec_alquiler) REFERENCES dimensional_eventos.dim_tiempo(sk_tiempo),
	FOREIGN KEY (sk_tipo_stand) REFERENCES dimensional_eventos.dim_tipo_stand(sk_tipo_stand),
	FOREIGN KEY (sk_categoria) REFERENCES dimensional_eventos.dim_categoria(sk_categoria)
);
