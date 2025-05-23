import '../models/tamizadoIndividualModel.dart';
import '../models/tamizadoMultipleModel.dart';
import '../models/tamizadoRespuestaModel.dart';

abstract class TamizadoApiService {
  /// Envía un tamizado individual al backend.
  ///
  /// Retorna un mapa con la respuesta del servidor o null si hay error.
  Future<TamizadoRespuesta?> tamizarCharolaIndividual(TamizadoIndividual tamizadoIndividual);

  /// Envía un tamizado múltiple al backend.
  ///
  /// Retorna un mapa con la respuesta del servidor o null si hay error.
  Future<TamizadoRespuesta?> tamizarCharolasMultiples(TamizadoMultiple tamizadoMultiple);

  /// Obtiene la lista de alimentos desde el backend.
  Future<List<String>> getAlimentos();

  /// Obtiene la lista de hidratación desde el backend.
  Future<List<String>> getHidratacion();
}