import 'package:flutter/material.dart';
import '../../data/models/alimento_model.dart';
import '../../data/repositories/alimento_repository.dart';
import '../../data/services/alimentacion_service.dart';

class AlimentacionScreen extends StatefulWidget {
  const AlimentacionScreen({super.key});

  @override
  State<AlimentacionScreen> createState() => _AlimentacionScreenState();
}

class _AlimentacionScreenState extends State<AlimentacionScreen> {
  late final AlimentoRepository _repo;
  List<Alimento> alimentos = [];
  final List<String> hidrataciones = ['ejemplo', 'ejemplo', 'ejemplo', 'ejemplo'];

  @override
  void initState() {
    super.initState();
    _repo = AlimentoRepository(AlimentacionService());
    _cargarAlimentos();
  }

  Future<void> _cargarAlimentos() async {
    try {
      final lista = await _repo.obtenerAlimentos();
      setState(() => alimentos = lista);
    } catch (e) {
      // manejar error
    }
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
            child: Divider(
              color: Color(0xFF385881),
              thickness: 2,
              height: 20,
            ),
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
                  Expanded(
                    child: _buildColumnSectionAlimentos(),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildColumnSectionHydratacion(),
                  ),
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
                onPressed: _onAgregarAlimento,
              ),
            ],
          ),
        ),
        ...alimentos.asMap().entries.map((entry) {
          final idx = entry.key;
          final comida = entry.value;
          return _buildRowAlimento(comida, idx);
        }).toList(),
      ],
    );
  }

  Widget _buildColumnSectionHydratacion() {
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
                onPressed: () {}, // aqui va _onAgregarHidratacion

              ),
            ],
          ),
        ),
        ...hidrataciones.asMap().entries.map((entry) {
          final idx = entry.key;
          return _buildRowHydratacion(entry.value, idx);
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
            onPressed: () => _onEditarAlimento(alimento, index),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () async { // aqui va _onEliminarAlimento
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRowHydratacion(String text, int index) {
    final isEven = index.isEven;
    final bg = isEven ? Colors.white : Colors.grey.shade200;
    return Container(
      color: bg,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      height: 48,
      child: Row(
        children: [
          Expanded(child: Text(text)),
          IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
          IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () {}),
        ],
      ),
    );
  }

  void _onAgregarAlimento() {
    final nombreCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Nuevo alimento'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nombreCtrl, decoration: const InputDecoration(hintText: 'Nombre')),
            TextField(controller: descCtrl, decoration: const InputDecoration(hintText: 'Descripción')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              // Guardar el nuevo alimento 
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _onEditarAlimento(Alimento alimento, int index) {
    final nombreCtrl = TextEditingController(text: alimento.nombreAlimento);
    final descCtrl = TextEditingController(text: alimento.descripcionAlimento);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Editar alimento'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nombreCtrl, decoration: const InputDecoration(hintText: 'Nombre')),
            TextField(controller: descCtrl, decoration: const InputDecoration(hintText: 'Descripción')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              final updated = Alimento(
                idAlimento: alimento.idAlimento,
                nombreAlimento: nombreCtrl.text.trim(),
                descripcionAlimento: descCtrl.text.trim(),
              );
              await _repo.editarAlimento(updated);
              setState(() => alimentos[index] = updated);
              Navigator.pop(context);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }
}

