// RF36: Registrar un nuevo tipo de hidratación al sistema - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF36
import '../models/hidratacionModel.dart';

/// Interfaz para el servicio de hidratación.
///
/// Aquí declaramos los métodos básicos que deberá implementar
/// cualquier servicio de datos de alimentación (API, local, mock…).
abstract class HidratacionService {
  /// Obtiene la lista completa de alimentos desde la fuente de datos.
  ///
  Future<List<Hidratacion>> obtenerHidratacion();

  /// Registra un nuevo tipo de comida en el sistema.
  ///
  /// [nombre] es el nombre de la nueva hidratación.
  /// [descripcion] es la descripción detallada de la hidratación.
  ///
  /// Lanza excepciones si el backend responde con error (400, 500, etc.).
  Future<void> registrarHidratacion(String nombre, String descripcion);
}
