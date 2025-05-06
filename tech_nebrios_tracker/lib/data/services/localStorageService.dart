///Servicio de almacenamiento local para datos de autenticación
///
////// Este servicio se encarga de almacenar, recuperar y eliminar información
////// del usuario actual en el almacenamiento local.
abstract class LocalStorageService {
  /// Obtiene el token del usuario actual del almacenamiento local.
  /// 
  /// Retorna null si no hay usuario actual.
  Future<String?> getCurrentUser();
  /// Guarda el token del usuario actual en el almacenamiento local.
  /// 
  /// Retorna null si no hay usuario actual.
  Future<void> setCurrentUser(String token);
  /// Elimina el token del usuario actual del almacenamiento local, cerrando la sesión.
  Future<void> removeCurrentUser();
}