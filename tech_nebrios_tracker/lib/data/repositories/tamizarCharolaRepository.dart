import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/tamizadoIndividualModel.dart';
import '../models/tamizadoMultipleModel.dart';
import '../models/tamizadoRespuestaModel.dart';
import '../services/tamizadoApiService.dart';
import '../models/constantes.dart';

class TamizarCharolaRepository implements TamizadoApiService {
  @override
  Future<TamizadoRespuesta?> tamizarCharolaIndividual(
    TamizadoIndividual tamizadoIndividual,
  ) async {
    final url = Uri.parse('${APIRutas.CHAROLA_TAMIZADO}/tamizadoIndividual');

    final respuesta = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(tamizadoIndividual.toJson()),
    );

    final decodificado = json.decode(respuesta.body);
    return TamizadoRespuesta.fromJson(decodificado);
  }

  @override
  Future<TamizadoRespuesta?> tamizarCharolasMultiples(
    TamizadoMultiple tamizadoMultiple,
  ) async {
    final url = Uri.parse('${APIRutas.CHAROLA_TAMIZADO}/tamizadoMultiple');

    final respuesta = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(tamizadoMultiple.toJson()),
    );

    final decodificado = json.decode(respuesta.body);
    return TamizadoRespuesta.fromJson(decodificado);
  }
}
