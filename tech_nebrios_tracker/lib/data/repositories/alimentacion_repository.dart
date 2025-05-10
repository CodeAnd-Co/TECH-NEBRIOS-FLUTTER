//RF23: Registrar un nuevo tipo de comida en el sistema - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF23
import '../models/alimentacion_model.dart';
import '../services/alimentacion_service.dart';
import '../models/constantes.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AlimentacionRepository extends AlimentacionService{

  @override
  Future<List<Alimento>> obtenerAlimentos() async {
    final uri = Uri.parse(APIRutas.ALIMENTACION);
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception(
        'Error al cargar alimentos (${response.statusCode}): ${response.body}'
      );
    }

    final List<dynamic> data = jsonDecode(response.body);
    return data.map((item) => Alimento.fromJson(item)).toList();
  }

  @override
    // Edita un alimento existente
  Future<void> editarAlimento(Alimento alimento) async {
    final uri = Uri.parse('${APIRutas.ALIMENTACION}/editar/${alimento.idAlimento}');
    final response = await http.put(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'nombreAlimento': alimento.nombreAlimento,
        'descripcionAlimento': alimento.descripcionAlimento,
      }),
    );

    if (response.statusCode == 400) {
      throw Exception('❌ Datos no válidos.');
    } else if (response.statusCode == 101) {
      throw Exception('❌ Sin conexión a internet.');
    } else if (response.statusCode == 500) {
      throw Exception('❌ Error del servidor.');
    } else if (response.statusCode != 200) {
      throw Exception('❌ Error desconocido (${response.statusCode}).');
    }
  }
}