import '../data/repositories/tamizarCharolaRepository.dart';
import '../data/models/tamizadoIndividualModel.dart';
import '../data/models/tamizadoMultipleModel.dart';
import '../data/models/tamizadoRespuestaModel.dart';

abstract class TamizarCharolaUseCases {
  Future<TamizadoRespuesta?> tamizarCharola(TamizadoIndividual tamizadoIndividual);
  Future<TamizadoRespuesta?> tamizarCharolasMultiples(TamizadoMultiple tamizadoMultiple);
}

class TamizarCharolaUseCasesImpl implements TamizarCharolaUseCases {
  final TamizarCharolaRepository repository;

  TamizarCharolaUseCasesImpl({TamizarCharolaRepository? repository}): repository = repository ?? TamizarCharolaRepository();

  @override
  Future<TamizadoRespuesta?> tamizarCharola(tamizadoIndividual) async {
    return await repository.tamizarCharolaIndividual(tamizadoIndividual);
  }

  @override
  Future<TamizadoRespuesta?> tamizarCharolasMultiples(tamizadoMultiple) async {
    return await repository.tamizarCharolasMultiples(tamizadoMultiple);
  }
}