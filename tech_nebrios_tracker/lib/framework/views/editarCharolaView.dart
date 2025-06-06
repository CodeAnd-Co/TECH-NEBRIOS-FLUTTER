// RF7 Editar información de una charola
// https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF7

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../viewmodels/editarCharolaViewModel.dart';
import '../viewmodels/charolaViewModel.dart';
import '../../utils/positive_number_formatter.dart';

Future<void> mostrarPopUpEditarCharola({
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
}) async {
  final vm = Provider.of<CharolaViewModel>(context, listen: false);
  final editarViewModel = Provider.of<EditarCharolaViewModel>(
    context,
    listen: false,
  );

  await editarViewModel.cargarDatos(nombreCharola, fechaCreacion, densidadLarva, alimentoId, alimento, alimentoOtorgado, hidratacionId, hidratacion, hidratacionOtorgado, estado);

  // Cargar dropdowns y los datos existentes en el ViewModel de edición
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (vm.alimentos.isEmpty) vm.cargarAlimentos();
    if (vm.hidrataciones.isEmpty) vm.cargarHidratacion();

    editarViewModel.cargarDatos(
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
    );
  });

  showDialog(
    context: context,
    builder: (dialogContext) {
      return ChangeNotifierProvider.value(
        value: editarViewModel,
        child: Consumer<EditarCharolaViewModel>(
          builder: (context, editarVM, _) {
            return AlertDialog(
              title: const Text(
                'Editar información de la charola',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: Form(
                  key: vm.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(height: 1),
                      const SizedBox(height: 30),

                      // Si el estado es “pasada”, mostramos solo el dropdown de estado
                      if (editarVM.estadoController.text == "pasada")
                        Center(
                          child: _buildDropdownStateField(
                            label: "Estado",
                            items: const ["activa", "pasada"],
                            value: editarVM.estadoController.text,
                            onChanged: (value) {
                              editarVM.estadoController.text = value!;
                            },
                            validator: (v) =>
                                v == null ? 'Selecciona un estado' : null,
                          ),
                        )
                      else
                        Column(
                          children: [
                            // ─── FILA 1: Nombre | Fecha | Densidad ───
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTextFormField(
                                    label: 'Nombre *',
                                    controller: editarVM.nombreController,
                                    validator: (v) =>
                                        v == null || v.isEmpty
                                            ? 'Nombre obligatorio'
                                            : null,
                                    maxLength: 20,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _buildDateFormField(
                                    label: 'Fecha (dd/mm/yyyy) *',
                                    controller: editarVM.fechaController,
                                    context: dialogContext,
                                    validator: (v) =>
                                        v == null || v.isEmpty
                                            ? 'Selecciona fecha'
                                            : null,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _buildTextFormField(
                                    label: "Densidad de larva",
                                    controller:
                                        editarVM.densidadLarvaController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      PositiveNumberFormatter(),
                                    ],
                                    validator: (v) =>
                                        v == null || v.isEmpty
                                            ? 'Ingresa densidad'
                                            : null,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 30),

                            // ─── FILA 2: Dropdown Alimentos | Cantidad Alimento | Estado ───
                            Row(
                              children: [
                                Expanded(
                                  child: Builder(builder: (ctx) {
                                    // 1. Lista de nombres de alimentos
                                    final listaAlimentos = vm.alimentos
                                        .map((a) => a.nombreAlimento)
                                        .toList();
                                    // 2. Valor actual solo si existe en la lista
                                    String? valorActualAlim;
                                    final nombreGuardado = editarVM
                                        .selectedAlimentacion
                                        ?.nombreAlimento;
                                    if (listaAlimentos.isNotEmpty &&
                                        nombreGuardado != null &&
                                        listaAlimentos.contains(nombreGuardado)) {
                                      valorActualAlim = nombreGuardado;
                                    } else {
                                      valorActualAlim = null;
                                    }

                                    return DropdownButtonFormField<String>(
                                      hint: listaAlimentos.isEmpty
                                          ? const Text(
                                              'No hay alimentos disponibles',
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 14,
                                              ),
                                            )
                                          : const Text('Selecciona alimento'),
                                      decoration: const InputDecoration(
                                        labelText: 'Alimentación *',
                                        border: OutlineInputBorder(),
                                        isDense: true,
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 12,
                                        ),
                                      ),
                                      items: listaAlimentos
                                          .map((nombre) => DropdownMenuItem(
                                              value: nombre,
                                              child: Text(nombre)))
                                          .toList(),
                                      value: valorActualAlim,
                                      onChanged: listaAlimentos.isEmpty
                                          ? null
                                          : (nuevo) {
                                              final seleccionado = vm.alimentos
                                                  .firstWhere((a) =>
                                                      a.nombreAlimento == nuevo);
                                              editarVM.selectedAlimentacion =
                                                  seleccionado;
                                            },
                                      validator: (v) =>
                                          v == null ? 'Selecciona alimento' : null,
                                    );
                                  }),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _buildTextFormField(
                                    label: 'Cantidad de alimento (gr) *',
                                    controller:
                                        editarVM.comidaCicloController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      PositiveNumberFormatter(),
                                    ],
                                    maxLength: 4,
                                    validator: (v) =>
                                        v == null || v.isEmpty
                                            ? 'Ingresa cantidad'
                                            : null,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _buildDropdownStateField(
                                    label: "Estado",
                                    items: const ["activa", "pasada"],
                                    value: editarVM.estadoController.text,
                                    onChanged: (value) {
                                      editarVM.estadoController.text =
                                          value!;
                                    },
                                    validator: (v) =>
                                        v == null ? 'Selecciona un estado' : null,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 30),

                            // ─── FILA 3: Dropdown Hidratación | Cantidad Hidratación ───
                            Row(
                              children: [
                                Expanded(
                                  child: Builder(builder: (ctx) {
                                    // 1. Lista de nombres de hidratación
                                    final listaHidra = vm.hidrataciones
                                        .map((h) => h.nombreHidratacion)
                                        .toList();
                                    // 2. Valor actual solo si existe en la lista
                                    String? valorActualHidra;
                                    final nombreGuardadoH = editarVM
                                        .selectedHidratacion
                                        ?.nombreHidratacion;
                                    if (listaHidra.isNotEmpty &&
                                        nombreGuardadoH != null &&
                                        listaHidra.contains(nombreGuardadoH)) {
                                      valorActualHidra = nombreGuardadoH;
                                    } else {
                                      valorActualHidra = null;
                                    }

                                    return DropdownButtonFormField<String>(
                                      hint: listaHidra.isEmpty
                                          ? const Text(
                                              'No hay hidratación disponible',
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 14,
                                              ),
                                            )
                                          : const Text('Selecciona hidratación'),
                                      decoration: const InputDecoration(
                                        labelText: 'Hidratación *',
                                        border: OutlineInputBorder(),
                                        isDense: true,
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 12,
                                        ),
                                      ),
                                      items: listaHidra
                                          .map((nombre) => DropdownMenuItem(
                                              value: nombre,
                                              child: Text(nombre)))
                                          .toList(),
                                      value: valorActualHidra,
                                      onChanged: listaHidra.isEmpty
                                          ? null
                                          : (nuevo) {
                                              final seleccionadoH = vm.hidrataciones
                                                  .firstWhere((h) =>
                                                      h.nombreHidratacion == nuevo);
                                              editarVM.selectedHidratacion =
                                                  seleccionadoH;
                                            },
                                      validator: (v) =>
                                          v == null ? 'Selecciona hidratación' : null,
                                    );
                                  }),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _buildTextFormField(
                                    label: 'Cantidad de hidratación (gr) *',
                                    controller:
                                        editarVM.hidratacionCicloController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      PositiveNumberFormatter(),
                                    ],
                                    maxLength: 4,
                                    validator: (v) =>
                                        v == null || v.isEmpty
                                            ? 'Ingresa cantidad'
                                            : null,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                // Columna vacía para equilibrar 3 campos por fila
                                const Expanded(child: SizedBox()),
                              ],
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              actions: [
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      editarVM.cargandoEditar
                          ? const CircularProgressIndicator()
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
                                    'Editar',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                  onPressed: () async {
                                    if (vm.formKey.currentState!.validate()) {
                                      await editarVM.editarCharola(charolaId);
                                      vm.resetForm();
                                      Navigator.of(dialogContext).pop();
                                      vm.cargarCharola(charolaId);
                                      vm.cargarCharolas();

                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(editarVM.mensaje),
                                          backgroundColor: editarVM.error
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
}

/// Texto + campo dropdown para “Estado”
Widget _buildDropdownStateField({
  required String label,
  required List<String> items,
  required String? value,
  required ValueChanged<String?> onChanged,
  String? Function(String?)? validator,
  String? hintText,
  Color? hintColor,
}) {
  return DropdownButtonFormField<String>(
    value: value,
    decoration: InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
      hintStyle: hintColor != null ? TextStyle(color: hintColor) : null,
    ),
    items: items
        .map((item) => DropdownMenuItem(value: item, child: Text(item)))
        .toList(),
    onChanged: onChanged,
    validator: validator,
    hint: hintText != null
        ? Text(
            hintText,
            style: hintColor != null ? TextStyle(color: hintColor) : null,
          )
        : null,
  );
}

/// Helper genérico para campos de texto
Widget _buildTextFormField({
  required String label,
  required TextEditingController controller,
  TextInputType keyboardType = TextInputType.text,
  List<TextInputFormatter>? inputFormatters,
  String? Function(String?)? validator,
  int? maxLength,
}) {
  return TextFormField(
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
  );
}

/// Helper genérico para fecha
Widget _buildDateFormField({
  required String label,
  required TextEditingController controller,
  required BuildContext context,
  String? Function(String?)? validator,
}) {
  return TextFormField(
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
  );
}
