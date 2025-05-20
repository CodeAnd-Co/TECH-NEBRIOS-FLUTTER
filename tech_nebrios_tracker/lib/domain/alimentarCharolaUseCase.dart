import '../data/models/alimentacionModel.dart';
import '../data/repositories/alimentacionRepository.dart';

class AlimentarCharolaUseCase {
  final AlimentacionRepository repositorio;

  AlimentarCharolaUseCase({required this.repositorio});

  Future<bool> call(ComidaCharola comidaCharola) {
    return repositorio.registrarAlimentacion(comidaCharola);
  }

  Future<List<Alimento>> obtenerAlimentos() {
    return repositorio.obtenerAlimentos();
  }
}
