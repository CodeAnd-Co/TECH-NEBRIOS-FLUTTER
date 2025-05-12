import 'package:flutter/material.dart';
import 'package:tech_nebrios_tracker/framework/views/editar_charola.view.dart';
import '../../domain/editar_charola.dart';
import 'package:intl/intl.dart';

class EditarCharolaViewModel extends ChangeNotifier {
  final EditarCharola editarCharolaUseCase;

  EditarCharolaViewModel(this.editarCharolaUseCase);

  final fechaController = TextEditingController();
  final estadoController = TextEditingController();
  final pesoController = TextEditingController();
  final hidratacionController = TextEditingController();
  final alimentoController = TextEditingController();
  final hidratacionCantidadController = TextEditingController();
  final alimentoCantidadController = TextEditingController();

  // Dropdowns
  List<String> hidratacionItems = [];
  String? selectedHidratacion;

  List<String> alimentoItems = [];
  String? selectedAlimento;

  Future<void> editarCharola() async {
    try {
      final fechaFormateada = DateFormat(
        'yyyy-MM-dd',
      ).format(DateFormat('dd/MM/yyyy').parse(fechaController.text));

      // Aquí puedes procesar los datos editados
      print('Estado: ${estadoController.text}');
      print('Fecha: $fechaFormateada');
      print('Peso: ${pesoController.text}');
      print('Hidratación: ${hidratacionController.text}');
      print('Alimento: ${alimentoController.text}');

      // Limpia los campos del formulario
      fechaController.clear();
      estadoController.clear();
      pesoController.clear();
      hidratacionController.clear();
      alimentoController.clear();

      notifyListeners();
    } catch (e) {
      print('Error al editar la charola: $e');
      rethrow;
    }
  }
}
