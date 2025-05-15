// RF10 https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF10

import '../data/models/charolaModel.dart';
import '../data/repositories/charolaRepository.dart';

abstract class ObtenerCharolaUseCase {
  /// Obtiene una charola por su ID.
  Future<CharolaDetalle?> obtenerCharola(int id);
  }

class ObtenerCharolaUseCaseImpl implements ObtenerCharolaUseCase {
  /// Repositorio de charolas.
  final CharolaRepository _charolaRepository;

  /// Constructor que permite inyectar un repositorio personalizado (opcional).
  ObtenerCharolaUseCaseImpl({CharolaRepository? charolaRepository})
      : _charolaRepository = charolaRepository ?? CharolaRepository();

  @override
  Future<CharolaDetalle?> obtenerCharola(int id) {
    return _charolaRepository.obtenerCharola(id);
  }
}
