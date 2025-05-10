//RF23: Registrar un nuevo tipo de comida en el sistema - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF23
//RF25: Eliminar un tipo de comida en el sistema - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF25
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/alimentacion_model.dart';
import '../models/constantes.dart';
import '../services/alimentacion_service.dart';

/// Repositorio que implementa [AlimentacionService] y realiza
/// las llamadas HTTP a la API de alimentación.
///
/// Responsable de:
///  - Construir URIs (endpoints).
///  - Gestionar respuestas y errores HTTP.
///  - Convertir JSON a modelos [Alimento].
class AlimentacionRepository extends AlimentacionService {
  
  /// Obtiene la lista completa de alimentos desde la API.
  ///
  /// Lanza una excepción si ocurre algún problema de red o parsing.
  /// El resultado es una lista de objetos [Alimento].
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

  /// Elimina un alimento existente en el sistema.
  ///
  /// [idAlimento] es el identificador del alimento a eliminar.
  @override
  Future<void> eliminarAlimento(int idAlimento) async {
    final uri = Uri.parse('${APIRutas.ALIMENTACION}/eliminar/$idAlimento');
    final response = await http.delete(uri);

    // Manejo de códigos de error específicos
    if (response.statusCode == 500) {
      throw Exception('❌ Error del servidor.');
    } else if (response.statusCode != 200) {
      throw Exception('❌ Error desconocido (${response.statusCode}).');
    }
  }
}
