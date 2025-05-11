// RF16 Visualizar todas las charolas registradas en el sistema - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF16

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../../data/models/menuCharolasModel.dart';
import '../../domain/getMenuCharolas.dart';

/// ViewModel encargado de gestionar el estado de la vista de charolas.
/// Implementa la lógica de paginación, carga desde el caso de uso y control de errores.
class CharolaVistaModelo extends ChangeNotifier {
  final Logger _logger = Logger();
  /// Caso de uso para obtener las charolas desde el repositorio.
  final ObtenerMenuCharolas obtenerCharolasCasoUso;
    

  /// Constructor con opción de inyectar una implementación personalizada.
  CharolaVistaModelo({ObtenerMenuCharolas? casoUso})
      : obtenerCharolasCasoUso = casoUso ?? ObtenerCharolasCasoUsoImpl(){
        cargarCharolas();
      }

  /// Lista de charolas actualmente mostradas en la vista.
  List<Charola> charolas = [];

  /// Página actual en la paginación.
  int pagActual = 1;

  /// Cantidad de elementos por página (valor fijo por ahora).
  final int limite = 15;

  /// Estado de carga actual.
  bool cargando = false;

  /// Indica si hay más páginas por cargar.
  bool hayMas = true;

  /// Total de páginas disponibles según la API.
  int totalPags = 1;

  /// Estado de las charola al inicio "activa" o "pasada".
  String estadoActual = 'activa';

  /// Carga charolas desde la API. Si refresh es true, reinicia paginación.
  Future<void> cargarCharolas({bool refresh = false}) async {
    if (cargando) return;

    if (refresh) {
      charolas.clear();
      hayMas = true;
    }

    cargando = true;
    notifyListeners();

    try {
      final respuesta = await obtenerCharolasCasoUso.ejecutar(pag: pagActual, limite: limite, estado: estadoActual);

      if (respuesta != null) {
        charolas.addAll(respuesta.data);
        totalPags = respuesta.totalPags;
        hayMas = pagActual < totalPags;
      }
    } catch (e) {
      String mensajeError;

      if (e.toString().contains('401')) {
        mensajeError = '🚫 Error 401: No autorizado. Por favor, inicie sesión.';
      } else if (e.toString().contains('101')) {
        mensajeError = '🌐 Error 101: Problemas de red. Verifica tu conexión a internet.';
      } else {
        mensajeError = '💥 Error 500: Fallo interno del servidor. Inténtalo más tarde.';
      }
      _logger.e(mensajeError);
    } finally {
      cargando = false;
      notifyListeners();
    }
  }

  /// Carga la página anterior, si existe.
  void cargarPaginaAnterior() {
    if (pagActual > 1) {
      pagActual--;
      cargarCharolas(refresh: true);
    }
  }

  /// Carga la siguiente página, si existe.
  void cargarPaginaSiguiente() {
    if (pagActual < totalPags) {
      pagActual++;
      cargarCharolas(refresh: true);
    }
  }

  /// Carga a la primera página con el ToggleButton.
  void cambiarEstado(String nuevoEstado) {
  estadoActual = nuevoEstado;
  pagActual = 1;
  cargarCharolas(refresh: true);
}

}

