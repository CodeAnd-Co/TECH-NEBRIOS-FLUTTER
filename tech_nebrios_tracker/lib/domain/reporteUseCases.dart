import '../data/repositories/reporteRepository.dart';

abstract class ReporteUseCases{
  Future<Map<dynamic, dynamic>> execute();

  Future<Map<dynamic, dynamic>> postExecute();
}

class TablaUseCasesImp extends ReporteUseCases{
  final ReporteRepository repositorio;

  TablaUseCasesImp({ReporteRepository? repositorio}) : repositorio = repositorio ?? ReporteRepository();

  @override
  Future<Map<dynamic, dynamic>> execute() async {
    return await repositorio.getDatos();
  }

  @override
  Future<Map<dynamic, dynamic>> postExecute() async {
    return await repositorio.postDescargarArchivo();
  }
}
