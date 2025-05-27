// RF41 Eliminar un tipo de hidratación en el sistema - Documentación: https://codeandco-wiki.netlify.app/docs/next/proyectos/larvas/documentacion/requisitos/RF41

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

    /// Elimina un hidrato existente en el sistema.
  ///
  /// [idHidratacion] es el identificador del alimento a eliminar.
  @override
  Future<void> eliminarHidratacion(int idHidratacion) async {
    final uri = Uri.parse('${APIRutas.HIDRATACION}/eliminar/$idHidratacion');
    final response = await http.delete(uri);

    // Manejo de códigos de error específicos
    if (response.statusCode == 500) {
      throw Exception('❌ Error del servidor.');
    } else if (response.statusCode != 200) {
      throw Exception('❌ Error desconocido (${response.statusCode}).');
    }
  }
}
