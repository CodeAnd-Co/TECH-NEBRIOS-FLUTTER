import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:flutter/material.dart';
import '../../data/models/alimentacionModel.dart';
import '../../data/repositories/alimentacionRepository.dart';
import '../../domain/editarAlimentacionUseCase.dart';
import '../../domain/eliminarAlimentacionUseCase.dart';
import '../../domain/registrarAlimentacionUseCase.dart';
import '../../domain/alimentarCharolaUseCase.dart';

enum EstadoViewModel { inicial, cargando, exito, error }

class AlimentacionViewModel extends ChangeNotifier {
  final AlimentacionRepository _repo;
  final EditarAlimentoCasoUso _editarCasoUso;
  final EliminarAlimentoCasoUso _eliminarCasoUso;
  final RegistrarAlimentoCasoUso _registrarCasoUso;
  final AlimentarCharolaUseCase _alimentarCasoUso;

  final formKey = GlobalKey<FormState>();

  static const int _chunkSize = 20;
  List<Alimento> _allAlimentos = [];
  final List<Alimento> _pagedAlimentos = [];
  /// Logger instance for logging
  final Logger _logger = Logger();
  EstadoViewModel _estado = EstadoViewModel.inicial;
  EstadoViewModel get estado => _estado;

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

  Future<String?> eliminarAlimento(int idAlimento) async {
    _setLoading(true);
    _estado = EstadoViewModel.cargando;
    notifyListeners();

    try {
      await _repo.eliminarAlimento(idAlimento);
      _estado = EstadoViewModel.exito;
      await cargarAlimentos();
      return null;
    } catch (e) {
      final msg = e.toString().contains('401')
          ? '🚫 401: No autorizado'
          : e.toString().contains('101')
          ? '🌐 101: Problemas de red'
          : e.toString().contains('400')
          ? '❌ 400: Datos no válidos'
          : e.toString().contains('409')
          ? '❌ No se puede eliminar el alimento porque está asignado a una charola'
          : '💥 Error de conexión';

      _logger.e(msg);
      _estado = EstadoViewModel.error;
      return msg;
    } finally {
      notifyListeners();
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
      _estado = EstadoViewModel.cargando;
      notifyListeners();
      try {
        await _repo.editarAlimento(alimento);
        _estado = EstadoViewModel.exito;
        await cargarAlimentos();
        return null;
      }catch (e) {
        final msg = e.toString().contains('401')
            ? '🚫 401: No autorizado'
            : e.toString().contains('101')
            ? '🌐 101: Problemas de red'
            : e.toString().contains('400')
            ? '❌ 400: Datos no válidos'
            : '💥 Error de conexión';

        _logger.e(msg);
        _estado = EstadoViewModel.error;
        return msg;
      }
      finally {
        notifyListeners();
        _setLoading(false);
      }
  }

  Future<String?> registrarAlimento(String nombre, String descripcion) async {
    if (nombre.trim().isEmpty || descripcion.trim().isEmpty) {
      return 'Nombre y descripción no pueden estar vacíos.';
    }
    if (nombre.length > 20) {
      return 'El nombre no puede tener más de 20 caracteres.';
    }
    if (descripcion.length > 200) {
      return 'La descripción no puede tener más de 200 caracteres.';
    }
    if (RegExp(r'[0-9]').hasMatch(nombre)) {
      return 'El nombre no debe contener números.';
    }

    _setLoading(true);
      _estado = EstadoViewModel.cargando;
      notifyListeners();

      try {
        await _repo.postDatosAlimento(nombre, descripcion);
        _estado = EstadoViewModel.exito;
        await cargarAlimentos();
        return null;
      } catch (e) {
        final msg = e.toString().contains('401')
            ? '🚫 401: No autorizado'
            : e.toString().contains('101')
            ? '🌐 101: Problemas de red'
            : e.toString().contains('400')
            ? '❌ 400: Datos no válidos'
            : '💥 Error de conexión';

        _logger.e(msg);
        _estado = EstadoViewModel.error;
        return msg;
      } finally {
        notifyListeners();
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
  _error = null;
  try {
    final comidaCharola = ComidaCharola(
      charolaId: charolaId,
      comidaId: comidaId,
      cantidadOtorgada: cantidadOtorgada,
      fechaOtorgada: fechaOtorgada,
    );
    await _alimentarCasoUso(comidaCharola);
  } catch (e) {
    _error = 'Error al registrar alimentación: ${e.toString()}';
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
