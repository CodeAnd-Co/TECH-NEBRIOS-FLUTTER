//RF23: Registrar un nuevo tipo de comida en el sistema - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF23
import '../data/repositories/alimentacionRepository.dart';

/// Interfaz de caso de uso para registrar un nuevo alimento.
///
/// Define la operación de registro sin depender de la implementación.
abstract class RegistrarAlimentoCasoUso {
  /// Registra un nuevo tipo de comida con [nombre] y [descripcion].
  ///
  /// Lanza excepción si el repositorio falla.
  Future<void> registrar({
    required String nombre,
    required String descripcion,
  });
}

/// Implementación concreta de [RegistrarAlimentoCasoUso].
///
/// Utiliza un [AlimentacionRepository] para realizar el registro
/// en la fuente de datos (API, base local, etc.).
class RegistrarAlimentoCasoUsoImpl implements RegistrarAlimentoCasoUso {
  /// Repositorio inyectado (por defecto usa [AlimentacionRepository]).
  final AlimentacionRepository repositorio;

  RegistrarAlimentoCasoUsoImpl({AlimentacionRepository? repositorio})
      : repositorio = repositorio ?? AlimentacionRepository();

  @override
  Future<void> registrar({
    required String nombre,
    required String descripcion,
  }) {
    return repositorio.postDatosComida(nombre, descripcion);
  }
}


