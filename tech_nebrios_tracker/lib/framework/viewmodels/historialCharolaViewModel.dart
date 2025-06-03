// RF03: Consultar historial de ancestros de una charola
// https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF3

import 'dart:io';
import 'package:flutter/foundation.dart';
import '../../data/models/historialCharolaModel.dart';
import '../../data/repositories/historialCharolaRepository.dart';
import '../../domain/historialAncestrosUseCase.dart';

class HistorialCharolaViewModel extends ChangeNotifier {
  late final HistorialActividadUseCasesImp Historial;
  final HistorialCharolaRepository _repo = HistorialCharolaRepository();

  HistorialCharolaViewModel() {
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
    _setLoading(true);
    _error = null;
    notifyListeners();

    try {
      final result = await _repo.obtenerAncestros(charolaId);
      _historialAncestros = result;
    } on SocketException {
      // Error de conexión a internet
      _historialAncestros = [];
      _error = 'El servidor no responde. Por favor, inténtalo más tarde.';
    } catch (e) {
      // Cualquier otro error
      _historialAncestros = [];
      _error = 'No pude cargar ancestros: ${e.toString()}';
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
