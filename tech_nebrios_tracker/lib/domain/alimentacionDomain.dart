//RF23: Registrar un nuevo tipo de comida en el sistema - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF23
//RF24: Editar un tipo de comida en el sistema - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF24
import 'package:tech_nebrios_tracker/data/models/alimentacionModel.dart';
import '../data/repositories/alimentacionRepository.dart';

/// Interfaz de caso de uso para editar un alimento.
///
/// Define la operación y permite invertir dependencias
/// entre la capa de dominio y la de datos.
abstract class EditarAlimentoCasoUso {
  /// Edita un [alimento] existente en el sistema.
  ///
  /// Lanza excepción si el repositorio falla.
  Future<void> editar({required Alimento alimento});
}

/// Implementación concreta de [EditarAlimentoCasoUso].
///
/// Recibe un [AlimentacionRepository] para ejecutar la lógica
/// de edición en la fuente de datos.
class EditarAlimentoCasoUsoImpl implements EditarAlimentoCasoUso {
  /// Repositorio inyectado (por defecto usa [AlimentacionRepository]).
  final AlimentacionRepository repositorio;

  EditarAlimentoCasoUsoImpl({AlimentacionRepository? repositorio})
    : repositorio = repositorio ?? AlimentacionRepository();

  @override
  Future<void> editar({required Alimento alimento}) {
    return repositorio.editarAlimento(alimento);
  }
}

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
