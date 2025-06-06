// RF29: Visualizar la información del Frass obtenido - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF29

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/frasModel.dart';
import '../models/constantes.dart';
import '../../domain/usuarioUseCases.dart';

/// Repositorio para manejar las operaciones relacionadas con el Frass.
class FrasRepository {
  final UserUseCases _userUseCases = UserUseCases();

  /// Obtiene la lista de Frass desde la API.
  /// Lanza una excepción si no hay token de usuario o si la respuesta es incorrecta.
  Future<List<Fras>> obtenerFras() async {
    final uri = Uri.parse(APIRutas.FRAS);
    final token = await _userUseCases.obtenerTokenActual();

    if (token == null) {
      throw Exception('Debe iniciar sesión para continuar');
    }

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((item) => Fras.fromJson(item)).toList();
    } else {
      throw Exception('Error al obtener los frass: ${response.reasonPhrase}');
    }
  }
}