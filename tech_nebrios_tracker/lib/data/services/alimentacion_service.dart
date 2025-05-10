//RF23: Registrar un nuevo tipo de comida en el sistema - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF23
//RF25: Eliminar un tipo de comida en el sistema - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF25

import '../models/alimentacion_model.dart';

/// Interfaz que define las operaciones de alimentación.
///
/// Aquí declaramos los métodos básicos que deberá implementar
/// cualquier servicio de datos de alimentación (API, local, mock…).
abstract class AlimentacionService {
  /// Obtiene la lista completa de alimentos desde la fuente de datos.
  ///
  /// Lanza una excepción si ocurre algún problema de red o parsing.
  Future<List<Alimento>> obtenerAlimentos();

  /// Elimina un alimento existente.
  ///
  /// [idAlimento] es el identificador del alimento a eliminar.
  /// Lanza excepción en caso de error (400, 500, etc.).
  Future<void> eliminarAlimento(int idAlimento);
}
