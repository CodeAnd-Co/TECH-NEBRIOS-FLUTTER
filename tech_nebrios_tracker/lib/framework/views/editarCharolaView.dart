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

                          // Si el estado es “pasada”, dejamos solo el dropdown de estado
                          if (editarViewModel.estadoController.text == "pasada")
                            Center(
                              child: _buildDropdownStateField(
                                label: "Estado",
                                items: const ["activa", "pasada"],
                                value: editarViewModel.estadoController.text,
                                onChanged: (value) {
                                  editarViewModel.estadoController.text =
                                      value!;
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
                                        controller:
                                            editarViewModel.nombreController,
                                        validator: (v) => v == null || v.isEmpty
                                            ? 'Nombre obligatorio'
                                            : null,
                                        maxLength: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: _buildDateFormField(
                                        label: 'Fecha (dd/mm/yyyy) *',
                                        controller:
                                            editarViewModel.fechaController,
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
                                        controller: editarViewModel
                                            .densidadLarvaController,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly,
                                          PositiveNumberFormatter(),
                                        ],
                                        validator: (v) => v == null || v.isEmpty
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
                                      child: _buildDropdownFormField<Alimento>(
                                        label: 'Alimentación *',
                                        items: vm.alimentos
                                            .map((a) => a.nombreAlimento)
                                            .toList(),
                                        value: editarViewModel
                                            .selectedAlimentacion
                                            ?.nombreAlimento,
                                        onChanged: (value) {
                                          final alimentoSel = vm.alimentos
                                              .firstWhere((a) =>
                                                  a.nombreAlimento == value);
                                          editarViewModel.setAlimentacion =
                                              alimentoSel;
                                        },
                                        validator: (v) =>
                                            v == null ? 'Selecciona alimento' : null,
                                        hintText: vm.alimentos.isEmpty
                                            ? 'No hay alimentos disponibles'
                                            : 'Selecciona alimento',
                                        hintColor: vm.alimentos.isEmpty
                                            ? Colors.red
                                            : null,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: _buildTextFormField(
                                        label: 'Cantidad de alimento (gr) *',
                                        controller:
                                            editarViewModel.comidaCicloController,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly,
                                          PositiveNumberFormatter(),
                                        ],
                                        maxLength: 4,
                                        validator: (v) => v == null || v.isEmpty
                                            ? 'Ingresa cantidad'
                                            : null,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: _buildDropdownStateField(
                                        label: "Estado",
                                        items: const ["activa", "pasada"],
                                        value: editarViewModel
                                            .estadoController
                                            .text,
                                        onChanged: (value) {
                                          editarViewModel.estadoController.text =
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
                                      child: _buildDropdownFormField<Hidratacion>(
                                        label: 'Hidratación *',
                                        items: vm.hidrataciones
                                            .map((h) => h.nombreHidratacion)
                                            .toList(),
                                        value: editarViewModel
                                            .selectedHidratacion
                                            ?.nombreHidratacion,
                                        onChanged: (value) {
                                          final hidraSel = vm.hidrataciones
                                              .firstWhere((h) =>
                                                  h.nombreHidratacion == value);
                                          editarViewModel.setHidratacion = hidraSel;
                                        },
                                        validator: (v) => v == null
                                            ? 'Selecciona hidratación'
                                            : null,
                                        hintText: vm.hidrataciones.isEmpty
                                            ? 'No hay hidratación disponible'
                                            : 'Selecciona hidratación',
                                        hintColor: vm.hidrataciones.isEmpty
                                            ? Colors.red
                                            : null,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: _buildTextFormField(
                                        label: 'Cantidad de hidratación (gr) *',
                                        controller:
                                            editarViewModel.hidratacionCicloController,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly,
                                          PositiveNumberFormatter(),
                                        ],
                                        maxLength: 4,
                                        validator: (v) => v == null || v.isEmpty
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
                          editarViewModel.cargandoEditar
                              ? const CircularProgressIndicator()
                              : Row(
                                  children: [
                                    TextButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        minimumSize: const Size(150, 50),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
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
                                          borderRadius:
                                              BorderRadius.circular(5),
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
                                        if (vm.formKey.currentState!
                                            .validate()) {
                                          await editarViewModel
                                              .editarCharola(charolaId);
                                          vm.resetForm();
                                          Navigator.of(dialogContext).pop();
                                          vm.cargarCharola(charolaId);
                                          vm.cargarCharolas();

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
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
      hintStyle: hintColor != null
          ? TextStyle(color: hintColor)
          : null,
    ),
    items: items
        .map((item) => DropdownMenuItem(value: item, child: Text(item)))
        .toList(),
    onChanged: onChanged,
    validator: validator,
    hint: hintText != null
        ? Text(
            hintText,
            style: hintColor != null
                ? TextStyle(color: hintColor)
                : null,
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

/// Helper genérico para dropdowns (Alimento / Hidratación) con hint interno
Widget _buildDropdownFormField<T>({
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
      hintStyle:
          hintColor != null ? TextStyle(color: hintColor) : null,
    ),
    items: items
        .map((item) => DropdownMenuItem(value: item, child: Text(item)))
        .toList(),
    onChanged: onChanged,
    validator: validator,
    hint: hintText != null
        ? Text(
            hintText,
            style: hintColor != null
                ? TextStyle(color: hintColor)
                : null,
          )
        : null,
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
