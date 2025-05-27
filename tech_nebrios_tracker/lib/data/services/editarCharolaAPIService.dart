//RF7 Editar información de una charola: https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF7

abstract class EditarCharolaAPIService {

  Future<Map<dynamic, dynamic>> putEditarCharola(charolaId, nombreCharola, nuevoEstado, nuevaDensidad, nuevaAlimentacion, nuevaAlimentacionOtorgada, fechaActualizacion, nuevaHidratacion, nuevaHidratacionOtorgada, fechaCreacion);
 }