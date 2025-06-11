import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/frasViewModel.dart';
import 'components/header.dart';
import '../../data/models/frasModel.dart';
import 'package:zuustento_tracker/framework/views/components/FormFields.dart';
import 'package:zuustento_tracker/utils/positive_number_formatter.dart';
import 'package:flutter/services.dart';

class FrasScreen extends StatefulWidget {
  final int charolaId;
  const FrasScreen({super.key, required this.charolaId});

  @override
  _FrasScreenState createState() => _FrasScreenState();
}

class _FrasScreenState extends State<FrasScreen> {
  final formKey4 = GlobalKey<FormState>();
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
                  /*if (frasVM.error != null) {
                    return Center(
                      child: Text(
                        frasVM.error!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }*/
                  final lista = frasVM.frasList;
                  if (lista.isEmpty) {
                    return const Center(
                      child: Text('No hay registros de Fras para mostrar.'),
                    );
                  }
                  return GridView.builder(
                    itemCount: lista.length,
                    gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        crossAxisSpacing: 4,
                        childAspectRatio: 0.9,
                    ),
                    itemBuilder: (context, index) {
                      return LayoutBuilder(
                        builder: (context, constraints) {
                          final item = lista[index];
                          return AspectRatio(
                            aspectRatio: 1.1,
                            child: _buildFrasCard(item)
                          );
                        },
                      );
                    }
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

  return LayoutBuilder(
    builder: (context, constraints) {
      final ancho = constraints.maxWidth;
      final alto = constraints.maxHeight;
      final double fontSizeTitle = (ancho * 0.08);
      final double fontSizeValue = (ancho * 0.12);
      final double fontSizeLabel = (ancho * 0.06);
      final double fontSizeFecha = (ancho * 0.06);
      final double fontSizeEditar = (ancho * 0.06);
      final paddingVertical = alto * 0.06;

    return Card(
      margin: const EdgeInsets.all(4.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Column(
        children: [
          Container(
            height: 60, 
            decoration: const BoxDecoration(
              color: Color(0xFF2E7D32),
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Generado',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: fontSizeTitle,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFF43A047),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(12),
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Origen',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: fontSizeTitle,
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
              padding: EdgeInsets.symmetric(vertical: paddingVertical),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '${data.gramosGenerados.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: fontSizeValue,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'gramos',
                          style: TextStyle(
                            fontSize: fontSizeLabel,
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
                        style: TextStyle(
                          fontSize: fontSizeLabel,
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
            padding: EdgeInsets.symmetric(vertical: paddingVertical),
            child: Row(
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      fechaStr,
                      style: TextStyle(
                        fontSize: fontSizeFecha,
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
                        children: [
                          Icon(Icons.edit, size: 18, color: Colors.pink),
                          SizedBox(width: 4),
                          Text(
                            'Editar',
                            style: TextStyle(
                              fontSize: fontSizeEditar,
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
    },
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
                  child: Form(
                    key: formKey4,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Divider(height: 1),
                      const SizedBox(height: 30),
                      CustomTextFormField(
                        label: 'Gramos generados*', 
                        controller: controller,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          PositiveNumberFormatter()
                        ],
                        validator: (v) => v == null || v.isEmpty
                              ? 'Cantidad obligatoria'
                              : null,
                        maxLength: 4,
                        width: 400,
                      ),
                    ],
                  ),
                ),
                ),
                actionsAlignment: MainAxisAlignment.center,
                actions: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child:
                        vm.isLoading
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
                                  onPressed:
                                      () => Navigator.of(dialogContext).pop(),
                                  child: const Text(
                                    'Cancelar',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
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
                                    if (formKey4.currentState!.validate()) {
                                      final nuevos = double.tryParse(controller.text);
                                      await vm.editarFras(data.frasId, nuevos!);
                                      if (vm.error == null) {
                                        Navigator.of(dialogContext).pop();
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              '✅ Gramos actualizados exitosamente',
                                            ),
                                            backgroundColor: Colors.green,
                                            duration: Duration(seconds: 3),
                                            behavior: SnackBarBehavior.floating,
                                          ),
                                        );
                                        vm.cargarFras(data.charolaId);
                                      } else {
                                        ScaffoldMessenger.of(
                                          dialogContext,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(vm.error!),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  child: const Text(
                                    'Guardar',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
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
