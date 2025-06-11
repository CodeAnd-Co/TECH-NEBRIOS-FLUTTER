// RF29: Visualizar la información del Frass obtenido - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF29

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:flutter/material.dart';
import '../../data/models/frasModel.dart';
import '../../data/repositories/frasRepository.dart';
import '../../domain/visualizarFrasUseCase.dart';

class FrasViewModel extends ChangeNotifier {
  final FrasRepository _repo;

  final formKey = GlobalKey<FormState>();

  /// Logger instance for logging
  final Logger _logger = Logger();

  bool _isLoading = false;
  String? _error;

  List<Fras> _frasList = [];
  List<Fras> get frasList => List.unmodifiable(_frasList);

  FrasViewModel({
    FrasRepository? repo,
    VisualizarFrasUseCase? visualizarCasoUso,
  }) : _repo = repo ?? FrasRepository();

  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<String?> cargarFras(int charolaId) async {
    _setLoading(true);
    try {
      _frasList = await _repo.obtenerFras();
      _error = null;
      return null;
    } catch (e) {
      final msg =
          e.toString().contains('401')
              ? '🚫 401: No autorizado'
              : e.toString().contains('101')
              ? '🌐 101: Problemas de red'
              : e.toString().contains('400')
              ? '❌ 400: Datos no válidos'
              : '💥 Error de conexión';

      _logger.e(msg);
      return msg;
    } finally {
      notifyListeners();
      _setLoading(false);
    }
  }

  Future<void> editarFras(int frasId, double nuevosGramos) async {
    _setLoading(true);
    try {
      final updatedList = await _repo.editarFras(frasId, nuevosGramos);
      _frasList = updatedList;
      _error = null;
    } catch (e) {
      final msg =
          e.toString().contains('401')
              ? '🚫 401: No autorizado'
              : e.toString().contains('400')
              ? '❌ 400: Datos no válidos'
              : '💥 Error de conexión';
      _logger.e(msg);
      _error = msg;
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}