import '../models/charola_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CharolaRepository {
  final List<CharolaModel> _charolas = []; // Simulacion de almacenamiento

  // Metodo para guardar una charola
  void saveCharola(CharolaModel charola) {
    _charolas.add(charola);
    print("Charola guardada: ${charola.nombre}");
  }

  // Metodo para obtener datos de alimentacion desde el backend
  Future<List<String>> getAlimentos() async {
    final url = Uri.parse(
      'https://localhost:3000/', // Cambia por tu endpoint
    ); // Cambia por tu endpoint
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // Decodifica la respuesta JSON
      final List<dynamic> data = json.decode(response.body);
      // Convierte los datos en una lista de strings
      return data.map((item) => item['nombre'].toString()).toList();
    } else {
      throw Exception('Error al obtener los alimentos: ${response.statusCode}');
    }
  }
}
