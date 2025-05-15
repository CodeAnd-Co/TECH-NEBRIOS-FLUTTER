//RF23: Registrar un nuevo tipo de comida en el sistema
//RF24: Editar un tipo de comida en el sistema - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF24

import 'package:flutter/foundation.dart';
import '../../data/models/alimentacionModel.dart';
import '../../data/repositories/alimentacionRepository.dart';
import '../../domain/editarAlimentacionDomain.dart';
import '../../domain/registrarAlimentacionDomain.dart';

/// ViewModel que controla el estado y la lógica de la pantalla
/// de alimentación (lista, edición, registro y scroll infinito).
///
/// Extiende [ChangeNotifier] para notificar a la UI de cambios.
class AlimentacionViewModel extends ChangeNotifier {
  final AlimentacionRepository _repo;
  final EditarAlimentoCasoUso _editarCasoUso;
  final RegistrarAlimentoCasoUso _registrarCasoUso;

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
    EditarAlimentoCasoUso? editarCasoUso,
    RegistrarAlimentoCasoUso? registrarCasoUso,
  })  : _repo = repo ?? AlimentacionRepository(),
        _editarCasoUso = editarCasoUso ??
            EditarAlimentoCasoUsoImpl(
              repositorio: repo ?? AlimentacionRepository(),
            ),
        _registrarCasoUso = registrarCasoUso ??
            RegistrarAlimentoCasoUsoImpl(
              repositorio: repo ?? AlimentacionRepository(),
            );

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
    Future.delayed(const Duration(milliseconds: 300), () {
      _agregarSiguienteChunk();
      _setLoading(false);
    });
  }

  /// Edita un [alimento] y vuelve a recargar datos.
  ///
  /// Valida nombre y descripción antes de enviar.
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
      if (msg.contains('500')) return '❌ Error del servidor.';
      return '❌ Error desconocido.';
    } finally {
      _setLoading(false);
    }
  }

  /// Registra un nuevo tipo de alimento y recarga la lista.
  ///
  /// Retorna `null` si fue exitoso o un mensaje de error si falla.
  Future<String?> registrarAlimento(String nombre, String descripcion) async {
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
      await _registrarCasoUso.registrar(nombre: nombre, descripcion: descripcion);
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