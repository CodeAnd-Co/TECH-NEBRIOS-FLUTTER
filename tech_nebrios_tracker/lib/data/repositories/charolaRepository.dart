// RF16 Visualizar todas las charolas registradas en el sistema - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF16
// RF5 Registrar una nueva charola en el sistema - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF5
//RF15  Filtrar charola por fecha - Documentación: https://codeandco-wiki.netlify.app/docs/next/proyectos/larvas/documentacion/requisitos/rf15/

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
  Future<Map<String, dynamic>?> obtenerCharolasPaginadas(
    int pag,
    int limite, {
    String estado = 'activa',
  }) async {
    final uri = Uri.parse(
      '${APIRutas.CHAROLA}/charolas?page=$pag&limit=$limite&estado=$estado',
    );
    final token = await _userUseCases.obtenerTokenActual();
    if (token == null) {
      throw Exception('Debe iniciar sesión para continuar');
    }

    try {
      final respuesta = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

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
      throw ('💥 Error de conexión');
    } catch (e) {
      _logger.e("Error al conectarse al backend (paginado): $e");
      rethrow;
    }
  }

  /// Convierte la respuesta cruda de la API en un modelo [CharolaDashboard].
  ///
  /// Retorna null si la respuesta no es válida.
  Future<CharolaDashboard?> obtenerCharolaRespuesta(
    int pag,
    int limite, {
    String estado = 'activa',
  }) async {
    final data = await obtenerCharolasPaginadas(pag, limite, estado: estado);
    if (data != null) {
      return CharolaDashboard.fromJson(data);
    }
    return null;
  }

  /// Obtiene el detalle de una charola específica.
  Future<CharolaDetalle?> obtenerCharola(int id) async {
    final token = await _userUseCases.obtenerTokenActual();
    if (token == null) {
      throw Exception('Debe iniciar sesión para continuar');
    }

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
      throw ('💥 Error de conexión');
    } catch (e) {
      _logger.e('Error al obtener charola: $e');
      return null;
    }
  }

  /// Elimina una charola por ID.
  Future<void> eliminarCharola(int id) async {
    final token = await _userUseCases.obtenerTokenActual();
    if (token == null) {
      throw Exception('Debe iniciar sesión para continuar');
    }

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
      throw ('💥 Error de conexión');
    } catch (e) {
      _logger.e('Error al eliminar charola: $e');
      rethrow;
    }
  }

  /// Registra una nueva charola.
  Future<Map<String, dynamic>> registrarCharola(CharolaRegistro charola) async {
    final token = await _userUseCases.obtenerTokenActual();
    if (token == null) {
      throw Exception('Debe iniciar sesión para continuar');
    }

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

      // Verifica el código de estado HTTP
      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body)['data'] as Map<String, dynamic>;
      }
      if (response.statusCode == 401) {
        throw Exception('No autorizado. Por favor, inicie sesión.');
      }
      _logger.e('Error HTTP: ${response.statusCode}');
      throw Exception('Error al registrar la charola');
    } on SocketException {
      throw ('💥 Error de conexión');
    } catch (e) {
      _logger.e('Error al registrar charola: $e');
      rethrow;
    }
  }

  /// Filtra charolas por un rango de fechas (fechaCreacion)
  Future<List<CharolaTarjeta>> filtrarCharolasPorFecha({
    required DateTime fechaInicio,
    required DateTime fechaFin,
    }) async {
      final token = await _userUseCases.obtenerTokenActual();
      if (token == null) {
        throw Exception('Debe iniciar sesión para continuar');
      }

      final String inicio = fechaInicio.toIso8601String().split('T').first;
      final String fin = fechaFin.toIso8601String().split('T').first;

      final uri = Uri.parse('${APIRutas.CHAROLA}/charolas/filtrar?inicio=$inicio&fin=$fin');

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
        final List<dynamic> lista = decoded['data'];
        return lista.map((item) => CharolaTarjeta.fromJson(item)).toList();
      } else if (response.statusCode == 401) {
        throw Exception('No autorizado. Por favor, inicie sesión.');
      } else {
        _logger.e('Error HTTP: ${response.statusCode}');
        throw Exception('Error al filtrar charolas por fecha');
      }
    } on SocketException {
      throw ('💥 Error de conexión');
    } catch (e) {
      _logger.e('Error al filtrar charolas: $e');
      rethrow;
    }
  }

}
