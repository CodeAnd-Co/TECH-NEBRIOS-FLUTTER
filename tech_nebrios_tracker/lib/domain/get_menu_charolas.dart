import '../data/models/menu_charolas.model.dart';
import '../data/repositories/menu_charolas.repository.dart';

abstract class ObtenerMenuCharolas {
  Future<CharolaTarjeta?> ejecutar({int pag, int limite});
}

class ObtenerCharolasCasoUsoImpl implements ObtenerMenuCharolas {
  final CharolaRepositorio repositorio;

  ObtenerCharolasCasoUsoImpl({CharolaRepositorio? repositorio})
      : repositorio = repositorio ?? CharolaRepositorio();

  @override
  Future<CharolaTarjeta?> ejecutar({int pag = 1, int limite = 12}) {
    return repositorio.obtenerCharolaRespuesta(pag, limite);
  }
}
