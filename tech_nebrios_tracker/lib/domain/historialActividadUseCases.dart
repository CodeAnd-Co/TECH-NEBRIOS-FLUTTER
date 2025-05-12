import '../data/repositories/historialActividadRepository.dart';
import '../data/models/historialActividadModel.dart';

abstract class HistorialActividadUseCases{
  Future<HistorialactividadRespuesta?> execute(charolaId);
}

class HistorialActividadUseCasesImp extends HistorialActividadUseCases{
  final HistorialActividadRepository repositorio;

  HistorialActividadUseCasesImp({HistorialActividadRepository? repositorio}) : repositorio = repositorio ?? HistorialActividadRepository();

  @override
  Future<HistorialactividadRespuesta?> execute(charolaId) async {
    return await repositorio.historialActividad(charolaId);
  }
}