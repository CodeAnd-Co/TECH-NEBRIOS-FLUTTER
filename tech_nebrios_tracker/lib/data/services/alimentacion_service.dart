import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/alimento_model.dart';

class AlimentacionService {
  static const _baseUrl = 'http://localhost:3000';

  // Temporal: datos de ejemplo sin usar la API
  Future<List<Alimento>> obtenerAlimentos() async {
    // Simula un retardo como si fuera una llamada de red
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      Alimento(
        idAlimento: 1,
        nombreAlimento: 'Manzana',
        descripcionAlimento: 'Fruta roja',
      ),
      Alimento(
        idAlimento: 2,
        nombreAlimento: 'Zanahoria',
        descripcionAlimento: 'Verdura anaranjada',
      ),
      Alimento(
        idAlimento: 3,
        nombreAlimento: 'Lechuga',
        descripcionAlimento: 'Hoja verde',
      ),
    ];
  }

  /// Envía la petición de editar
  Future<void> editarAlimento(Alimento alimento) async {
    final uri = Uri.parse(
      '$_baseUrl/alimentacion/editar/${alimento.idAlimento}',
    );
    final payload = {
      'nombreAlimento': alimento.nombreAlimento,
      'descripcionAlimento': alimento.descripcionAlimento,
    };

    final response = await http.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Error al editar alimento (${response.statusCode}): ${response.body}',
      );
    }
  }
}
