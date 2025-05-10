import '../data/repositories/eliminar_charola_repository.dart';

class EliminarCharolaUseCase {
  final EliminarCharolaRepository repository;

  EliminarCharolaUseCase(this.repository);

  Future<void> eliminar(int id) {
    return repository.eliminarCharola(id);
  }
}
