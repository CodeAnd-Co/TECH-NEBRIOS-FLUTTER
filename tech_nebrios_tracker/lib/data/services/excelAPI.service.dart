//lib/data/services/excel_api_servicio.dart
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:intl/intl.dart';

class ExcelApiServico {
  Future<String> descargarExcel() async {
    try {
      final url = Uri.parse('http://localhost:3000/api/descargar-excel'); 
      final response = await http.get(url, headers:{'Accept': 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'});
    
      if (response.statusCode == 200) {
        // 📅 Crear nombre único con fecha y hora
        final String timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
        final String fileName = 'charola_$timestamp.xlsx';
        final Directory homeDir = Directory('/Users/${Platform.environment['USER']}');
        final String downloadsPath = path.join(homeDir.path, 'Downloads');
        final savePath = path.join(downloadsPath, fileName);
        final file = File(savePath);
        await file.writeAsBytes(response.bodyBytes);

        return savePath;
      } else if (response.statusCode == 204) {
        throw Exception('No hay datos disponibles en la base de datos');
      } else {
        throw Exception('Error del servidor: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Fallo en la descarga: $e');
    }
  }
}
