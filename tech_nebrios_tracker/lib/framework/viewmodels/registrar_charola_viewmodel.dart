import 'package:flutter/material.dart';
import '../../data/models/charola_model.dart';

class RegistrarCharolaViewModel extends ChangeNotifier {
  final nombreController = TextEditingController();
  final frassController = TextEditingController();
  final fechaController = TextEditingController();
  final comidaController = TextEditingController();
  final pesoController = TextEditingController();
  final hidratacionController = TextEditingController();

  void registrarCharola() {
    // Aquí puedes manejar la lógica para guardar los datos
    CharolaModel charola = CharolaModel(
      nombre: nombreController.text,
      frass: frassController.text,
      fecha: DateTime.tryParse(fechaController.text) ?? DateTime.now(),
      comida: comidaController.text,
      peso: double.tryParse(pesoController.text) ?? 0.0,
      hidratacion: hidratacionController.text,
    );

    // Simulación: imprimir en consola
    print("Charola registrada: ${charola.nombre}");

    // Limpia los campos si quieres
    nombreController.clear();
    frassController.clear();
    fechaController.clear();
    comidaController.clear();
    pesoController.clear();
    hidratacionController.clear();

    notifyListeners();
  }

  @override
  void dispose() {
    nombreController.dispose();
    frassController.dispose();
    fechaController.dispose();
    comidaController.dispose();
    pesoController.dispose();
    hidratacionController.dispose();
    super.dispose();
  }
}
