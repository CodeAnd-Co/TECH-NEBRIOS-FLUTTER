//RF15  Filtrar charola por fecha - Documentación: https://codeandco-wiki.netlify.app/docs/next/proyectos/larvas/documentacion/requisitos/rf15/

import '../data/models/charolaModel.dart';
import '../data/repositories/charolaRepository.dart';

/// Contrato que define el caso de uso para filtrar charolas por fecha.
abstract class FiltrarCharolasFechasUseCase {
  Future<List<CharolaTarjeta>> filtrar(DateTime fechaInicio, DateTime fechaFin);
}

/// Implementación del caso de uso que usa el repositorio de charolas.
class FiltrarCharolasFechasUseCaseImpl implements FiltrarCharolasFechasUseCase {
  final CharolaRepository _charolaRepository;

  /// Permite inyectar un repositorio personalizado, útil para pruebas o mocks.
  FiltrarCharolasFechasUseCaseImpl({CharolaRepository? charolaRepository})
      : _charolaRepository = charolaRepository ?? CharolaRepository();

  @override
  Future<List<CharolaTarjeta>> filtrar(DateTime fechaInicio, DateTime fechaFin) {
    return _charolaRepository.filtrarCharolasPorFecha(
      fechaInicio: fechaInicio,
      fechaFin: fechaFin,
    );
  }
}
