//RF7 Editar información de una charola: https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF7
import '../data/repositories/editarCharolaRepository.dart';

abstract class EditarCharolaUseCase {
  Future <Map<dynamic,dynamic>> editarCharola(charolaId, nombreCharola, nuevoEstado, nuevoPeso, nuevaAlimentacion, nuevaAlimentacionOtorgada, fechaActualizacion, nuevaHidratacion, nuevaHidratacionOtorgada, fechaCreacion);
}

class EditarCharolaUseCaseImp extends EditarCharolaUseCase{
  final EditarCharolaRepository repositorio;

  EditarCharolaUseCaseImp({EditarCharolaRepository? repositorio}) : repositorio = repositorio ?? EditarCharolaRepository();

  @override
  Future <Map<dynamic,dynamic>> editarCharola(charolaId, nombreCharola, nuevoEstado, nuevoPeso, nuevaAlimentacion, nuevaAlimentacionOtorgada, fechaActualizacion, nuevaHidratacion, nuevaHidratacionOtorgada, fechaCreacion){
    return repositorio.putEditarCharola(charolaId, nombreCharola, nuevoEstado, nuevoPeso, nuevaAlimentacion, nuevaAlimentacionOtorgada, fechaActualizacion, nuevaHidratacion, nuevaHidratacionOtorgada, fechaCreacion);
  }
}