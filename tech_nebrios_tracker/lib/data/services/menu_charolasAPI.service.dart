// RF16 Visualizar todas las charolas registradas en el sistema - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF16

/// Contrato abstracto que define la comunicación con la API para charolas.
abstract class CharolaServicioApi {
  /// Obtiene las charolas paginadas desde el backend.
  ///
  /// pag es la página actual y limite la cantidad de elementos por página.
  /// Retorna un mapa con los datos obtenidos o null si hay error.
  Future<Map<String, dynamic>?> obtenerCharolasPaginadas(int pag, int limite);
}
