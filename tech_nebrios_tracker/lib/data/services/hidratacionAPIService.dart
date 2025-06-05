// RF41 Eliminar un tipo de hidratación en el sistema - Documentación: https://codeandco-wiki.netlify.app/docs/next/proyectos/larvas/documentacion/requisitos/RF41
// RF42 Registrar la hidratación de la charola - Documentación: https://codeandco-wiki.netlify.app/docs/next/proyectos/larvas/documentacion/requisitos/RF42

import '../models/hidratacionModel.dart';

/// Interfaz para el servicio de hidratación.
///
/// Aquí declaramos los métodos básicos que deberá implementar
/// cualquier servicio de datos de alimentación (API, local, mock…).
abstract class HidratacionService {
  /// Obtiene la lista completa de alimentos desde la fuente de datos.
  ///
  Future<List<Hidratacion>> obtenerHidratacion();

  /// Elimina un alimento existente en el sistema.
  ///
  /// [idHidratacion] es el identificador del alimento a eliminar.
  Future<void> eliminarHidratacion(int idHidratacion);
  /// Registra una hidratación en la charola especificada.
  ///
  /// [hidratacionCharola] contiene los datos de la hidratación a registrar.
  ///
  /// Returns `Future<bool>` indicando el éxito o fallo del registro.
  Future<bool> registrarHidratacion(HidratacionCharola hidratacionCharola); 
}
