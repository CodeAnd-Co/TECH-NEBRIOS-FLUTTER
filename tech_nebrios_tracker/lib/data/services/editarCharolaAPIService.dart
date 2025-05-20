//RF7 Editar información de una charola: https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF7

abstract class EditarCharolaAPIService {

  Future<Map<dynamic, dynamic>> putEditarCharola(charolaId, nuevoEstado, nuevoPeso, nuevaAlimentacion, nuevaAlimentacionOtorgada, fechaActualizacion, nuevaHidratacion, nuevaHidratacionOtorgada);
 }