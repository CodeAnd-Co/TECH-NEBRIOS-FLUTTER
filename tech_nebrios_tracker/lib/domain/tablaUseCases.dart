import '../data/repositories/tablaRepository.dart';

abstract class TablaUseCases{
  Future<List?> execute();

  Future<String?> postExecute();
}

class TablaUseCasesImp extends TablaUseCases{
  final TablaRepository repositorio;

  TablaUseCasesImp({TablaRepository? repositorio}) : repositorio = repositorio ?? TablaRepository();

  @override
  Future<List?> execute() async {
    return await repositorio.getTabla();
  }

  @override
  Future<String?> postExecute() async {
    return await repositorio.postDescargarArchivo();
  }
}
