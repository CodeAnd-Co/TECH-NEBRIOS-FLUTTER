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

   /// Edita un alimento existente
  Future<void> editarAlimento(Alimento alimento) async {
    await _service.editarAlimento(alimento);
  }
}
