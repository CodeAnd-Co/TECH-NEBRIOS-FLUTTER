// lib/framework/viewmodels/charolaViewModel.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

import '../../data/models/charolaModel.dart';
import '../../data/models/alimentacionModel.dart';
import '../../data/models/hidratacionModel.dart';
import '../../data/repositories/charolaRepository.dart';
import '../../data/repositories/alimentacionRepository.dart';
import '../../data/repositories/hidratacionRepository.dart';
import '../../domain/consultarCharolaUseCase.dart';
import '../../domain/eliminarCharolaUseCase.dart';
import '../../domain/charolasDashboardUseCase.dart';
import '../../domain/registrarCharolaUseCase.dart';

class CharolaViewModel extends ChangeNotifier {
  final _logger = Logger();
  final CharolaRepository _repo = CharolaRepository();
  final AlimentacionRepository _alimentoRepo = AlimentacionRepository();
  final HidratacionRepository _hidratacionRepo = HidratacionRepository();

  late final ObtenerCharolaUseCase _obtenerUseCase;
  late final EliminarCharolaUseCase _eliminarUseCase;
  late final ObtenerMenuCharolas _menuUseCase;
  late final RegistrarCharolaUseCase _registrarUseCase;

  CharolaViewModel() {
    _obtenerUseCase = ObtenerCharolaUseCaseImpl(charolaRepository: _repo);
    _eliminarUseCase = EliminarCharolaUseCaseImpl(charolaRepository: _repo);
    _menuUseCase = ObtenerCharolasUseCaseImpl(repositorio: _repo);
    _registrarUseCase = RegistrarCharolaUseCaseImpl(repositorio: _repo);

    cargarCharolas();
  }

  // === Dropdowns para registrar ===
  List<Alimento> alimentos = [];
  List<Hidratacion> hidrataciones = [];
  Alimento? selectedAlimentacion;
  Hidratacion? selectedHidratacion;
  bool _cargandoDropdowns = false;
  bool get cargandoDropdowns => _cargandoDropdowns;

  Future<void> cargarAlimentos() async {
    _cargandoDropdowns = true;
    notifyListeners();
    try {
      alimentos = await _alimentoRepo.obtenerAlimentos();
    } catch (e) {
      _logger.e('Error cargando alimentos: $e');
    } finally {
      _cargandoDropdowns = false;
      notifyListeners();
    }
  }

  Future<void> cargarHidratacion() async {
    _cargandoDropdowns = true;
    notifyListeners();
    try {
      hidrataciones = await _hidratacionRepo.obtenerHidratacion();
    } catch (e) {
      _logger.e('Error cargando hidrataciones: $e');
    } finally {
      _cargandoDropdowns = false;
      notifyListeners();
    }
  }

  // Controladores de formulario
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController densidadLarvaController = TextEditingController();
  final TextEditingController fechaController = TextEditingController();
  final TextEditingController comidaCicloController = TextEditingController();
  final TextEditingController pesoController = TextEditingController();
  final TextEditingController hidratacionCicloController = TextEditingController();

  Future<void> registrarCharola() async {
    try {
      final registro = CharolaRegistro(
        nombreCharola: nombreController.text,
        fechaCreacion: DateTime.parse(fechaController.text),
        densidadLarva: double.parse(densidadLarvaController.text),
        pesoCharola: double.parse(pesoController.text),
        comidas: [
          ComidaAsignada(
            comidaId: selectedAlimentacion!.idAlimento,
            cantidadOtorgada: double.parse(comidaCicloController.text),
          )
        ],
        hidrataciones: [
          HidratacionAsignada(
            hidratacionId: selectedHidratacion!.idHidratacion,
            cantidadOtorgada: double.parse(hidratacionCicloController.text),
          )
        ],
      );
      await _registrarUseCase;
      _logger.i('Charola registrada');
    } catch (e) {
      _logger.e('Error al registrar charola: $e');
      rethrow;
    }
  }

  // === DETALLE DE CHAROLA ===
  CharolaDetalle? _charola;
  CharolaDetalle? get charola => _charola;

  bool _cargandoCharola = false;
  bool get cargandoCharola => _cargandoCharola;

  Future<void> cargarCharola(int id) async {
    _cargandoCharola = true;
    notifyListeners();
    try {
      _charola = await _obtenerUseCase.obtenerCharola(id);
    } catch (e) {
      _logger.e('Error cargando detalle: $e');
      _charola = null;
    }
    _cargandoCharola = false;
    notifyListeners();
  }

  Future<void> eliminarCharola(int id) async {
    _cargandoCharola = true;
    notifyListeners();
    try {
      await _eliminarUseCase.eliminar(id);
      _charola = null;
    } catch (e) {
      _logger.e('Error eliminando charola: $e');
    }
    _cargandoCharola = false;
    notifyListeners();
  }

  // === LISTADO PAGINADO ===
  List<CharolaTarjeta> charolas = [];
  int pagActual = 1;
  final int limite = 15;
  bool _cargandoLista = false;
  bool get cargandoLista => _cargandoLista;
  bool hayMas = true;
  int totalPags = 1;

  Future<void> cargarCharolas({bool reset = false}) async {
    if (_cargandoLista) return;
    if (reset) {
      pagActual = 1;
      charolas.clear();
    }

    _cargandoLista = true;
    notifyListeners();

    try {
      final dash = await _menuUseCase.ejecutar(pag: pagActual, limite: limite);
      if (dash != null) {
        charolas = dash.data;
        totalPags = dash.totalPags;
        hayMas = pagActual < totalPags;
      }
    } catch (e) {
      final msg = e.toString().contains('401')
          ? '🚫 401: No autorizado'
          : e.toString().contains('101')
              ? '🌐 101: Problemas de red'
              : '💥 Error interno del servidor';
      _logger.e(msg);
    } finally {
      _cargandoLista = false;
      notifyListeners();
    }
  }

  void cargarPaginaAnterior() {
    if (pagActual > 1) {
      pagActual--;
      cargarCharolas();
    }
  }

  void cargarPaginaSiguiente() {
    if (pagActual < totalPags) {
      pagActual++;
      cargarCharolas();
    }
  }
}
