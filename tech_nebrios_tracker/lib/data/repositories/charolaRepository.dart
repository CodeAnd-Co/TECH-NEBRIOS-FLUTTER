// RF16 Visualizar todas las charolas registradas en el sistema - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF16
// RF10 Consultar información detallada de una charola https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF10
// RF8 Eliminar Charola https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF8

import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import '../models/constantes.dart';
import '../models/charolaModel.dart';
import '../../domain/usuarioUseCases.dart';

/// Repositorio encargado de manejar la comunicación entre la app y la API de charolas.
/// Contiene métodos para obtener, consultar detalles y eliminar charolas.
class CharolaRepository {
  final Logger _logger = Logger(); // Logger para depuración y errores
  final UserUseCases _userUseCases = UserUseCases(); // Casos de uso del usuario (e.g. obtener token)

  /// Obtiene charolas paginadas.
  Future<Map<String, dynamic>?> obtenerCharolasPaginadas(int pag, int limite, {String estado = 'activa'}) async {
    final uri = Uri.parse('${APIRutas.CHAROLA}/charolas?page=$pag&limit=$limite&estado=$estado');
    final UserUseCases _userUseCases = UserUseCases();
    final token = await _userUseCases.obtenerTokenActual();

    try {
      final respuesta = await http.get(
        uri,
        headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
        );

      // Si la respuesta es exitosa, decodifica y retorna los datos
      if (respuesta.statusCode == 200) {
        return jsonDecode(respuesta.body);
      } 
      // Manejo de errores comunes
      else if (respuesta.statusCode == 401) {
        throw Exception('Debe iniciar sesión para continuar');
      } else if (respuesta.statusCode == 500) {
        throw Exception('Error del servidor. Inténtelo más tarde');
      } else {
        _logger.e("Error HTTP: ${respuesta.statusCode}");
      }
    } on SocketException catch (_) {
      // Error 101: problema de red o conexión
      throw Exception('❌ Error de conexión. Verifique su red.');
    } catch (e) {
      // Otro tipo de error
      _logger.e('Error al conectarse al backend: $e');
    }

    return null; // Si hay error, se retorna null
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

  /// Consulta el detalle de una charola específica por su ID.
  /// Retorna un modelo [CharolaDetalle] o lanza una excepción si ocurre un error.
  Future<CharolaDetalle?> obtenerCharola(int id) async {
    final token = await _userUseCases.obtenerTokenActual(); // Token del usuario
    final uri = Uri.parse('${APIRutas.CHAROLA}/consultarCharola/$id');

    try {
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      // Si la respuesta es exitosa, decodifica y retorna el modelo de detalle
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        return CharolaDetalle.fromJson(decoded['data']);
      } 
      // Manejo de error de autorización
      else if (response.statusCode == 401) {
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

  /// Elimina una charola en la API por su ID.
  /// Lanza una excepción en caso de fallo.
  Future<void> eliminarCharola(int id) async {
    final token = await _userUseCases.obtenerTokenActual(); // Obtener token del usuario
    final uri = Uri.parse('${APIRutas.CHAROLA}/eliminarCharola/$id');

    try {
      final response = await http.delete(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      // Si se elimina correctamente, simplemente retorna
      if (response.statusCode == 200) return;

      // Si no está autorizado, lanza excepción
      if (response.statusCode == 401) {
        throw Exception('No autorizado. Por favor, inicie sesión.');
      }

      // Otros errores HTTP
      _logger.e('Error HTTP: ${response.statusCode}');
      throw Exception('Error al eliminar la charola');
    } on SocketException {
      throw Exception('❌ Error de conexión. Verifique su red.');
    } catch (e) {
      _logger.e('Error al eliminar charola: $e');
      rethrow; // Re-lanza la excepción para que la lógica superior la maneje
    }
  }
}
