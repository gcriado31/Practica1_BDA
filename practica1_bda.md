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

El resultado es: 1
![Imagen](./IMAGENES%20RESULTADOS/3_A.png)


