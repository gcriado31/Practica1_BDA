# Asignatura Bases de Datos Avanzadas - curso 2023-24
# ETS Ingeniería Sistemas Informáticos - UPM

# -----------------------------------------------------
# Practica 1 - Script de creación de la Tabla inicial
# -----------------------------------------------------

CREATE DATABASE IF NOT EXISTS practica1bda_tablaunica;

USE practica1bda_tablaunica;

--
-- Creación de tablaunica
--
CREATE TABLE tablaunica (
	pID varchar(11),
    nompaciente varchar(40),
    genero varchar(1),
    edad varchar(3),
    telefonos varchar (50),
    localidadP varchar (50),
    provinciaP varchar (30),
    cID varchar(3),
    nomcentro varchar (100),
    localidadC varchar (50),
    provinciaC varchar (30),
    fechahora varchar(20),
    motivo varchar (100),
    especialidad varchar(40),
    area varchar (30),
    mID varchar(5),
    nommedico varchar(40)
);

--
-- Inserción de datos
--
INSERT INTO tablaunica 
VALUES 
(100001,'Dolores Fuertes','M',45,'967000003','Villalzarcillo','Albacete',5,'Vallesol','Metrópolis','Madrid','2024-01-02 10:00','Dolor de espalda','Traumatología','Clínica',105,'Carmelo Cotón') ,
(8980521,'Elba Calao','M',22,'600000012','Puenteviejo','Madrid',8,'Parquesol','Cantaloa','Segovia','2024-01-03 08:30','Análisis cínico','Laboratorio','Clínica',201,'Edu Cado'),
(86785,'Ernesto Rero','H',35,'921000005, 921000004,600000018','Sagrillas','Segovia',8,'Parquesol','Cantaloa','Segovia','2024-01-10 09:00','Fractura clavícula','Cirugía ósea','Quirúrgica',778,'Curro Poco'),
(100001,'Dolores Fuertes','M',null,'967000003','Villalzarcillo','Albacete',5,'Vallesol','Metrópolis','Madrid','2024-01-10 12:00','Radiografía','Pruebas imagen','Clínica',55,'Curro Mucho') ,
(50354,'Armando Casas','H',70,'975000002, 600000003','Peñafría','Soria',8,'Parquesol','Cantaloa','Segovia','2024-01-10 12:30','Radiografía','Pruebas imagen','Clínica',55,'Curro Mucho') ,
(433256,'Leandro Gao','M',30,null,'Cantaloa','Segovia',8,'Parquesol','Cantaloa','Segovia','2024-01-10 13:00','Paranoia','Psiquiatría','Clínica',565,'Encarna Vales'),
(9638211,'Soly Luna',null,18,'600000008','Metrópolis','Madrid',5,'Vallesol','Metrópolis','Madrid','2024-01-12 08:00','Análisis cínico','Laboratorio','Clínica',34,'Rosa Nitaria'),
(954216,'Aylen Tejas','M',48,null,'Sagrillas','Segovia',5,'Vallesol','Metrópolis','Madrid','2024-01-12 10:30','Dolor abdominal','Medicina general','Clínica',55,'Curro Mucho'),
(100001,'Dolores Fuertes',null,45,'967000003','Villalzarcillo','Albacete',5,'Vallesol','Metrópolis','Madrid','2024-01-12 17:00','Dolor de espalda','Traumatología','Clínica',105,'Carmelo Cotón'),
(15345678,'Elga Tito','H',5,'600000012','Puenteviejo','Madrid',5,'Vallesol','Metrópolis','Madrid','2024-01-12 18:00','Resfriado','Pediatría','Clínica',323,'Jony Mentero'),
(954216,'Aylen Tejas','M',null,'921000004, 600000014','Sagrillas','Segovia',8,'Parquesol','Cantaloa','Segovia','2024-01-15 12:30','Quiste sebáceo','Cirugía general','Quirúrgica',533,'Jony Bisturí'),
(9638211,'Soly Luna','M',18,'600000008','Metrópolis','Madrid',5,'Vallesol','Metrópolis','Madrid','2024-01-15 12:30','Vértigos','Traumatología','Clínica',105,'Carmelo Cotón'),
(37104,'Pancracia Notica','M',85,'921000005, 921000004,600000018','Sagrillas','Segovia',16,'Centro 3','Cantaloa','Segovia','2024-01-16 09:00','Análisis cínico','Laboratorio','Clínica',201,'Edu Cado'),
(50354,'Armando Casas','H',70,'975000002, 600000003','Peñafría','Soria',8,'Parquesol','Cantaloa','Segovia','2024-01-18 16:00','Vértigos','Medicina general','Clínica',55,'Curro Mucho'),
(6803298,'Armando Bronca','H',24,'975000005','Peñafría','Soria',5,'Vallesol','Metrópolis','Madrid','2024-01-18 16:00','Fractura fémur','Cirugía ósea','Quirúrgica',575,'Ana Tomía');

ALTER TABLE tablaunica ADD PRIMARY KEY (fechahora,mID); -- Para la clave primaria 
ALTER TABLE tablaunica ADD UNIQUE (fechahora,pID); -- Para la clave secundaria

-- Consulta a 

-- Esta consulta está mal porque coge los pID en la subconsulta de todas las áreas, con lo cual puede haber gente que haya ido
-- en otras áreas a diferentes provinvias pero en Quirúrgica no y que se cuenten en el resultado cuando no es así.
SELECT count(distinct pID)
FROM tablaunica as t
where t.area ='Quirúrgica' AND t.pID IN (SELECT distinct pID 
										FROM tablaunica as t
										WHERE t.provinciaC <> t.provinciaP);

-- Esta está bien

SELECT count(distinct pID) as numPacientesDesplazados
FROM tablaunica as t
WHERE t.provinciaC <> t.provinciaP AND  t.area ='Quirúrgica';

-- Consulta b
SELECT cID, nomcentro,provinciaC, fechahora
FROM tablaunica as t
WHERE TIME(fechahora)> '12:00' AND pID IN ( SELECT distinct pID
											FROM tablaunica as t
                                            WHERE t.localidadP =  'Sagrillas' OR t.localidadP = 'Peñafría');

-- Consulta c

-- Solo salen los centros que recibieron visitas
SELECT nomcentro, count(*) as atenciones
FROM tablaunica as t
WHERE dayofweek(t.fechahora)='6' AND t.genero = 'M'
GROUP BY (nomcentro);

-- Para que salgan los valores nulos 
SELECT C.nomcentro AS Centro_Salud, COALESCE(Total_Asistencias_Femeninas_Viernes, 0) AS Asistencias_Femeninas_Viernes
FROM (SELECT nomcentro, COUNT(*) AS Total_Asistencias_Femeninas_Viernes
      FROM tablaunica as t
      WHERE dayofweek(t.fechahora)='6' AND genero = 'M'
      GROUP BY nomcentro) AS AsistenciasPorCentro
RIGHT JOIN (SELECT DISTINCT nomcentro FROM tablaunica) AS C ON AsistenciasPorCentro.nomcentro = C.nomcentro;




