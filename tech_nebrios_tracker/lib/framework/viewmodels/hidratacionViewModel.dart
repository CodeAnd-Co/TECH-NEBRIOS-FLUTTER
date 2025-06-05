// RF41 Eliminar un tipo de hidratación en el sistema - Documentación: https://codeandco-wiki.netlify.app/docs/next/proyectos/larvas/documentacion/requisitos/RF41
// RF42 Registrar la hidratación de la charola - Documentación: https://codeandco-wiki.netlify.app/docs/next/proyectos/larvas/documentacion/requisitos/RF42

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../../data/models/hidratacionModel.dart';
import '../../data/repositories/hidratacionRepository.dart';
import '../../domain/hidratarCharolaUseCase.dart';
import '../../domain/eliminarHidratacionUseCase.dart';

enum EstadoViewModel { inicial, cargando, exito, error }


/// ViewModel que controla el estado y la lógica de la pantalla
/// de alimentación (lista, edición, registro y scroll infinito).
///
/// Extiende [ChangeNotifier] para notificar a la UI de cambios.
class HidratacionViewModel extends ChangeNotifier {
  final HidratacionRepository _repo;
  final EliminarHidratacionCasoUso _eliminarCasoUso;
  final HidratarCharolaUseCase _hidratarCasoUso;

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
    HidratarCharolaUseCase? hidratarCasoUso,
    EliminarHidratacionCasoUso? eliminarCasoUso,
  })  : _repo = repo ?? HidratacionRepository(),
        _hidratarCasoUso = hidratarCasoUso ?? HidratarCharolaUseCase(repositorio: repo ?? HidratacionRepository()),
        _eliminarCasoUso = eliminarCasoUso ?? EliminarAlimentoCasoUsoImpl(repositorio: repo ?? HidratacionRepository()); 

  /// Indica si actualmente se está cargando más datos.
  bool get isLoading => _isLoading;

  /// Mensaje de error si algo falla.
  String? get error => _error;

  /// Lista inmutable que la UI puede leer.
  List<Hidratacion> get listaHidratacion => List.unmodifiable(_pagedHidratacion);

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
  /// Registra una nueva hidratación para una charola mediante el caso de uso asociado.
  ///
  /// Este método construye un objeto [HidratarCharola] con los parámetros proporcionados
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

    } on Exception catch (e) {
      final mensaje = e.toString();

      if (mensaje.contains('400')) {
        _error = '❌ Datos inválidos. Revisa la información ingresada.';
      } else if (mensaje.contains('101')) {
        _error = '❌ Sin conexión a internet.';
      } else if (mensaje.contains('500')) {
        _error = '❌ Error del servidor. Intenta más tarde.';
      } else {
        _error = '❌ Ocurrió un error: ${mensaje.replaceAll('Exception: ', '')}';
      }

    } finally {
      _setLoading(false);
    }
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

  /// Toma el siguiente rango de [_chunkSize] ítems y los añade.
  void _agregarSiguienteChunk() {
    final nextIndex = (_currentIndex + _chunkSize).clamp(
      0,
      _allHidratacion.length,
    );
    _pagedHidratacion.addAll(_allHidratacion.getRange(_currentIndex, nextIndex));
    _currentIndex = nextIndex;
    notifyListeners();
  }

  /// Cambia [_isLoading] y notifica a la UI.
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
