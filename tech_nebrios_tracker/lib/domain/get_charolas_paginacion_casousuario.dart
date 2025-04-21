import '../data/models/charola_modelo.dart';
import '../data/repositories/charola_repositorio.dart';

abstract class GetCharolasPaginacionCasousuario {
  Future<CharolaTarjerta?> execute({int page, int limit});
}

class GetCharolasCasoUsoImpl implements GetCharolasPaginacionCasousuario {
  final CharolaRepositorio repository;

  GetCharolasCasoUsoImpl({CharolaRepositorio? repository})
      : repository = repository ?? CharolaRepositorio();

  @override
  Future<CharolaTarjerta?> execute({int page = 1, int limit = 10}) {
    return repository.getCharolaResponse(page, limit);
  }
}
