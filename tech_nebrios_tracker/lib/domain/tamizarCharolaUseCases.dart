import '../data/repositories/tamizarCharolaRepository.dart';
import '../data/models/tamizadoIndividualModel.dart';
import '../data/models/tamizadoMultipleModel.dart';

abstract class TamizarCharolaUseCases {
  Future<void> tamizarCharola(TamizadoIndividual tamizadoIndividual);
  Future<void> tamizarCharolasMultiples(TamizadoMultiple tamizadoMultiple);
  Future<List<String>> cargarAlimentos();
  Future<List<String>> cargarHidratacion();
}

class TamizarCharolaUseCasesImpl implements TamizarCharolaUseCases {
  final TamizarCharolaRepository repository;

  TamizarCharolaUseCasesImpl({TamizarCharolaRepository? repository}): repository = repository ?? TamizarCharolaRepository();

  @override
  Future<List<String>> cargarAlimentos() async {
    return await repository.getAlimentos();
  }

  @override
  Future<List<String>> cargarHidratacion() async {
    return await repository.getHidratacion();
  }

  @override
  Future<void> tamizarCharola(tamizadoIndividual) async {
    return await repository.tamizarCharola(tamizadoIndividual);
  }

  @override
  Future<void> tamizarCharolasMultiples(tamizadoMultiple) async {
    return await repository.tamizarCharolasMultiples(tamizadoMultiple);
  }
}