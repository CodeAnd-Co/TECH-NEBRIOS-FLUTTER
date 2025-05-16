import '../data/models/charolaModel.dart';
import '../data/repositories/charolaRepository.dart';

abstract class RegistrarCharolaUseCase {
  /// Registra una nueva charola en el sistema.
  ///
  /// Lanza excepción si el repositorio falla.
  Future<void> registrar({required CharolaRegistro charola});
}

class RegistrarCharolaUseCaseImpl implements RegistrarCharolaUseCase {
  /// Repositorio inyectado (por defecto usa [CharolaRepository]).
  final CharolaRepository repositorio;

  RegistrarCharolaUseCaseImpl({CharolaRepository? repositorio})
    : repositorio = repositorio ?? CharolaRepository();

  @override
  Future<void> registrar({required CharolaRegistro charola}) {
    return repositorio.registrarCharola(charola);
  }
}
