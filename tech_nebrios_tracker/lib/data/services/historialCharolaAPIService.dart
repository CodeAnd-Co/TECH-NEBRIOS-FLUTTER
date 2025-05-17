//RF03: Consultar historial de ancestros de una charola - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF3

import '../models/historialCharolaModel.dart';

abstract class HistorialActividadAPIService {
  Future<List<HistorialAncestros>> obtenerAncestros(int idCharola);
}