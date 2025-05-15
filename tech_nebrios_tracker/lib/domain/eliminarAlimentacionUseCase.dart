//RF24: Editar un tipo de comida en el sistema - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF24
import 'package:tech_nebrios_tracker/data/models/alimentacionModel.dart';
import '../data/repositories/alimentacionRepository.dart';

/// Interfaz de caso de uso para editar un alimento.
///
/// Define la operación y permite invertir dependencias
/// entre la capa de dominio y la de datos.
abstract class EliminarAlimentoCasoUso {
  /// Edita un [alimento] existente en el sistema.
  ///
  /// Lanza excepción si el repositorio falla.
  Future<void> eliminar({required int idAlimento});
}

/// Implementación concreta de [EliminarAlimentoCasoUso].
///
/// Recibe un [AlimentacionRepository] para ejecutar la lógica
/// de edición en la fuente de datos.
class EliminarAlimentoCasoUsoImpl implements EliminarAlimentoCasoUso {
  /// Repositorio inyectado (por defecto usa [AlimentacionRepository]).
  final AlimentacionRepository repositorio;

  EliminarAlimentoCasoUsoImpl({AlimentacionRepository? repositorio})
    : repositorio = repositorio ?? AlimentacionRepository();

  @override
  Future<void> eliminar({required int idAlimento}) {
    return repositorio.eliminarAlimento(idAlimento);
  }
}
