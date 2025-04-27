import 'package:flutter/material.dart';
import '../../data/models/charola_model.dart';
import '../../domain/registrar_charola.dart';
import 'package:intl/intl.dart';

class RegistrarCharolaViewModel extends ChangeNotifier {
  final RegistrarCharola registrarCharolaUseCase;
  List<String> alimentos = [];
  String? selectedAlimentacion;
  bool _alimentosCargados = false; // Indicador para evitar múltiples cargas

  List<String> hidratacion = [];
  String? selectedHidratacion;
  bool _hidratacionCargados = false; // Indicador para evitar múltiples cargas

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
      _alimentosCargados = true; // Marca los datos como cargados
      print('Alimentos cargados: $alimentos');
      notifyListeners(); // Notifica a la vista que los datos han cambiado
    } catch (e) {
      print('Error al cargar los alimentos: $e');
    }
  }

  Future<void> cargarHidratacion() async {
    if (_hidratacionCargados) return; // Evita cargar los datos más de una vez
    try {
      print('Cargando hidratación...');
      hidratacion = await registrarCharolaUseCase.repository.getHidratacion();
      _hidratacionCargados = true; // Marca los datos como cargados
      print('Hidratación cargada: $hidratacion');
      notifyListeners(); // Notifica a la vista que los datos han cambiado
    } catch (e) {
      print('Error al cargar la hidratación: $e');
    }
  }

  Future<void> registrarCharola() async {
    try {
      // Formatear la fecha al formato yyyy-MM-dd
      final fechaFormateada = DateFormat(
        'yyyy-MM-dd',
      ).format(DateTime.parse(fechaController.text));
      // Crear el modelo de charola con los datos del formulario
      final charola = CharolaModel(
        nombre: nombreController.text,
        densidadLarva: densidadLarvaController.text,
        fechaCreacion: DateTime.parse(fechaFormateada),
        comidaCiclo: comidaController.text,
        cantidadComida: double.parse(cantidadComidaController.text),
        pesoCharola: double.parse(pesoController.text),
        hidratacionCiclo: hidratacionController.text,
        cantidadHidratacion: double.parse(cantidadHidratacionController.text),
      );

      // Llamar al caso de uso para registrar la charola
      await registrarCharolaUseCase.execute(charola);
      print('Charola registrada exitosamente');

      // Limpia los campos del formulario
      nombreController.clear();
      densidadLarvaController.clear();
      fechaController.clear();
      comidaController.clear();
      cantidadComidaController.clear();
      pesoController.clear();
      hidratacionController.clear();
      cantidadHidratacionController.clear();

      notifyListeners();
    } catch (e) {
      print('Error al registrar la charola: $e');
    }
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
