//RF23: Registrar un nuevo tipo de comida en el sistema - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF23
//RF24: Editar un tipo de comida en el sistema - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF24
//RF26: Registrar la alimentación de la charola - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF26
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/alimentacionModel.dart';
import '../models/constantes.dart';
import '../services/alimentacionAPIService.dart';
import '../../domain/usuarioUseCases.dart';

/// Repositorio que implementa [AlimentacionService] y realiza
/// las llamadas HTTP a la API de alimentación.
///
/// Responsable de:
///  - Construir URIs (endpoints).
///  - Gestionar respuestas y errores HTTP.
///  - Convertir JSON a modelos [Alimentacion].
class AlimentacionRepository extends AlimentacionService {
  final UserUseCases _userUseCases = UserUseCases();

  @override
  Future<List<Alimento>> obtenerAlimentos() async {
    final uri = Uri.parse(APIRutas.ALIMENTACION);
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

  /// Elimina un alimento existente en el sistema.
  ///
  /// [idAlimento] es el identificador del alimento a eliminar.
  @override
  Future<void> eliminarAlimento(int idAlimento) async {
    final uri = Uri.parse('${APIRutas.ALIMENTACION}/eliminar/$idAlimento');
    final token = await _userUseCases.obtenerTokenActual();
    if (token == null) {
      throw Exception('Debe iniciar sesión para continuar');
    }

    final response = await http.delete(uri,
    headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    // Manejo de códigos de error específicos
    if (response.statusCode == 500) {
      throw Exception('❌ Error del servidor.');
    } else if (response.statusCode != 200) {
      throw Exception('❌ Error desconocido (${response.statusCode}).');
    }
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
  Future<void> postDatosAlimento(String nombre, String descripcion) async {
    try {
      final uri = Uri.parse('${APIRutas.ALIMENTACION}/agregar');
      final token = await _userUseCases.obtenerTokenActual();
      if (token == null) {
        throw Exception('Debe iniciar sesión para continuar');
      }

      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'nombre': nombre, 'descripcion': descripcion}),
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
    } on SocketException {
      throw Exception('❌ Error de conexión. Verifica tu conexión a internet.');
    } catch (e) {
      throw Exception('❌ Ocurrió un error inesperado: $e');
    }
  }


  @override
  Future<bool> registrarAlimentacion(ComidaCharola comidaCharola) async {
    final url = Uri.parse('${APIRutas.CHAROLA}/alimentar');
    final token = await _userUseCases.obtenerTokenActual();
    if (token == null) {
      throw Exception('Debe iniciar sesión para continuar');
    }

    final response = await http.post(
      url,
       headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(comidaCharola.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      throw Exception('Error al registrar alimentación: ${response.body}');
    }
  }
}
