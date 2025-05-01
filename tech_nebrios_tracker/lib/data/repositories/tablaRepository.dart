import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:tech_nebrios_tracker/data/models/constantes.dart';
import '../models/tablaModel.dart';
import '../services/backendApiService.dart';

class TablaRepository extends backendApiService {
  @override
  Future<List?> getTabla() async{
    // Construir la URL
    final url = Uri.parse('${APIRutas.CHAROLA}/getTablaCharolas');

    try{
      print("Entro al repository");
      // Esperar la respuesta de la llamada al backend
      final respuesta = await http.get(url);

      // Si la respuesta de la llamada salió bien
      if (respuesta.statusCode == 200){
        if(respuesta.body != []){
          // Decodificar la respuesta
          return jsonDecode(respuesta.body);
        }
      }else {
        print('Error fetching pokemon list: ${respuesta.statusCode}');
        return null;
      }
    } catch (error){
      print('Error fetching pokemon list: ${error}');
      return null;
    }
  }

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