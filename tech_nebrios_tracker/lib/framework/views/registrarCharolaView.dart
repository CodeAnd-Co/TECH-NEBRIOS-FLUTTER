// RF5 Registrar una nueva charola en el sistema - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF5
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../viewmodels/charolaViewModel.dart';
import '../../data/models/alimentacionModel.dart';
import '../../data/models/hidratacionModel.dart';
import '../../utils/positive_number_formatter.dart';

class RegistrarCharolaView extends StatelessWidget {
  const RegistrarCharolaView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<CharolaViewModel>(context);
    // Carga dropdowns una única vez tras el primer frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (vm.alimentos.isEmpty) vm.cargarAlimentos();
      if (vm.hidrataciones.isEmpty) vm.cargarHidratacion();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Charola'),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 35,
          color: Colors.black,
          fontWeight: FontWeight.w400,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: vm.formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Divider(
                  thickness: 4,
                  color: Color.fromRGBO(56, 88, 129, 1),
                ),
                const SizedBox(height: 10),
                const Center(
                  child: Text(
                    'Ingresa una charola nueva',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(height: 75),
                GridView.count(
                  crossAxisCount: 3,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                  childAspectRatio: 4.5,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildTextFormField(
                      label: 'Nombre *',
                      controller: vm.nombreController,
                      validator: (v) => v == null || v.isEmpty ? 'Nombre obligatorio' : null,
                      maxLength: 20,
                    ),
                    _buildTextFormField(
                      label: 'Densidad de Larva *',
                      controller: vm.densidadLarvaController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        PositiveNumberFormatter(),
                      ],
                      validator: (v) => v == null || v.isEmpty ? 'Ingresa densidad' : null,
                    ),
                    _buildDateFormField(
                      label: 'Fecha (dd/mm/yyyy) *',
                      controller: vm.fechaController,
                      context: context,
                      validator: (v) => v == null || v.isEmpty ? 'Selecciona fecha' : null,
                    ),
                    _buildDropdownFormField<Alimento>(
                      label: 'Alimentación *',
                      items: vm.alimentos.map((a) => a.nombreAlimento).toList(),
                      value: vm.selectedAlimentacion?.nombreAlimento,
                      onChanged: (value) {
                        vm.selectedAlimentacion = vm.alimentos.firstWhere((a) => a.nombreAlimento == value);
                      },
                      validator: (v) => v == null ? 'Selecciona alimento' : null,
                    ),
                    _buildTextFormField(
                      label: 'Cantidad de alimento (g) *',
                      controller: vm.comidaCicloController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        PositiveNumberFormatter(),
                      ],
                      validator: (v) => v == null || v.isEmpty ? 'Ingresa cantidad' : null,
                    ),
                    _buildTextFormField(
                      label: 'Peso (g) *',
                      controller: vm.pesoController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        PositiveNumberFormatter(),
                      ],
                      validator: (v) => v == null || v.isEmpty ? 'Ingresa peso' : null,
                    ),
                    _buildDropdownFormField<Hidratacion>(
                      label: 'Hidratación *',
                      items: vm.hidrataciones.map((h) => h.nombreHidratacion).toList(),
                      value: vm.selectedHidratacion?.nombreHidratacion,
                      onChanged: (value) {
                        vm.selectedHidratacion = vm.hidrataciones.firstWhere((h) => h.nombreHidratacion == value);
                      },
                      validator: (v) => v == null ? 'Selecciona hidratación' : null,
                    ),
                    _buildTextFormField(
                      label: 'Cantidad de hidratación (g) *',
                      controller: vm.hidratacionCicloController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        PositiveNumberFormatter(),
                      ],
                      validator: (v) => v == null || v.isEmpty ? 'Ingresa cantidad' : null,
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                   onPressed: () async {
                    if (vm.formKey.currentState!.validate()) {
                      try {
                        // Registrar y obtener la nueva CharolaTarjeta
                        final nuevaTarjeta = await vm.registrarCharola();
                        vm.resetForm();
                        await vm.cargarCharolas();
                        // Salir de esta pantalla devolviendo la tarjeta creada
                        Navigator.pop(context, nuevaTarjeta);
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    minimumSize: const Size(200, 70),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Registrar',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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
          ),
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
            );
            if (pickedDate != null) {
              controller.text = '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
            }
          },
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
          items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
          onChanged: onChanged,
          validator: validator,
        ),
      ),
    );
  }
}
