
import '../models/hidratacionModel.dart';

/// Interfaz que define las operaciones de alimentación.
///
/// Aquí declaramos los métodos básicos que deberá implementar
/// cualquier servicio de datos de alimentación (API, local, mock…).
abstract class HidratacionService {
  /// Obtiene la lista completa de alimentos desde la fuente de datos.
  ///
  /// Lanza una excepción si ocurre algún problema de red o parsing.
  Future<List<Hidratacion>> obtenerHidratacion();
}
