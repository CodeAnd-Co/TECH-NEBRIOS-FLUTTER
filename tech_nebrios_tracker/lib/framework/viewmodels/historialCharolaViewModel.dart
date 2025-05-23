//RF03: Consultar historial de ancestros de una charola - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF3

import 'package:flutter/foundation.dart';
import '../../data/models/historialCharolaModel.dart';
import '../../data/repositories/historialCharolaRepository.dart';
import '../../domain/historialAncestrosUseCase.dart';

class HistorialCharolaViewModel extends ChangeNotifier {
  late final HistorialActividadUseCasesImp Historial;
  final HistorialCharolaRepository _repo = HistorialCharolaRepository();

  HistorialCharolaViewModel(){
    Historial = HistorialActividadUseCasesImp(repositorio: _repo);
  }

  bool _isLoading = false;
  String? _error;
  List<HistorialAncestros> _historialAncestros = [];

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<HistorialAncestros> get historialAncestros =>
      List.unmodifiable(_historialAncestros);

  Future<void> obtenerAncestros(int charolaId) async {
  try {
    final result = await _repo.obtenerAncestros(charolaId);
    _historialAncestros = result;
    _error = null;
  } catch (e) {
    _historialAncestros = [];
    _error = 'No pude cargar ancestros';
  }
}


  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
