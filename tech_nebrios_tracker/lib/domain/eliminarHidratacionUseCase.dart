// RF41 Eliminar un tipo de hidratación en el sistema - Documentación: https://codeandco-wiki.netlify.app/docs/next/proyectos/larvas/documentacion/requisitos/RF41

import '../data/repositories/hidratacionRepository.dart';

/// Interfaz de caso de uso para editar un alimento.
///
/// Define la operación y permite invertir dependencias
/// entre la capa de dominio y la de datos.
abstract class EliminarHidratacionCasoUso {
  /// Edita un [hidrato] existente en el sistema.
  ///
  /// Lanza excepción si el repositorio falla.
  Future<void> eliminar({required int idHidratacion});
}

/// Implementación concreta de [EliminarHidratacionCasoUso].
///
/// Recibe un [HidratacionRepository] para ejecutar la lógica
/// de edición en la fuente de datos.
class EliminarAlimentoCasoUsoImpl implements EliminarHidratacionCasoUso {
  /// Repositorio inyectado (por defecto usa [HidratacionRepository]).
  final HidratacionRepository repositorio;

  EliminarAlimentoCasoUsoImpl({HidratacionRepository? repositorio})
    : repositorio = repositorio ?? HidratacionRepository();

  @override
  Future<void> eliminar({required int idHidratacion}) {
    return repositorio.eliminarHidratacion(idHidratacion);
  }
}
