// RF03: Consultar historial de ancestros de una charola
// https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF3

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../viewmodels/historialCharolaViewModel.dart';
import '../../data/models/historialCharolaModel.dart';

void mostrarPopUpHistorialAncestros({
  required BuildContext context,
  required int charolaId,
}) {
  final vistaModelo =
      Provider.of<HistorialCharolaViewModel>(context, listen: false);

  // Llamamos obtenerAncestros _antes_ de construir el FutureBuilder,
  // para que no dispare notifyListeners() durante el build.
  final futureAncestros = vistaModelo.obtenerAncestros(charolaId);

  showDialog(
    context: context,
    builder: (dialogContext) {
      return FutureBuilder<void>(
        future: futureAncestros,
        builder: (context, snapshot) {
          // Mientras carga la petición
          if (snapshot.connectionState != ConnectionState.done) {
            return const AlertDialog(
              content: SizedBox(
                height: 100,
                child: Center(child: CircularProgressIndicator()),
              ),
            );
          }

          // Si hubo un error en el ViewModel (conexión o backend)
          final errorMsg = vistaModelo.error;
          if (errorMsg != null) {
            return AlertDialog(
              title: Stack(
                alignment: Alignment.center,
                children: [
                  const Center(
                    child: Text(
                      'Historial de Ancestros',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),
              content: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  errorMsg,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }

          // Si no hubo error, obtenemos la lista
          final lista = vistaModelo.historialAncestros;
          // Si la lista está vacía, indicamos que no hay ancestros
          if (lista.isEmpty) {
            return AlertDialog(
              title: Stack(
                alignment: Alignment.center,
                children: [
                  const Center(
                    child: Text(
                      'Historial de Ancestros',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),
              content: const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'La charola no tiene ancestros',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }

          // Finalmente, mostramos la tabla con el primer elemento (único historial)
          final data = lista.first;

          return AlertDialog(
            title: Stack(
              alignment: Alignment.center,
              children: [
                const Center(
                  child: Text(
                    'Historial de Ancestros',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Positioned(
                  left: 0,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: SizedBox(
                width: 500,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Divider(height: 1),
                    _HistorialAncestrosTable(data: data),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

/// Tabla que muestra la lista de ancestros y fecha de creación
class _HistorialAncestrosTable extends StatelessWidget {
  final HistorialAncestros data;
  const _HistorialAncestrosTable({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Table(
        border: TableBorder.all(color: Colors.black, width: 1),
        columnWidths: const {0: FlexColumnWidth(2), 1: FlexColumnWidth(1)},
        children: [
          const TableRow(
            decoration: BoxDecoration(color: Colors.teal),
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Charolas Ancestros',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Fecha de creación',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ],
          ),
          TableRow(
            decoration: const BoxDecoration(color: Color(0xFFf5ecec)),
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: data.ancestros.map((a) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(a.nombreCharola, style: const TextStyle(fontSize: 16)),
                    );
                  }).toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Center(
                  child: Text(
                    DateFormat('dd/MM/yyyy').format(data.fechaCreacion),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
