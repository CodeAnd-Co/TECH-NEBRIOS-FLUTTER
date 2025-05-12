import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/historial_ancestros_model.dart';

class HistorialAncestrosService {
  static const _baseUrl = 'http://localhost:3000';

  // Obtiene la lista de alimentos
  Future<HistorialAncestros> obtenerAncestros(int idCharola) async {
    final uri = Uri.parse('$_baseUrl/charola/$idCharola/historial');
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception(
        'Error al cargar ancestros (${response.statusCode}): ${response.body}'
      );
    }

      return HistorialAncestros.fromJson(json.decode(response.body));
  }
}