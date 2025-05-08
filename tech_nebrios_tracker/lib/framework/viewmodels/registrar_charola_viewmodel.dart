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
  final comidaCicloController = TextEditingController();
  final pesoController = TextEditingController();
  final hidratacionCicloController = TextEditingController();

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
      // Validar campos obligatorios
      if (nombreController.text.isEmpty) {
        throw FormatException('El campo "Nombre" es obligatorio.');
      }

      // Validar que los valores sean positivos
      if (double.tryParse(comidaCicloController.text) == null ||
          double.parse(comidaCicloController.text) <= 0) {
        throw FormatException(
          'La cantidad de alimento debe ser un número positivo.',
        );
      }
      if (double.tryParse(pesoController.text) == null ||
          double.parse(pesoController.text) <= 0) {
        throw FormatException('El peso debe ser un número positivo.');
      }
      if (double.tryParse(hidratacionCicloController.text) == null ||
          double.parse(hidratacionCicloController.text) <= 0) {
        throw FormatException(
          'La cantidad de hidratación debe ser un número positivo.',
        );
      }
      if (double.tryParse(densidadLarvaController.text) == null ||
          double.parse(densidadLarvaController.text) <= 0) {
        throw FormatException(
          'La densidad de larva debe ser un número positivo.',
        );
      }

      if (nombreController.text.length > 20) {
        throw FormatException(
          'El campo "Nombre" no puede tener más de 20 caracteres.',
        );
      }

      if (densidadLarvaController.text.isEmpty) {
        throw FormatException('El campo "Densidad de Larva" es obligatorio.');
      }
      if (fechaController.text.isEmpty) {
        throw FormatException('El campo "Fecha" es obligatorio.');
      }
      if (selectedAlimentacion == null || selectedAlimentacion!.isEmpty) {
        throw FormatException('El campo "Alimentación" es obligatorio.');
      }
      if (comidaCicloController.text.isEmpty) {
        throw FormatException(
          'El campo "Cantidad de alimento" es obligatorio.',
        );
      }
      if (pesoController.text.isEmpty) {
        throw FormatException('El campo "Peso" es obligatorio.');
      }
      if (selectedHidratacion == null || selectedHidratacion!.isEmpty) {
        throw FormatException('El campo "Hidratación" es obligatorio.');
      }
      if (hidratacionCicloController.text.isEmpty) {
        throw FormatException(
          'El campo "Cantidad de hidratación" es obligatorio.',
        );
      }

      // Validar campos numéricos
      if (double.tryParse(densidadLarvaController.text) == null) {
        throw FormatException(
          'La densidad de larva debe ser un número válido.',
        );
      }
      if (double.tryParse(comidaCicloController.text) == null) {
        throw FormatException(
          'La cantidad de alimento debe ser un número válido.',
        );
      }
      if (double.tryParse(pesoController.text) == null) {
        throw FormatException('El peso debe ser un número válido.');
      }
      if (double.tryParse(hidratacionCicloController.text) == null) {
        throw FormatException(
          'La cantidad de hidratación debe ser un número válido.',
        );
      }

      final fechaFormateada = DateFormat(
        'yyyy-MM-dd',
      ).format(DateFormat('dd/MM/yyyy').parse(fechaController.text));

      // Crear el modelo de charola con los datos del formulario
      final charola = CharolaModel(
        nombre: nombreController.text,
        densidadLarva: double.parse(densidadLarvaController.text),
        fechaCreacion: fechaFormateada,
        nombreComida: selectedAlimentacion ?? '',
        comidaCiclo: double.parse(comidaCicloController.text),
        pesoCharola: double.parse(pesoController.text),
        nombreHidratacion: selectedHidratacion ?? '',
        hidratacionCiclo: double.parse(hidratacionCicloController.text),
      );

      // Llamar al caso de uso para registrar la charola
      await registrarCharolaUseCase.execute(charola);
      print('Charola registrada exitosamente');

      // Limpia los campos del formulario
      nombreController.clear();
      densidadLarvaController.clear();
      fechaController.clear();
      selectedAlimentacion = null;
      comidaCicloController.clear();
      pesoController.clear();
      selectedHidratacion = null;
      hidratacionCicloController.clear();

      notifyListeners();
    } catch (e) {
      print('Error al registrar la charola: $e');
      rethrow;
    }
  }

  @override
  void dispose() {
    nombreController.dispose();
    densidadLarvaController.dispose();
    fechaController.dispose();
    comidaCicloController.dispose();
    pesoController.dispose();
    hidratacionCicloController.dispose();
    super.dispose();
  }
}
