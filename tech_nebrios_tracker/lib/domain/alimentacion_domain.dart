//RF23: Registrar un nuevo tipo de comida en el sistema - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF23
import 'package:tech_nebrios_tracker/data/models/alimentacion_model.dart';
import '../../data/repositories/alimentacion_repository.dart';

abstract class EditarAlimentoCasoUso {
  /// Interfaz del caso de uso para editar un alimento.
  Future<void> editar({required Alimento alimento});
}

class EditarAlimentoCasoUsoImpl implements EditarAlimentoCasoUso {
  /// Repositorio de donde se obtendrán los alimentos.
  final AlimentacionRepository repositorio;

  /// Constructor que permite inyectar un repositorio personalizado (opcional).
  EditarAlimentoCasoUsoImpl({AlimentacionRepository? repositorio}): repositorio = repositorio ?? AlimentacionRepository();

  @override
  Future<void> editar({required Alimento alimento}) {
    return repositorio.editarAlimento(alimento);
  }
}