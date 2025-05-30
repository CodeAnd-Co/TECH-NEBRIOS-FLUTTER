//RF7 Editar información de una charola https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF7

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../viewmodels/editarCharolaViewModel.dart';
import '../viewmodels/charolaViewModel.dart';
import '../../data/models/alimentacionModel.dart';
import '../../data/models/hidratacionModel.dart';
import '../../utils/positive_number_formatter.dart';

void mostrarPopUpEditarCharola({
  required BuildContext context,
  required int charolaId,
  required String nombreCharola,
  required String fechaCreacion,
  required int densidadLarva,
  required int alimentoId,
  required String alimento,
  required int alimentoOtorgado,
  required int hidratacionId,
  required String hidratacion,
  required int hidratacionOtorgado,
  required String estado,
}) {
  final vm = Provider.of<CharolaViewModel>(context, listen: false);
  final editarViewModel = Provider.of<EditarCharolaViewModel>(
    context,
    listen: false,
  );

  // Cargar dropdowns si están vacíos
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (vm.alimentos.isEmpty) vm.cargarAlimentos();
    if (vm.hidrataciones.isEmpty) vm.cargarHidratacion();
  });

  showDialog(
    context: context,
    builder: (dialogContext) {
      return FutureBuilder(
        future: editarViewModel.cargarDatos(
          nombreCharola,
          fechaCreacion,
          densidadLarva,
          alimentoId,
          alimento,
          alimentoOtorgado,
          hidratacionId,
          hidratacion,
          hidratacionOtorgado,
          estado,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const AlertDialog(
              content: SizedBox(
                height: 100,
                child: Center(child: CircularProgressIndicator()),
              ),
            );
          }

          return ChangeNotifierProvider.value(
            value: editarViewModel,
            child: Consumer<EditarCharolaViewModel>(
              builder: (context, value, _) {
                return AlertDialog(
                  title: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Center(
                        child: Text(
                          'Editar información de la charola',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  content: SizedBox(
                    child: SingleChildScrollView(
                      child: Form(
                        key: vm.formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Divider(height: 1),
                            const SizedBox(height: 30),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildTextFormField(
                                        label: 'Nombre *',
                                        controller:
                                            editarViewModel.nombreController,
                                        validator:
                                            (v) =>
                                                v == null || v.isEmpty
                                                    ? 'Nombre obligatorio'
                                                    : null,
                                        maxLength: 20,
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildDateFormField(
                                        label: 'Fecha (dd/mm/yyyy) *',
                                        controller:
                                            editarViewModel.fechaController,
                                        context: dialogContext,
                                        validator:
                                            (v) =>
                                                v == null || v.isEmpty
                                                    ? 'Selecciona fecha'
                                                    : null,
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildTextFormField(
                                      label: "Densidad de larva",
                                      controller:
                                          editarViewModel
                                              .densidadLarvaController,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        PositiveNumberFormatter(),
                                      ],
                                      validator:
                                          (v) =>
                                              v == null || v.isEmpty
                                                  ? 'Ingresa densidad'
                                                  : null,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildDropdownFormField<Alimento>(
                                        label: 'Alimentación *',
                                        items:
                                            vm.alimentos
                                                .map((a) => a.nombreAlimento)
                                                .toList(),
                                        value:
                                            editarViewModel
                                                .selectedAlimentacion
                                                ?.nombreAlimento,
                                        onChanged: (value) {
                                          final alimento = vm.alimentos
                                              .firstWhere(
                                                (a) =>
                                                    a.nombreAlimento == value,
                                              );
                                          editarViewModel.setAlimentacion =
                                              alimento;
                                        },
                                        validator:
                                            (v) =>
                                                v == null
                                                    ? 'Selecciona alimento'
                                                    : null,
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildTextFormField(
                                        label: 'Cantidad de alimento (gr) *',
                                        controller:
                                            editarViewModel
                                                .comidaCicloController,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                          PositiveNumberFormatter(),
                                        ],
                                        maxLength: 4,
                                        validator:
                                            (v) =>
                                                v == null || v.isEmpty
                                                    ? 'Ingresa cantidad'
                                                    : null,
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildDropdownFormField(
                                      label: "Estado",
                                      items: ["activa", "pasada"],
                                      value:
                                          editarViewModel.estadoController.text,
                                      onChanged: (value) {
                                        editarViewModel.estadoController.text =
                                            value!;
                                      },
                                      validator:
                                          (v) =>
                                              v == null
                                                  ? 'Selecciona un estado'
                                                  : null,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildDropdownFormField<Hidratacion>(
                                        label: 'Hidratación *',
                                        items:
                                            vm.hidrataciones
                                                .map((h) => h.nombreHidratacion)
                                                .toList(),
                                        value:
                                            editarViewModel
                                                .selectedHidratacion
                                                ?.nombreHidratacion,
                                        onChanged: (value) {
                                          final hidratacion = vm.hidrataciones
                                              .firstWhere(
                                                (h) =>
                                                    h.nombreHidratacion ==
                                                    value,
                                              );
                                          editarViewModel.setHidratacion =
                                              hidratacion;
                                        },
                                        validator:
                                            (v) =>
                                                v == null
                                                    ? 'Selecciona hidratación'
                                                    : null,
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildTextFormField(
                                      label: 'Cantidad de hidratación (gr) *',
                                      controller:
                                          editarViewModel
                                              .hidratacionCicloController,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        PositiveNumberFormatter(),
                                      ],
                                      maxLength: 4,
                                      validator:
                                          (v) =>
                                              v == null || v.isEmpty
                                                  ? 'Ingresa cantidad'
                                                  : null,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  actions: [
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          editarViewModel.cargandoEditar
                              ? CircularProgressIndicator()
                              : Row(
                                children: [
                                  TextButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      minimumSize: const Size(150, 50),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                    child: const Text(
                                      'Cancelar',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                                    onPressed: () {
                                      vm.resetForm();
                                      Navigator.of(dialogContext).pop();
                                    },
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
                                    child: const Text(
                                      'Editar información',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                                    onPressed: () async {
                                      if (vm.formKey.currentState!.validate()) {
                                        await editarViewModel.editarCharola(
                                          charolaId,
                                        );
                                        vm.resetForm();
                                        Navigator.of(dialogContext).pop();
                                        vm.cargarCharola(charolaId);

                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              editarViewModel.mensaje,
                                            ),
                                            backgroundColor:
                                                editarViewModel.error
                                                    ? Colors.red
                                                    : Colors.green,
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ],
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
    },
  );
}

Widget _buildTextFormField({
  required String label,
  required TextEditingController controller,
  TextInputType keyboardType = TextInputType.text,
  List<TextInputFormatter>? inputFormatters,
  String? Function(String?)? validator,
  int? maxLength,
}) {
  return Container(
    margin: const EdgeInsets.all(5),
    child: SizedBox(
      width: 200,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        maxLength: maxLength,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          counterText: '',
        ),
        validator: validator,
      ),
    ),
  );
}

Widget _buildDropdownFormField<T>({
  required String label,
  required List<String> items,
  required String? value,
  required ValueChanged<String?> onChanged,
  String? Function(String?)? validator,
}) {
  return Container(
    margin: const EdgeInsets.all(5),
    child: SizedBox(
      width: 200,
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        items:
            items
                .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                .toList(),
        onChanged: onChanged,
        validator: validator,
      ),
    ),
  );
}

Widget _buildDateFormField({
  required String label,
  required TextEditingController controller,
  required BuildContext context,
  String? Function(String?)? validator,
}) {
  return Container(
    margin: const EdgeInsets.all(5),
    child: SizedBox(
      width: 200,
      child: TextFormField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.calendar_today),
        ),
        validator: validator,
        onTap: () async {
          final pickedDate = await showDatePicker(
            context: context,
            locale: const Locale('es', 'ES'),
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime.now(),
            cancelText: 'Cancelar',
            confirmText: 'Aceptar',
          );
          if (pickedDate != null) {
            final dd = pickedDate.day.toString().padLeft(2, '0');
            final mm = pickedDate.month.toString().padLeft(2, '0');
            controller.text = '$dd/$mm/${pickedDate.year}';
          }
        },
      ),
    ),
  );
}
