// RF10 https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF10

import 'dart:convert';
import 'package:http/http.dart' as http;

class CharolaApiService {
  final String baseUrl;

  CharolaApiService({required this.baseUrl});

  Future<Map<String, dynamic>> getCharola(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/charola/consultarCharola/$id'));

    if (response.statusCode == 200) {
      final decodedJson = json.decode(response.body);
      return decodedJson['data'];
    } else {
      throw Exception('Error al obtener la charola');
    }
  }

  Future<void> eliminarCharola(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/charola/eliminarCharola/$id'));
  
    if (response.statusCode != 200) {
      throw Exception('Error al eliminar la charola');
    }
  }
}
