//RF23: Registrar un nuevo tipo de comida en el sistema - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF23
//RF25: Eliminar un tipo de comida en el sistema - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF25
import '../../data/repositories/alimentacion_repository.dart';

/// Interfaz de caso de uso para eliminar un alimento.
///
/// Define la operación y permite invertir dependencias
/// entre la capa de dominio y la de datos.
abstract class EliminarAlimentoCasoUso {
  /// Elimina un alimento existente en el sistema.
  ///
  /// Lanza excepción si el repositorio falla.
  Future<void> eliminar({required int idAlimento});
}
/// Implementación concreta de [EliminarAlimentoCasoUso].
///
/// Recibe un [AlimentacionRepository] para ejecutar la lógica
/// de eliminación en la fuente de datos.
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