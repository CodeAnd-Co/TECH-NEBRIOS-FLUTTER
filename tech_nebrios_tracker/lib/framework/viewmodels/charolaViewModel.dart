// RF16 Visualizar todas las charolas registradas en el sistema - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF16

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../../data/repositories/charolaRepository.dart';
import '../../domain/consultarCharolaUseCase.dart';
import '../../domain/eliminarCharolaUseCase.dart';
import '../../domain/charolasDashboardUseCase.dart';
import '../../data/models/charolaModel.dart';

/// ViewModel encargado de gestionar el estado de la vista de charolas.
class CharolaViewModel extends ChangeNotifier {
  final _logger = Logger();

  late final ObtenerCharolaUseCase _obtenerUseCase;
  late final EliminarCharolaUseCase _eliminarUseCase;
  late final ObtenerMenuCharolas _menuUseCase;

  /// Constructor sin parámetros: crea repo y use-cases internamente.
  CharolaViewModel() {
    final repo = CharolaRepository();
    _obtenerUseCase = ObtenerCharolaUseCaseImpl(charolaRepository: repo);
    _eliminarUseCase = EliminarCharolaUseCaseImpl(charolaRepository: repo);
    _menuUseCase = ObtenerCharolasUseCaseImpl(repositorio: repo);

    // Carga inicial de listado
    cargarCharolas();
  }

  // === DETALLE DE CHAROLA ===
  CharolaDetalle? _charola;
  CharolaDetalle? get charola => _charola;

  bool _cargandoCharola = false;
  bool get cargandoCharola => _cargandoCharola;

  Future<void> cargarCharola(int id) async {
    _cargandoCharola = true; notifyListeners();
    try {
      _charola = await _obtenerUseCase.obtenerCharola(id);
    } catch (_) {
      _charola = null;
    }
    _cargandoCharola = false; notifyListeners();
  }

  Future<void> eliminarCharola(int id) async {
    _cargandoCharola = true; notifyListeners();
    try {
      await _eliminarUseCase.eliminar(id);
      _charola = null;
    } catch (e) {
      _logger.e('Error eliminando charola: $e');
    }
    _cargandoCharola = false; notifyListeners();
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

  Future<void> cargarCharolas({bool reset = false}) async {
    if (_cargandoLista) return;

    if (reset) {
      pagActual = 1;
      charolas.clear();
    }

    // if (refresh) {
    //   charolas.clear();
    //   pagActual = 1;
    //   hayMas = true;
    // }
    _cargandoLista = true; 
    notifyListeners();

    try {
      final dash = await _menuUseCase.ejecutar(pag: pagActual, limite: limite, estado: estadoActual);
      if (dash != null) {
        charolas = dash.data;
        totalPags = dash.totalPags;
        hayMas = pagActual < totalPags;
      }
    } catch (e) {
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

  void cargarPaginaAnterior() {
    if (pagActual > 1) {
      pagActual--;
      cargarCharolas();
    }
  }

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
