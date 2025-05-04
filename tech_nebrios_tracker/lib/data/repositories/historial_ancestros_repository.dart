import '../models/historial_ancestros_model.dart';
import '../services/historial_ancestros_service.dart';

class HistorialAncestrosRepository {
  final HistorialAncestrosService _service;

  HistorialAncestrosRepository(this._service);

  /// Obtiene la lista de ancestros
 Future<List<HistorialAncestros>> obtenerAncestros(int idCharola) async {
    final historial = await _service.obtenerAncestros(idCharola);
    return [historial];
  }
}