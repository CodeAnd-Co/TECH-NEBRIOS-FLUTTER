import '../data/repositories/tablaRepository.dart';

abstract class TablaUseCases{
  Future<Map<dynamic, dynamic>> execute();

  Future<Map<dynamic, dynamic>> postExecute();
}

class TablaUseCasesImp extends TablaUseCases{
  final TablaRepository repositorio;

  TablaUseCasesImp({TablaRepository? repositorio}) : repositorio = repositorio ?? TablaRepository();

  @override
  Future<Map<dynamic, dynamic>> execute() async {
    return await repositorio.getTabla();
  }

  @override
  Future<Map<dynamic, dynamic>> postExecute() async {
    return await repositorio.postDescargarArchivo();
  }
}
