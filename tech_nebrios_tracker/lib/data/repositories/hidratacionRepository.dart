//RF40: Editar hidratacion - https://codeandco-wiki.netlify.app/docs/next/proyectos/larvas/documentacion/requisitos/RF40
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/hidratacionModel.dart';
import '../models/constantes.dart';
import '../services/hidratacionAPIService.dart';
import '../../domain/usuarioUseCases.dart';

class HidratacionRepository extends HidratacionService {
  final UserUseCases _userUseCases = UserUseCases();

  @override
  Future<List<Hidratacion>> obtenerHidratacion() async {
    final uri = Uri.parse(APIRutas.HIDRATACION);
    final token = await _userUseCases.obtenerTokenActual();
    if (token == null) {
      throw Exception('Debe iniciar sesión para continuar');
    }

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    // Verifica éxito 200 OK
    if (response.statusCode != 200) {
      throw Exception(
        'Error al cargar hidratación (${response.statusCode}): ${response.body}',
      );
    }

    // Decodifica JSON y mapea a objetos Hidratación
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((item) => Hidratacion.fromJson(item)).toList();
  }

  @override
  Future<void> editarHidratacion(Hidratacion hidratacion) async {
    final uri = Uri.parse(
      '${APIRutas.HIDRATACION}/editar/${hidratacion.idHidratacion}',
    );
    final token = await _userUseCases.obtenerTokenActual();
    if (token == null) {
      throw Exception('Debe iniciar sesión para continuar');
    }

    final response = await http.put(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'nombreHidratacion': hidratacion.nombreHidratacion,
        'descripcionHidratacion': hidratacion.descripcionHidratacion,
      }),
    );

    // Manejo de códigos de error específicos
    if (response.statusCode == 400) {
      throw Exception('❌ Datos no válidos.');
    } else if (response.statusCode == 500) {
      throw Exception('❌ Error del servidor.');
    } else if (response.statusCode != 200) {
      throw Exception('❌ Error desconocido (${response.statusCode}).');
    }
    // Si es 200 OK, simplemente retorna
  }

}
