// RF41 Eliminar un tipo de hidratación en el sistema - Documentación: https://codeandco-wiki.netlify.app/docs/next/proyectos/larvas/documentacion/requisitos/RF41
// RF40: Editar hidratacion - https://codeandco-wiki.netlify.app/docs/next/proyectos/larvas/documentacion/requisitos/RF40
// RF42 Registrar la hidratación de la charola - Documentación: https://codeandco-wiki.netlify.app/docs/next/proyectos/larvas/documentacion/requisitos/RF42

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:zuustento_tracker/domain/registrarTipoHidratacionUseCase.dart';
import '../../data/models/hidratacionModel.dart';
import '../../data/repositories/hidratacionRepository.dart';
import '../../domain/editarHidratacionUseCase.dart';
import '../../domain/hidratarCharolaUseCase.dart';
import '../../domain/eliminarHidratacionUseCase.dart';
import '../../domain/registrarTipoHidratacionUseCase.dart';

enum EstadoViewModel { inicial, cargando, exito, error }

/// ViewModel que controla el estado y la lógica de la pantalla
/// de alimentación (lista, edición, registro y scroll infinito).
///
/// Extiende [ChangeNotifier] para notificar a la UI de cambios.
class HidratacionViewModel extends ChangeNotifier {
  final HidratacionRepository _repo;
  final HidratarCharolaUseCase _hidratarCasoUso;  
  final EditarHidratacionCasoUso _editarCasoUso;
  final EliminarHidratacionCasoUso _eliminarCasoUso;
  final RegistrarTipoHidratacionCasoUso _registrarCasoUso;

  final formKey = GlobalKey<FormState>();
  

  /// Tamaño de cada “chunk” que se mostrará por scroll.
  static const int _chunkSize = 20;

  /// Lista completa descargada desde la API.
  List<Hidratacion> _allHidratacion = [];

  /// Subconjunto actual que se muestra en pantalla.
  final List<Hidratacion> _pagedHidratacion = [];

   /// Logger instance for logging
  final Logger _logger = Logger();
  EstadoViewModel _estado = EstadoViewModel.inicial;
  EstadoViewModel get estado => _estado;

  /// Índice hasta donde ya se ha cargado.
  int _currentIndex = 0;

  bool _isLoading = false;
  String? _error;

  HidratacionViewModel({
    HidratacionRepository? repo,
    EditarHidratacionCasoUso? editarCasoUso,
    HidratarCharolaUseCase? hidratarCasoUso,
    EliminarHidratacionCasoUso? eliminarCasoUso,
    RegistrarTipoHidratacionCasoUso? registrarCasoUso,
  })  : _repo = repo ?? HidratacionRepository(),
              _editarCasoUso = editarCasoUso ?? EditarHidratacionCasoUsoImpl(repositorio: repo ?? HidratacionRepository()),
              _eliminarCasoUso = eliminarCasoUso ?? EliminarHidratacionCasoUsoImpl(repositorio: repo ?? HidratacionRepository()),
              _hidratarCasoUso = hidratarCasoUso ?? HidratarCharolaUseCase(repositorio: repo ?? HidratacionRepository()),     
              _registrarCasoUso = registrarCasoUso ?? RegistrarTipoHidratacionCasoUsoImpl( repositorio: repo ?? HidratacionRepository());

  /// Indica si actualmente se está cargando más datos.
  bool get isLoading => _isLoading;

  /// Mensaje de error si algo falla.
  String? get error => _error;

  /// Lista inmutable que la UI puede leer.
  List<Hidratacion> get listaHidratacion =>
      List.unmodifiable(_pagedHidratacion);

  /// True si quedan más ítems en [_allHidratacion] que no se han mostrado.
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

  Future<String?> eliminarHidratacion(int idHidratacion) async {
    _setLoading(true);
    _estado = EstadoViewModel.cargando;
    notifyListeners();

    try {
      await _repo.eliminarHidratacion(idHidratacion);
      _estado = EstadoViewModel.exito;
      await cargarHidratacion();
      return null;
    } catch (e) {
      
      final msg = e.toString().contains('401')
          ? '🚫 401: No autorizado'
          : e.toString().contains('101')
          ? '🌐 101: Problemas de red'
          : e.toString().contains('400')
          ? '❌ 400: Datos no válidos'
          : e.toString().contains('409')
          ? '❌ No se puede eliminar la hidratación porque está asignado a una charola'
          : '💥 Error de conexión';

      _logger.e(msg);
      _estado = EstadoViewModel.error;

      return msg;
    } finally {
      notifyListeners();
      _setLoading(false);
    }
  }

  Future<String?> editarHidratacion(Hidratacion hidratacion) async {
    if (hidratacion.nombreHidratacion.trim().isEmpty || hidratacion.descripcionHidratacion.trim().isEmpty) {
      return 'Nombre y descripción no pueden estar vacíos.';
    }
    if (RegExp(r'[0-9]').hasMatch(hidratacion.nombreHidratacion)) {
      return 'El nombre no debe contener números.';
    }

    _setLoading(true);
      _estado = EstadoViewModel.cargando;
      notifyListeners();
      try {
        await _repo.editarHidratacion(hidratacion);
        _estado = EstadoViewModel.exito;
        await cargarHidratacion();
        return null;
      } catch (e) {
        _logger.e('ERROR INTERNO: $e');

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

  /// Registra una nueva hidratación para una charola mediante el caso de uso asociado.
  ///
  /// Este método construye un objeto [HidratacionCharola] con los parámetros proporcionados
  /// y llama al caso de uso para realizar el registro en el backend. Durante el proceso:
  ///
  /// - Se activa un estado de carga mediante `_setLoading(true)`.
  /// - Se limpian errores previos.
  /// - Se capturan errores específicos según el código de estado retornado por la API.
  /// - Se desactiva el estado de carga al finalizar.
  ///
  /// Si ocurre un error durante la operación, el atributo [_error] será actualizado
  /// con un mensaje adecuado que puede ser mostrado en la interfaz.
  ///
  Future<void> registrarHidratacion({
    required int charolaId,
    required int hidratacionId,
    required int cantidadOtorgada,
    required String fechaOtorgada,
  }) async {
    _setLoading(true);
    _error = null;

    try {
      final hidratacionCharola = HidratacionCharola(
        charolaId: charolaId,
        hidratacionId: hidratacionId,
        cantidadOtorgada: cantidadOtorgada,
        fechaOtorgada: fechaOtorgada,
      );

      await _hidratarCasoUso(hidratacionCharola);

    } catch (e) {
    _error = 'Error al registrar hidratación: ${e.toString()}';
    } finally {
      _setLoading(false);
    }
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

  Future<String?> registrarTipoHidratacion(
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
