import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/tamizadoIndividualModel.dart';
import '../models/tamizadoMultipleModel.dart';
import '../models/tamizadoRespuestaModel.dart';
import '../services/tamizadoApiService.dart';
import '../models/constantes.dart';
import '../../domain/usuarioUseCases.dart';

class TamizarCharolaRepository implements TamizadoApiService {
  final UserUseCases _userUseCases = UserUseCases();

  @override
  Future<TamizadoRespuesta?> tamizarCharolaIndividual(
    TamizadoIndividual tamizadoIndividual,
  ) async {
    final url = Uri.parse('${APIRutas.CHAROLA_TAMIZADO}/tamizadoIndividual');
    final token = await _userUseCases.obtenerTokenActual();
    if (token == null) {
      throw Exception('Debe iniciar sesión para continuar');
    }

    final respuesta = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
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
    final token = await _userUseCases.obtenerTokenActual();
    if (token == null) {
      throw Exception('Debe iniciar sesión para continuar');
    }

    final respuesta = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(tamizadoMultiple.toJson()),
    );

    final decodificado = json.decode(respuesta.body);
    return TamizadoRespuesta.fromJson(decodificado);
  }
}
