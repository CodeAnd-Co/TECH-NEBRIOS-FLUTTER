import 'package:flutter/foundation.dart';
import '../../data/models/alimentacionModel.dart';
import '../../data/repositories/alimentacionRepository.dart';
import '../../domain/editarAlimentacionUseCase.dart';
import '../../domain/eliminarAlimentacionUseCase.dart';
import '../../domain/registrarAlimentacionUseCase.dart';
import '../../domain/alimentarCharolaUseCase.dart';

class AlimentacionViewModel extends ChangeNotifier {
  final AlimentacionRepository _repo;
  final EditarAlimentoCasoUso _editarCasoUso;
  final EliminarAlimentoCasoUso _eliminarCasoUso;
  final RegistrarAlimentoCasoUso _registrarCasoUso;
  final AlimentarCharolaUseCase _alimentarCasoUso;

  static const int _chunkSize = 20;
  List<Alimento> _allAlimentos = [];
  final List<Alimento> _pagedAlimentos = [];
  int _currentIndex = 0;

  bool _isLoading = false;
  String? _error;

  AlimentacionViewModel({
    AlimentacionRepository? repo,
    EditarAlimentoCasoUso? editarCasoUso,
    EliminarAlimentoCasoUso? eliminarCasoUso,
    RegistrarAlimentoCasoUso? registrarCasoUso,
    AlimentarCharolaUseCase? alimentarCasoUso,
  })  : _repo = repo ?? AlimentacionRepository(),
        _editarCasoUso = editarCasoUso ?? EditarAlimentoCasoUsoImpl(repositorio: repo ?? AlimentacionRepository()),
        _registrarCasoUso = registrarCasoUso ?? RegistrarAlimentoCasoUsoImpl(repositorio: repo ?? AlimentacionRepository()),
        _eliminarCasoUso = eliminarCasoUso ?? EliminarAlimentoCasoUsoImpl(repositorio: repo ?? AlimentacionRepository()),
        _alimentarCasoUso = alimentarCasoUso ?? AlimentarCharolaUseCase(repositorio: repo ?? AlimentacionRepository());

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Alimento> get alimentos => List.unmodifiable(_pagedAlimentos);
  bool get hasMore => _currentIndex < _allAlimentos.length;

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

  void cargarMas() {
    if (_isLoading || !hasMore) return;
    _setLoading(true);
    Future.delayed(const Duration(milliseconds: 300), () {
      _agregarSiguienteChunk();
      _setLoading(false);
    });
  }

  Future<void> eliminarAlimento(int idAlimento) async {
    _setLoading(true);
    try {
      await _eliminarCasoUso.eliminar(idAlimento: idAlimento);
      await cargarAlimentos();
    } on Exception catch (e) {
      final msg = e.toString();
      if (msg.contains('500')) throw Exception('❌ Error del servidor.');
      throw Exception('❌ Error desconocido. $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<String?> editarAlimento(Alimento alimento) async {
    if (alimento.nombreAlimento.trim().isEmpty || alimento.descripcionAlimento.trim().isEmpty) {
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

  Future<void> registrarAlimentacion({
  required int charolaId,
  required int comidaId,
  required int cantidadOtorgada,
  required String fechaOtorgada,
}) async {
  _setLoading(true);
  _error = null; // ✅ Asegúrate de limpiar el error antes de empezar
  try {
    final comidaCharola = ComidaCharola(
      charolaId: charolaId,
      comidaId: comidaId,
      cantidadOtorgada: cantidadOtorgada,
      fechaOtorgada: fechaOtorgada,
    );
    await _alimentarCasoUso(comidaCharola);
  } catch (e) {
    _error = 'Error al registrar alimentación: ${e.toString()}'; // ✅ Más útil
  } finally {
    _setLoading(false);
  }
}


  void _agregarSiguienteChunk() {
    final nextIndex = (_currentIndex + _chunkSize).clamp(0, _allAlimentos.length);
    _pagedAlimentos.addAll(_allAlimentos.getRange(_currentIndex, nextIndex));
    _currentIndex = nextIndex;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
