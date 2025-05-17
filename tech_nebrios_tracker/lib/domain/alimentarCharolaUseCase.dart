//RF26: Registrar la alimentación de la charola - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF26
import '../data/models/alimentacionModel.dart';
import '../data/repositories/alimentacionRepository.dart';

class AlimentarCharolaUseCase {
  final ComidaCharolaRepository repository;

  AlimentarCharolaUseCase(this.repository);

  Future<bool> call(ComidaCharola comidaCharola) {
    return repository.registrarAlimentacion(comidaCharola);
  }
}
