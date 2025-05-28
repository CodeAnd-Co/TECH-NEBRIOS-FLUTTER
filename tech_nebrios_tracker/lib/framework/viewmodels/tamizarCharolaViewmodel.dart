// RF20 Tamizar charolas - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF16

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../../data/models/charolaModel.dart' as modelo;
import '../../data/repositories/alimentacionRepository.dart';
import '../../data/repositories/hidratacionRepository.dart';
import '../../data/models/alimentacionModel.dart';
import '../../data/models/hidratacionModel.dart';
import '../../data/repositories/tamizarCharolaRepository.dart';
import '../../domain/tamizarCharolaUseCases.dart';
import '../../data/models/tamizadoIndividualModel.dart';
import '../../data/models/tamizadoMultipleModel.dart';
import '../../data/models/tamizadoRespuestaModel.dart';

/// ViewModel encargado de gestionar los datos de las charolas que se van a tamizar.
/// Implementa la vista previa de selección de charolas.
class TamizadoViewModel extends ChangeNotifier {
  final Logger _logger = Logger();
  final TamizarCharolaRepository repository = TamizarCharolaRepository();
  final TamizarCharolaUseCases tamizarCharolaUseCases = TamizarCharolaUseCasesImpl();

  final AlimentacionRepository _alimentoRepo = AlimentacionRepository();
  final HidratacionRepository _hidratacionRepo = HidratacionRepository();

  List<Alimento> alimentos = [];
  Alimento? seleccionAlimentacion;
  bool _alimentosCargados = false;

  List<Hidratacion> hidratacion = [];
  Hidratacion? seleccionHidratacion;
  bool _hidratacionCargados = false;

  /// Se definen controladores para el texto
  final frasController = TextEditingController();
  final pupaController = TextEditingController();
  final alimentoCantidadController = TextEditingController();
  final hidratacionCantidadController = TextEditingController();

  /// Lista de charolas seleccionadas por el usuario.
  List<modelo.CharolaTarjeta> charolasParaTamizar = [];

  /// Lista de nombres de charolas seleccionadas por el usuario.
  List<String> nombresCharolas = [];

  /// Estado de carga actual.
  bool cargando = false;

  String _errorMessage = '';
  bool _hasError = false;

  bool _tamizadoExitoso = false;
  final _mensajeExitoso = 'Tamizado exitoso';
  
  String get errorMessage => _errorMessage;
  bool get hasError => _hasError;
  bool get tamizadoExitoso => _tamizadoExitoso;
  String get mensajeExitoso => _mensajeExitoso;

  TamizadoViewModel() {
    cargarAlimentos();
    cargarHidratacion();
  }

  Future<bool> tamizarCharolaIndividual(List<modelo.CharolaRegistro> charolasNuevas) async {
    try {
      _tamizadoExitoso = false;
      cargando = true;
      _hasError = false;
      notifyListeners();

      DateTime fecha = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

      /// Se construye el objeto de tamizado individual
      TamizadoIndividual tamizadoIndividual = TamizadoIndividual(
        charolasNuevas: charolasNuevas,
        charolasParaTamizar: charolasParaTamizar,
        alimento: seleccionAlimentacion!.idAlimento,
        hidratacion: seleccionHidratacion!.idHidratacion,
        fras: double.parse(frasController.text),
        pupa: double.parse(pupaController.text),
        alimentoCantidad: double.parse(alimentoCantidadController.text),
        hidratacionCantidad: double.parse(hidratacionCantidadController.text),
        fecha: fecha,
      );

      TamizadoRespuesta? respuesta = await tamizarCharolaUseCases.tamizarCharola(tamizadoIndividual);

      if (respuesta?.exito == true) {
        _hasError = false;
        cargando = false;
        _tamizadoExitoso = true;
        charolasParaTamizar.clear();
        notifyListeners();
        return true;
      } else {
        _hasError = true;
        _errorMessage = 'Error al tamizar la charola. Inténtalo de nuevo más tarde.';
        cargando = false;
        notifyListeners();
        return false;
      }

    } catch (e) {
      _hasError = true;
      _errorMessage = 'Error de servidor. Inténtalo de nuevo más tarde.';
      cargando = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> tamizarCharolaMultiple(List<modelo.CharolaRegistro> charolasNuevas) async {
    try {
      _tamizadoExitoso = false;
      cargando = true;
      _hasError = false;
      notifyListeners();

      /// Se construye el objeto de tamizado múltiple
      TamizadoMultiple tamizadoMultiple = TamizadoMultiple(
        charolas: charolasNuevas,
        charolasParaTamizar: charolasParaTamizar
      );

      TamizadoRespuesta? respuesta = await tamizarCharolaUseCases.tamizarCharolasMultiples(tamizadoMultiple);


      if (respuesta?.exito == true) {
        _hasError = false;
        cargando = false;
        _tamizadoExitoso = true;
        charolasParaTamizar.clear();
        notifyListeners();
        return true;
      } else {
        _hasError = true;
        _errorMessage = 'Error al tamizar las charolas. Inténtalo de nuevo más tarde.';
        cargando = false;
        notifyListeners();
        return false;
      }

    } catch (e) {
      _hasError = true;
      _errorMessage = 'Error de servidor. Inténtalo de nuevo más tarde.';
      cargando = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> cargarAlimentos() async {
    if (_alimentosCargados) return; // Evita cargar los datos más de una vez
    try {
      alimentos = await _alimentoRepo.obtenerAlimentos();
      _alimentosCargados = true; // Marca los datos como cargados
      notifyListeners(); // Notifica a la vista que los datos han cambiado
    } catch (e) {
      _logger.e('Error al cargar los alimentos: $e');
    }
  }

  Future<void> cargarHidratacion() async {
    if (_hidratacionCargados) return; // Evita cargar los datos más de una vez
    try {
      hidratacion = await _hidratacionRepo.obtenerHidratacion();
      _hidratacionCargados = true; // Marca los datos como cargados
      notifyListeners(); // Notifica a la vista que los datos han cambiado
    } catch (e) {
      _logger.e('Error al cargar la hidratación: $e');
    }
  }

  bool siguienteInterfaz(BuildContext context) {
    _hasError = false;
    _tamizadoExitoso = false;
    if(charolasParaTamizar.isEmpty) {
      _hasError = true;
      _errorMessage = 'No hay charolas seleccionadas para tamizar.';
      notifyListeners();
      return false;
    } 
    return true;
    
  }

  void agregarCharola(modelo.CharolaTarjeta charola) {
    _tamizadoExitoso = false;
    if(charolasParaTamizar.contains(charola)) {
      _hasError = true;
      _errorMessage = 'La charola ya está seleccionada.';
      notifyListeners();
      return;
    }
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

  void quitarCharola(modelo.CharolaTarjeta charola) {
    charolasParaTamizar.remove(charola);
    _hasError = false;
    notifyListeners();
  }

  void limpiarInformacion() {
    frasController.clear();
    pupaController.clear();
    alimentoCantidadController.clear();
    hidratacionCantidadController.clear();
    seleccionAlimentacion = null;
    seleccionHidratacion = null;
    charolasParaTamizar.clear();
    nombresCharolas.clear();
    _hasError = false;
    notifyListeners();
  }
}

