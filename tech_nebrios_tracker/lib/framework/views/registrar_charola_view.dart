import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/registrar_charola_viewmodel.dart';

class RegistrarCharolaView extends StatelessWidget {
  const RegistrarCharolaView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<RegistrarCharolaViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Charola')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const Text(
              'Ingresa una charola nueva',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),

            _buildTextField('Nombre', viewModel.nombreController),
            _buildTextField('Frass', viewModel.frassController),
            _buildTextField('Fecha (dd/mm/yyyy)', viewModel.fechaController),
            _buildTextField('Alimentación', viewModel.comidaController),
            _buildTextField(
              'Peso',
              viewModel.pesoController,
              keyboardType: TextInputType.number,
            ),
            _buildTextField('Hidratación', viewModel.hidratacionController),

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
