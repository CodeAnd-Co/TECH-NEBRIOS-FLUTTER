import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:tech_nebrios_tracker/data/models/constantes.dart';
import '../models/historialActividadModel.dart';
import '../services/historialActividadAPIService.dart';

class HistorialActividadRepository extends HistorialActividadAPIService {
  @override
  Future<HistorialactividadRespuesta?> historialActividad(charolaId) async {
    final url = Uri.parse('${APIRutas.CHAROLA}/historialActividad?charolaId=1');
    try {
      final respuesta = await http.get(url);

      if (respuesta.statusCode == 200) {
        final data = jsonDecode(respuesta.body);
        final resultado = HistorialactividadRespuesta.fromJson(data);
        return resultado;
      } else {
        return null;
      }
      
    } catch (error) {
      return null;
    }
  }

}