//RF23: Registrar un nuevo tipo de comida en el sistema - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF23
import '../models/alimento_model.dart';
import '../services/alimentacion_service.dart';

class AlimentoRepository {
  final AlimentacionService _service;

  AlimentoRepository(this._service);

  /// Obtiene la lista de alimentos
  Future<List<Alimento>> obtenerAlimentos() async {
    return await _service.obtenerAlimentos();
  }

  // Elimina un alimento por su ID
  Future<void> eliminarAlimento(int idAlimento) async {
    await _service.eliminarAlimento(idAlimento);
  }

  Future<void> postDatosComida(String nombre, String descripcion) async {
  await _service.postDatosComida(nombre, descripcion);
  }
}
