//RF23: Registrar un nuevo tipo de comida en el sistema - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF23
import '../models/alimento_model.dart';
import '../services/alimentacion_service.dart';

/// Repositorio que maneja las operaciones de alimentos con el backend.
///
/// Se comunica con el [AlimentacionService] para obtener, agregar y eliminar alimentos.
class AlimentoRepository {
  final AlimentacionService _service;

  /// Crea una nueva instancia del repositorio con el servicio dado.
  AlimentoRepository(this._service);

  /// Obtiene la lista completa de alimentos desde el backend.
  Future<List<Alimento>> obtenerAlimentos() async {
    return await _service.obtenerAlimentos();
  }

  /// Elimina un alimento específico por su [idAlimento].
  Future<void> eliminarAlimento(int idAlimento) async {
    await _service.eliminarAlimento(idAlimento);
  }

  /// Envía los datos de un nuevo alimento al servidor.
  Future<void> postDatosComida(String nombre, String descripcion) async {
  await _service.postDatosComida(nombre, descripcion);
  }
}
