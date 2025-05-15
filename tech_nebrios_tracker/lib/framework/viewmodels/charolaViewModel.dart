// RF16 Visualizar todas las charolas registradas en el sistema - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF16
// RF10 Consultar información detallada de una charola https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF10
// RF8 Eliminar Charola https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF8

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../../data/repositories/charolaRepository.dart';
import '../../domain/consultarCharolaUseCase.dart';
import '../../domain/eliminarCharolaUseCase.dart';
import '../../domain/charolasDashboardUseCase.dart';
import '../../data/models/charolaModel.dart';

/// ViewModel encargado de manejar el estado de una charola y su lista
class CharolaViewModel extends ChangeNotifier {
  final _logger = Logger(); // Logger para errores o información

  // Casos de uso para operaciones relacionadas a charolas
  late final ObtenerCharolaUseCase _obtenerUseCase;
  late final EliminarCharolaUseCase _eliminarUseCase;
  late final ObtenerMenuCharolas _menuUseCase;

  /// Constructor sin parámetros que inicializa los casos de uso con el repositorio
  CharolaViewModel() {
    final repo = CharolaRepository();
    _obtenerUseCase = ObtenerCharolaUseCaseImpl(charolaRepository: repo);
    _eliminarUseCase = EliminarCharolaUseCaseImpl(charolaRepository: repo);
    _menuUseCase = ObtenerCharolasUseCaseImpl(repositorio: repo);

    // Carga inicial del listado de charolas
    cargarCharolas();
  }

  // === DETALLE DE UNA CHAROLA ===
  CharolaDetalle? _charola; // Detalle de la charola actual
  CharolaDetalle? get charola => _charola; // Getter del detalle

  bool _cargandoCharola = false; // Bandera para indicar si se está cargando el detalle
  bool get cargandoCharola => _cargandoCharola;

  /// Carga el detalle de una charola por ID
  Future<void> cargarCharola(int id) async {
    _cargandoCharola = true; 
    notifyListeners(); // Notifica a la UI que está cargando
    try {
      _charola = await _obtenerUseCase.obtenerCharola(id); // Llama al caso de uso
    } catch (_) {
      _charola = null; // Si hay error, se deja en null
    }
    _cargandoCharola = false; 
    notifyListeners(); // Notifica que terminó de cargar
  }

  /// Elimina una charola por ID
  Future<void> eliminarCharola(int id) async {
    _cargandoCharola = true; 
    notifyListeners();
    try {
      await _eliminarUseCase.eliminar(id); // Llama al caso de uso de eliminación
      _charola = null; // Limpia el detalle después de eliminar
    } catch (e) {
      _logger.e('Error eliminando charola: $e'); // Registra el error
    }
    _cargandoCharola = false; 
    notifyListeners();
  }

  // === LISTADO PAGINADO ===
  List<CharolaTarjeta> charolas = [];
  int pagActual = 1;
  final int limite = 100;
  bool _cargandoLista = false;
  bool get cargandoLista => _cargandoLista;
  bool hayMas = true;
  int totalPags = 1;
  String estadoActual = 'activa';

  /// Carga la lista de charolas con paginación. Si [reset] es true, reinicia la paginación.
  Future<void> cargarCharolas({bool reset = false}) async {
    if (_cargandoLista) return; // Previene múltiples cargas simultáneas

    if (reset) {
      pagActual = 1;
      charolas.clear(); // Limpia lista si es reinicio
    }

    _cargandoLista = true; 
    notifyListeners();

    try {
      final dash = await _menuUseCase.ejecutar(pag: pagActual, limite: limite, estado: estadoActual);
      if (dash != null) {
        charolas = dash.data; // Asigna las nuevas charolas
        totalPags = dash.totalPags; // Total de páginas disponibles
        hayMas = pagActual < totalPags; // Verifica si hay más páginas
      }
    } catch (e) {
      // Manejo básico de errores comunes con logs personalizados
      final msg = e.toString().contains('401')
        ? '🚫 401: No autorizado'
        : e.toString().contains('101')
          ? '🌐 101: Problemas de red'
          : '💥 Error interno del servidor';
      _logger.e(msg);
    } finally {
      _cargandoLista = false; 
      notifyListeners();
    }
  }

  /// Carga la página anterior si existe
  void cargarPaginaAnterior() {
    if (pagActual > 1) {
      pagActual--;
      cargarCharolas();
    }
  }

  /// Carga la página siguiente si no es la última
  void cargarPaginaSiguiente() {
    if (pagActual < totalPags) {
      pagActual++;
      cargarCharolas();
    }
  }

  void cambiarEstado(String nuevoEstado) {
  estadoActual = nuevoEstado;
  pagActual = 1;
  cargarCharolas(reset: true);
  }
}
