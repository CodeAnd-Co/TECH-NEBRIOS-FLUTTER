//RF23: Registrar un nuevo tipo de comida en el sistema - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF23
//RF24: Editar un tipo de comida en el sistema - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF24
//RF26: Registrar la alimentación de la charola - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF26

import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/alimentacionModel.dart';

/// Interfaz que define las operaciones de alimentación.
///
/// Aquí declaramos los métodos básicos que deberá implementar
/// cualquier servicio de datos de alimentación (API, local, mock…).
abstract class AlimentacionService {
  /// Obtiene la lista completa de alimentos desde la fuente de datos.
  ///
  /// Lanza una excepción si ocurre algún problema de red o parsing.
  Future<List<Alimento>> obtenerAlimentos();

  /// Edita un alimento existente.
  ///
  /// [alimento] instancia con los datos actualizados.
  /// Lanza excepción en caso de error (400, 500, etc.).
  Future<void> editarAlimento(Alimento alimento);


  /// Elimina un alimento existente en el sistema.
  ///
  /// [idAlimento] es el identificador del alimento a eliminar.
  Future<void> eliminarAlimento(int idAlimento);
  
  /// Registra un nuevo tipo de comida en el sistema.
  ///
  /// [nombre] es el nombre del nuevo alimento.
  /// [descripcion] es la descripción detallada del alimento.
  ///
  /// Lanza excepciones si el backend responde con error (400, 500, etc.).
  Future<void> postDatosComida(String nombre, String descripcion);
}

class ComidaCharolaAPIService {
  final String baseUrl = 'http://localhost:3000';

  Future<bool> registrarAlimentacion(ComidaCharola comidaCharola) async {
    final url = Uri.parse('$baseUrl/charola/alimentar');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(comidaCharola.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      throw Exception('Error al registrar alimentación: ${response.body}');
    }
  }
  
  Future<List<Alimento>> obtenerAlimentos() async {
    final url = Uri.parse('$baseUrl/alimentacion');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Alimento.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener alimentos: ${response.body}');
    }
  }
}