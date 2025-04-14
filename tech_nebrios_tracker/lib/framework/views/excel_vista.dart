//lib/framework/views/excel_vista.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/excel_vista_modelo.dart';

class ExcelVista extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vistaModelo = Provider.of<ExcelVistaModelo>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Generador de Excel')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: vistaModelo.generarExcel,
              child: Text('Generar Excel'),
            ),
            SizedBox(height: 32),
            Text(
              vistaModelo.estado,
              style: TextStyle(fontFamily: 'Courier'),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
