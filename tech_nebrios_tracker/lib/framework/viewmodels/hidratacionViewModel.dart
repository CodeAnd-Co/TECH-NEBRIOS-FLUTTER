import 'package:flutter/foundation.dart';
import 'package:tech_nebrios_tracker/domain/registrarHidratacionUseCase.dart';
import '../../data/models/hidratacionModel.dart';
import '../../data/repositories/hidratacionRepository.dart';

/// ViewModel que controla el estado y la lógica de la pantalla
/// de alimentación (lista, edición, registro y scroll infinito).
///
/// Extiende [ChangeNotifier] para notificar a la UI de cambios.
class HidratacionViewModel extends ChangeNotifier {
  final HidratacionRepository _repo;
  final RegistrarHidratacionCasoUso _registrarCasoUso;

  /// Tamaño de cada “chunk” que se mostrará por scroll.
  static const int _chunkSize = 20;

  /// Lista completa descargada desde la API.
  List<Hidratacion> _allHidratacion = [];

  /// Subconjunto actual que se muestra en pantalla.
  final List<Hidratacion> _pagedHidratacion = [];

  /// Índice hasta donde ya se ha cargado.
  int _currentIndex = 0;

  bool _isLoading = false;
  String? _error;

  HidratacionViewModel({
    HidratacionRepository? repo,
    RegistrarHidratacionCasoUso? registrarCasoUso,
  }) : _repo = repo ?? HidratacionRepository(),
       _registrarCasoUso =
           registrarCasoUso ??
           RegistrarHidratacionCasoUsoImpl(
             repositorio: repo ?? HidratacionRepository(),
           );

  /// Indica si actualmente se está cargando más datos.
  bool get isLoading => _isLoading;

  /// Mensaje de error si algo falla.
  String? get error => _error;

  /// Lista inmutable que la UI puede leer.
  List<Hidratacion> get listaHidratacion =>
      List.unmodifiable(_pagedHidratacion);

  /// True si quedan más ítems en [_allAlimentos] que no se han mostrado.
  bool get hasMore => _currentIndex < _allHidratacion.length;

  /// Descarga toda la lista y carga el primer chunk.
  Future<void> cargarHidratacion() async {
    _setLoading(true);
    try {
      _allHidratacion = await _repo.obtenerHidratacion();
      _pagedHidratacion.clear();
      _currentIndex = 0;
      _agregarSiguienteChunk();
      _error = null;
    } catch (e) {
      _error = 'Error al cargar hidratación: $e';
    } finally {
      _setLoading(false);
    }
  }

  /// Agrega un nuevo chunk simulado al final de la lista actual.
  void cargarMas() {
    if (_isLoading || !hasMore) return;
    _setLoading(true);
    Future.delayed(const Duration(milliseconds: 300), () {
      _agregarSiguienteChunk();
      _setLoading(false);
    });
  }

  /// Toma el siguiente rango de [_chunkSize] ítems y los añade.
  void _agregarSiguienteChunk() {
    final nextIndex = (_currentIndex + _chunkSize).clamp(
      0,
      _allHidratacion.length,
    );
    _pagedHidratacion.addAll(
      _allHidratacion.getRange(_currentIndex, nextIndex),
    );
    _currentIndex = nextIndex;
    notifyListeners();
  }

  /// Cambia [_isLoading] y notifica a la UI.
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<String?> registrarHidratacion(
    String nombre,
    String descripcion,
  ) async {
    if (nombre.trim().isEmpty || descripcion.trim().isEmpty) {
      return 'Nombre y descripción no pueden estar vacíos.';
    }
    if (nombre.length > 25) {
      return 'El nombre no puede tener más de 25 caracteres.';
    }
    if (descripcion.length > 200) {
      return 'La descripción no puede tener más de 200 caracteres.';
    }
    if (RegExp(r'[0-9]').hasMatch(nombre)) {
      return 'El nombre no debe contener números.';
    }

    _setLoading(true);
    try {
      await _registrarCasoUso.registrar(
        nombre: nombre,
        descripcion: descripcion,
      );
      await cargarHidratacion();
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
}
