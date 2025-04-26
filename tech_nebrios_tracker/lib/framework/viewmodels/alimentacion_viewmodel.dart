import 'package:flutter/foundation.dart';

import '../../data/models/alimento_model.dart';
import '../../data/repositories/alimento_repository.dart';
import '../../data/services/alimentacion_service.dart';

class AlimentacionViewModel extends ChangeNotifier {
  final AlimentoRepository _repo;

  AlimentacionViewModel() : _repo = AlimentoRepository(AlimentacionService());

  bool _isLoading = false;
  String? _error;
  List<Alimento> _alimentos = [];

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Alimento> get alimentos => List.unmodifiable(_alimentos);

  Future<void> cargarAlimentos() async {
    _setLoading(true);
    try {
      _alimentos = await _repo.obtenerAlimentos();
      _error = null;
    } catch (e) {
      _error = 'Error al cargar alimentos: $e';
    }
    _setLoading(false);
  }

  Future<void> eliminarAlimento(int id) async {
    _setLoading(true);
    try {
      await _repo.eliminarAlimento(id);
      _alimentos.removeWhere((c) => c.idAlimento == id);
      _error = null;
    } catch (e) {
      _error = 'Error al eliminar alimento: $e';
    }
    _setLoading(false);
  }

  void _setLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }
}
