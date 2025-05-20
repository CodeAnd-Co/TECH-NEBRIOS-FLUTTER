//RF7 Editar información de una charola https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF7

import 'package:flutter/material.dart';
import 'package:tech_nebrios_tracker/data/models/alimentacionModel.dart';
import 'package:tech_nebrios_tracker/data/models/historialActividadModel.dart';
import 'package:tech_nebrios_tracker/domain/editarCharolaUseCase.dart';
import '../../data/repositories/editarCharolaRepository.dart';
import './../../data/models/charolaModel.dart';
import 'package:intl/intl.dart';

class EditarCharolaViewModel extends ChangeNotifier{
  late final EditarCharolaUseCaseImp Editar;
  final EditarCharolaRepository _Repo = EditarCharolaRepository();

    // Controladores de formulario
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController densidadLarvaController = TextEditingController();
  final TextEditingController fechaController = TextEditingController();
  final TextEditingController comidaCicloController = TextEditingController();
  final TextEditingController pesoController = TextEditingController();
  final TextEditingController hidratacionCicloController = TextEditingController();
  late final Alimento selectedAlimentacion;
  late final String selectedHidratacion;

  EditarCharolaViewModel(){
    Editar = EditarCharolaUseCaseImp(repositorio: _Repo);
  }

  Future<void> cargarDatos(nombreCharola, fechaCreacion, densidadLarva, alimento, alimentoOtorgado, hidratacion, hidratacionOtorgado, peso) async{
    nombreController.text = nombreCharola;
    fechaController.text = fechaCreacion;
    densidadLarvaController.text = densidadLarva.toString();
    selectedAlimentacion = Alimento(idAlimento: 1, nombreAlimento: alimento, descripcionAlimento: '');
    comidaCicloController.text = alimentoOtorgado.toString();
    selectedHidratacion = hidratacion;
    hidratacionCicloController.text = hidratacionOtorgado.toString();
    pesoController.text = peso.toString();
  }

  Future<void> editarCharola(charolaId) async {
    try{
      final hoy = DateTime.now();
      final fechaFormateada = DateFormat('yyyy-MM-dd').format(hoy);

      var respuesta = await Editar.repositorio.putEditarCharola(charolaId, "activa", pesoController.text, selectedAlimentacion, comidaCicloController.text, fechaFormateada, selectedHidratacion, hidratacionCicloController.text);

    } catch (error){
      print("Error al editar charola: $error");
    }
  }
}