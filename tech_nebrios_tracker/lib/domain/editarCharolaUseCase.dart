//RF7 Editar información de una charola: https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF7
import '../data/repositories/editarCharolaRepository.dart';

abstract class EditarCharolaUseCase {
  Future <Map<dynamic,dynamic>> editarCharola(charolaId, nuevoEstado, nuevoPeso, nuevaAlimentacion, nuevaAlimentacionOtorgada, fechaActualizacion, nuevaHidratacion, nuevaHidratacionOtorgada);
}

class EditarCharolaUseCaseImp extends EditarCharolaUseCase{
  final EditarCharolaRepository repositorio;

  EditarCharolaUseCaseImp({EditarCharolaRepository? repositorio}) : repositorio = repositorio ?? EditarCharolaRepository();

  @override
  Future <Map<dynamic,dynamic>> editarCharola(charolaId, nuevoEstado, nuevoPeso, nuevaAlimentacion, nuevaAlimentacionOtorgada, fechaActualizacion, nuevaHidratacion, nuevaHidratacionOtorgada){
    return repositorio.putEditarCharola(charolaId, nuevoEstado, nuevoPeso, nuevaAlimentacion, nuevaAlimentacionOtorgada, fechaActualizacion, nuevaHidratacion, nuevaHidratacionOtorgada);
  }
}