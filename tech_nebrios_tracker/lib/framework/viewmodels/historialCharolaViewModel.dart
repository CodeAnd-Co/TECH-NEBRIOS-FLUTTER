//RF03: Consultar historial de ancestros de una charola - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF3

import 'package:flutter/foundation.dart';
import '../../data/models/historialCharolaModel.dart';
import '../../data/repositories/historialCharolaRepository.dart';

class HistorialCharolaViewModel extends ChangeNotifier {
  final HistorialCharolaRepository _repo;

  HistorialCharolaViewModel(this._repo);

  bool _isLoading = false;
  String? _error;
  List<HistorialAncestros> _historialAncestros = [];

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<HistorialAncestros> get historialAncestros =>
      List.unmodifiable(_historialAncestros);

  Future<void> obtenerAncestros(int charolaId) async {
  _setLoading(true);
  try {
    final result = await _repo.obtenerAncestros(charolaId);
    _historialAncestros = result;
    _error = null;
  } catch (e) {
    _historialAncestros = [];
    _error = 'No pude cargar ancestros';
  } finally {
    _setLoading(false);
  }
}


  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
