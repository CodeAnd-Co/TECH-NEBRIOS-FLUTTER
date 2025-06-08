// RF29: Visualizar la información del Frass obtenido - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF29

import '../models/frasModel.dart';

abstract class FrasAPIService {
  /// Obtiene la lista de Frass desde la fuente de datos.
  /// @return Una lista de objetos Fras.
  /// @throws Exception si no se puede obtener la lista de Frass.
  Future<List<Fras>> obtenerFras();

  /// Edita un Frass en la fuente de datos.
  /// @param idCharola El ID de la charola a editar.
  /// @throws Exception si no se puede editar el Frass.
  Future<void> editarFras(idCharola, nuevosGramos);
}