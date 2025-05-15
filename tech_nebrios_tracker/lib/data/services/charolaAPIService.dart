// RF16 Visualizar todas las charolas registradas en el sistema - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF16

import 'package:tech_nebrios_tracker/data/models/charolaModel.dart';

/// Contrato abstracto que define la comunicación con la API para charolas.
abstract class CharolaAPIService {
  /// Obtiene las charolas paginadas desde el backend.
  ///
  /// [pag] es la página actual, [limite] la cantidad de elementos por página,
  /// y [estado] filtra por charolas activas o pasadas.
  Future<Map<String, dynamic>?> obtenerCharolasPaginadas(int pag, int limite, {String estado});

  Future<CharolaDetalle> obtenerCharola(int id);

  Future<void> eliminarCharola(int id);
}
