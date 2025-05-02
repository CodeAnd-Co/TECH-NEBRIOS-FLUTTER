import '../../data/repositories/alimento_repository.dart';

/// Interfaz del caso de uso para registrar un nuevo alimento.
abstract class RegistrarAlimentoCasoUso {
  /// Ejecuta el registro de un alimento.
  Future<void> ejecutar({required String nombre, required String descripcion});
}

/// Implementación del caso de uso.
class PostRegistrarAlimento implements RegistrarAlimentoCasoUso {
  final AlimentoRepository _repositorio;

  PostRegistrarAlimento({required AlimentoRepository repositorio})
      : _repositorio = repositorio;

  @override
  Future<void> ejecutar({required String nombre, required String descripcion}) {
    return _repositorio.postDatosComida(nombre, descripcion);
  }
}
