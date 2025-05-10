//RF25: Eliminar un tipo de comida en el sistema - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF25
import 'package:flutter/material.dart';
import '../../data/models/alimentacion_model.dart';
import '../viewmodels/alimentacion_viewmodel.dart';

/// Pantalla principal de alimentación e hidratación.
///
/// Muestra dos columnas: alimentos con scroll infinito
/// y sección estática de hidratación.
class AlimentacionScreen extends StatefulWidget {
  const AlimentacionScreen({super.key});

  @override
  _AlimentacionScreenState createState() => _AlimentacionScreenState();
}

class _AlimentacionScreenState extends State<AlimentacionScreen> {
  /// ViewModel que maneja la lista y edición de alimentos.
  final vm = AlimentacionViewModel();

  /// Controlador de scroll para detectar fin de lista.
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    vm.addListener(() => setState(() {}));
    vm.cargarAlimentos();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          vm.hasMore &&
          !vm.isLoading) {
        vm.cargarMas();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    vm.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFA),
      body: Column(
        children: [
          const SizedBox(height: 40),
          const Text(
            "Modificar datos",
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 4.0),
            child: Divider(color: Color(0xFF385881), thickness: 2, height: 20),
          ),
          const Text(
            'Selecciona el dato a editar',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.pink,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  Expanded(child: _buildColumnSectionAlimentos()),
                  const SizedBox(width: 16),
                  Expanded(child: _buildColumnSectionHydratacion()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Construye la columna de alimentos con encabezado y contenido.
  Widget _buildColumnSectionAlimentos() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Encabezado verde con título y botón de agregar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: const BoxDecoration(
            color: Color(0xFF92D050),
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Alimento',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () async {}, // TODO: implementar _onAgregarAlimento
              ),
            ],
          ),
        ),
        // Lista con carga infinita
        Expanded(
          child: vm.alimentos.isEmpty && vm.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  controller: _scrollController,
                  itemCount: vm.alimentos.length + (vm.hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index < vm.alimentos.length) {
                      return _buildRowAlimento(vm.alimentos[index], index);
                    }
                    // Indicador de carga al final
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  },
                ),
        ),
      ],
    );
  }

  /// Construye la columna de hidratación (estática por ahora).
  Widget _buildColumnSectionHydratacion() {
    const hidrataciones = [
      'ejemplo',
      'ejemplo',
      'ejemplo',
      'ejemplo',
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: const BoxDecoration(
            color: Color(0xFF92D050),
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Hidratación',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {}, // TODO: implementar _onAgregarHidratacion
              ),
            ],
          ),
        ),
        // Filas de hidrataciones
        ...hidrataciones.asMap().entries.map((entry) {
          final text = entry.value;
          final bg = entry.key.isEven ? Colors.white : Colors.grey.shade200;
          return Container(
            color: bg,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            height: 48,
            child: Row(
              children: [
                Expanded(child: Text(text)),
                IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {},
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  /// Construye una fila de alimento con botones de editar y eliminar.
  Widget _buildRowAlimento(Alimento alimento, int index) {
    final bg = index.isEven ? Colors.white : Colors.grey.shade200;
    return Container(
      color: bg,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      height: 48,
      child: Row(
        children: [
          Expanded(child: Text(alimento.nombreAlimento)),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => {},
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Color(0xFFF44336)),
           onPressed: () => _onEliminarAlimento(alimento.idAlimento),
          ),
        ],
      ),
    );
  }

  /// Muestra un diálogo de confirmación para eliminar [alimento].
  /// Si se confirma, llama a [vm.eliminarAlimento].
  void _onEliminarAlimento(int idAlimento) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFFF8F1F1),
        title: const Text('Eliminar Alimento'),
        content: const Text('¿Estás seguro de eliminar este alimento?'),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              await vm.eliminarAlimento(idAlimento);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Alimento eliminado exitosamente')),
              );
            },
            child: const Text('Eliminar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }
}