import '../models/alimento_model.dart';
import '../services/alimentacion_service.dart';

class AlimentoRepository {
  final AlimentacionService _service;

  AlimentoRepository(this._service);

  /// Obtiene la lista de alimentos
  Future<List<Alimento>> obtenerAlimentos() async {
    return await _service.obtenerAlimentos();
  }

  /// Edita un alimento existente
  Future<void> editarAlimento(Alimento comida) async {
    await _service.editarAlimento(comida);
  }
}
