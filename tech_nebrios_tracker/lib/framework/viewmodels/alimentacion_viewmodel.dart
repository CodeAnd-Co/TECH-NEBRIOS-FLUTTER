//RF25: Eliminar un tipo de comida en el sistema - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF25

import 'package:flutter/foundation.dart';
import '../../data/models/alimentacion_model.dart';
import '../../data/repositories/alimentacion_repository.dart';
import '../../domain/alimentacion_domain.dart';

/// ViewModel que controla el estado y la lógica de la pantalla
/// de alimentación (lista, edición y scroll infinito).
///
/// Extiende [ChangeNotifier] para notificar a la UI de cambios.
class AlimentacionViewModel extends ChangeNotifier {
  final AlimentacionRepository _repo;
  final EliminarAlimentoCasoUso _eliminarCasoUso;

  /// Tamaño de cada “chunk” que se mostrará por scroll.
  static const int _chunkSize = 20;

  /// Lista completa descargada desde la API.
  List<Alimento> _allAlimentos = [];

  /// Subconjunto actual que se muestra en pantalla.
  final List<Alimento> _pagedAlimentos = [];

  /// Índice hasta donde ya se ha cargado.
  int _currentIndex = 0;

  bool _isLoading = false;
  String? _error;

  AlimentacionViewModel({
    AlimentacionRepository? repo,
    EliminarAlimentoCasoUso? eliminarCasoUso,
  })  : _repo = repo ?? AlimentacionRepository(),
        _eliminarCasoUso = eliminarCasoUso ??
            EliminarAlimentoCasoUsoImpl(repositorio: repo ?? AlimentacionRepository());

  /// Indica si actualmente se está cargando más datos.
  bool get isLoading => _isLoading;

  /// Mensaje de error si algo falla.
  String? get error => _error;

  /// Lista inmutable que la UI puede leer.
  List<Alimento> get alimentos => List.unmodifiable(_pagedAlimentos);

  /// True si quedan más ítems en [_allAlimentos] que no se han mostrado.
  bool get hasMore => _currentIndex < _allAlimentos.length;

  /// Descarga toda la lista y carga el primer chunk.
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

  /// Agrega un nuevo chunk simulado al final de la lista actual.
  void cargarMas() {
    if (_isLoading || !hasMore) return;
    _setLoading(true);
    // Simula retardo para mejor UX
    Future.delayed(const Duration(milliseconds: 300), () {
      _agregarSiguienteChunk();
      _setLoading(false);
    });
  }

  /// Elimina un alimento de la lista y vuelve a cargar datos.
  ///
  /// Lanza excepción si no se puede eliminar.
  Future<void> eliminarAlimento(int idAlimento) async {
    _setLoading(true);
    try {
      await _eliminarCasoUso.eliminar(idAlimento: idAlimento);
      await cargarAlimentos();
    } on Exception catch (e) {
      final msg = e.toString();
      if (msg.contains('500')) throw Exception('❌ Error del servidor.');
      throw Exception('❌ Error desconocido.');
    } finally {
      _setLoading(false);
    }
  }

  /// Toma el siguiente rango de [_chunkSize] ítems y los añade.
  void _agregarSiguienteChunk() {
    final nextIndex = (_currentIndex + _chunkSize).clamp(0, _allAlimentos.length);
    _pagedAlimentos.addAll(
      _allAlimentos.getRange(_currentIndex, nextIndex),
    );
    _currentIndex = nextIndex;
    notifyListeners();
  }

  /// Cambia [_isLoading] y notifica a la UI.
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}