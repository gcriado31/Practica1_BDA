# Practica 1 de Bases de Datos Avanzadas

## 1. Teniendo en cuenta el conjunto de dependencias funcionales (L), contestar a las siguientes preguntas

1. ¿Puede atender un centro de salud a pacientes que sean de una localidad o provincia diferente a la del centro?
   - Si, si puede tenemos un paciente de Villazacillo, Albacete y la clínica que le atiende es en Metrópolis, Madrid.
2. ¿Puede un mismo paciente acudir a centros diferentes?
   - Sí, si puede ya que no existe una dependencia funcinal entre los centros y los pacientes.
3. ¿Puede una especialidad pertenecer a dos áreas diferentes?
   - No ya que existe una dependencia funcional entre especialidad y área.
4. ¿Podría haber dos médicos atendiendo consultas del mismo área en un mismo centro?
   - Si, ya que no hay dependencia funcional.

---

## 2. Determinar el nivel de normalización de la relación TablaUnica, calculando TODAS las claves existentes y sin eliminar la tabla previamente creada

### Cálculo de claves

<style>
    table {
      border-collapse: collapse;
      width: 50%;
      float: right;
    }
    th, td {
      border: 1px solid black;
      padding: 8px;
      text-align: center;
    }
    th {
      background-color: #f2f2f2;
    }
    .special-row th {
      background-color: #f2f2f2;
      font-weight: bold;
    }
  </style>
  <table>
    <tr>
      <th colspan="2">Atributos Esenciales</th>
    </tr>
    <tr>
      <td>H </td>
      <td>F </td>
    </tr>
    <tr class="special-row">
      <td>I,G,E,N,K,O,A,B</td>
      <td>P,L,C,D,J,S,M</td>
    </tr>
    <tr class="special-row">
      <th>Atributos no posibles</th>
      <th>Atributos posibles</th>
    </tr>

Primero comprobamos si la clave se puede constituir con los atributos esenciales

(HF)<sup>+</sup>= H,F ≠T

Como no se cubre todos los atributos de T probamos con combinaciones de los atributos posibles
<strong>(HFM)<sup>+</sup></strong>=H,F,M,P,O,S,C,A,D,J,K,B,I,G,E,L,N=T

<strong>(HFL)<sup>+</sup></strong>=H,F,L,P,I,G,E,L,N,O,S,C,M,B,J,K,D,A=T

(HFL)<sup>+</sup>H,F,L,N≠T

(HFD)<sup>+</sup>=H,F,D,C,J,K≠T

(HFC)<sup>+</sup>=H,F,C,D,J,K≠T

(HFJ)<sup>+</sup>=H,F,J,K≠T

(HFS)<sup>+</sup>=H,F,S,A≠T

Con lo cual, la clave principal será: ( H F M ) = ( teléfonos fecha_hora mID )

La clave secundaria será: ( H F P ) = ( teléfonos fecha_hora pID )

<mark>Como no se pueden tener atributos en la clave que sean nulos, quitamos el atributo "teléfono" de las claves</mark>

Se establecen las claves en SQL tal que

```SQL
ALTER TABLE tablaunica ADD PRIMARY KEY (fechahora,mID); -- Para la clave primaria
ALTER TABLE tablaunica ADD UNIQUE (fechahora,pID); -- Para la clave secundaria
```

Para finalizar los atributos quedan tal que:

- <font color='Darkblue'><strong>Atributos principales (P) :</strong></font> (H, F, M, P)
- <font color='Darkblue'><strong>Atributos no principales (Q) :</strong></font> (O,S,C,A,D,J,K,B,I,G,E,L,N)

### Nivel de normalización

Habiendo calculado las claves, podemos determinar el nivel de normalización.

El esquema está en 1FN ya que hay atributos no principales que dependen de un subconjunto de la clave. Como por ejemplo P->I.

---

## Resolver en SQL las siguientes consultas

### a. Obtener el número de pacientes que han sido atendidos en centros de salud de una provincia diferente a la suya en el área Quirúrgica.

El código en SQL será:

```SQL
SELECT count(distinct pID)
FROM tablaunica as t
WHERE t.provinciaC <> t.provinciaP AND  t.area ='Quirúrgica';
```

El resultado es:
![Imagen](./IMAGENES%20RESULTADOS/3_A.png)

### b. Obtener el centro y su provincia para aquellos centros que hayan atendido tanto a pacientes de Sagrillas como de Peñafría a partir de las 12:00.

El código en SQL será:

```SQL
SELECT cID, nomcentro,provinciaC, fechahora
FROM tablaunica as t
WHERE TIME(fechahora)> '12:00' AND pID IN ( SELECT distinct pID
											                      FROM tablaunica as t
                                            WHERE t.localidadP =  'Sagrillas' OR t.localidadP = 'Peñafría');
```

El resultado es: ![Imagen](./IMAGENES%20RESULTADOS/3_B.png)

### c. Obtener para cada centro de salud, el número de asistencias atendidas en viernes a pacientes de género femenino (valor “M”).

La consulta en SQL será:

```SQL
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
```

> Explicación: En la segunda consulta lo que se hace es coger la consulta anterior y transformarla como si fuera una tabla, seguidamente, se hace un right join con una tabla con todos los nombres de centros para que aunque haya valores null en nuestra primera consulta, se conserven y finalmente con la función COALESCE() hacemos que los valores NULL se muestre 0.

Resultados: ![Imagen](./IMAGENES%20RESULTADOS/3_C_1.png) ![Imagen](./IMAGENES%20RESULTADOS/3_C_2.png)

---

## Transaciones y anomalías de inserción

Como se indica en la guía de la práctica, en las inserciones en _tablaunica_ los valores que no figuren en el apartado se han puesto a null.

### a. Los datos de un nuevo centro de salud con identificador 18, y nombre “El Pueblo” en la localidad de Peñafría de la provincia de Soria

La transacción en SQL sería:

```SQL
START TRANSACTION;
INSERT INTO tablaunica VALUES (null,null,null,null,null,null,null,18,'El Pueblo','Peñafría','Soria',null,null,null,null,null,null);
ROLLBACK;


```

**TEORICAMENTE**: Dará error ya que no se puede introducir nueva información sin fechahora ni mID ya que es parte de la clave..

**PRÁCTICA**: ![Imagen](./IMAGENES%20RESULTADOS/4_A.png)

### b. Datos de una nueva asistencia al paciente “Nuevo” con identificador 99999, residente en Cerrofrío de la provincia de Burgos, atendido en el centro ”El Pueblo” (código de centro 18) de Peñafría en Soria, el día 20 de enero de 2024 a las 10:00, por el motivo de “Dolor pecho” de la especialidad de “Medicina general” (área Clínica) durante 10 minutos. Se desconoce el médico que atendió al paciente

La transacción en SQL sería:

```SQL
START TRANSACTION;
INSERT INTO tablaunica
VALUES (99999, 'Nuevo',null,null,null, 'Cerrofrío', 'Burgos', 18, 'El Pueblo', 'Peñafría', 'Soria', "2024-01-20 10:00", 'Dolor pecho', 'Medicina general', 'Clínica', null,null);
ROLLBACK;
```

**TEORICAMENTE**: Dará error ya que no se puede introducir nueva información sin mID ya que es parte de la clave.

**PRÁCTICA**: ![Imagen](./IMAGENES%20RESULTADOS/4_B.png)

### c. Igual que el apartado anterior pero subsanando el dato del médico, siendo “Tomé Dico” con identificador 95

La transacción en SQL sería:

```SQL
START TRANSACTION;
INSERT INTO tablaunica
VALUES (99999, 'Nuevo',null,null,null, 'Cerrofrío', 'Burgos', 18, 'El Pueblo', 'Peñafría', 'Soria', "2024-01-20 10:00", 'Dolor pecho', 'Medicina general', 'Clínica', 95, "Tomé Dico");
ROLLBACK;
```

**TEORICAMENTE**: No debe de dar error ya que quitamos el atributo teléfono de la calve por tomar valores nulos, en caso de no haberlo hecho si debería de dar error.

**PRÁCTICA**: ![Imagen](./IMAGENES%20RESULTADOS/4_C.png)

### d. Datos de una nueva asistencia al paciente “Elga Tito” con identificador 15345678, y teléfono 600000012, residente en “Puenteviejo” de la provincia de Madrid, atendido en el centro ”Vallesol” (código 5) de la localidad de Metrópolis de Madrid, el día 20 de enero de 2024 a las 20:00, por el motivo de “Fiebre” de la especialidad de “Pediatría” (área Clínica) y atendida por el médico “Jony Mentero” con identificador 323.

La transacción en SQL sería:

```SQL
START TRANSACTION;
INSERT INTO tablaunica
VALUES (15345678, 'Elga Tito',null,null,'600000012', 'Puenteviejo', 'Madrid', 5, 'Vallesol', 'Metrópolis', 'Madrid', '2024-01-20 20:000', 'Fiebre', 'Pediatría', 'Clínica', 323, 'Jony Mentero');
ROLLBACK;
```

**TEORICAMENTE**: No debe de dar error ya que género y edad que son los atributos a null no son parte de la clave principal.

**PRÁCTICA**: ![Imagen](./IMAGENES%20RESULTADOS/4_D.png)

---

## Transaciones y anomalías de modificación

### a. Modificar la edad de la paciente “Dolores Fuertes” a 46 años

Transacción en SQL:

```SQL
START TRANSACTION;
UPDATE tablaunica
SET edad = 46
WHERE nompaciente='Dolores Fuertes';
ROLLBACK;
```

**TEORICAMENTE**: No debe de dar error ya que no se han tocado parte de la clave.

**PRÁCTICA**: ![Imagen](./IMAGENES%20RESULTADOS/5_A.png)

### b. A partir del 12 de enero de 2024 el centro Vallesol ha cambiado de nombre y de localidad, pasándose a llamar “Vallesol 2” en la localidad de “Datapolis” de Madrid con código de centro 19

Transacción en SQL:

```SQL
START TRANSACTION ;
UPDATE tablaunica
SET nomcentro= 'Vallesol 2', localidadC='Datapolis', provinciaC='Madrid', cID=19
WHERE cID=5 AND date(fechahora)>='2024-01-12';
ROLLBACK;
```

**TEORICAMENTE**: No debe de dar error.

**PRÁCTICA**: ![Imagen](./IMAGENES%20RESULTADOS/5_B.png)

### c. Debido a un error, se debe eliminar la asistencia al paciente “Armando Bronca” realizada el día 18 de enero de 2024 a las 16:00 horas, eliminando los datos de dicha asistencia

```SQL
START TRANSACTION;
DELETE FROM tablaunica
WHERE nompaciente='Armando Bronca' AND fechahora='2024-01-18 16:00';
ROLLBACK;
```
**TEORICAMENTE**: No debe de dar error ya que estamos eliminando toda la clave.

**PRÁCTICA**: ![Imagen](./IMAGENES%20RESULTADOS/5_C.png)

### d. Eliminar la asistencia de la paciente “Soly Luna” del día 2024-01-15 a las 12:30. Indica si se produce algún tipo de anomalía o perdida de datos

```SQL
START TRANSACTION;
DELETE FROM tablaunica
WHERE nompaciente='Soly Luna' AND fechahora='2024-01-15 12:30';
ROLLBACK;
```
**TEORICAMENTE**: No debe de dar error ya que estamos eliminando toda la clave.

**PRÁCTICA**: ![Imagen](./IMAGENES%20RESULTADOS/5_D.png)

