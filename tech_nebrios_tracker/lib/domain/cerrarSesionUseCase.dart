import 'package:zuustento_tracker/data/services/localStorageService.dart';

/// Interfaz del caso de uso
abstract class CerrarSesionUseCase {
  /// Elimina localmente el access token
  Future<void> call();
}

/// Implementación concreta
class CerrarSesionUseCaseImpl implements CerrarSesionUseCase {
  final LocalStorageService _localStorage;

  CerrarSesionUseCaseImpl(this._localStorage);

  @override
  Future<void> call() async {
    await _localStorage.eliminarToken();
  }
}