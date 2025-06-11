// RF29: Visualizar la información del Frass obtenido - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF29

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/frasModel.dart';
import '../models/constantes.dart';
import '../../domain/usuarioUseCases.dart';

/// Repositorio para manejar las operaciones relacionadas con el Frass.
class FrasRepository {
  final UsuarioUseCasesImp _userUseCases = UsuarioUseCasesImp();

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

  Future<List<Fras>> editarFras(
    int frasId,
    double nuevosGramos,
  ) async {
    final token = await _userUseCases.obtenerTokenActual();
    final uri = Uri.parse(
      '${APIRutas.FRAS}/editar/$frasId',
    );

    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({'nuevosGramos': nuevosGramos}),
    );

   if (response.statusCode == 200) {
  try {
    final js = jsonDecode(response.body);
    final data = js['data'];
    if (data == null) {
      return [];
    }
    if (data is List && data.isNotEmpty) {
for (var i = 0; i < data.length; i++) {
}
return data
    .where((e) => e != null && e is Map && e['frasId'] != null)
    .map((e) => Fras.fromEditedJson(e))
    .toList();


    }
    if (data is List && data.isEmpty) {
      // Vacío, pero sin error
      return [];
    }
    if (data is Map) {
      return [Fras.fromEditedJson(Map<String, dynamic>.from(data))];
    }
    // Cualquier otro caso
    return [];
  } catch (e) {
    throw Exception('Error en el decode POST: $e');
  }
}
throw Exception('Error al editar gramos: ${response.reasonPhrase}');
  }
}