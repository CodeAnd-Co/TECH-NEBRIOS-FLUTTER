import '../models/tamizadoIndividualModel.dart';
import '../models/tamizadoMultipleModel.dart';

abstract class TamizadoApiService {
  /// Envía un tamizado individual al backend.
  ///
  /// Retorna un mapa con la respuesta del servidor o null si hay error.
  Future<Map<String, dynamic>?> tamizarCharolaIndividual(TamizadoIndividual tamizadoIndividual);

  /// Envía un tamizado múltiple al backend.
  ///
  /// Retorna un mapa con la respuesta del servidor o null si hay error.
  Future<Map<String, dynamic>?> tamizarCharolasMultiples(TamizadoMultiple tamizadoMultiple);
}