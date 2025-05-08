//RF23: Registrar un nuevo tipo de comida en el sistema - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF23
import '../../data/repositories/alimento_repository.dart';

/// Interfaz abstracta para el caso de uso de registrar un alimento.
abstract class RegistrarAlimentoCasoUso {
  
  /// Ejecuta el registro del alimento con [nombre] y [descripcion].
  Future<void> ejecutar({required String nombre, required String descripcion});
}

/// Implementación concreta del caso de uso [RegistrarAlimentoCasoUso].
///
/// Usa un repositorio para comunicar la lógica de dominio con la fuente de datos.
class PostRegistrarAlimento implements RegistrarAlimentoCasoUso {
  final AlimentoRepository _repositorio;

  /// Constructor que recibe el repositorio a utilizar.
  PostRegistrarAlimento({required AlimentoRepository repositorio})
      : _repositorio = repositorio;

  @override
  Future<void> ejecutar({required String nombre, required String descripcion}) {
    return _repositorio.postDatosComida(nombre, descripcion);
  }
}
