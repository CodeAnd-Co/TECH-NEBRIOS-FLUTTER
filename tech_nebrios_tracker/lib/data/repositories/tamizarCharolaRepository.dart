import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/tamizadoIndividualModel.dart';
import '../models/tamizadoMultipleModel.dart';
import '../models/tamizadoRespuestaModel.dart';
import '../services/tamizadoApiService.dart';
import '../models/constantes.dart';

class TamizarCharolaRepository implements TamizadoApiService {

  @override
  Future<TamizadoRespuesta?> tamizarCharolaIndividual(TamizadoIndividual tamizadoIndividual) async {
    final url = Uri.parse(
      'http://localhost:3000/charolaTamizado/tamizadoIndividual', // Cambia por tu endpoint
    );

    final respuesta = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(tamizadoIndividual.toJson()),
    );

    final decodificado = json.decode(respuesta.body);
    return TamizadoRespuesta.fromJson(decodificado);
  }

  @override
  Future<TamizadoRespuesta?> tamizarCharolasMultiples(TamizadoMultiple tamizadoMultiple) async {
    final url = Uri.parse(
      'http://localhost:3000/charolaTamizado/tamizadoMultiple', // Cambia por tu endpoint
    );

    final respuesta = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(tamizadoMultiple.toJson()),
    );

    final decodificado = json.decode(respuesta.body);
    return TamizadoRespuesta.fromJson(decodificado);
  }

  @override
  Future<List<String>> getAlimentos() async {
    final url = Uri.parse(
      'http://localhost:3000/alimentacion', // Cambia por tu endpoint
    );
    print('Realizando la peticion a la API a $url'); // Cambia por tu endpoint
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decodedResponse = json.decode(response.body);
      
        // Si `comida` es una lista, mapea los nombres
        if (decodedResponse is List<dynamic>) {
          return decodedResponse.map((item) => item['nombre'].toString()).toList();
        }
      

      throw Exception('Estructura de respuesta inesperada');
    } else {
      print('Error en la solicitud: ${response.statusCode}');
      throw Exception('Error al obtener los alimentos: ${response.statusCode}');
    }
  }

  // Metodo para obtener datos de hidratacion desde el backend
  @override
  Future<List<String>> getHidratacion() async {
    final url = Uri.parse(
      'http://localhost:3000/hidratacion/', // Cambia por tu endpoint
    );
    print('Realizando la peticion a la API a $url'); // Cambia por tu endpoint
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decodedResponse = json.decode(response.body);

        // Si `hidratacion` es una lista, mapea los nombres
        if (decodedResponse is List<dynamic>) {
          return decodedResponse.map((item) => item['nombre'].toString()).toList();
        }
      

      throw Exception('Estructura de respuesta inesperada');
    } else {
      print('Error en la solicitud: ${response.statusCode}');
      throw Exception('Error al obtener los alimentos: ${response.statusCode}');
    }
  }

  @override
  Future<void> asignarAncestros(
    int charolaId,
    List<int> charolasAncestroIds,
  ) async {
    final uri = Uri.parse('${APIRutas.HISTORIAL_CHAROLA}/$charolaId/ancestros');
    final body = jsonEncode({'ancestros': charolasAncestroIds});
    final resp = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json', 
      },
      body: body,
    );
    if (resp.statusCode == 200) {
      return;
    } else if (resp.statusCode == 400) {
      throw Exception('Error en la solicitud: ${resp.body}');
    } else if (resp.statusCode == 401) {
      throw Exception('No autorizado. Por favor, inicie sesión.');
    } else {
      throw Exception('Error al asignar ancestros: ${resp.statusCode}');
   }
  }
}
