// RF16 Visualizar todas las charolas registradas en el sistema - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF16

import '../data/models/charolaModel.dart';
import '../data/repositories/charolaRepository.dart';

/// Interfaz para el caso de uso de obtención de charolas.
/// Permite recuperar datos paginados desde el repositorio.
abstract class ObtenerMenuCharolas {
  /// Ejecuta el caso de uso solicitando la página [pag] con [limite] de elementos y el [estado] del menú de charolas.
  Future<CharolaDashboard?> ejecutar({int pag, int limite, String estado});
}

/// Implementación del caso de uso para obtener charolas.
/// Usa el repositorio para acceder a la fuente de datos.
class ObtenerCharolasUseCaseImpl implements ObtenerMenuCharolas {
  /// Repositorio de donde se obtendrán las charolas.
  final CharolaRepository repositorio;

  /// Constructor que permite inyectar un repositorio personalizado (opcional).
  ObtenerCharolasUseCaseImpl({CharolaRepository? repositorio})
    : repositorio = repositorio ?? CharolaRepository();

  @override
  Future<CharolaDashboard?> ejecutar({int pag = 1, int limite = 15, String estado = 'activa'}) {
    return repositorio.obtenerCharolaRespuesta(pag, limite, estado: estado);
  }
}
