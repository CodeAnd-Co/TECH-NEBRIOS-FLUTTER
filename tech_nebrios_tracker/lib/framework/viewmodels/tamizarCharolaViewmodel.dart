// RF20 Tamizar charolas - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF16

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../../data/models/menuCharolasModel.dart';
import '../views/tamizarCharolaIndividualView.dart';
import '../views/tamizarMultiplesCharolasView.dart';

/// ViewModel encargado de gestionar los datos de las charolas que se van a tamizar.
/// Implementa la vista previa de selección de charolas.
class TamizadoViewModel extends ChangeNotifier {
  final Logger _logger = Logger();

  /// Se definen controladores para el texto
  final frasController = TextEditingController();
  final pupaController = TextEditingController();
  final alimentoCantidadController = TextEditingController();
  final hidratacionCantidadController = TextEditingController();
  /// Lista de charolas actualmente mostradas en la vista.
  List<Charola> charolasParaTamizar = [];

  /// Estado de carga actual.
  bool cargando = false;

  String _errorMessage = '';
  bool _hasError = false;
  
  String get errorMessage => _errorMessage;
  bool get hasError => _hasError;

  Future<void> tamizarCharola() async {
    try {
      cargando = true;
      notifyListeners();

      // Simulación de una llamada a la API
      await Future.delayed(const Duration(seconds: 2));

      // Aquí puedes agregar la lógica para tamizar las charolas seleccionadas
      // Por ejemplo, enviar una solicitud a la API para tamizar las charolas

      cargando = false;
      notifyListeners();
    } catch (e) {
      _hasError = true;
      _errorMessage = 'Error al tamizar la charola. Inténtalo de nuevo más tarde.';
      cargando = false;
      notifyListeners();
    }
  }

  void siguienteInterfaz(BuildContext context) {
    if(charolasParaTamizar.isEmpty) {
      _hasError = true;
      _errorMessage = 'No hay charolas seleccionadas para tamizar.';
      notifyListeners();
    } else if(charolasParaTamizar.length == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VistaTamizadoIndividual(),
        ),
      );
    }else{
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VistaTamizadoMultiple(),
        ),
      );
    }
  }

  void agregarCharola(Charola charola) {
    if (charolasParaTamizar.length < 5) {
      charolasParaTamizar.add(charola);
      notifyListeners();
    }
    else {
      _hasError = true;
      _errorMessage = 'No se pueden tamizar más de 5 charolas.';
      notifyListeners();
    }
  }

  void quitarCharola(Charola charola) {
    charolasParaTamizar.remove(charola);
    _hasError = false;
    notifyListeners();
  }

}

