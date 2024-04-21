set sql_safe_updates = 0;

# INSERCIÓN DE DATOS  ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Transacción a
START TRANSACTION;
INSERT INTO tablaunica VALUES (null,null,null,null,null,null,null,18,'El Pueblo','Peñafría','Soria',null,null,null,null,null,null);
ROLLBACK;

-- Transacción b
START TRANSACTION;
INSERT INTO tablaunica 
VALUES (99999, 'Nuevo',null,null,null, 'Cerrofrío', 'Burgos', 18, 'El Pueblo', 'Peñafría', 'Soria', "2024-01-20 10:00", 'Dolor pecho', 'Medicina general', 'Clínica', null,null);
ROLLBACK;

-- Transacción c
START TRANSACTION;
INSERT INTO tablaunica 
VALUES (99999, 'Nuevo',null,null,null, 'Cerrofrío', 'Burgos', 18, 'El Pueblo', 'Peñafría', 'Soria', "2024-01-20 10:00", 'Dolor pecho', 'Medicina general', 'Clínica', 95, "Tomé Dico");
ROLLBACK;

-- Transacción d
START TRANSACTION;
INSERT INTO tablaunica 
VALUES (15345678, 'Elga Tito',null,null,'600000012', 'Puenteviejo', 'Madrid', 5, 'Vallesol', 'Metrópolis', 'Madrid', '2024-01-20 20:000', 'Fiebre', 'Pediatría', 'Clínica', 323, 'Jony Mentero');
ROLLBACK;

# MODIFICACIÓN DE DATOS  ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Transacción a
START TRANSACTION;
UPDATE tablaunica
SET edad = 46
WHERE nompaciente='Dolores Fuertes';
ROLLBACK;

-- Transacción b 
START TRANSACTION ;
UPDATE tablaunica
SET nomcentro= 'Vallesol 2', localidadC='Datapolis', provinciaC='Madrid', cID=19
WHERE cID=5 AND date(fechahora)>='2024-01-12';
ROLLBACK;

-- Transacción c
START TRANSACTION;
DELETE FROM tablaunica
WHERE nompaciente='Armando Bronca' AND fechahora='2024-01-18 16:00';
ROLLBACK;

-- Transaccion d
START TRANSACTION;
DELETE FROM tablaunica
WHERE nompaciente='Soly Luna' AND fechahora='2024-01-15 12:30';
ROLLBACK;

