import 'package:flutter/material.dart';
import '../../data/models/charola_model.dart';
import '../../domain/registrar_charola.dart';

class RegistrarCharolaViewModel extends ChangeNotifier {
  final RegistrarCharola registrarCharolaUseCase;
  List<String> alimentos = [];
  String? selectedAlimentacion;
  bool _alimentosCargados = false; // Indicador para evitar múltiples cargas

  RegistrarCharolaViewModel(this.registrarCharolaUseCase);

  final nombreController = TextEditingController();
  final densidadLarvaController = TextEditingController();
  final fechaController = TextEditingController();
  final comidaController = TextEditingController();
  final cantidadComidaController = TextEditingController();
  final pesoController = TextEditingController();
  final hidratacionController = TextEditingController();
  final cantidadHidratacionController = TextEditingController();

  Future<void> cargarAlimentos() async {
    if (_alimentosCargados) return; // Evita cargar los datos más de una vez
    try {
      print('Cargando alimentos...');
      alimentos = await registrarCharolaUseCase.repository.getAlimentos();
      if (selectedAlimentacion == null && alimentos.isNotEmpty) {
        selectedAlimentacion = alimentos.first; // Establece un valor inicial
      }
      _alimentosCargados = true; // Marca los datos como cargados
      print('Alimentos cargados: $alimentos');
      notifyListeners(); // Notifica a la vista que los datos han cambiado
    } catch (e) {
      print('Error al cargar los alimentos: $e');
    }
  }

  void registrarCharola() {
    // Crear el modelo de charola
    CharolaModel charola = CharolaModel(
      nombre: nombreController.text,
      frass: densidadLarvaController.text,
      fecha: DateTime.tryParse(fechaController.text) ?? DateTime.now(),
      comida: comidaController.text,
      cantidadComida: double.tryParse(cantidadComidaController.text) ?? 0.0,
      peso: double.tryParse(pesoController.text) ?? 0.0,
      hidratacion: hidratacionController.text,
      cantidadHidratacion:
          double.tryParse(cantidadHidratacionController.text) ?? 0.0,
    );

    // Llamar al caso de uso para guardar la charola
    registrarCharolaUseCase.execute(charola);

    // Limpia los campos
    nombreController.clear();
    densidadLarvaController.clear();
    fechaController.clear();
    comidaController.clear();
    cantidadComidaController.clear();
    pesoController.clear();
    hidratacionController.clear();
    cantidadHidratacionController.clear();

    notifyListeners();
  }

  @override
  void dispose() {
    nombreController.dispose();
    densidadLarvaController.dispose();
    fechaController.dispose();
    comidaController.dispose();
    cantidadComidaController.dispose();
    pesoController.dispose();
    hidratacionController.dispose();
    cantidadHidratacionController.dispose();
    super.dispose();
  }
}
