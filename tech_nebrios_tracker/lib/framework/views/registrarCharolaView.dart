// framework/views/registrarCharolaView.dart
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
      //if (vm.hidrataciones.isEmpty) vm.cargarHidratacion();
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
                  _buildTextFieldContainer(
                    'Nombre',
                    vm.nombreController,
                    maxLength: 20,
                  ),
                  _buildTextFieldContainer(
                    'Densidad de Larva',
                    vm.densidadLarvaController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      PositiveNumberFormatter(),
                    ],
                  ),
                  _buildDateFieldContainer(
                    'Fecha (dd/mm/yyyy)',
                    vm.fechaController,
                    context,
                  ),
                  _buildDropdownFieldContainer<Alimento>(
                    'Alimentación',
                    vm.alimentos.map((a) => a.nombreAlimento).toList(),
                    vm.selectedAlimentacion?.nombreAlimento,
                    (value) {
                      vm.selectedAlimentacion = vm.alimentos.firstWhere(
                        (a) => a.nombreAlimento == value,
                      );
                      vm.notifyListeners();
                    },
                  ),
                  _buildTextFieldContainer(
                    'Cantidad de alimento (Kg)',
                    vm.comidaCicloController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      PositiveNumberFormatter(),
                    ],
                  ),
                  _buildTextFieldContainer(
                    'Peso (kg)',
                    vm.pesoController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      PositiveNumberFormatter(),
                    ],
                  ),
                  _buildDropdownFieldContainer<Hidratacion>(
                    'Hidratación',
                    vm.hidrataciones.map((h) => h.nombreHidratacion).toList(),
                    vm.selectedHidratacion?.nombreHidratacion,
                    (value) {
                      vm.selectedHidratacion = vm.hidrataciones.firstWhere(
                        (h) => h.nombreHidratacion == value,
                      );
                      vm.notifyListeners();
                    },
                  ),
                  _buildTextFieldContainer(
                    'Cantidad de hidratación (Kg)',
                    vm.hidratacionCicloController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      PositiveNumberFormatter(),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await vm.registrarCharola();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Charola registrada exitosamente'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.toString()),
                        backgroundColor: Colors.red,
                      ),
                    );
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
    );
  }

  Widget _buildTextFieldContainer(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
    int? maxLength,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Container(
      margin: const EdgeInsets.all(5),
      child: SizedBox(
        width: 200,
        child: TextField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
        ),
      ),
    );
  }

  Widget _buildDateFieldContainer(
    String label,
    TextEditingController controller,
    BuildContext context,
  ) {
    return Container(
      margin: const EdgeInsets.all(5),
      child: SizedBox(
        width: 200,
        child: TextField(
          controller: controller,
          readOnly: true,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
            suffixIcon: const Icon(Icons.calendar_today),
          ),
          onTap: () async {
            final pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
            );
            if (pickedDate != null) {
              final formatted =
                  '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
              controller.text = formatted;
            }
          },
        ),
      ),
    );
  }

  Widget _buildDropdownFieldContainer<T>(
    String label,
    List<String> items,
    String? selectedValue,
    ValueChanged<String?> onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.all(5),
      child: SizedBox(
        width: 200,
        child: DropdownButtonFormField<String>(
          value: selectedValue,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
          items:
              items
                  .map(
                    (item) => DropdownMenuItem(value: item, child: Text(item)),
                  )
                  .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
