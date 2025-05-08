//RF23: Registrar un nuevo tipo de comida en el sistema - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF23
import 'package:flutter/foundation.dart';

import '../../data/models/alimento_model.dart';
import '../../data/repositories/alimento_repository.dart';
import '../../data/services/alimentacion_service.dart';
import '../../domain/alimentacion_domain.dart';


/// ViewModel que gestiona la lógica y estado de alimentos para la vista.
///
/// Se comunica con los casos de uso y repositorios.
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

  /// Estado de carga de operaciones asíncronas.
  bool get isLoading => _isLoading;

  /// Último error capturado.
  String? get error => _error;

  /// Lista de alimentos obtenida desde el repositorio.
  List<Alimento> get alimentos => List.unmodifiable(_alimentos);

  /// Carga la lista de alimentos desde la fuente de datos.
  ///
  /// Notifica listeners al cambiar el estado de carga o error.
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

  
  /// Valida y registra un nuevo alimento.
  ///
  /// Retorna `null` si fue exitoso o un mensaje de error si falla.
  Future<String?> registrarAlimento(String nombre, String descripcion) async {
    if (nombre.trim().isEmpty || descripcion.trim().isEmpty) {
      return 'Nombre y descripción no pueden estar vacíos.';
    }

    if (nombre.length > 25) {
    return 'El nombre no puede tener más de 25 caracteres.';
    }

    if (descripcion.length > 200) {
      return 'La descripción no puede tener más de 200 caracteres.';
    }

    final tieneNumeros = RegExp(r'[0-9]').hasMatch(nombre);
    if (tieneNumeros) {
      return 'El nombre no debe contener números.';
    }

    _setLoading(true);
    try {
      await _registrarCasoUso.ejecutar(nombre: nombre, descripcion: descripcion);
      await cargarAlimentos(); 
      return null; 
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

  /// Actualiza la variable [_isLoading] y notifica a los listeners.
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
