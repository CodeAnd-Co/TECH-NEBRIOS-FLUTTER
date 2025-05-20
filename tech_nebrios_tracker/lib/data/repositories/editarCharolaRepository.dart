//RF7 Editar información de una charola: https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF7

import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:tech_nebrios_tracker/data/models/constantes.dart';
import '../services/editarCharolaAPIService.dart';

class EditarCharolaRepository extends EditarCharolaAPIService{
  @override
  Future<Map<dynamic, dynamic>> putEditarCharola(charolaId, nuevoEstado, nuevoPeso, nuevaAlimentacion, nuevaAlimentacionOtorgada, fechaActualizacion, nuevaHidratacion, nuevaHidratacionOtorgada) async {
    // Construir la URL
    final url = Uri.parse('${APIRutas.CHAROLA}/editarCharola?charolaId=$charolaId&nuevoEstado=$nuevoEstado&nuevoPeso=$nuevoPeso&nuevaAlimentacion=$nuevaAlimentacion&nuevaAlimentacionOtorgada=$nuevaAlimentacionOtorgada&fechaActualizacion=$fechaActualizacion&nuevaHidratacion=$nuevaHidratacion&nuevaHidratacionOtorgada=$nuevaHidratacionOtorgada');

    try{
      // Esperar la respuesta de la llamada al backend
      final respuesta = await http.put(url);

      print(respuesta.statusCode);

      if (respuesta.statusCode == 200){
        return {'codigo': 200, 'mensaje': 'Ok'};
      }
      
      return {'codigo': 500, 'mensaje': 'Error de servidor'};

    } catch (error) {
      return {'codigo': 500, 'mensaje': 'Error de servidor'};
    }
  }
}

