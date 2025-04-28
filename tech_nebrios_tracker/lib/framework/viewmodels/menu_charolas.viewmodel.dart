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
      pagActual = 1; // 👈 (opcional) resetear página si refrescas
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
      print('❌ Error al cargar charolas: $e');
      // Si quieres, podrías guardar este error en una variable para la UI
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
