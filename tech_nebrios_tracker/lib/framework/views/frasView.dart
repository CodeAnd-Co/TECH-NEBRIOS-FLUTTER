import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/frasViewModel.dart';
import 'components/header.dart';
import '../../data/models/frasModel.dart';

class FrasScreen extends StatefulWidget {
  final int charolaId;
  const FrasScreen({super.key, required this.charolaId});

  @override
  _FrasScreenState createState() => _FrasScreenState();
}

class _FrasScreenState extends State<FrasScreen> {
  bool _hasLoadedOnce = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasLoadedOnce) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Cargar FRAS usando el charolaId de la ruta
        context.read<FrasViewModel>().cargarFras(widget.charolaId);
      });
      _hasLoadedOnce = true;
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<FrasViewModel>().cargarFras(widget.charolaId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Column(
        children: [
          const Header(titulo: 'Fras', showDivider: true, subtitulo: null),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Consumer<FrasViewModel>(
                builder: (context, frasVM, child) {
                  if (frasVM.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (frasVM.error != null) {
                    return Center(
                      child: Text(
                        frasVM.error!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }
                  final lista = frasVM.frasList;
                  if (lista.isEmpty) {
                    return const Center(
                      child: Text('No hay registros de Fras para mostrar.'),
                    );
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 16.0,
                    ),
                    itemCount: lista.length,
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 300,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 12,
                          childAspectRatio: 1.0,
                        ),
                    itemBuilder: (context, index) {
                      final item = lista[index];
                      return _buildFrasCard(item);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFrasCard(Fras data) {
    final fecha = data.fechaRegistro;
    final fechaStr =
        '${fecha.day.toString().padLeft(2, '0')}/'
        '${fecha.month.toString().padLeft(2, '0')}/'
        '${fecha.year}';

    return Card(
      margin: const EdgeInsets.all(4.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF2E7D32),
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 14.0),
                    child: Center(
                      child: Text(
                        'Fras Generado',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFF43A047),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14.0),
                      child: Center(
                        child: Text(
                          'Producción',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16.0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '${data.gramosGenerados.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'gramos',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        data.nombreCharola,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Colors.grey),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 25.0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      fechaStr,
                      style: const TextStyle(
                        fontSize: 17,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: InkWell(
                      onTap: () => _showEditDialog(data),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.edit, size: 18, color: Colors.pink),
                          SizedBox(width: 4),
                          Text(
                            'Editar',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: Colors.pink,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

 void _showEditDialog(Fras data) {
  // Aquí cargamos SIN DECIMALES usando toStringAsFixed(0)
  final controller = TextEditingController(
    text: data.gramosGenerados.toStringAsFixed(0),
  );

  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return ChangeNotifierProvider.value(
        value: context.read<FrasViewModel>(),
        child: Consumer<FrasViewModel>(
          builder: (context, vm, _) {
            return AlertDialog(
              title: const Center(
                child: Text(
                  'Editar Gramos',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Divider(height: 1),
                    const SizedBox(height: 30),
                    TextField(
                      controller: controller,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Gramos generados',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: vm.isLoading
                      ? const CircularProgressIndicator()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                minimumSize: const Size(150, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              onPressed: () => Navigator.of(dialogContext).pop(),
                              child: const Text(
                                'Cancelar',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ),
                            const SizedBox(width: 20),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                minimumSize: const Size(150, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              onPressed: () async {
                                final nuevos = double.tryParse(controller.text) ??
                                    data.gramosGenerados;
                                await vm.editarFras(data.charolaId, nuevos);
                                if (vm.error == null) {
                                  Navigator.of(dialogContext).pop();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          '✅ Gramos actualizados exitosamente'),
                                      backgroundColor: Colors.green,
                                      duration: Duration(seconds: 3),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                  vm.cargarFras(data.charolaId);
                                } else {
                                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                                    SnackBar(
                                      content: Text(vm.error!),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                              child: const Text(
                                'Guardar',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ),
                          ],
                        ),
                ),
              ],
            );
          },
        ),
      );
    },
  );
}


}