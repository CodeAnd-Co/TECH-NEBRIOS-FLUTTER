import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/registrar_charola_viewmodel.dart';

class RegistrarCharolaView extends StatelessWidget {
  const RegistrarCharolaView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<RegistrarCharolaViewModel>(context);

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
        child: Column(
          children: [
            const Divider(thickness: 4, color: Color.fromRGBO(56, 88, 129, 1)),
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
            const SizedBox(height: 20),
            SizedBox(
              height: 400,
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 5,
                childAspectRatio: 2,
                shrinkWrap: true, // Importante para evitar conflictos de tamaño
                physics:
                    const NeverScrollableScrollPhysics(), // Desactiva el scroll interno
                children: [
                  _buildTextField('Nombre', viewModel.nombreController),
                  _buildTextField('Frass', viewModel.frassController),
                  _buildTextField(
                    'Fecha (dd/mm/yyyy)',
                    viewModel.fechaController,
                  ),
                  _buildTextField('Alimentación', viewModel.comidaController),
                  _buildTextField(
                    'Peso (kg)',
                    viewModel.pesoController,
                    keyboardType: TextInputType.number,
                  ),
                  _buildTextField(
                    'Hidratación',
                    viewModel.hidratacionController,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: viewModel.registrarCharola,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
              child: const Text(
                'Registrar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
