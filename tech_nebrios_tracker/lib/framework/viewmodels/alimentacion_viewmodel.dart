import 'package:flutter/foundation.dart';

import '../../data/models/alimento_model.dart';
import '../../data/repositories/alimento_repository.dart';
import '../../data/services/alimentacion_service.dart';
import '../../domain/alimentacion_domain.dart';

class AlimentacionViewModel extends ChangeNotifier {
  final AlimentoRepository _repo;
  final RegistrarAlimentoCasoUso _registrarCasoUso;

  AlimentacionViewModel()
      : _repo = AlimentoRepository(AlimentacionService()),
        _registrarCasoUso = PostRegistrarAlimento(
          repositorio: AlimentoRepository(AlimentacionService()),
        );

  bool _isLoading = false;
  String? _error;
  List<Alimento> _alimentos = [];

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Alimento> get alimentos => List.unmodifiable(_alimentos);

  /// Cargar lista de alimentos desde el repositorio
  Future<void> cargarAlimentos() async {
    _setLoading(true);
    try {
      _alimentos = await _repo.obtenerAlimentos();
      _error = null;
    } catch (e) {
      _error = 'Error al cargar alimentos: $e';
    }
    _setLoading(false);
  }

  /// Validar y registrar nuevo alimento
  Future<String?> registrarAlimento(String nombre, String descripcion) async {
    // Validación local
    if (nombre.trim().isEmpty || descripcion.trim().isEmpty) {
      return 'Nombre y descripción no pueden estar vacíos.';
    }

    final tieneNumeros = RegExp(r'[0-9]').hasMatch(nombre);
    if (tieneNumeros) {
      return 'El nombre no debe contener números.';
    }

    _setLoading(true);
    try {
      await _registrarCasoUso.ejecutar(nombre: nombre, descripcion: descripcion);
      await cargarAlimentos(); // Recargar lista
      return null; // éxito
    } on Exception catch (e) {
      final msg = e.toString();
      if (msg.contains('400')) return '❌ Datos no válidos.';
      if (msg.contains('101')) return '❌ Sin conexión a internet.';
      if (msg.contains('500')) return '❌ Error del servidor.';
      return '❌ Error desconocido.';
    } finally {
      _setLoading(false);
    }
  }

  /// Cambiar estado de carga y notificar listeners
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
