// RF16 Visualizar todas las charolas registradas en el sistema - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF16

import '../data/models/menuCharolasModel.dart';
import '../data/repositories/menuCharolasRepository.dart';

/// Interfaz para el caso de uso de obtención de charolas.
/// Permite recuperar datos paginados desde el repositorio.
abstract class ObtenerMenuCharolas {
  /// Ejecuta el caso de uso solicitando la página [pag] con [limite] de elementos.
  Future<CharolaTarjeta?> ejecutar({int pag, int limite, String estado});
}

/// Implementación del caso de uso para obtener charolas.
/// Usa el repositorio para acceder a la fuente de datos.
class ObtenerCharolasCasoUsoImpl implements ObtenerMenuCharolas {
  /// Repositorio de donde se obtendrán las charolas.
  final CharolaRepositorio repositorio;

  /// Constructor que permite inyectar un repositorio personalizado (opcional).
  ObtenerCharolasCasoUsoImpl({CharolaRepositorio? repositorio})
      : repositorio = repositorio ?? CharolaRepositorio();

  @override
  Future<CharolaTarjeta?> ejecutar({int pag = 1, int limite = 15, String estado = 'activa'}) {
    return repositorio.obtenerCharolaRespuesta(pag, limite, estado: estado);
  }
}

