import 'package:flutter/material.dart';
import 'package:tech_nebrios_tracker/domain/historialActividadUseCases.dart';
//import '../../domain/tablaUseCases.dart';

class HistorialActividadViewmodel extends ChangeNotifier{
  final HistorialActividadUseCasesImp Historial;

  HistorialActividadViewmodel(this.Historial);

  String _mensajeError = '';
  bool _error = false;

  String _estadoCharola = '';
  bool _estadoCharolaColor = true; // El booleano se ocupa para determinar el color del texto dependiendo del estado de la charola
  String _fechaActualizacion = '';
  
  List _alimentacion = [];
  List _hidratacion = [];

  String get estadoCharola => _estadoCharola;
  String get fechaActualizacion => _fechaActualizacion;

  String get mensajeError => _mensajeError;
  bool get error => _error;

  bool get estadoCharolaColor => _estadoCharolaColor;
  List get alimentacion => _alimentacion;
  List get hidratacion => _hidratacion;

  Future<void> historialActividad(charolaId) async {
    try{
      _estadoCharolaColor = true;
      _mensajeError = '';
      _error = false;

      var respuesta = await Historial.repositorio.historialActividad(charolaId);

      if(respuesta.codigo == '500'){
        _mensajeError = "⛔️Ha ocurrido un error en el servidor, favor de intentar más tarde⛔️";
        _error = true;
      }else {
        _estadoCharola = respuesta.estado.estado;
        _fechaActualizacion = respuesta.estado.fechaActualizacion;

        if (_estadoCharola == 'pasada'){
          _estadoCharolaColor = false;
        }

        _alimentacion = respuesta.alimentacion;
        _hidratacion = respuesta.hidratacion;
      }
      notifyListeners();

    } catch(error){
      _mensajeError = "⛔️Ha ocurrido un error en el servidor, favor de intentar más tarde⛔️";
      _error = true;
      notifyListeners();
    }
  }

}