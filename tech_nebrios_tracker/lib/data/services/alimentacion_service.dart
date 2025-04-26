import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/alimento_model.dart';

class AlimentacionService {
  static const _baseUrl = 'http://localhost:3000';

  // Obtiene la lista de alimentos
  Future<List<Alimento>> obtenerAlimentos() async {
    final uri = Uri.parse('$_baseUrl/alimentacion');
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception(
        'Error al cargar alimentos (${response.statusCode}): ${response.body}'
      );
    }

    final List<dynamic> data = jsonDecode(response.body);
    return data.map((item) => Alimento.fromJson(item)).toList();
  }

 /// Envía la petición de eliminar
  Future<void> eliminarAlimento(int idAlimento) async {
    final uri = Uri.parse('$_baseUrl/alimentacion/eliminar/$idAlimento');

    final response = await http.delete(uri);

    if (response.statusCode != 200) {
      throw Exception(
        'Error al eliminar alimento (${response.statusCode}): ${response.body}',
      );
    }
  }
}
