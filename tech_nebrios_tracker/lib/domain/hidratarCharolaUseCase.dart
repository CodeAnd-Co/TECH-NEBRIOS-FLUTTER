// RF42 Registrar la hidratación de la charola - Documentación: https://codeandco-wiki.netlify.app/docs/next/proyectos/larvas/documentacion/requisitos/RF42
import '../data/models/hidratacionModel.dart';
import '../data/repositories/hidratacionRepository.dart';

/// Caso de uso para gestionar la lógica de hidratación de charolas.
///
/// Esta clase representa la capa intermedia entre la vista (o ViewModel) y el repositorio,
/// encapsulando las operaciones disponibles relacionadas con la hidratación.
///
/// Según la arquitectura Clean Architecture, el caso de uso se encarga de orquestar
/// las llamadas a los repositorios y preparar los datos necesarios.
class HidratarCharolaUseCase {
  /// Repositorio de hidratación inyectado, encargado de realizar las operaciones de red o base de datos.
  final HidratacionRepository repositorio;

  /// Crea una instancia del caso de uso con el repositorio requerido.
  HidratarCharolaUseCase({required this.repositorio});

  /// Registra una hidratación para una charola.
  ///
  /// Llama al repositorio para enviar los datos de hidratación.
  ///
  /// - [hidratarCharola]: Objeto con los datos de la hidratación a registrar.
  /// - Returns: `true` si el registro fue exitoso, o lanza una excepción si falla.
  Future<bool> call(HidratacionCharola hidratarCharola) {
    return repositorio.registrarHidratacion(hidratarCharola);
  }

  /// Obtiene la lista de tipos de hidratación disponibles desde la fuente de datos.
  ///
  /// Returns: Una lista de objetos [Hidratacion] cargados desde el backend o la base de datos.
  Future<List<Hidratacion>> obtenerHidratacion() {
    return repositorio.obtenerHidratacion();
  }
}
