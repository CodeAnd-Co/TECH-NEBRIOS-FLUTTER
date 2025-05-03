import 'package:flutter/material.dart';
import '../../domain/tablaUseCases.dart';
import 'package:open_file/open_file.dart';


class TablaViewModel extends ChangeNotifier{
  final TablaUseCasesImp tabla;

  TablaViewModel(this.tabla);

  List? valoresTabla = [];
  String _estadoDescarga = '';
  String _mensajeGet = '';

  String get estadoDescarga => _estadoDescarga;
  String get mensajeGet => _mensajeGet;

  Future<void> getTabla() async {
    try{
      print("Iniciando request: ");
      _estadoDescarga = '';
      _mensajeGet = '';
      notifyListeners();

      var respuesta = await tabla.repositorio.getTabla();
      valoresTabla = respuesta['mensaje'];

      if (respuesta['codigo'] == 200 && respuesta['mensaje'].isEmpty){
        _mensajeGet = '❌ No hay datos de charolas registradas ❌';
      } else if (respuesta['codigo'] == 401){
        _mensajeGet = '❌ Por favor, vuelva a iniciar sesión. ❌';
      } else if (respuesta['codigo'] == 403){
        _mensajeGet = '❌ No tiene permisos para acceder a esta información. ❌';
      }
      notifyListeners();
    }catch (error) {
      print('Error al cargar los datos de la tabla: $error');
    }
  }

  Future<void> postDescargarArchivo() async {
    try {
      _estadoDescarga = 'Descargando Excel...';
      notifyListeners();

      final path = await tabla.repositorio.postDescargarArchivo();

      _estadoDescarga ='✅ Excel guardado en:\n$path';
      notifyListeners();
      await OpenFile.open(path);
    } catch (e) {
      _estadoDescarga = '❌ Error: $e';
      notifyListeners();
    }
  }
}