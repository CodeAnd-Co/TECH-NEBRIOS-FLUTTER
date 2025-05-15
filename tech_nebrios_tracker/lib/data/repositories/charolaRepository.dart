// RF16 Visualizar todas las charolas registradas en el sistema - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF16

import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import '../models/constantes.dart';
import '../models/charolaModel.dart';
import '../../domain/usuarioUseCases.dart';

/// Repositorio que implementa la lógica para consumir la API de charolas.
/// Encapsula llamadas HTTP y transformación de datos.
class CharolaRepository {
  final Logger _logger = Logger();
  final UserUseCases _userUseCases = UserUseCases();

  /// Obtiene charolas paginadas.
Future<Map<String, dynamic>?> obtenerCharolasPaginadas(int pag, int limite, {String estado = 'activa'}) async {
  final uri = Uri.parse('${APIRutas.CHAROLA}/charolas?page=$pag&limit=$limite&estado=$estado');
  final token = await _userUseCases.obtenerTokenActual();

  try {
    final respuesta = await http.get(uri, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    if (respuesta.statusCode == 200) {
      return jsonDecode(respuesta.body) as Map<String, dynamic>;
    } else if (respuesta.statusCode == 401) {
      throw Exception('Debe iniciar sesión para continuar');
    } else if (respuesta.statusCode == 500) {
      throw Exception('Error del servidor. Inténtelo más tarde');
    } else {
      _logger.e("Error HTTP inesperado: ${respuesta.statusCode}");
      throw Exception('Error HTTP ${respuesta.statusCode}');
    }
  } on SocketException catch (_) {
    throw Exception('❌ Error de conexión. Verifique su red.');
  } catch (e) {
    _logger.e("Error al conectarse al backend (paginado): $e");
    rethrow;
  }
}


  /// Convierte la respuesta cruda de la API en un modelo [CharolaDashboard].
  ///
  /// Retorna null si la respuesta no es válida.
  Future<CharolaDashboard?> obtenerCharolaRespuesta(int pag, int limite, {String estado = 'activa'}) async {
    final data = await obtenerCharolasPaginadas(pag, limite, estado: estado);
    if (data != null) {
      return CharolaDashboard.fromJson(data);
    }
    return null;
  }

  /// Obtiene el detalle de una charola específica.
  Future<CharolaDetalle?> obtenerCharola(int id) async {
    final token = await _userUseCases.obtenerTokenActual();
    final uri = Uri.parse('${APIRutas.CHAROLA}/consultarCharola/$id');

    try {
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        return CharolaDetalle.fromJson(decoded['data']);
      } else if (response.statusCode == 401) {
        throw Exception('No autorizado. Por favor, inicie sesión.');
      } else {
        _logger.e('Error HTTP: ${response.statusCode}');
        throw Exception('Error al obtener la charola');
      }
    } on SocketException {
      throw Exception('❌ Error de conexión. Verifique su red.');
    } catch (e) {
      _logger.e('Error al obtener charola: $e');
      return null;
    }
  }

  /// Elimina una charola por ID.
  Future<void> eliminarCharola(int id) async {
    final token = await _userUseCases.obtenerTokenActual();
    final uri = Uri.parse('${APIRutas.CHAROLA}/eliminarCharola/$id');

    try {
      final response = await http.delete(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) return;
      if (response.statusCode == 401) {
        throw Exception('No autorizado. Por favor, inicie sesión.');
      }
      _logger.e('Error HTTP: ${response.statusCode}');
      throw Exception('Error al eliminar la charola');
    } on SocketException {
      throw Exception('❌ Error de conexión. Verifique su red.');
    } catch (e) {
      _logger.e('Error al eliminar charola: $e');
      rethrow;
    }
  }

  /// Registra una nueva charola.
  Future<void> registrarCharola(CharolaRegistro charola) async {
    final token = await _userUseCases.obtenerTokenActual();
    final uri = Uri.parse('${APIRutas.CHAROLA}/registrarCharola');

    try {
      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(charola.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
  // Éxito: charola creada
        return;
      }
      if (response.statusCode == 401) {
        throw Exception('No autorizado. Por favor, inicie sesión.');
      }
      _logger.e('Error HTTP: ${response.statusCode}');
      throw Exception('Error al registrar la charola');
    } on SocketException {
      throw Exception('❌ Error de conexión. Verifique su red.');
    } catch (e) {
      _logger.e('Error al registrar charola: $e');
      rethrow;
    }
  }
}
