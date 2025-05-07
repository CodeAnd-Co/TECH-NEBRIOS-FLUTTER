import '../data/models/charola_model.dart';
import '../data/repositories/consultar_charola_repository.dart';

class ObtenerCharolaUseCase {
  final CharolaRepository repository;

  ObtenerCharolaUseCase(this.repository);

  Future<Charola> obtenerCharola(int id) {
    return repository.obtenerCharola(id);
  }
}
