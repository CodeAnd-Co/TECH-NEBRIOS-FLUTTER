import 'package:flutter/material.dart';
import '../../domain/tablaUseCases.dart';
import 'package:open_file/open_file.dart';

class TablaViewModel extends ChangeNotifier{
  final TablaUseCasesImp tabla;

  TablaViewModel(this.tabla);

  List? valoresTabla = [];
  String _estado = '';
  String get estado => _estado;

  Future<void> getTabla() async {
    try{
      print("Iniciando request: ");
      _estado = '';
      notifyListeners();
      
      valoresTabla = await tabla.repositorio.getTabla();
      

    }catch (error) {
      print('Error al cargar los datos de la tabla: $error');
    }
  }

  Future<void> postDescargarArchivo() async {
    try {
      _estado = '🌀 Descargando Excel...';
      notifyListeners();

      final path = await tabla.repositorio.postDescargarArchivo();

      _estado ='✅ Excel guardado en:\n$path';
      notifyListeners();
      await OpenFile.open(path);
    } catch (e) {
      _estado = '❌ Error: $e';
      notifyListeners();
    }
  }
}