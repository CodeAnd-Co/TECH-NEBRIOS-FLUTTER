//RF03: Consultar historial de ancestros de una charola - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF3

import '../data/repositories/historialCharolaRepository.dart';
import '../data/models/historialCharolaModel.dart';

abstract class HistorialCharolaUseCases{
  Future<List<HistorialAncestros>> execute(charolaId);
}

class HistorialActividadUseCasesImp extends HistorialCharolaUseCases{
  final HistorialCharolaRepository repositorio;

  HistorialActividadUseCasesImp({HistorialCharolaRepository? repositorio}) : repositorio = repositorio ?? HistorialCharolaRepository();

  @override
  Future<List<HistorialAncestros>> execute(charolaId) async {
    return await repositorio.obtenerAncestros(charolaId);
  }
}