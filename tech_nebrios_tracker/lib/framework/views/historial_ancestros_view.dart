// lib/framework/views/historial_ancestros_screen.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../viewmodels/historial_ancestros_viewmodel.dart';
import '../../data/models/historial_ancestros_model.dart';

/// Pantalla que dispara y muestra el popup de historial de ancestros
class HistorialAncestrosScreen extends StatefulWidget {
  const HistorialAncestrosScreen({super.key, this.charolaId = 1});

  /// ID de la charola cuya historia se consulta
  final int charolaId;

  @override
  State<HistorialAncestrosScreen> createState() => _HistorialAncestrosScreenState();
}

class _HistorialAncestrosScreenState extends State<HistorialAncestrosScreen> {
  bool _hasShownPopup = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (kDebugMode) {
        debugPrint('[View] initState: solicitando ancestros para id=${widget.charolaId}');
      }
      context.read<HistorialAncestrosViewModel>().obtenerAncestros(widget.charolaId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HistorialAncestrosViewModel>();

    // Mostrar popup automáticamente una sola vez cuando haya datos
    if (!vm.isLoading && vm.error == null && vm.historialAncestros.isNotEmpty && !_hasShownPopup) {
      _hasShownPopup = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showHistorialPopup(context, vm.historialAncestros.first);
      });
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

    final HistorialAncestros data = vm.historialAncestros.first;
    return ElevatedButton(
      onPressed: () => _showHistorialPopup(context, data),
      child: const Text('Ver Historial'),
    );
  }
}

/// Tabla que muestra la lista de ancestros y fecha de creación
class _HistorialAncestrosTable extends StatelessWidget {
  final HistorialAncestros data;
  const _HistorialAncestrosTable({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
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
          // Fila de datos con fondo crema
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

/// Diálogo personalizado con cierre en X rojo a la izquierda y texto centrado
class HistorialAncestrosDialog extends StatelessWidget {
  final HistorialAncestros data;
  const HistorialAncestrosDialog({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header con botón de cierre a la izquierda y título centrado
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Center(
                    child: Text(
                      'Historial de Ancestros',
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Positioned(
                    left: 0,
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      color: Colors.red,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            // Contenido con la tabla
            _HistorialAncestrosTable(data: data),
          ],
        ),
      ),
    );
  }
}

/// Función de ayuda para mostrar el diálogo
void _showHistorialPopup(BuildContext context, HistorialAncestros data) {
  showDialog(
    context: context,
    builder: (_) => HistorialAncestrosDialog(data: data),
  );
}
