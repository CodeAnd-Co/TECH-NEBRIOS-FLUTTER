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
}
