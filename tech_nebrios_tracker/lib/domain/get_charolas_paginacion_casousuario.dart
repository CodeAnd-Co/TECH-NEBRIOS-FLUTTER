import '../data/models/charola_modelo.dart';
import '../data/repositories/charola_repositorio.dart';

abstract class GetCharolasUseCase {
  Future<CharolaResponse?> execute({int page, int limit});
}

class GetCharolasUseCaseImpl implements GetCharolasUseCase {
  final CharolaRepository repository;

  GetCharolasUseCaseImpl({CharolaRepository? repository})
      : repository = repository ?? CharolaRepository();

  @override
  Future<CharolaResponse?> execute({int page = 1, int limit = 10}) {
    return repository.getCharolaResponse(page, limit);
  }
}
