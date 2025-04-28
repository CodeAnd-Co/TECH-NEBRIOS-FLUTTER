import '../data/repositories/tablaRepository.dart';

abstract class TablaUseCases{
  Future<List?> execute();
}

class TablaUseCasesImp extends TablaUseCases{
  final TablaRepository repositorio;

  TablaUseCasesImp({TablaRepository? repositorio}) : repositorio = repositorio ?? TablaRepository();

  @override
  Future<List?> execute() async {
    return await repositorio.getTabla();
  }
}
