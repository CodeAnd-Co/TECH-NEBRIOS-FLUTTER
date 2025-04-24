import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/menu_charolas.model.dart';
import '../services/menu_charolasAPI.service.dart';

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

  Future<CharolaTarjeta?> obtenerCharolaRespuesta(int pag, int limite) async {
    final data = await obtenerCharolasPaginadas(pag, limite);
    if (data != null) {
      return CharolaTarjeta.fromJson(data);
    }
    return null;
  }
}
