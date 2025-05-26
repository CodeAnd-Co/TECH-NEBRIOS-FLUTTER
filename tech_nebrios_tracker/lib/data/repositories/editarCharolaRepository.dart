//RF7 Editar información de una charola: https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF7

import 'package:http/http.dart' as http;
import 'package:tech_nebrios_tracker/data/models/constantes.dart';
import '../services/editarCharolaAPIService.dart';
import '../../domain/usuarioUseCases.dart';

class EditarCharolaRepository extends EditarCharolaAPIService {
  final UserUseCases _userUseCases = UserUseCases();

  @override
  Future<Map<dynamic, dynamic>> putEditarCharola(
    charolaId,
    nombreCharola,
    nuevoEstado,
    nuevoPeso,
    nuevaAlimentacion,
    nuevaAlimentacionOtorgada,
    fechaActualizacion,
    nuevaHidratacion,
    nuevaHidratacionOtorgada,
    fechaCreacion,
  ) async {
    // Construir la URL
    final url = Uri.parse(
      '${APIRutas.CHAROLA}/editarCharola?charolaId=$charolaId&nuevoNombre=$nombreCharola&nuevoEstado=$nuevoEstado&nuevoPeso=$nuevoPeso&nuevaAlimentacion=$nuevaAlimentacion&nuevaAlimentacionOtorgada=$nuevaAlimentacionOtorgada&fechaActualizacion=$fechaActualizacion&nuevaHidratacion=$nuevaHidratacion&nuevaHidratacionOtorgada=$nuevaHidratacionOtorgada&fechaCreacion=$fechaCreacion',
    );
    final token = await _userUseCases.obtenerTokenActual();
    if (token == null) {
      throw Exception('Debe iniciar sesión para continuar');
    }

    try {
      // Esperar la respuesta de la llamada al backend
      final respuesta = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (respuesta.statusCode == 200) {
        return {'codigo': 200, 'mensaje': 'Ok'};
      }

      return {'codigo': 500, 'mensaje': 'Error de servidor'};
    } catch (error) {
      return {'codigo': 500, 'mensaje': 'Error de servidor'};
    }
  }
}
