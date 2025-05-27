// RF20 Tamizar charolas - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF16

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../../data/models/charolaModel.dart' as modelo;
import '../../data/repositories/tamizarCharolaRepository.dart';
import '../../domain/tamizarCharolaUseCases.dart';
import '../views/sidebarView.dart';
import '../../data/models/tamizadoIndividualModel.dart';
import '../../data/models/tamizadoMultipleModel.dart';
import '../../data/models/tamizadoRespuestaModel.dart';

/// ViewModel encargado de gestionar los datos de las charolas que se van a tamizar.
/// Implementa la vista previa de selección de charolas.
class TamizadoViewModel extends ChangeNotifier {
  final Logger _logger = Logger();
  final TamizarCharolaRepository repository = TamizarCharolaRepository();
  final TamizarCharolaUseCases tamizarCharolaUseCases = TamizarCharolaUseCasesImpl();

  List<String> alimentos = [];
  String? seleccionAlimentacion;
  bool _alimentosCargados = false;

  List<String> hidratacion = [];
  String? seleccionHidratacion;
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

  /// Se definen variables para convertir de texto a número
  double frasCantidad = 0;
  double pupaCantidad = 0;
  double alimentoCantidad = 0;
  double hidratacionCantidad = 0;

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

  Future<bool> tamizarCharolaIndividual() async {
    try {
      cargando = true;
      _hasError = false;
      notifyListeners();

      ///Se validan todas las entradas del usuario
      verificacionDeCampos();

      ///Se extraen solo los nombres de las charolas seleccionadas
      conseguirNombresCharolas();

      ///Se convierten los campos de texto a números
      convertirCampos();

      ///Se obtiene la fecha actual sin la hora
      DateTime fecha = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

      /// Se construye el objeto de tamizado individual
      TamizadoIndividual tamizadoIndividual = TamizadoIndividual(
        charolas: nombresCharolas,
        alimento: seleccionAlimentacion!,
        hidratacion: seleccionHidratacion!,
        fras: frasCantidad,
        pupa: pupaCantidad,
        alimentoCantidad: alimentoCantidad,
        hidratacionCantidad: hidratacionCantidad,
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
      _errorMessage = 'Error al tamizar la charola. Inténtalo de nuevo más tarde.';
      cargando = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> tamizarCharolaMultiple(List<modelo.CharolaRegistro> charolasNuevas) async {
    try {
      cargando = true;
      _hasError = false;
      notifyListeners();

      ///Se obtiene la fecha actual sin la hora
      DateTime fecha = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

      /// Se construye el objeto de tamizado múltiple
      TamizadoMultiple tamizadoMultiple = TamizadoMultiple(
        charolas: charolasNuevas,
        fecha: fecha,
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
      alimentos = await tamizarCharolaUseCases.cargarAlimentos();
      _alimentosCargados = true; // Marca los datos como cargados
      notifyListeners(); // Notifica a la vista que los datos han cambiado
    } catch (e) {
      _logger.e('Error al cargar los alimentos: $e');
    }
  }

  Future<void> cargarHidratacion() async {
    if (_hidratacionCargados) return; // Evita cargar los datos más de una vez
    try {
      hidratacion = await tamizarCharolaUseCases.cargarHidratacion();
      _hidratacionCargados = true; // Marca los datos como cargados
      notifyListeners(); // Notifica a la vista que los datos han cambiado
    } catch (e) {
      _logger.e('Error al cargar la hidratación: $e');
    }
  }

  void siguienteInterfaz(BuildContext context) {
    _tamizadoExitoso = false;
    if(charolasParaTamizar.isEmpty) {
      _hasError = true;
      _errorMessage = 'No hay charolas seleccionadas para tamizar.';
      notifyListeners();
      _hasError = false;
      return;
    } else if(charolasParaTamizar.length == 1) {
      _hasError = false;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SidebarView(initialIndex: 5),
        ),
      );
    }else{
      _hasError = false;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SidebarView(initialIndex: 6),
        ),
      );
    }
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

  void verificacionDeCampos(){
    if(charolasParaTamizar.length == 1){
      revisarCampoFras();
      revisarCampoPupa();
      revisarCampoAlimentoCantidad();
      revisarCampoHidratacionCantidad();
      revisarSeleccionAlimentacion();
      revisarSeleccionHidratacion();
    }else{
      revisarCampoFras();
      revisarCampoPupa();
    }
  }

  void convertirCampos(){
    if(charolasParaTamizar.length == 1){
      frasCantidad = double.parse(frasController.text);
      pupaCantidad = double.parse(pupaController.text);
      alimentoCantidad = double.parse(alimentoCantidadController.text);
      hidratacionCantidad = double.parse(hidratacionCantidadController.text);
    }else{
      frasCantidad = double.parse(frasController.text);
      pupaCantidad = double.parse(pupaController.text);
    }
  }

  void revisarCampoFras(){
    if(frasController.text.isEmpty){
      _hasError = true;
      _errorMessage = 'El campo de Fras no puede estar vacío.';
    }
    notifyListeners();
    return;
  }

  void revisarCampoPupa(){
    if(pupaController.text.isEmpty){
      _hasError = true;
      _errorMessage = 'El campo de Pupa no puede estar vacío.';
    }
    notifyListeners();
    return;
  }

  void revisarCampoAlimentoCantidad(){
    if(alimentoCantidadController.text.isEmpty){
      _hasError = true;
      _errorMessage = 'El campo de Cantidad de Alimento no puede estar vacío.';
    }
    notifyListeners();
    return;
  }

  void revisarCampoHidratacionCantidad(){
    if(hidratacionCantidadController.text.isEmpty){
      _hasError = true;
      _errorMessage = 'El campo de Cantidad de Hidratación no puede estar vacío.';
    }
    notifyListeners();
    return;
  }

  void revisarSeleccionAlimentacion(){
    if(seleccionAlimentacion == null){
      _hasError = true;
      _errorMessage = 'Por favor, selecciona un alimento.';
    }
    notifyListeners();
    return;
  }

  void revisarSeleccionHidratacion(){
    if(seleccionHidratacion == null){
      _hasError = true;
      _errorMessage = 'Por favor, selecciona una hidratación.';
    }
    notifyListeners();
    return;
  }

  void conseguirNombresCharolas() {
    nombresCharolas = charolasParaTamizar.map((charola) => charola.nombreCharola).toList();
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

   void limpiarError() {
    _hasError = false;
  }

  void limpiarTamizadoExitoso() {
    _tamizadoExitoso = false;
  }

  Future<void> asignarAncestros({
    required int charolaHijaId,
    required List<int> ancestrosIds,
  }) async{ 
    await repository.asignarAncestros(charolaHijaId, ancestrosIds);
  }

}

