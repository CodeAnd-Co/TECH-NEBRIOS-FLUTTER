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

  /// Carga inicial de datos
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

  /// Edita un alimento existente
  Future<void> editarAlimento(Alimento alimento) async {
    _setLoading(true);
    try {
      await _repo.editarAlimento(alimento);
      final idx = _alimentos.indexWhere(
        (a) => a.idAlimento == alimento.idAlimento,
      );
      if (idx != -1) {
        _alimentos[idx] = alimento;
      }
      _error = null;
    } catch (e) {
      _error = 'Error al editar alimento: $e';
    }
    _setLoading(false);
  }

  void _setLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }
}
