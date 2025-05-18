import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tech_nebrios_tracker/data/models/constantes.dart';
import '../models/historialActividadModel.dart';
import '../services/historialActividadAPIService.dart';

class HistorialActividadRepository extends HistorialActividadAPIService {
  @override
  Future<HistorialactividadRespuesta> historialActividad(charolaId) async {
    final url = Uri.parse('${APIRutas.HISTORIAL_CHAROLA}/historialActividad?charolaId=$charolaId');

    try {
      final respuesta = await http.get(url);

      if (respuesta.statusCode == 200) {
        final data = jsonDecode(respuesta.body);
        final resultado = HistorialactividadRespuesta.fromJson(data);
        return resultado;

      } else if (respuesta.statusCode == 201){
        final data = jsonDecode(respuesta.body);

        final estado = Estado(estado: data['estado']['estado'], fechaActualizacion: data['estado']['fechaActualizacion']);
        final resultado = HistorialactividadRespuesta(codigo: data['codigo'], estado: estado, alimentacion: [], hidratacion: [] );
        return resultado;

      } else { 
        return HistorialactividadRespuesta(codigo: '500', estado: Estado(estado: '', fechaActualizacion: ''), alimentacion: [], hidratacion: []);
      }
      
    } catch (error) {
      return HistorialactividadRespuesta(codigo: '500', estado: Estado(estado: '', fechaActualizacion: ''), alimentacion: [], hidratacion: []);
    }
  }

}