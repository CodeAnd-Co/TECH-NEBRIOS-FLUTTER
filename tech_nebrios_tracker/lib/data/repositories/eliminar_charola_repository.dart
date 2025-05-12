import '../services/charola_api.dart';

abstract class EliminarCharolaRepository {
  Future<void> eliminarCharola(int id);
}

class EliminarCharolaRepositoryImpl implements EliminarCharolaRepository {
  final CharolaApiService apiService;

  EliminarCharolaRepositoryImpl(this.apiService);

  @override
  Future<void> eliminarCharola(int id) {
    return apiService.eliminarCharola(id);
  }
}
