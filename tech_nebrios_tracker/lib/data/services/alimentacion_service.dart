//RF23: Registrar un nuevo tipo de comida en el sistema - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF23
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/alimentacion_model.dart';


/// Servicio que realiza peticiones HTTP para manejar alimentos.
///
/// Se conecta con el backend mediante rutas como `/alimentacion`, `/alimentacion/agregar` y `/alimentacion/eliminar`.
class AlimentacionService {
  static const _baseUrl = 'http://localhost:3000';

    /// Obtiene la lista de alimentos desde el backend.
  ///
  /// Lanza una excepción si la respuesta no es 200.
  Future<List<Alimento>> obtenerAlimentos() async {
    final uri = Uri.parse('$_baseUrl/');
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception(
        'Error al cargar alimentos (${response.statusCode}): ${response.body}'
      );
    }

    final List<dynamic> data = jsonDecode(response.body);
    return data.map((item) => Alimento.fromJson(item)).toList();
  }

  /// Elimina un alimento por su [idAlimento].
  ///
  /// Lanza una excepción si la eliminación falla.
  Future<void> eliminarAlimento(int idAlimento) async {
    final uri = Uri.parse('$_baseUrl/alimentacion/eliminar/$idAlimento');

    final response = await http.delete(uri);

    if (response.statusCode != 200) {
      throw Exception(
        'Error al eliminar alimento (${response.statusCode}): ${response.body}',
      );
    }
  }

  /// Envía los datos de un nuevo alimento para su registro.
  ///
  /// Lanza excepciones específicas según el código de respuesta del backend.
  Future<void> postDatosComida(String nombre, String descripcion) async {
  final uri = Uri.parse('$_baseUrl/alimentacion/agregar');
  final response = await http.post(
    uri,
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'nombre': nombre,
      'descripcion': descripcion,
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
