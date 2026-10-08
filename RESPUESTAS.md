Escenarios que elegí y por qué
1. Solapamiento parcial: Evalúa la intersección donde el inicio de la nueva reserva cae dentro del intervalo ocupado.
2. Solapamiento envolvente: Valida cuando la nueva reserva engloba completamente a una existente (de 09:00 a 12:00 sobre 10:00 a 11:00), caso típico que escapa a comparaciones simples.
3. Reserva contigua: Como se observa en lib/domain/crear_reserva.dart:18, se usa isBefore estricto para que una reserva pueda iniciar exactamente al terminar otra (ej. 11:00), evitando falsos positivos.
4. Aislamiento por sala: Demuestra que reservas idénticas en horario son válidas si corresponden a salas distintas.
Riesgo más grave del repositorio
Si dos estudiantes intentan reservar la misma sala en el mismo horario simultáneamente desde dispositivos distintos, ambas peticiones leerán el estado libre al mismo tiempo en memoria y ambas escribirán con éxito, generando una reserva duplicada en la base de datos real.
¿La regla protege la app real?
No la protege por completo. Esta validación vive exclusivamente en la capa de dominio en memoria del cliente (lib/domain/crear_reserva.dart:16), lo cual previene errores locales en un entorno monousuario, pero es insuficiente en una arquitectura cliente-servidor.