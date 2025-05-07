// RF10 https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF10

import '../models/charola_model.dart';
import '../services/charola_api.dart';

abstract class CharolaRepository {
  Future<Charola> obtenerCharola(int id);
}

class ConsultarCharolaRepository implements CharolaRepository {
  final CharolaApiService apiService;

  ConsultarCharolaRepository(this.apiService);

  @override
  Future<Charola> obtenerCharola(int id) async {
    final data = await apiService.getCharola(id);
    return Charola.fromJson(data);
  }
}
