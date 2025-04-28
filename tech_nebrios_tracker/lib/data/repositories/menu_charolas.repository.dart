// RF16 Visualizar todas las charolas registradas en el sistema - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF16

import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/menu_charolas.model.dart';
import '../services/menu_charolasAPI.service.dart';

class CharolaRepositorio implements CharolaServicioApi {
  static const String _baseUrl = 'http://localhost:3000/api';

  @override
  Future<Map<String, dynamic>?> obtenerCharolasPaginadas(int pag, int limite) async {
    final uri = Uri.parse('$_baseUrl/charolas?page=$pag&limit=$limite');

    try {
      final respuesta = await http.get(uri);

      if (respuesta.statusCode == 200) {
        return jsonDecode(respuesta.body);
      } else if (respuesta.statusCode == 401) {
        throw Exception('Debe iniciar sesión para continuar');
      } else if (respuesta.statusCode == 500) {
        throw Exception('Error del servidor. Inténtelo más tarde');
      }else {
        print("Error HTTP: ${respuesta.statusCode}");
      }
    } on SocketException catch (_) {
      // ❌ Error 101: Red caída, timeout, servidor no responde
      throw Exception('Error de conexión. Verifique su red.');
    } catch (e) {
      print("Error al conectarse al backend: $e");
    }

    return null;
  }

  Future<CharolaTarjeta?> obtenerCharolaRespuesta(int pag, int limite) async {
    final data = await obtenerCharolasPaginadas(pag, limite);
    if (data != null) {
      return CharolaTarjeta.fromJson(data);
    }
    return null;
  }
}
