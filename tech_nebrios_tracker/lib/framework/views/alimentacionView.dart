//RF23: Registrar un nuevo tipo de comida en el sistema - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF23
import 'package:flutter/material.dart';
import '../../data/models/alimentacionModel.dart';
import '../../data/models/hidratacionModel.dart';
import '../viewmodels/alimentacionViewModel.dart';
import '../viewmodels/hidratacionViewModel.dart';

import 'components/header.dart';

/// Pantalla que permite visualizar y gestionar alimentos e hidratación.
///
/// Incluye scroll infinito en la sección de alimentos,
/// un formulario para agregar nuevos alimentos y
/// una sección estática de ejemplos de hidratación.
class AlimentacionScreen extends StatefulWidget {
  const AlimentacionScreen({super.key});

  @override
  _AlimentacionScreenState createState() => _AlimentacionScreenState();
}

/// Estado de [AlimentacionScreen].
///
/// Maneja el estado interno de la vista, incluyendo
/// controladores, eventos de scroll y renderizado dinámico.
class _AlimentacionScreenState extends State<AlimentacionScreen> {
  final vmAlimentacion = AlimentacionViewModel();
  final vmHidratacion = HidratacionViewModel();

  final _alimScrollController = ScrollController();
  final _hidrScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Llamada única a setState cuando cambie cualquiera de los VMs
    vmAlimentacion.addListener(_onVmChanged);
    vmHidratacion.addListener(_onVmChanged);

    // Carga inicial
    vmAlimentacion.cargarAlimentos();
    vmHidratacion.cargarHidratacion();

    // Scroll infinito por separado
    _alimScrollController.addListener(_onScrollAlimentos);
    _hidrScrollController.addListener(_onScrollHidratacion);
  }

  void _onVmChanged() {
    if (mounted) setState(() {});
  }

  void _onScrollAlimentos() {
    if (_alimScrollController.position.pixels >=
            _alimScrollController.position.maxScrollExtent - 200 &&
        vmAlimentacion.hasMore &&
        !vmAlimentacion.isLoading) {
      vmAlimentacion.cargarMas();
    }
  }

  void _onScrollHidratacion() {
    if (_hidrScrollController.position.pixels >=
            _hidrScrollController.position.maxScrollExtent - 200 &&
        vmHidratacion.hasMore &&
        !vmHidratacion.isLoading) {
      vmHidratacion.cargarMas();
    }
  }

  @override
  void dispose() {
    // Limpia controladores de scroll
    _alimScrollController
      ..removeListener(_onScrollAlimentos)
      ..dispose();
    _hidrScrollController
      ..removeListener(_onScrollHidratacion)
      ..dispose();

    // Limpia listeners de los ViewModels
    vmAlimentacion.removeListener(_onVmChanged);
    vmHidratacion.removeListener(_onVmChanged);

    super.dispose();
  }

  /// Construye la UI general de la pantalla.
  @override
  Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xFFF5F7FA),
    body: Column(
      children: [
        const Header(
          titulo: 'Nutrición',
          subtitulo: 'Visualiza tu alimentación',
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              children: [
                Expanded(child: _buildColumnSectionAlimentos()),
                const SizedBox(width: 16),
                Expanded(child: _buildColumnSectionHidratacion()),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

  /// Construye la columna que contiene la lista de alimentos.
  Widget _buildColumnSectionAlimentos() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header
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
        // Lista dinámica con scroll infinito
        Expanded(
          child:
              vmAlimentacion.alimentos.isEmpty && vmAlimentacion.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                    controller: _alimScrollController,
                    itemCount:
                        vmAlimentacion.alimentos.length +
                        (vmAlimentacion.hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index < vmAlimentacion.alimentos.length) {
                        return _buildRowAlimento(
                          vmAlimentacion.alimentos[index],
                          index,
                        );
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

  /// Construye la columna de hidratación (datos simulados).
  Widget _buildColumnSectionHidratacion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: const BoxDecoration(
            color: Color(0xFF92D050),
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: Text(
                  'Hidratación',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              // IconButton(
              //   icon: const Icon(Icons.add),
              //   onPressed: _onAgregarHidratacion,
              // ),
            ],
          ),
        ),
        // Lista dinámica con scroll infinito
        // Lista dinámica con scroll infinito
        Expanded(
          child:
              vmHidratacion.listaHidratacion.isEmpty && vmHidratacion.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                    controller: _hidrScrollController,
                    itemCount:
                        vmHidratacion.listaHidratacion.length +
                        (vmHidratacion.hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index < vmHidratacion.listaHidratacion.length) {
                        return _buildRowHidratacion(
                          vmHidratacion.listaHidratacion[index],
                          index,
                        );
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

  /// Construye una fila individual con un [alimento] y botones de acción.
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
            onPressed: () => _onEditarAlimento(alimento),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _onEliminarAlimento(alimento.idAlimento),
          ),
        ],
      ),
    );
  }

  Widget _buildRowHidratacion(Hidratacion hidratacion, int index) {
    final bg = index.isEven ? Colors.white : Colors.grey.shade200;
    return Container(
      color: bg,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      height: 48,
      child: Row(
        children: [
          Expanded(child: Text(hidratacion.nombreHidratacion)),
          // placeholder para el espacio del icono “editar”
          const SizedBox(width: 48),
          // placeholder para el espacio del icono “borrar”
          const SizedBox(width: 48),
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
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          backgroundColor: const Color(0xFFF8F1F1),
          title: const Center(
            child: Text(
              'Nuevo Alimento',
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
              const SizedBox(height: 5),
              TextField(
                controller: descripcionController,
                maxLength: 200,
                decoration: const InputDecoration(labelText: 'Descripción:'),
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final nombre = nombreController.text.trim();
                      final descripcion = descripcionController.text.trim();

                      final resultado = await vmAlimentacion.registrarAlimento(
                        nombre,
                        descripcion,
                      );
                      if (!mounted) return;

                      if (resultado == null) {
                        Navigator.of(dialogContext).pop();
                        await vmAlimentacion.cargarAlimentos();
                      } else {
                        ScaffoldMessenger.of(
                          dialogContext,
                        ).showSnackBar(SnackBar(content: Text(resultado)));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(120, 48),
                      textStyle: const TextStyle(fontSize: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: const Text('Guardar'),
                  ),
                  const SizedBox(width: 40),
                  ElevatedButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(120, 48),
                      textStyle: const TextStyle(fontSize: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
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

  /// Muestra un diálogo para editar [alimento] y guarda cambios.
  void _onEditarAlimento(Alimento alimento) {
    final nombreController = TextEditingController(
      text: alimento.nombreAlimento,
    );
    final descripcionController = TextEditingController(
      text: alimento.descripcionAlimento,
    );

    showDialog(
      context: context,
      builder:
          (BuildContext dialogContext) => AlertDialog(
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
                  final resultado = await vmAlimentacion.editarAlimento(
                    Alimento(
                      idAlimento: alimento.idAlimento,
                      nombreAlimento: nombreController.text.trim(),
                      descripcionAlimento: descripcionController.text.trim(),
                    ),
                  );
                  if (resultado == null) {
                    Navigator.of(dialogContext).pop();
                  } else {
                    ScaffoldMessenger.of(
                      dialogContext,
                    ).showSnackBar(SnackBar(content: Text(resultado)));
                  }
                },
                child: const Text('Guardar'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('Cancelar'),
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
      builder:
          (BuildContext dialogContext) => AlertDialog(
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
                  await vmAlimentacion.eliminarAlimento(idAlimento);
                  Navigator.of(dialogContext).pop();
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    const SnackBar(
                      content: Text('Alimento eliminado exitosamente'),
                    ),
                  );
                },
                child: const Text('Eliminar'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('Cancelar'),
              ),
            ],
          ),
    );
  }
}
