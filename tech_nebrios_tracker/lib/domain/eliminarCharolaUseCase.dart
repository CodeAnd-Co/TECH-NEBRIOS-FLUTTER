import '../data/repositories/charolaRepository.dart';

abstract class EliminarCharolaUseCase {
  /// Elimina una charola por su ID.
  Future<void> eliminar(int id, String razon);
}
class EliminarCharolaUseCaseImpl implements EliminarCharolaUseCase {
  /// Repositorio de charolas.
  final CharolaRepository _charolaRepository;

  /// Constructor que permite inyectar un repositorio personalizado (opcional).
  EliminarCharolaUseCaseImpl({CharolaRepository? charolaRepository})
      : _charolaRepository = charolaRepository ?? CharolaRepository();

  @override
  Future<void> eliminar(int id, String razon) {
    return _charolaRepository.eliminarCharola(id, razon);
  }
}
