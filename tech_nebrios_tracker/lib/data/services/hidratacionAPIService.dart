//RF40: Editar hidratacion - https://codeandco-wiki.netlify.app/docs/next/proyectos/larvas/documentacion/requisitos/RF40
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

  /// Edita un alimento existente.
  ///
  /// [hidratacion] instancia con los datos actualizados.
  /// Lanza excepción en caso de error (400, 500, etc.).
  
  Future<void> editarHidratacion(Hidratacion hidratacion);
  /// Registra una hidratación en la charola especificada.
  ///
  /// [hidratarCharola] contiene los datos de la hidratación a registrar.
  ///
  /// Returns `Future<bool>` indicando el éxito o fallo del registro.
  Future<bool> registrarHidratacion(HidratarCharola hidratarCharola); 
}
