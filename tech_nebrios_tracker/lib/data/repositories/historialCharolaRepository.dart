//RF03: Consultar historial de ancestros de una charola - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF3

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/historialCharolaModel.dart';
import '../models/constantes.dart';

class HistorialCharolaRepository {

Future<List<HistorialAncestros>> obtenerAncestros(int charolaId) async {
  final uri = Uri.parse('${APIRutas.HISTORIAL_CHAROLA}/$charolaId/ancestros');
  final resp = await http.get(uri, headers: { /* tus headers */ });

  if (resp.statusCode != 200) {
    throw Exception('Error HTTP ${resp.statusCode}');
  }

  // 1) Decodifica todo el cuerpo como Map
  final decoded = jsonDecode(resp.body) as Map<String, dynamic>;

  // 2) Extrae la lista de ancestros
  final rawAnc = decoded['ancestros'];
  if (rawAnc == null || rawAnc is! List) {
    return [];
  }

  // 3) Mapea cada objeto JSON a tu submodelo (p.ej. AncestroItem)
  final items = rawAnc
      .map((e) => Ancestro.fromJson(e as Map<String, dynamic>))
      .toList();

  // 4) Parsea la fecha de creación de la charola
  final fechaCreacionStr = decoded['fechaCreacion'] as String?;
  final fechaCreacion = fechaCreacionStr != null
      ? DateTime.parse(fechaCreacionStr)
      : DateTime.now();

  // 5) Envuelve todo en un HistorialAncestros y regresa en lista
  return [
    HistorialAncestros(
      ancestros: items,
      fechaCreacion: fechaCreacion,
    )
  ];
}


  }
