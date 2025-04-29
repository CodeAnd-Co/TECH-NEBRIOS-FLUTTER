// RF16 Visualizar todas las charolas registradas en el sistema - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF16

import 'package:flutter/material.dart';
import '../../data/models/menu_charolas.model.dart';
import '../../domain/get_menu_charolas.dart';

class CharolaVistaModelo extends ChangeNotifier {
  final ObtenerMenuCharolas obtenerCharolasCasoUso;

  CharolaVistaModelo({ObtenerMenuCharolas? casoUso})
      : obtenerCharolasCasoUso = casoUso ?? ObtenerCharolasCasoUsoImpl();

  List<Charola> charolas = [];
  int pagActual = 1;
  final int limite = 12;
  bool cargando = false;
  bool hayMas = true;
  int totalPags = 1;

  Future<void> cargarCharolas({bool refresh = false}) async {
    if (cargando) return;

    if (refresh) {
      charolas.clear();
      hayMas = true;
    }

    cargando = true;
    notifyListeners();

    print("🔗 ViewModel intenta cargar charolas desde la API (page: $pagActual, limit: $limite)");

    try {
      final respuesta = await obtenerCharolasCasoUso.ejecutar(pag: pagActual, limite: limite);

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

      print(mensajeError);
    } finally {
      cargando = false;
      notifyListeners();
    }
  }

  void cargarPaginaAnterior() {
    if (pagActual > 1) {
      pagActual--;
      cargarCharolas(refresh: true); // limpiar antes de cargar
    }
  }

  void cargarPaginaSiguiente() {
    if (pagActual < totalPags) {
      pagActual++;
      cargarCharolas(refresh: true);
    }
  }
}
