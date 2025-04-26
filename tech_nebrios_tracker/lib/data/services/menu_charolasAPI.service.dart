// RF16 Visualizar todas las charolas registradas en el sistema - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF16

abstract class CharolaServicioApi {
  Future<Map<String, dynamic>?> obtenerCharolasPaginadas(int pag, int limite);
}
