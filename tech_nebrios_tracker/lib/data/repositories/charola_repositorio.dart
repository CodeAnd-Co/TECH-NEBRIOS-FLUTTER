import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/charola_modelo.dart';
import '../services/charola_servicio_api.dart';

class CharolaRepositorio implements CharolaServicioApi {
  static const String _baseUrl = 'http://localhost:3000/api';

  @override
  Future<Map<String, dynamic>?> fetchCharolasPaginated(int page, int limit) async {
    final uri = Uri.parse('$_baseUrl/charolas?page=$page&limit=$limit');

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("Error HTTP: ${response.statusCode}");
      }
    } catch (e) {
      print("Error al conectarse al backend: $e");
    }

    return null;
  }

  Future<CharolaTarjerta?> getCharolaResponse(int page, int limit) async {
    final data = await fetchCharolasPaginated(page, limit);
    if (data != null) {
      return CharolaTarjerta.fromJson(data);
    }
    return null;
  }
}
