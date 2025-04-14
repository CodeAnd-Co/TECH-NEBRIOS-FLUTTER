import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/services/excel_api_servicio.dart';
import 'data/repositories/excel_repositorio.dart';
import 'domain/excel.dart';
import 'framework/viewmodels/excel_vista_modelo.dart';
import 'framework/views/excel_vista.dart';

void main() {
  final servicio = ExcelApiServico();
  final repositorio = RepositorioExcelImpl(servicio);
  runApp(ExcelMenu(repositorio));
}

class ExcelMenu extends StatelessWidget {
  final ExcelRepositorio repositorio;

  ExcelMenu(this.repositorio);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ExcelVistaModelo(repositorio),
      child: MaterialApp(
        title: 'Generador de Excel',
        home: ExcelVista(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}