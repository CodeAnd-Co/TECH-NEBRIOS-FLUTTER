//RF23: Registrar un nuevo tipo de comida en el sistema - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF23
//RF24: Editar un tipo de comida en el sistema - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF24

import '../models/alimentacionModel.dart';

/// Interfaz que define las operaciones de alimentación.
///
/// Aquí declaramos los métodos básicos que deberá implementar
/// cualquier servicio de datos de alimentación (API, local, mock…).
abstract class AlimentacionService {
  /// Obtiene la lista completa de alimentos desde la fuente de datos.
  ///
  /// Lanza una excepción si ocurre algún problema de red o parsing.
  Future<List<Alimento>> obtenerAlimentos();

  /// Edita un alimento existente.
  ///
  /// [alimento] instancia con los datos actualizados.
  /// Lanza excepción en caso de error (400, 500, etc.).
  Future<void> editarAlimento(Alimento alimento);

  /// Registra un nuevo tipo de comida en el sistema.
  ///
  /// [nombre] es el nombre del nuevo alimento.
  /// [descripcion] es la descripción detallada del alimento.
  ///
  /// Lanza excepciones si el backend responde con error (400, 500, etc.).
  Future<void> postDatosComida(String nombre, String descripcion);
}