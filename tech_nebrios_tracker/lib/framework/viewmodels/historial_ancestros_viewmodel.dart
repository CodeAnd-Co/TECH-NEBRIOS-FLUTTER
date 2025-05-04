// lib/framework/viewmodels/historial_ancestros_viewmodel.dart

import 'package:flutter/foundation.dart';
import '../../data/models/historial_ancestros_model.dart';
import '../../data/repositories/historial_ancestros_repository.dart';

class HistorialAncestrosViewModel extends ChangeNotifier {
  final HistorialAncestrosRepository _repo;

  HistorialAncestrosViewModel(this._repo);

  bool _isLoading = false;
  String? _error;
  List<HistorialAncestros> _historialAncestros = [];

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<HistorialAncestros> get historialAncestros => List.unmodifiable(_historialAncestros);

  Future<void> obtenerAncestros(int charolaId) async {
    // 1) Marca inicio de carga
    _debug('>> obtenerAncestros START (charolaId=$charolaId)');
    _setLoading(true);

    try {
      // 2) Llama al repositorio
      _debug(' - Llamando a repositorio.obtenerAncestros(...)');
      final result = await _repo.obtenerAncestros(charolaId);

      // 3) Revisa lo que llega
      _debug(' - Resultado del repositorio: $result');

      // 4) Asigna los datos
      _historialAncestros = result;
      _error = null;
      _debug(' - _historialAncestros length: ${_historialAncestros.length}');
    } catch (e, st) {
      // 5) Captura errores
      _error = 'Error al cargar historial: $e';
      _historialAncestros = [];
      _debug('!! Exception en obtenerAncestros: $e');
      _debug('   StackTrace: $st');
    } finally {
      // 6) Finaliza la carga
      _setLoading(false);
      _debug('<< obtenerAncestros END');
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
    _debug('   isLoading = $_isLoading');
  }

  void _debug(String message) {
    // Sólo imprime en modo debug
    if (kDebugMode) {
      print('[HistorialVM] $message');
    }
  }
}
