import 'reserva.dart';
import 'reservas_repository.dart';

class CrearReserva {
  CrearReserva(this.repositorio);

  final ReservasRepository repositorio;

  Future<ResultadoReserva> call(SolicitudReserva solicitud) async {
    if (!solicitud.fin.isAfter(solicitud.inicio)) {
      return ResultadoReserva.rechazada(
        'La hora de fin debe ser posterior a la de inicio',
      );
    }

    final reservasExistentes =
        await repositorio.reservasDeSala(solicitud.salaId);
    final haySolapamiento = reservasExistentes.any((reserva) =>
        solicitud.inicio.isBefore(reserva.fin) &&
        solicitud.fin.isAfter(reserva.inicio));
    if (haySolapamiento) {
      return ResultadoReserva.rechazada(
        'La sala ya tiene una reserva en ese horario',
      );
    }

    final reserva = await repositorio.guardar(solicitud);
    return ResultadoReserva.aceptada(reserva);
  }
}
