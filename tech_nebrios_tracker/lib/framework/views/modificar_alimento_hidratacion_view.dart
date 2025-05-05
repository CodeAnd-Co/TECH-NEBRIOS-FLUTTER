//RF23: Registrar un nuevo tipo de comida en el sistema - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF23
import 'package:flutter/material.dart';
import '../../data/models/alimento_model.dart';
import '../../data/repositories/alimento_repository.dart';
import '../../data/services/alimentacion_service.dart';
import '../viewmodels/alimentacion_viewmodel.dart';

class AlimentacionScreen extends StatefulWidget {
  const AlimentacionScreen({super.key});

  @override
  State<AlimentacionScreen> createState() => _AlimentacionScreenState();
}

class _AlimentacionScreenState extends State<AlimentacionScreen> {
  late final AlimentoRepository _repo;
  List<Alimento> alimentos = [];
  final List<String> hidrataciones = [
    'ejemplo',
    'ejemplo',
    'ejemplo',
    'ejemplo',
  ];

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
          IconButton(icon: const Icon(Icons.edit),  onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Color(0xFFF44336)),
            onPressed: () => _onEliminarAlimento(alimento),
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
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

void _onAgregarAlimento() {
  final nombreController = TextEditingController();
  final descripcionController = TextEditingController();

  showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        backgroundColor: const Color(0xFFF8F1F1),
        title: const Text('Nuevo Alimento'),
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
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, ),
            onPressed: () async {
              final nombre = nombreController.text.trim();
              final descripcion = descripcionController.text.trim();

              final vm = AlimentacionViewModel(); // <- Idealmente debería venir de Provider

              final resultado = await vm.registrarAlimento(nombre, descripcion);
              if (resultado == null) {
                Navigator.of(context).pop();
                await _cargarAlimentos();
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
              foregroundColor: Colors.white, // <-- Texto en blanco
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),

          ],
        );
      },
    );
  }


  void _onEliminarAlimento(Alimento alimento) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Eliminar alimento'),
            content: const Text('¿Estás seguro de eliminar este alimento?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Eliminar'),
              ),
            ],
          ),
    );
    if (confirm == true) {
      try {
        await _repo.eliminarAlimento(alimento.idAlimento);
        setState(() {
          alimentos.removeWhere((c) => c.idAlimento == alimento.idAlimento);
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar alimento: $e')),
        );
      }
    }
  }
}
