// lib/framework/views/alimentacion_hidratacion_view.dart
import 'package:flutter/material.dart';
import '../../data/models/alimentacion_model.dart';
import '../viewmodels/alimentacion_viewmodel.dart';

class AlimentacionScreen extends StatefulWidget {
  const AlimentacionScreen({super.key});

  @override
  State<AlimentacionScreen> createState() => _AlimentacionScreenState();
}

class _AlimentacionScreenState extends State<AlimentacionScreen> {
  final vm = AlimentacionViewModel();
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

  Widget _buildColumnSectionAlimentos() {
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
                'Alimento',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () async {}, // _onAgregarAlimento
              ),
            ],
          ),
        ),
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
                onPressed: () {}, // _onAgregarHidratacion
              ),
            ],
          ),
        ),
        ...hidrataciones.asMap().entries.map((entry) {
          final idx = entry.key;
          final text = entry.value;
          final bg = idx.isEven ? Colors.white : Colors.grey.shade200;
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

  Widget _buildRowAlimento(Alimento alimento, int index) {
    final isEven = index.isEven;
    final bg = isEven ? Colors.white : Colors.grey.shade200;
    return Container(
      color: bg,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      height: 48,
      child: Row(
        children: [
          Expanded(child: Text(alimento.nombreAlimento)),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _onEditarAlimento(alimento),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Color(0xFFF44336)),
            onPressed: () async {}, // _onEliminarAlimento
          ),
        ],
      ),
    );
  }

  void _onEditarAlimento(Alimento alimento) {
    final nombreController = TextEditingController(text: alimento.nombreAlimento);
    final descripcionController = TextEditingController(text: alimento.descripcionAlimento);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFFF8F1F1),
        title: const Text('Modificar Alimento'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nombreController,
              decoration: const InputDecoration(labelText: 'Nombre:'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descripcionController,
              decoration: const InputDecoration(labelText: 'Descripción:'),
              maxLines: null,
              keyboardType: TextInputType.multiline,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              final resultado = await vm.editarAlimento(
                Alimento(
                  idAlimento: alimento.idAlimento,
                  nombreAlimento: nombreController.text.trim(),
                  descripcionAlimento: descripcionController.text.trim(),
                ),
              );
              if (resultado == null) {
                Navigator.of(context).pop();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(resultado)),
                );
              }
            },
            child: const Text('Guardar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
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
