// RF10 https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF10

import 'package:flutter/material.dart';
import '../../domain/consular_charola.dart';
import '../../domain/eliminar_charola.dart';
import '../../data/models/charola_model.dart';

class CharolaViewModel extends ChangeNotifier {
  final ObtenerCharolaUseCase _useCase;
  final EliminarCharolaUseCase _eliminarUseCase;

  CharolaViewModel(this._useCase, this._eliminarUseCase);

  Charola? _charola;
  Charola? get charola => _charola;

  bool _cargando = false;
  bool get cargando => _cargando;

  Future<void> cargarCharola(int id) async {
    _cargando = true;
    notifyListeners();

    try {
      _charola = await _useCase.obtenerCharola(id);
    } catch (e) {
      _charola = null;
    }

    _cargando = false;
    notifyListeners();
  }

  Future<void> eliminarCharola(int id) async {
    _cargando = true;
    notifyListeners();

    try {
      await _eliminarUseCase.eliminar(id);
      _charola = null; // Opcional, si quieres limpiar el estado
    } catch (e) {
      // Manejo de errores
    }

    _cargando = false;
    notifyListeners();
  }
}
