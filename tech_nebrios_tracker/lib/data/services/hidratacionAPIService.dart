
import '../models/hidratacionModel.dart';

/// Interfaz para el servicio de hidratación.
///
/// Aquí declaramos los métodos básicos que deberá implementar
/// cualquier servicio de datos de alimentación (API, local, mock…).
abstract class HidratacionService {
  /// Obtiene la lista completa de alimentos desde la fuente de datos.
  ///
  Future<List<Hidratacion>> obtenerHidratacion();
}
