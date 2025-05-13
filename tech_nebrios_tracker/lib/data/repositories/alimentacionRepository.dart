//RF23: Registrar un nuevo tipo de comida en el sistema - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF23
//RF24: Editar un tipo de comida en el sistema - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF24
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/alimentacionModel.dart';
import '../models/constantes.dart';
import '../services/alimentacionService.dart';

/// Repositorio que implementa [AlimentacionService] y realiza
/// las llamadas HTTP a la API de alimentación.
///
/// Responsable de:
///  - Construir URIs (endpoints).
///  - Gestionar respuestas y errores HTTP.
///  - Convertir JSON a modelos [Alimento].
class AlimentacionRepository extends AlimentacionService {
  @override
  Future<List<Alimento>> obtenerAlimentos() async {
    final uri = Uri.parse(APIRutas.ALIMENTACION);
    final response = await http.get(uri);

    // Verifica éxito 200 OK
    if (response.statusCode != 200) {
      throw Exception(
        'Error al cargar alimentos (${response.statusCode}): ${response.body}',
      );
    }

    // Decodifica JSON y mapea a objetos Alimento
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((item) => Alimento.fromJson(item)).toList();
  }

  @override
  Future<void> editarAlimento(Alimento alimento) async {
    final uri = Uri.parse(
      '${APIRutas.ALIMENTACION}/editar/${alimento.idAlimento}',
    );
    final response = await http.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nombreAlimento': alimento.nombreAlimento,
        'descripcionAlimento': alimento.descripcionAlimento,
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

  /// Envía los datos de un nuevo tipo de comida al backend para su registro.
  ///
  /// Realiza una solicitud `POST` al endpoint `ALIMENTACION/agregar` con el
  /// nombre y la descripción del alimento como cuerpo en formato JSON.
  ///
  /// - Lanza una excepción si el servidor responde con un código distinto a 200.
  /// - Maneja errores comunes como datos inválidos (400), problemas de conexión (101),
  ///   o fallos del servidor (500).
  ///
  /// [nombre] Nombre del nuevo tipo de comida a registrar.
  /// [descripcion] Descripción asociada al tipo de comida.
  ///
  /// @throws [Exception] si ocurre un error en la solicitud o respuesta.
  @override
  Future<void> postDatosComida(String nombre, String descripcion) async {
    final uri = Uri.parse(
      '${APIRutas.ALIMENTACION}/agregar',
    );
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