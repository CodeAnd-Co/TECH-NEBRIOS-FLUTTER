// RF16 Visualizar todas las charolas registradas en el sistema - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF16

import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/constantes.dart';
import '../models/menu_charolas.model.dart';
import '../services/menu_charolasAPI.service.dart';

/// Repositorio que implementa la lógica para consumir la API de charolas.
/// Encapsula llamadas HTTP y transformación de datos.
class CharolaRepositorio implements CharolaServicioApi {
  /// Llama a la API para obtener charolas paginadas.
  ///
  /// Retorna un mapa con la respuesta JSON o lanza excepciones según el error.
  @override
  Future<Map<String, dynamic>?> obtenerCharolasPaginadas(int pag, int limite) async {
    final uri = Uri.parse('${APIRutas.CHAROLA}?page=$pag&limit=$limite');

    try {
      final respuesta = await http.get(uri);

      if (respuesta.statusCode == 200) {
        return jsonDecode(respuesta.body);
      } else if (respuesta.statusCode == 401) {
        throw Exception('Debe iniciar sesión para continuar');
      } else if (respuesta.statusCode == 500) {
        throw Exception('Error del servidor. Inténtelo más tarde');
      } else {
        print("Error HTTP: ${respuesta.statusCode}");
      }
    } on SocketException catch (_) {
      // Error 101: problema de red o conexión
      throw Exception('❌ Error de conexión. Verifique su red.');
    } catch (e) {
      print("Error al conectarse al backend: $e");
    }

    return null;
  }

  /// Convierte la respuesta cruda de la API en un modelo [CharolaTarjeta].
  ///
  /// Retorna null si la respuesta no es válida.
  Future<CharolaTarjeta?> obtenerCharolaRespuesta(int pag, int limite) async {
    final data = await obtenerCharolasPaginadas(pag, limite);
    if (data != null) {
      return CharolaTarjeta.fromJson(data);
    }
    return null;
  }
}
