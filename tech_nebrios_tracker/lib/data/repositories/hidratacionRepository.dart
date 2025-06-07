// RF41 Eliminar un tipo de hidratación en el sistema - Documentación: https://codeandco-wiki.netlify.app/docs/next/proyectos/larvas/documentacion/requisitos/RF41
//RF40: Editar hidratacion - https://codeandco-wiki.netlify.app/docs/next/proyectos/larvas/documentacion/requisitos/RF40
// RF42 Registrar la hidratación de la charola - Documentación: https://codeandco-wiki.netlify.app/docs/next/proyectos/larvas/documentacion/requisitos/RF42

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/hidratacionModel.dart';
import '../models/constantes.dart';
import '../services/hidratacionAPIService.dart';
import '../../domain/usuarioUseCases.dart';

/// Repositorio que implementa [HidratacionService] y realiza
/// las llamadas HTTP a la API de alimentación.
///
/// Responsable de:
///  - Construir URIs (endpoints).
///  - Gestionar respuestas y errores HTTP.
///  - Convertir JSON a modelos [Hidratacion].
class HidratacionRepository extends HidratacionService {
  final UsuarioUseCasesImp _userUseCases = UsuarioUseCasesImp();

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
    var status = response.statusCode;

    print("status code $status");

    // Manejo de códigos de error específicos
    if (response.statusCode == 500) {
      throw Exception('❌ Error del servidor.');
    } else if (response.statusCode != 200) {
      throw Exception('❌ Error desconocido (${response.statusCode}).');
    }
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

/// Registra una hidratación para una charola a través de una solicitud HTTP POST.
///
/// Este método toma un objeto [HidratarCharola], lo convierte a JSON y lo envía a la
/// API configurada mediante un endpoint definido en [APIRutas.CHAROLA]/hidratar.
///
/// El token de autenticación se obtiene desde [_userUseCases] y se incluye en los headers
/// como autorización. La función maneja explícitamente varios códigos de error.
///
/// Si el código de estado es 200 o 201, se considera que el registro fue exitoso.
///
/// Lanza:
/// - [Exception] con un mensaje específico en caso de error.
///
/// Parámetros:
/// - [hidratarCharola]: Objeto con los datos de la hidratación a registrar.
///
/// Retorna:
/// - [Future<bool>] que indica si la operación fue exitosa (`true`), o lanza una excepción si falla.
@override
Future<bool> registrarHidratacion(HidratacionCharola hidratacionCharola) async {
  final uri = Uri.parse('${APIRutas.CHAROLA}/hidratar');
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
    body: jsonEncode(hidratacionCharola.toJson()),
  );

  if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      throw Exception('Error al registrar alimentación: ${response.body}');
    }
}

}
