// RF36 Registrar un nuevo tipo de hidratación al sistema - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF36
import '../data/repositories/hidratacionRepository.dart';

/// Interfaz de caso de uso para registrar un nuevo tipo de hidratación.
///
/// Define la operación de registro sin depender de la implementación.
abstract class RegistrarHidratacionCasoUso {
  /// Registra un nuevo tipo de hidratación con [nombre] y [descripcion].
  ///
  /// Lanza excepción si el repositorio falla.
  Future<void> registrar({required String nombre, required String descripcion});
}

/// Implementación concreta de [RegistrarHidratacionCasoUso].
///
/// Utiliza un [HidratacionRepository] para realizar el registro
/// en la fuente de datos (API, base local, etc.).
class RegistrarHidratacionCasoUsoImpl implements RegistrarHidratacionCasoUso {
  /// Repositorio inyectado (por defecto usa [HidratacionRepository]).
  final HidratacionRepository repositorio;

  RegistrarHidratacionCasoUsoImpl({HidratacionRepository? repositorio})
    : repositorio = repositorio ?? HidratacionRepository();

  @override
  Future<void> registrar({
    required String nombre,
    required String descripcion,
  }) {
    return repositorio.registrarHidratacion(nombre, descripcion);
  }
}
