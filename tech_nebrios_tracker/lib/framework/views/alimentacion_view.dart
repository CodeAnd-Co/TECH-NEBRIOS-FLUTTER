//RF23: Registrar un nuevo tipo de comida en el sistema - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF23
import 'package:flutter/material.dart';
import '../../data/models/alimentacion_model.dart';
import '../../data/repositories/alimentacion_repository.dart';
import '../../data/services/alimentacion_service.dart';
import '../viewmodels/alimentacion_viewmodel.dart';

/// Pantalla que permite modificar alimentos e hidratación en el sistema.
///
/// Incluye funcionalidades para visualizar, agregar y eliminar alimentos,
/// así como gestionar elementos de hidratación (simulados).
class AlimentacionScreen extends StatefulWidget {
  const AlimentacionScreen({super.key});

  @override
  State<AlimentacionScreen> createState() => _AlimentacionScreenState();
}

class _AlimentacionScreenState extends State<AlimentacionScreen> {
  /// Repositorio de alimentos para acceder a datos desde el backend.
  late final AlimentoRepository _repo;

  /// Lista local de alimentos obtenidos.
  List<Alimento> alimentos = [];

  /// Lista fija de ejemplos de hidratación.
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

  /// Carga la lista de alimentos desde el repositorio.
  Future<void> _cargarAlimentos() async {
    try {
      final lista = await _repo.obtenerAlimentos();
      setState(() => alimentos = lista);
    } catch (e) {
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

  /// Construye la columna visual para mostrar los alimentos existentes.
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
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: alimentos.asMap().entries.map((entry) {
                final idx = entry.key;
                final comida = entry.value;
                return _buildRowAlimento(comida, idx);
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  /// Construye la columna visual para mostrar las entradas de hidratación.
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
                onPressed: () {},
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


  /// Construye una fila visual de alimento con opciones para editar o eliminar.
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

  /// Construye una fila visual de hidratación.
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

/// Muestra un formulario emergente para registrar un nuevo alimento. 
void _onAgregarAlimento() {
  final nombreController = TextEditingController();
  final descripcionController = TextEditingController();

  showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero, 
        ),
        backgroundColor: const Color(0xFFF8F1F1),
        title: const Center( 
          child: Text(
            'Nuevo Alimento',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.normal),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nombreController,
              maxLength: 25,
              decoration: const InputDecoration(labelText: 'Nombre:'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descripcionController,
              decoration: const InputDecoration(labelText: 'Descripción:'),
              maxLength: 200,
              maxLines: null,
              keyboardType: TextInputType.multiline,
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),

                    ),
                  ),
                  onPressed: () async {
                    final nombre = nombreController.text.trim();
                    final descripcion = descripcionController.text.trim();
                    final vm = AlimentacionViewModel();

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
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar'),
                ),
              ],
            ),
          ),
          ],
        );
      },
    );
  }

  /// Elimina un alimento después de confirmación por parte del usuario.
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
