import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:tech_nebrios_tracker/data/models/constantes.dart';
import '../services/backendApiService.dart';

class TablaRepository extends backendApiService {
  @override
  Future<Map<dynamic, dynamic>> getTabla() async{

    // Construir la URL
    final url = Uri.parse('${APIRutas.CHAROLA}/getTablaCharolas');

    try{
      print("Entro al repository");
      // Esperar la respuesta de la llamada al backend
      final respuesta = await http.get(url);
      print(respuesta.statusCode);

      // Si la respuesta de la llamada salió bien
      if (respuesta.statusCode == 200){
        var decodificacion = jsonDecode(respuesta.body);

        if(decodificacion.length > 0){
          // Decodificar la respuesta
          print("Hay datos");
          return {'codigo': 200, 'mensaje': decodificacion};
        } else {
          // Si la respuesta no contiene información
          print("No hay datos");
          return {'codigo': 200, 'mensaje': []};
        }
      } else if (respuesta.statusCode == 401){
        // Si el usuario no esta loggueado
        return {'codigo': 401, 'mensaje': null};
        
      } else if (respuesta.statusCode == 403){
        // Si el usuario no es un administrador
        return {'codigo': 403, 'mensaje': null};

      } else {
        // Error de servidor
        return {'codigo': 500, 'mensaje':null};
      }
    } catch (error){
      print('Error obteniendo informacion: ${error}');
      return {'codigo': 500, 'mensaje':null};
    }
  }

  @override
  Future<String?> postDescargarArchivo() async{
    // Construir la URL
    final url = Uri.parse('${APIRutas.CHAROLA}/postArchivoExcel');
    print(url);
    try{
      print("Entro al repository");
      // Esperar la respuesta de la llamada al backend
      final respuesta = await http.post(url, headers:{'Accept': 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'});

      if (respuesta.statusCode == 200) {
        // 📅 Crear nombre único con fecha y hora
        final String timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
        final String fileName = 'charola_$timestamp.xlsx';
        final Directory homeDir = Directory('/Users/${Platform.environment['USER']}');
        final String downloadsPath = path.join(homeDir.path, 'Downloads');
        final savePath = path.join(downloadsPath, fileName);
        final file = File(savePath);
        await file.writeAsBytes(respuesta.bodyBytes);
        print("Aqui");

        return savePath;
      } else if (respuesta.statusCode == 204) {
        throw Exception('No hay datos disponibles en la base de datos');
      } else {
        throw Exception('Error del servidor: ${respuesta.statusCode}');
      }
    }catch (error){
      print('Error obteniendo el excel: ${error}');
      return null;
    }
  }

}