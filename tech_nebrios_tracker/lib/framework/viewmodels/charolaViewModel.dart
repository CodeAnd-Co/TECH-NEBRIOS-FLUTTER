// RF16 Visualizar todas las charolas registradas en el sistema - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF16
// RF10 Consultar información detallada de una charola https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF10
// RF8 Eliminar Charola https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF8
// RF5 Registrar una nueva charola en el sistema - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF5

import 'package:flutter/material.dart';
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

/// ViewModel encargado de gestionar el estado de la vista de charolas.
class CharolaViewModel extends ChangeNotifier {
  final _logger = Logger();
  final CharolaRepository _repo = CharolaRepository();
  final AlimentacionRepository _alimentoRepo = AlimentacionRepository();
  final HidratacionRepository _hidratacionRepo = HidratacionRepository();

  final formKey = GlobalKey<FormState>();

  // Casos de uso para operaciones relacionadas a charolas
  late final ObtenerCharolaUseCase _obtenerUseCase;
  late final EliminarCharolaUseCase _eliminarUseCase;
  late final ObtenerMenuCharolas _menuUseCase;
  late final RegistrarCharolaUseCase _registrarUseCase;

  /// Constructor sin parámetros que inicializa los casos de uso con el repositorio
  CharolaViewModel() {
    _obtenerUseCase = ObtenerCharolaUseCaseImpl(charolaRepository: _repo);
    _eliminarUseCase = EliminarCharolaUseCaseImpl(charolaRepository: _repo);
    _menuUseCase = ObtenerCharolasUseCaseImpl(repositorio: _repo);
    _registrarUseCase = RegistrarCharolaUseCaseImpl(repositorio: _repo);

    // Carga inicial de charolas y dropdowns
    cargarCharolas();
    cargarAlimentos();
    cargarHidratacion();
  }

  // === Dropdowns para registrar ===
  List<Alimento> alimentos = [];
  List<Hidratacion> hidrataciones = [];
  Alimento? selectedAlimentacion;
  Hidratacion? selectedHidratacion;
  bool _cargandoRegistro = false;
  bool get cargandoRegistro => _cargandoRegistro;
  String? _mensajeError;
  String? get mensajeError => _mensajeError;

  void Function(String mensaje)? onErrorSnackBar;

  /// Asigna un mensaje de error y permite notificar con SnackBar desde la vista
  void mostrarErrorSnackBar(String mensaje) {
    _mensajeError = mensaje.isNotEmpty ? mensaje : null;
    notifyListeners();
    if (mensaje.isNotEmpty && onErrorSnackBar != null) {
      onErrorSnackBar!(mensaje);
    }
  }


  Future<void> cargarAlimentos() async {
    try {
      alimentos = await _alimentoRepo.obtenerAlimentos();
    } catch (e) {
      _logger.e('Error cargando alimentos');
    }
  }

  Future<void> cargarHidratacion() async {
    try {
      hidrataciones = await _hidratacionRepo.obtenerHidratacion();
    } catch (e) {
      _logger.e('Error cargando hidrataciones');
    }
  }

  // Controladores de formulario
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController densidadLarvaController = TextEditingController();
  final TextEditingController fechaController = TextEditingController();
  final TextEditingController comidaCicloController = TextEditingController();
  final TextEditingController razonEliminacionController = TextEditingController();
  final TextEditingController hidratacionCicloController =
      TextEditingController();
  final TextEditingController busquedaController = TextEditingController();
  String _busqueda = '';
  List<CharolaTarjeta> _charolasFiltradas = [];
  List<CharolaTarjeta> get charolasFiltradas =>
      _charolasFiltradas.isEmpty && _busqueda.isEmpty
          ? charolas
          : _charolasFiltradas;

  /// Valida el formulario y registra la charola si es válido.
  /// Si el formulario no es válido, muestra un mensaje de error.
  Future<CharolaTarjeta> registrarCharola() async {
    try {
      _cargandoRegistro = true;
      notifyListeners();
      final parts = fechaController.text.split('/');
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      final fecha = DateTime(year, month, day);

      final registro = CharolaRegistro(
        nombreCharola: nombreController.text,
        fechaCreacion: fecha,
        fechaActualizacion: fecha,
        densidadLarva: double.parse(densidadLarvaController.text),
        comidas: [
          ComidaAsignada(
            comidaId: selectedAlimentacion!.idAlimento,
            cantidadOtorgada: double.parse(comidaCicloController.text),
          ),
        ],
        hidrataciones: [
          HidratacionAsignada(
            hidratacionId: selectedHidratacion!.idHidratacion,
            cantidadOtorgada: double.parse(hidratacionCicloController.text),
          ),
        ],
      );
      final data = await _registrarUseCase.registrar(charola: registro);
      final tarjeta = CharolaTarjeta(
        charolaId: data['charolaId'] as int,
        nombreCharola: data['nombreCharola'] as String,
        fechaCreacion: DateTime.parse(data['fechaCreacion'] as String),
      );
      _cargandoRegistro = false;
      notifyListeners();
      return tarjeta;
    } catch (e) {
      _cargandoRegistro = false;
      notifyListeners();
      rethrow;
    }
  }

  /// Limpia todos los campos del formulario y selecciones.
  void resetForm() {
    nombreController.clear();
    densidadLarvaController.clear();
    fechaController.clear();
    comidaCicloController.clear();
    hidratacionCicloController.clear();
    selectedAlimentacion = null;
    selectedHidratacion = null;
    notifyListeners();
  }

  void filtrarCharolas(String query) {
    _busqueda = query;
    if (query.isEmpty) {
      _charolasFiltradas = [];
    } else {
      _charolasFiltradas =
          charolas
              .where(
                (c) =>
                    c.nombreCharola.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
    }
    notifyListeners();
  }

  // === DETALLE DE UNA CHAROLA ===
  CharolaDetalle? _charola; // Detalle de la charola actual
  CharolaDetalle? get charola => _charola; // Getter del detalle

  bool _cargandoCharola =
      false; // Bandera para indicar si se está cargando el detalle
  bool get cargandoCharola => _cargandoCharola;

  /// Carga el detalle de una charola por ID
  Future<void> cargarCharola(int id) async {
    _cargandoCharola = true;
    notifyListeners();
    try {
      _charola = await _obtenerUseCase.obtenerCharola(id);
      // Al final de cargarCharolas()
      if (_busqueda.isNotEmpty) {
        filtrarCharolas(_busqueda);
      }
    } catch (e) {
      _logger.e('Error cargando detalle: $e');

      final msg = e.toString().contains('401')
          ? '🚫 Error 401: No autorizado'
          : e.toString().contains('101')
              ? '🌐 Error 101: Sin conexión a internet'
              : '💥 Error de conexión';

      mostrarErrorSnackBar(msg);
      _charola = null;
    } finally {
      _cargandoCharola = false;
      notifyListeners();
    }
  }


  /// Elimina una charola por ID
  bool _error = false;
  bool get error => _error;

  Future<void> eliminarCharola(int id) async {
    _error = false;
    _cargandoCharola = true;
    final razon = razonEliminacionController.text;
    notifyListeners();
    try {
      await _eliminarUseCase.eliminar(
        id,
        razon,
      );
      _charola = null;
      _cargandoCharola = false;
      notifyListeners();
    } catch (e) {
      _error = true;
      _cargandoCharola = false;
      notifyListeners();
      _logger.e('Error eliminando charola: $e');
    }
  }

  // === LISTADO PAGINADO ===
  List<CharolaTarjeta> charolas = [];
  int pagActual = 1;
  final int limite = 100;
  bool _cargandoLista = false;
  bool get cargandoLista => _cargandoLista;
  bool hayMas = true;
  int totalPags = 1;
  String estadoActual = 'activa';

  /// Carga la lista de charolas con paginación. Si [reset] es true, reinicia la paginación.
  Future<void> cargarCharolas({bool reset = false}) async {
    if (_cargandoLista) return; // Previene múltiples cargas simultáneas

    if (reset) {
      pagActual = 1;
      charolas.clear(); // Limpia lista si es reinicio
    }

    _cargandoLista = true;
    notifyListeners();

    try {
      final dash = await _menuUseCase.ejecutar(
        pag: pagActual,
        limite: limite,
        estado: estadoActual,
      );
      if (dash != null) {
        charolas = dash.data; // Asigna las nuevas charolas
        totalPags = dash.totalPags; // Total de páginas disponibles
        hayMas = pagActual < totalPags; // Verifica si hay más páginas

        _mensajeError = null;
      }
    } catch (e) {
      final msg = e.toString().contains('401')
          ? '🚫 Error 401: No autorizado'
          : e.toString().contains('101')
              ? '🌐 Error 101: Sin conexión a internet'
              : '💥 Error de conexión';

      _logger.e(_mensajeError);
      mostrarErrorSnackBar(msg);

    } finally {
      _cargandoLista = false;
      notifyListeners();
    }
  }

  /// Carga la página anterior si existe
  void cargarPaginaAnterior() {
    if (pagActual > 1) {
      pagActual--;
      cargarCharolas();
    }
  }

  /// Carga la página siguiente si no es la última
  void cargarPaginaSiguiente() {
    if (pagActual < totalPags) {
      pagActual++;
      cargarCharolas();
    }
  }

  void cambiarEstado(String nuevoEstado) {
    estadoActual = nuevoEstado;
    pagActual = 1;
    cargarCharolas(reset: true);
  }
}
