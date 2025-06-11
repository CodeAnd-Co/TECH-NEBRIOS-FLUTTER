//RF15  Filtrar charola por fecha - Documentación: https://codeandco-wiki.netlify.app/docs/next/proyectos/larvas/documentacion/requisitos/rf15/

import '../data/models/charolaModel.dart';
import '../data/repositories/charolaRepository.dart';

/// Contrato que define el caso de uso para filtrar charolas por fecha.
abstract class FiltrarCharolasFechasUseCase {
  Future<List<CharolaTarjeta>> filtrar(DateTime fechaInicio, DateTime fechaFin, String estado);

}

/// Implementación del caso de uso que usa el repositorio de charolas.
class FiltrarCharolasFechasUseCaseImpl implements FiltrarCharolasFechasUseCase {
  final CharolaRepository charolaRepository;

  FiltrarCharolasFechasUseCaseImpl({required this.charolaRepository});

  @override
  Future<List<CharolaTarjeta>> filtrar(DateTime inicio, DateTime fin, String estado) {
    return charolaRepository.filtrarCharolasPorFecha(
      fechaInicio: inicio,
      fechaFin: fin,
      estado: estado,
    );
  }
}
