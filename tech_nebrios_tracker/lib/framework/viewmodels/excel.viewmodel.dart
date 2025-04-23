//lib/framework/viewmodels/excel_vista_modelo.dart
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import '../../domain/excel.dart';

class ExcelVistaModelo extends ChangeNotifier {
  final ExcelRepositorio repository;


  ExcelVistaModelo(this.repository);

  String _estado = 'Esperando acción...';
  String get estado => _estado;

  Future<void> generarExcel() async {
    _estado = '🔄 Generando Excel...';
    notifyListeners();

    try {
      final path = await repository.descargarExcel();
      _estado = '✅ Excel guardado en:\n$path';
      await OpenFile.open(path);
    } catch (e) {
      _estado = '❌ Error: $e';
    }

    notifyListeners();
  }
}
