import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/registrar_charola_viewmodel.dart';

class RegistrarCharolaView extends StatelessWidget {
  const RegistrarCharolaView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<RegistrarCharolaViewModel>(context);

    viewModel.cargarAlimentos();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Charola'),
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 35,
          color: Colors.black,
          fontWeight: FontWeight.w400,
        ),
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
                shrinkWrap: true, // Importante para evitar conflictos de tamaño
                physics:
                    const NeverScrollableScrollPhysics(), // Desactiva el scroll interno
                children: [
                  _buildTextFieldContainer(
                    'Nombre',
                    viewModel.nombreController,
                  ),
                  _buildTextFieldContainer(
                    'Densidad de Larva',
                    viewModel.densidadLarvaController,
                  ),
                  _buildDateFieldContainer(
                    'Fecha (dd/mm/yyyy)',
                    viewModel.fechaController,
                    context,
                  ),
                  _buildDropdownFieldContainer(
                    'Alimentación',
                    viewModel.alimentos,
                    viewModel.selectedAlimentacion != null &&
                            viewModel.alimentos.contains(
                              viewModel.selectedAlimentacion,
                            )
                        ? viewModel.selectedAlimentacion
                        : null, // Asegúrate de que el valor seleccionado sea válido
                    (value) {
                      viewModel.selectedAlimentacion = value;
                      viewModel
                          .notifyListeners(); // Notifica a la vista que el valor ha cambiado
                    },
                  ),
                  _buildTextFieldContainer(
                    'Cantidad de alimento (Kg)',
                    viewModel.cantidadComidaController,
                  ),
                  _buildTextFieldContainer(
                    'Peso (kg)',
                    viewModel.pesoController,
                    keyboardType: TextInputType.number,
                  ),
                  _buildTextFieldContainer(
                    'Hidratación',
                    viewModel.hidratacionController,
                  ),
                  _buildTextFieldContainer(
                    'Cantidad de hidratación (litros)',
                    viewModel.cantidadHidratacionController,
                  ),
                ],
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  await viewModel.registrarCharola();
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

  Widget _buildDateFieldContainer(
    String label,
    TextEditingController controller,
    BuildContext context,
  ) {
    return Container(
      margin: const EdgeInsets.all(5), // Margen alrededor del TextField
      child: SizedBox(
        width: 200, // Ancho fijo para el campo de fecha
        child: TextField(
          controller: controller,
          readOnly: true, // Evita que el usuario escriba manualmente
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
            suffixIcon: const Icon(Icons.calendar_today), // Ícono de calendario
          ),
          onTap: () async {
            // Mostrar el selector de fecha
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(), // Fecha inicial
              firstDate: DateTime(2000), // Fecha mínima
              lastDate: DateTime(2100), // Fecha máxima
            );

            if (pickedDate != null) {
              // Formatear la fecha seleccionada
              String formattedDate =
                  "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
              controller.text = formattedDate; // Actualizar el TextField
            }
          },
        ),
      ),
    );
  }

  Widget _buildTextFieldContainer(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      margin: const EdgeInsets.all(5), // Margen alrededor del TextField
      child: SizedBox(
        width: 200, // Ancho fijo para los TextFields
        child: TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownFieldContainer(
    String label,
    List<String> items,
    String? selectedValue,
    ValueChanged<String?> onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.all(5), // Margen alrededor del Dropdown
      child: SizedBox(
        width: 200, // Ancho fijo para el Dropdown
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
