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
  required String alimento, 
  required int alimentoOtorgado, 
  required String hidratacion, 
  required int hidratacionOtorgado,
  required int peso
  }) {
  

  final vm = Provider.of<CharolaViewModel>(context, listen: false);
  final editarViewModel = Provider.of<EditarCharolaViewModel>(context, listen: false);

  // Cargar dropdowns si están vacíos
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (vm.alimentos.isEmpty) vm.cargarAlimentos();
    if (vm.hidrataciones.isEmpty) vm.cargarHidratacion();
  });

  showDialog(
    context: context,
    builder: (dialogContext) {
      return FutureBuilder(
        future: editarViewModel.cargarDatos(nombreCharola, fechaCreacion, densidadLarva, alimento, alimentoOtorgado, hidratacion, hidratacionOtorgado, peso),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const AlertDialog(
              content: SizedBox(
                height: 100,
                child: Center(child: CircularProgressIndicator()),
              ),
            );
          }

      
      return AlertDialog(
        title: const Text('Editar informacion de la charola'),
        content: SizedBox(
        child: SingleChildScrollView(
          child: Form(
            key: vm.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Nombre de la charola:"),
                          _buildTextFormField(
                            controller: editarViewModel.nombreController,
                            validator: (v) => v == null || v.isEmpty ? 'Nombre obligatorio' : null,
                            maxLength: 20,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Fecha de creación:"),
                          _buildDateFormField(
                            controller: editarViewModel.fechaController,
                            context: dialogContext,
                            validator: (v) => v == null || v.isEmpty ? 'Selecciona fecha' : null,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Densidad de Larva:"),
                        _buildTextFormField(
                          controller: editarViewModel.densidadLarvaController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            PositiveNumberFormatter(),
                          ],
                          validator: (v) => v == null || v.isEmpty ? 'Ingresa densidad' : null,
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Tipo de alimento:"),
                          _buildDropdownFormField<Alimento>(
                            items: vm.alimentos.map((a) => a.nombreAlimento).toList(),
                            value: editarViewModel.selectedAlimentacion.nombreAlimento,
                            onChanged: (value) {
                              editarViewModel.selectedAlimentacion = vm.alimentos.firstWhere((a) => a.nombreAlimento == value);
                            },
                            validator: (v) => v == null ? 'Selecciona alimento' : null,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Cantidad de alimento (gr):"),
                          _buildTextFormField(
                            controller: editarViewModel.comidaCicloController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              PositiveNumberFormatter(),
                            ],
                            validator: (v) => v == null || v.isEmpty ? 'Ingresa cantidad' : null,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Peso:"),
                        _buildTextFormField(
                          controller: editarViewModel.pesoController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            PositiveNumberFormatter(),
                          ],
                          validator: (v) => v == null || v.isEmpty ? 'Ingresa peso' : null,
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Tipo de Hidratación:"),
                          _buildDropdownFormField<Hidratacion>(
                            items: vm.hidrataciones.map((h) => h.nombreHidratacion).toList(),
                            value: editarViewModel.selectedHidratacion,
                            onChanged: (value) {
                              vm.selectedHidratacion = vm.hidrataciones.firstWhere((h) => h.nombreHidratacion == value);
                            },
                            validator: (v) => v == null ? 'Selecciona hidratación' : null,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Cantidad de hidratación (gr):"),
                        _buildTextFormField(
                          controller: editarViewModel.hidratacionCicloController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            PositiveNumberFormatter(),
                          ],
                          validator: (v) => v == null || v.isEmpty ? 'Ingresa cantidad' : null,
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
          TextButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              minimumSize: const Size(150, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            child: const Text('Cancelar', style: TextStyle(color: Colors.white, fontSize: 20),),
            onPressed: () {
              vm.resetForm();
              Navigator.of(dialogContext).pop();
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              minimumSize: const Size(150, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            child: const Text('Editar información', style: TextStyle(color: Colors.white, fontSize: 20),),
            onPressed: () async {
              if (vm.formKey.currentState!.validate()) {
                try {
                  await editarViewModel.editarCharola(charolaId);
                  vm.resetForm();
                  Navigator.of(dialogContext).pop();
                  /*
                  vm.cargarCharolas();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Charola registrada exitosamente'),
                      backgroundColor: Colors.green,
                    ),
                  );*/
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.toString()),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
          ),
        ],
      );
    }
    );
    },
  );
}


  Widget _buildTextFormField({
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
            border: const OutlineInputBorder(),
            counterText: '',
          ),
          validator: validator,
        ),
      ),
    );
  }

Widget _buildDropdownFormField<T>({
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
            border: const OutlineInputBorder(),
          ),
          items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
          onChanged: onChanged,
          validator: validator,
        ),
      ),
    );
  }
  Widget _buildDateFormField({
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
            );
            if (pickedDate != null) {
              controller.text = '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
            }
          },
        ),
      ),
    );
  }