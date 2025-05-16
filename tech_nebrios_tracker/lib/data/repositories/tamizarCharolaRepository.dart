import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/tamizadoIndividualModel.dart';
import '../models/tamizadoMultipleModel.dart';
import '../services/tamizadoApiService.dart';

class TamizarCharolaRepository {

  Future<void> tamizarCharola(TamizadoIndividual tamizadoIndividual) async {
    final url = Uri.parse(
      'http://localhost:3000/charolaTamizado/tamizadoIndividual', // Cambia por tu endpoint
    );

    final respuesta = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(tamizadoIndividual.toJson()),
    );

    if (respuesta.statusCode == 200) {
      print('Charola tamizada correctamente');
    } else if(respuesta.statusCode == 400) {
      print('Error al tamizar la charola: ${respuesta.statusCode}');
    } else if (respuesta.statusCode == 500) {
      print('Error interno del servidor: ${respuesta.statusCode}');
    } else {
      print('Error desconocido: ${respuesta.statusCode}');
    }
  }

  Future<void> tamizarCharolasMultiples(TamizadoMultiple tamizadoMultiple) async {
    final url = Uri.parse(
      'http://localhost:3000/charolaTamizado/tamizadoMultiple', // Cambia por tu endpoint
    );

    final respuesta = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(tamizadoMultiple.toJson()),
    );

    if (respuesta.statusCode == 200) {
      print('Charolas tamizadas correctamente');
    } else if(respuesta.statusCode == 400) {
      print('Error al tamizar las charolas: ${respuesta.statusCode}');
    } else if (respuesta.statusCode == 500) {
      print('Error interno del servidor: ${respuesta.statusCode}');
    } else {
      print('Error desconocido: ${respuesta.statusCode}');
    }
  }

  Future<List<String>> getAlimentos() async {
    final url = Uri.parse(
      'http://localhost:3000/alimentacion', // Cambia por tu endpoint
    );
    print('Realizando la peticion a la API a $url'); // Cambia por tu endpoint
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decodedResponse = json.decode(response.body);
      
        // Si `comida` es una lista, mapea los nombres
        if (decodedResponse is List<dynamic>) {
          return decodedResponse.map((item) => item['nombre'].toString()).toList();
        }
      

      throw Exception('Estructura de respuesta inesperada');
    } else {
      print('Error en la solicitud: ${response.statusCode}');
      throw Exception('Error al obtener los alimentos: ${response.statusCode}');
    }
  }

  // Metodo para obtener datos de hidratacion desde el backend
  Future<List<String>> getHidratacion() async {
    final url = Uri.parse(
      'http://localhost:3000/hidratacion/', // Cambia por tu endpoint
    );
    print('Realizando la peticion a la API a $url'); // Cambia por tu endpoint
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decodedResponse = json.decode(response.body);

        // Si `hidratacion` es una lista, mapea los nombres
        if (decodedResponse is List<dynamic>) {
          return decodedResponse.map((item) => item['nombre'].toString()).toList();
        }
      

      throw Exception('Estructura de respuesta inesperada');
    } else {
      print('Error en la solicitud: ${response.statusCode}');
      throw Exception('Error al obtener los alimentos: ${response.statusCode}');
    }
  }
}
