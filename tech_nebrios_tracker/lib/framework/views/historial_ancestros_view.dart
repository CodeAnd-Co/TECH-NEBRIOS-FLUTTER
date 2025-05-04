// lib/framework/views/historial_ancestros_screen.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../viewmodels/historial_ancestros_viewmodel.dart';
import '../../data/models/historial_ancestros_model.dart';

/// Pantalla que muestra el historial de ancestros de una charola
class HistorialAncestrosScreen extends StatefulWidget {
  const HistorialAncestrosScreen({super.key, this.charolaId = 1});

  /// ID de la charola cuya historia se consulta
  final int charolaId;

  @override
  State<HistorialAncestrosScreen> createState() =>
      _HistorialAncestrosScreenState();
}

class _HistorialAncestrosScreenState extends State<HistorialAncestrosScreen> {
  @override
  void initState() {
    super.initState();
    // Disparamos la carga en el primer frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (kDebugMode) {
        debugPrint('[View] initState: solicitando ancestros para id=${widget.charolaId}');
      }
      context
          .read<HistorialAncestrosViewModel>()
          .obtenerAncestros(widget.charolaId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HistorialAncestrosViewModel>();

    if (kDebugMode) {
      debugPrint('[View] isLoading=${vm.isLoading}');
      debugPrint('[View] error=${vm.error}');
      debugPrint('[View] datos count=${vm.historialAncestros.length}');
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Historial de Ancestros')),
      body: Center(child: _buildBody(vm)),
    );
  }

  Widget _buildBody(HistorialAncestrosViewModel vm) {
    if (vm.isLoading) {
      return const CircularProgressIndicator();
    }

    if (vm.error != null) {
      return Text(
        vm.error!,
        style: const TextStyle(color: Colors.red, fontSize: 16),
      );
    }

    if (vm.historialAncestros.isEmpty) {
      return const Text('No hay ancestros disponibles');
    }

    // Tomamos el primer historial (según diseño)
    final HistorialAncestros data = vm.historialAncestros.first;
    return _HistorialAncestrosTable(data: data);
  }
}

/// Widget que dibuja la tabla de ancestros según el mockup
class _HistorialAncestrosTable extends StatelessWidget {
  final HistorialAncestros data;
  const _HistorialAncestrosTable({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFf5ecec),
      padding: const EdgeInsets.all(16),
      child: Table(
        border: TableBorder.all(color: Colors.black, width: 1),
        columnWidths: const {0: FlexColumnWidth(2), 1: FlexColumnWidth(1)},
        children: [
          // Encabezado
          const TableRow(
            decoration: BoxDecoration(color: Colors.teal),
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Charolas Ancestros',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Fecha de creación',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ],
          ),
          // Fila de datos
          TableRow(children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: data.ancestros
                    .map((a) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(a.nombreCharola,
                              style: const TextStyle(fontSize: 16)),
                        ))
                    .toList(),
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
          ]),
        ],
      ),
    );
  }
}
