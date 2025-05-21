import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/hidratacionModel.dart';
import '../models/constantes.dart';
import '../services/hidratacionAPIService.dart';

class HidratacionRepository extends HidratacionService {
  @override
  Future<List<Hidratacion>> obtenerHidratacion() async {
    final uri = Uri.parse(APIRutas.HIDRATACION);
    final response = await http.get(uri);

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

/// Envía los datos de un nuevo tipo de hidratacion al backend para su registro.
  ///
  /// Realiza una solicitud `POST` al endpoint `HIDRATACION/agregar` con el
  /// nombre y la descripción del alimento como cuerpo en formato JSON.
  ///
  /// - Lanza una excepción si el servidor responde con un código distinto a 200.
  /// - Maneja errores comunes como datos inválidos (400), problemas de conexión (101),
  ///   o fallos del servidor (500).
  ///
  /// [nombre] Nombre del nuevo tipo de hidratacion a registrar.
  /// [descripcion] Descripción asociada al tipo de hidratacion.
  ///
  /// @throws [Exception] si ocurre un error en la solicitud o respuesta.
  @override
  Future<void> registrarHidratacion(String nombre, String descripcion) async {
    final uri = Uri.parse('${APIRutas.HIDRATACION}/agregar');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'nombre': nombre, 'descripcion': descripcion}),
    );

    // Manejo de códigos de error específicos
    if (response.statusCode == 400) {
      throw Exception('Datos no válidos.');
    } else if (response.statusCode == 101) {
      throw Exception('Sin conexión a internet.');
    } else if (response.statusCode == 500) {
      throw Exception('Error del servidor.');
    } else if (response.statusCode != 200) {
      throw Exception('Error desconocido (${response.statusCode}).');
    }
  }
}
