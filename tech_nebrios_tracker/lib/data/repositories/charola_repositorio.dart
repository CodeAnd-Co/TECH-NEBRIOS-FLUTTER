import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/charola_modelo.dart';
import '../services/charola_servicio_api.dart';

class CharolaRepositorio implements CharolaServicioApi {
  static const String _baseUrl = 'http://localhost:3000/api';

  @override
  Future<Map<String, dynamic>?> obtenerCharolasPaginadas(int pag, int limite) async {
    final uri = Uri.parse('$_baseUrl/charolas?page=$pag&limit=$limite');

    try {
      final respuesta = await http.get(uri);

      if (respuesta.statusCode == 200) {
        return jsonDecode(respuesta.body);
      } else {
        print("Error HTTP: ${respuesta.statusCode}");
      }
    } catch (e) {
      print("Error al conectarse al backend: $e");
    }

    return null;
  }

  Future<CharolaTarjerta?> obtenerCharolaRespuesta(int pag, int limite) async {
    final data = await obtenerCharolasPaginadas(pag, limite);
    if (data != null) {
      return CharolaTarjerta.fromJson(data);
    }
    return null;
  }
}
