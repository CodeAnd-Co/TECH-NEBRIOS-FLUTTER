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
              const SizedBox(height: 20),
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 5,
                mainAxisSpacing: 1,
                childAspectRatio: 4.5,
                shrinkWrap: true, // Importante para evitar conflictos de tamaño
                physics:
                    const NeverScrollableScrollPhysics(), // Desactiva el scroll interno
                children: [
                  _buildTextFieldContainer(
                    'Nombre',
                    viewModel.nombreController,
                  ),
                  _buildTextFieldContainer('Frass', viewModel.frassController),
                  _buildTextFieldContainer(
                    'Fecha (dd/mm/yyyy)',
                    viewModel.fechaController,
                  ),
                  _buildTextFieldContainer(
                    'Alimentación',
                    viewModel.comidaController,
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
                ],
              ),
              const SizedBox(height: 10),
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
