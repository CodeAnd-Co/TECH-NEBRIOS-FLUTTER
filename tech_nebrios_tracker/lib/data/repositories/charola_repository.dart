import '../models/charola_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CharolaRepository {
  // Metodo para guardar una charola
  Future<void> registrarCharola(CharolaModel charola) async {
    final url = Uri.parse(
      'http://localhost:3000/charola/registrarCharola',
    ); // Cambia por tu endpoint
    print('Enviando datos de la charola a $url');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'nombre': charola.nombre,
        'densidadLarva': charola.densidadLarva,
        'fechaCreacion': charola.fechaCreacion,
        'nombreComida': charola.nombreComida,
        'comidaCiclo': charola.comidaCiclo,
        'pesoCharola': charola.pesoCharola,
        'nombreHidratacion': charola.nombreHidratacion,
        'hidratacionCiclo': charola.hidratacionCiclo,
      }),
    );

    // JSON enviado para verificar
    print(
      'JSON enviado: ${json.encode({'nombre': charola.nombre, 'densidadLarva': charola.densidadLarva, 'fechaCreacion': charola.fechaCreacion, 'nombreComida': charola.nombreComida, 'comidaCiclo': charola.comidaCiclo, 'pesoCharola': charola.pesoCharola, 'nombreHidratacion': charola.nombreHidratacion, 'hidratacionCiclo': charola.hidratacionCiclo})}',
    );

    if (response.statusCode == 201) {
      print('Charola registrada exitosamente: ${response.body}');
    } else if (response.statusCode == 409) {
      // Manejar el caso en que el nombre ya existe
      final errorResponse = json.decode(response.body);
      throw Exception(errorResponse['message']);
    } else {
      print('Error al registrar la charola: ${response.statusCode}');
      throw Exception('Error al registrar la charola: ${response.statusCode}');
    }
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

  // Metodo para obtener datos de hidratacion desde el backend
  Future<List<String>> getHidratacion() async {
    final url = Uri.parse(
      'http://localhost:3000/hidratacion/obtener-hidratacion', // Cambia por tu endpoint
    );
    print('Realizando la peticion a la API a $url'); // Cambia por tu endpoint
    final response = await http.get(url);

    if (response.statusCode == 200) {
      print('Respuesta del servidor: ${response.body}');
      final Map<String, dynamic> decodedResponse = json.decode(response.body);

      // Verifica si la respuesta tiene el formato esperado
      if (decodedResponse['status'] == 'success' &&
          decodedResponse['data'] != null &&
          decodedResponse['data']['hidratacion'] != null) {
        final hidratacion = decodedResponse['data']['hidratacion'];

        // Si `hidratacion` es un objeto, extrae el nombre
        if (hidratacion is Map<String, dynamic>) {
          return [hidratacion['NOMBRE'].toString()];
        }

        // Si `hidratacion` es una lista, mapea los nombres
        if (hidratacion is List<dynamic>) {
          return hidratacion.map((item) => item['NOMBRE'].toString()).toList();
        }
      }

      throw Exception('Estructura de respuesta inesperada');
    } else {
      print('Error en la solicitud: ${response.statusCode}');
      throw Exception('Error al obtener los alimentos: ${response.statusCode}');
    }
  }
}
