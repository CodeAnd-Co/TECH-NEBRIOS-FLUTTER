//RF40: Editar hidratacion - https://codeandco-wiki.netlify.app/docs/next/proyectos/larvas/documentacion/requisitos/RF40
import 'package:zuustento_tracker/data/models/hidratacionModel.dart';
import '../data/repositories/hidratacionRepository.dart';

/// Interfaz de caso de uso para editar hidratacion.
///
/// Define la operación y permite invertir dependencias
/// entre la capa de dominio y la de datos.
abstract class EditarHidratacionCasoUso {
  /// Edita un [hidratacion] existente en el sistema.
  ///
  /// Lanza excepción si el repositorio falla.
  Future<void> editar({required Hidratacion hidratacion});
}

/// Implementación concreta de [EditarHidratacionCasoUso].
///
/// Recibe un [HidratacionRepository] para ejecutar la lógica
/// de edición en la fuente de datos.
class EditarHidratacionCasoUsoImpl implements EditarHidratacionCasoUso {
  /// Repositorio inyectado (por defecto usa [HidratacionRepository]).
  final HidratacionRepository repositorio;

  EditarHidratacionCasoUsoImpl({HidratacionRepository? repositorio})
    : repositorio = repositorio ?? HidratacionRepository();

  @override
  Future<void> editar({required Hidratacion hidratacion}) {
    return repositorio.editarHidratacion(hidratacion);
  }
}