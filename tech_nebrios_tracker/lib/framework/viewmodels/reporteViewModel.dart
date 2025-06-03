import 'package:flutter/material.dart';
import '../../domain/reporteUseCases.dart';
import 'package:open_file/open_file.dart';


class ReporteViewModel extends ChangeNotifier{
  late final TablaUseCasesImp tabla;

  ReporteViewModel(){
    tabla = TablaUseCasesImp();
  }

  List? valoresTabla = [];
  String _estadoDescarga = '';
  String _mensajeGet = '';
  bool _error = false;

  bool get errorGet => _error;
  String get estadoDescarga => _estadoDescarga;
  String get mensajeGet => _mensajeGet;

  Future<void> getDatos() async {
    try{
      _estadoDescarga = '';
      _mensajeGet = '';
      notifyListeners();

      var respuesta = await tabla.repositorio.getDatos();
      valoresTabla = respuesta['mensaje'];
      var codigo = respuesta['codigo'];

      if (codigo == 201) {
        _mensajeGet = '❌ No hay datos de charolas registradas ❌';
      } else if (codigo == 401) {
        _mensajeGet = '❌ Por favor, vuelva a iniciar sesión. ❌';
      } else if (codigo == 403) {
        _mensajeGet = '❌ No tiene permisos para acceder a esta información. ❌';
      } else if (codigo == 500) {
        _mensajeGet = '❌ Ocurrió un error en el servidor, favor de intentar mas tarde. ❌';
      }
      notifyListeners();
    }catch (error) {
      _mensajeGet = '❌ Ocurrió un error en el servidor, favor de intentar mas tarde. ❌';
      notifyListeners();
    }
  }

  Future<void> postDescargarArchivo() async {
    try {
      _error = false;

      notifyListeners();

      final respuesta = await tabla.repositorio.postDescargarArchivo();
      var codigo = respuesta['codigo'];

      if (codigo == 200) {
        var ruta = respuesta['path'];
        _estadoDescarga ='✅ Excel guardado en:\n$ruta.';
        
        await OpenFile.open(ruta);
      } else if (codigo == 201) {
        _estadoDescarga ='Aún no existen datos de charolas que descargar.';
        _error = true;
      } else if (codigo == 500) {
        _estadoDescarga ='❌ Ha ocurrido un error al descargar el archivo. No se puede descargar en iPad.';
        _error = true;
      }
      notifyListeners();
    } catch (e) {
      _estadoDescarga = '❌ Ha ocurrido un error al descargar el archivo.';
      notifyListeners();
    }
  }
}