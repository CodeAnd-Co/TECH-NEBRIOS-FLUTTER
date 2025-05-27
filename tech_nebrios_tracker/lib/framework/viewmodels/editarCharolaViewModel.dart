//RF7 Editar información de una charola https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF7

import 'package:flutter/material.dart';
import 'package:tech_nebrios_tracker/data/models/alimentacionModel.dart';
import 'package:tech_nebrios_tracker/domain/editarCharolaUseCase.dart';
import '../../data/repositories/editarCharolaRepository.dart';
import 'package:tech_nebrios_tracker/data/models/hidratacionModel.dart';
import 'package:intl/intl.dart';

class EditarCharolaViewModel extends ChangeNotifier{
  late final EditarCharolaUseCaseImp Editar;
  final EditarCharolaRepository _Repo = EditarCharolaRepository();

    // Controladores de formulario
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController densidadLarvaController = TextEditingController();
  final TextEditingController fechaController = TextEditingController();
  final TextEditingController comidaCicloController = TextEditingController();
  final TextEditingController hidratacionCicloController = TextEditingController();
  final TextEditingController estadoController = TextEditingController();
  Alimento? selectedAlimentacion;
  Hidratacion? selectedHidratacion;

  set setAlimentacion(Alimento value) {
    selectedAlimentacion = value;
    notifyListeners();
  }

  set setHidratacion(Hidratacion value) {
    selectedHidratacion = value;
    notifyListeners();
  }

  bool _cargandoEditar = false;
  bool get cargandoEditar => _cargandoEditar;

  String _mensaje = '';
  bool _error = false;

  String get mensaje => _mensaje;
  bool get error => _error;



  EditarCharolaViewModel(){
    Editar = EditarCharolaUseCaseImp(repositorio: _Repo);
  }

  Future<void> cargarDatos(nombreCharola, fechaCreacion, densidadLarva, alimentoId, alimento, alimentoOtorgado, hidratacionId, hidratacion, hidratacionOtorgado, estado) async{
    nombreController.text = nombreCharola;
    fechaController.text = fechaCreacion;
    densidadLarvaController.text = densidadLarva.toString();
    selectedAlimentacion = Alimento(idAlimento: alimentoId, nombreAlimento: alimento, descripcionAlimento: '');
    comidaCicloController.text = alimentoOtorgado.toString();
    selectedHidratacion = Hidratacion(idHidratacion: hidratacionId, nombreHidratacion: hidratacion, descripcionHidratacion: '');
    hidratacionCicloController.text = hidratacionOtorgado.toString();
    estadoController.text = estado;
  }

  Future<void> editarCharola(charolaId) async {
    try{
      _cargandoEditar = true;
      notifyListeners();
      final hoy = DateTime.now();
      final fechaFormateada = DateFormat('yyyy-MM-dd').format(hoy);

      final fechaCreacionFormateada = DateFormat('yyyy-MM-dd').format(DateFormat('dd/MM/yyyy').parse(fechaController.text));

      var respuesta = await Editar.repositorio.putEditarCharola(charolaId, nombreController.text, estadoController.text, densidadLarvaController.text, selectedAlimentacion!.idAlimento, comidaCicloController.text, fechaFormateada, selectedHidratacion!.idHidratacion, hidratacionCicloController.text, fechaCreacionFormateada);
      
      if (respuesta['codigo'] == 200){
        _mensaje = 'Se editó la información correctamente.';
        _cargandoEditar = false;
        _error = false;
        notifyListeners();
        return;
      }
      _mensaje = 'Ocurrió un error al editar la información.';
      _cargandoEditar = false;
      _error = true;
      notifyListeners();

    } catch (error){
      _mensaje = 'Ocurrió un error al editar la información.';
      _cargandoEditar = false;
      _error = true;
      notifyListeners();
    }
  }
}