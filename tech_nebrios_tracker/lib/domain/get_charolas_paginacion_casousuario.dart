import '../data/models/charola_modelo.dart';
import '../data/repositories/charola_repositorio.dart';

abstract class ObtenerCharolasPaginacionCasousuario {
  Future<CharolaTarjerta?> ejecutar({int pag, int limite});
}

class ObtenerCharolasCasoUsoImpl implements ObtenerCharolasPaginacionCasousuario {
  final CharolaRepositorio repositorio;

  ObtenerCharolasCasoUsoImpl({CharolaRepositorio? repositorio})
      : repositorio = repositorio ?? CharolaRepositorio();

  @override
  Future<CharolaTarjerta?> ejecutar({int pag = 1, int limite = 10}) {
    return repositorio.obtenerCharolaRespuesta(pag, limite);
  }
}
