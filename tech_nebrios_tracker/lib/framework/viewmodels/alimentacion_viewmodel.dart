import 'package:flutter/foundation.dart';

import '../../data/models/alimentacion_model.dart';
import '../../data/repositories/alimentacion_repository.dart';
import '../../domain/alimentacion_domain.dart';

class AlimentacionViewModel extends ChangeNotifier {
  final AlimentacionRepository _repo;
  final EditarAlimentoCasoUso _editarCasoUso;

  // —— Estado de scroll infinito —— 
  static const int _chunkSize = 20;
  List<Alimento> _allAlimentos = [];
  final List<Alimento> _pagedAlimentos = [];
  int _currentIndex = 0;

  bool _isLoading = false;
  String? _error;

  AlimentacionViewModel({
    AlimentacionRepository? repo,
    EditarAlimentoCasoUso? editarCasoUso,
  })  : _repo = repo ?? AlimentacionRepository(),
        _editarCasoUso = editarCasoUso ??
            EditarAlimentoCasoUsoImpl(
              repositorio: repo ?? AlimentacionRepository(),
            );

  // —— Getters expuestos —— 
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Alimento> get alimentos => List.unmodifiable(_pagedAlimentos);
  bool get hasMore => _currentIndex < _allAlimentos.length;

  /// Carga toda la lista desde la API y llena el primer chunk
  Future<void> cargarAlimentos() async {
    _setLoading(true);
    try {
      _allAlimentos = await _repo.obtenerAlimentos();
      _pagedAlimentos.clear();
      _currentIndex = 0;
      _agregarSiguienteChunk();
      _error = null;
    } catch (e) {
      _error = 'Error al cargar alimentos: $e';
    } finally {
      _setLoading(false);
    }
  }

  /// Agrega el siguiente chunk de ítems a la lista visible
  void cargarMas() {
    if (_isLoading || !hasMore) return;

    _setLoading(true);
    Future.delayed(const Duration(milliseconds: 300), () {
      _agregarSiguienteChunk();
      _setLoading(false);
    });
  }

  /// Caso de uso: editar un alimento y refrescar la lista
  Future<String?> editarAlimento(Alimento alimento) async {
    if (alimento.nombreAlimento.trim().isEmpty ||
        alimento.descripcionAlimento.trim().isEmpty) {
      return 'Nombre y descripción no pueden estar vacíos.';
    }
    if (RegExp(r'[0-9]').hasMatch(alimento.nombreAlimento)) {
      return 'El nombre no debe contener números.';
    }

    _setLoading(true);
    try {
      await _editarCasoUso.editar(alimento: alimento);
      await cargarAlimentos();
      return null;
    } on Exception catch (e) {
      final msg = e.toString();
      if (msg.contains('400')) return '❌ Datos no válidos.';
      if (msg.contains('101')) return '❌ Sin conexión a internet.';
      if (msg.contains('500')) return '❌ Error del servidor.';
      return '❌ Error desconocido.';
    } finally {
      _setLoading(false);
    }
  }

  /// Toma el siguiente rango de [_chunkSize] ítems de [_allAlimentos]
  void _agregarSiguienteChunk() {
    final nextIndex = (_currentIndex + _chunkSize).clamp(0, _allAlimentos.length);
    _pagedAlimentos.addAll(
      _allAlimentos.getRange(_currentIndex, nextIndex),
    );
    _currentIndex = nextIndex;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
