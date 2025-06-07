import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:zuustento_tracker/data/models/constantes.dart';
import '../services/reporteAPIService.dart';
import '../../domain/usuarioUseCases.dart';

class ReporteRepository extends ReporteAPIService {
  final UsuarioUseCasesImp _userUseCases = UsuarioUseCasesImp();

  @override
  Future<Map<dynamic, dynamic>> getDatos() async {
    // Construir la URL
    final url = Uri.parse('${APIRutas.REPORTE}/getDatos');
    final token = await _userUseCases.obtenerTokenActual();
    if (token == null) {
      throw Exception('Debe iniciar sesión para continuar');
    }

    try {
      // Esperar la respuesta de la llamada al backend
      final respuesta = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      // Si la respuesta de la llamada salió bien
      if (respuesta.statusCode == 200) {
        var decodificacion = jsonDecode(respuesta.body);
        var informacionCharolas = decodificacion["resultado"];

        return {'codigo': 200, 'mensaje': informacionCharolas};
      } else if (respuesta.statusCode == 201) {
        // Si la respuesta no contiene información
        return {'codigo': 201, 'mensaje': []};
      } else if (respuesta.statusCode == 401) {
        // Si el usuario no esta loggueado
        return {'codigo': 401, 'mensaje': null};
      } else if (respuesta.statusCode == 403) {
        // Si el usuario no es un administrador
        return {'codigo': 403, 'mensaje': null};
      } else {
        // Error de servidor
        return {'codigo': 500, 'mensaje': null};
      }
    } catch (error) {
      return {'codigo': 500, 'mensaje': null};
    }
  }

  Future<Map<dynamic, dynamic>> getEliminadas() async {
    // Construir la URL
    final url = Uri.parse('${APIRutas.REPORTE}/getEliminadas');
    final token = await _userUseCases.obtenerTokenActual();
    if (token == null) {
      throw Exception('Debe iniciar sesión para continuar');
    }

    try {
      // Esperar la respuesta de la llamada al backend
      final respuesta = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      // Si la respuesta de la llamada salió bien
      if (respuesta.statusCode == 200) {
        var decodificacion = jsonDecode(respuesta.body);
        var informacionCharolas = decodificacion["resultado"];

        return {'codigo': 200, 'mensaje': informacionCharolas};
      } else if (respuesta.statusCode == 201) {
        // Si la respuesta no contiene información
        return {'codigo': 201, 'mensaje': []};
      } else if (respuesta.statusCode == 401) {
        // Si el usuario no esta loggueado
        return {'codigo': 401, 'mensaje': null};
      } else if (respuesta.statusCode == 403) {
        // Si el usuario no es un administrador
        return {'codigo': 403, 'mensaje': null};
      } else {
        // Error de servidor
        return {'codigo': 500, 'mensaje': null};
      }
    } catch (error) {
      return {'codigo': 500, 'mensaje': null};
    }
  }

  @override
  Future<Map<dynamic, dynamic>> postDescargarArchivo() async {
    // Construir la URL
    final url = Uri.parse('${APIRutas.REPORTE}/postArchivoExcel');
    final token = await _userUseCases.obtenerTokenActual();
    if (token == null) {
      throw Exception('Debe iniciar sesión para continuar');
    }

    try {
      // Esperar la respuesta de la llamada al backend
      final respuesta = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept':
              'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
        },
      );

      if (respuesta.statusCode == 200) {
        // Crear nombre único con fecha y hora
        final String timestamp = DateFormat(
          'yyyyMMdd_HHmmss',
        ).format(DateTime.now());
        final String fileName = 'charola_$timestamp.xlsx';
        final Directory homeDir = getHomeDirectory();
        final String downloadsPath = path.join(homeDir.path, 'Downloads');
        final savePath = path.join(downloadsPath, fileName);
        final file = File(savePath);
        await file.writeAsBytes(respuesta.bodyBytes);

        return {'codigo': 200, 'path': savePath};
      } else if (respuesta.statusCode == 201) {
        // Se regresa un error 201 cuando no hay información de las charolas.
        return {'codigo': 201, 'path': null};
      } else {
        // Se regresa un error 500 en caso de haber algún error de servidor.
        return {'codigo': 500, 'path': null};
      }
    } catch (error) {
      return {'codigo': 500, 'path': null};
    }
  }

  Directory getHomeDirectory() {
    if (Platform.isMacOS || Platform.isLinux) {
      return Directory(Platform.environment['HOME'] ?? '');
    } else if (Platform.isWindows) {
      return Directory(Platform.environment['USERPROFILE'] ?? '');
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}
