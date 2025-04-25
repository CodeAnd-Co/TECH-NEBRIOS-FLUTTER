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
      'http://localhost:3000/comida/obtener-comida', // Cambia por tu endpoint
    );
    print('Realizando la peticion a la API a $url'); // Cambia por tu endpoint
    final response = await http.get(url);

    if (response.statusCode == 200) {
      print('Respuesta del servidor: ${response.body}');
      final Map<String, dynamic> decodedResponse = json.decode(response.body);

      // Verifica si la respuesta tiene el formato esperado
      if (decodedResponse['status'] == 'success' &&
          decodedResponse['data'] != null &&
          decodedResponse['data']['comida'] != null) {
        final comida = decodedResponse['data']['comida'];

        // Si `comida` es un objeto, extrae el nombre
        if (comida is Map<String, dynamic>) {
          return [comida['NOMBRE'].toString()];
        }

        // Si `comida` es una lista, mapea los nombres
        if (comida is List<dynamic>) {
          return comida.map((item) => item['NOMBRE'].toString()).toList();
        }
      }

      throw Exception('Estructura de respuesta inesperada');
    } else {
      print('Error en la solicitud: ${response.statusCode}');
      throw Exception('Error al obtener los alimentos: ${response.statusCode}');
    }
  }
}
