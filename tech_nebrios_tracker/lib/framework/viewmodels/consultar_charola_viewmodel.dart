// RF10 https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF10

import 'package:flutter/material.dart';
import '../../domain/consular_charola.dart';
import '../../data/models/charola_model.dart';

class CharolaViewModel extends ChangeNotifier {
  final ObtenerCharolaUseCase _useCase;

  CharolaViewModel(this._useCase);

  Charola? _charola;
  Charola? get charola => _charola;

  bool _cargando = false;
  bool get cargando => _cargando;

  Future<void> cargarCharola(int id) async {
    _cargando = true;
    notifyListeners();

    _charola = await _useCase.obtenerCharola(id);

    _cargando = false;
    notifyListeners();
  }
}
