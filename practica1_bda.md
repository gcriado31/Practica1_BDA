# Practica 1 de Bases de Datos Avanzadas

## 1. Teniendo en cuenta el conjunto de dependencias funcionales (L), contestar a las siguientes preguntas

1. ¿Puede atender un centro de salud a pacientes que sean de una localidad o provincia diferente a la del centro?
    * Si, si puede tenemos un paciente de Villazacillo, Albacete y la clínica que le atiende es en Metrópolis, Madrid.
2. ¿Puede un mismo paciente acudir a centros diferentes?
    * Sí, si puede ya que no existe una dependencia funcinal entre los centros y los pacientes.
3. ¿Puede una especialidad pertenecer a dos áreas diferentes?
    * No ya que existe una dependencia funcional entre especialidad y área.
4. ¿Podría haber dos médicos atendiendo consultas del mismo área en un mismo centro?
    * Si, ya que no hay dependencia funcional.

---

## 2. Determinar el nivel de normalización de la relación TablaUnica, calculando TODAS las claves existentes y sin eliminar la tabla previamente creada


