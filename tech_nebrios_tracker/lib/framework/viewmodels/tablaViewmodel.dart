import 'package:flutter/material.dart';
import '../../domain/tablaUseCases.dart';

class TablaViewModel extends ChangeNotifier{
  final TablaUseCasesImp tabla;

  TablaViewModel(this.tabla);

  List? valoresTabla = [];

  Future<void> getTabla() async {
    try{
      print("Iniciando request: ");
      valoresTabla = await tabla.repositorio.getTabla();
      

    }catch (error) {
      print('Error al cargar los datos de la tabla: $error');
    }
  }
}