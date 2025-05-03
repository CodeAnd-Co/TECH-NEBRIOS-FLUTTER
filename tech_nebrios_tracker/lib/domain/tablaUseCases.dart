import '../data/repositories/tablaRepository.dart';

abstract class TablaUseCases{
  Future<Map<dynamic, dynamic>> execute();

  Future<String?> postExecute();
}

class TablaUseCasesImp extends TablaUseCases{
  final TablaRepository repositorio;

  TablaUseCasesImp({TablaRepository? repositorio}) : repositorio = repositorio ?? TablaRepository();

  @override
  Future<Map<dynamic, dynamic>> execute() async {
    return await repositorio.getTabla();
  }

  @override
  Future<String?> postExecute() async {
    return await repositorio.postDescargarArchivo();
  }
}
