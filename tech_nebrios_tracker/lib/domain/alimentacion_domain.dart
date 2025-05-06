//RF23: Registrar un nuevo tipo de comida en el sistema - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF23
import 'package:tech_nebrios_tracker/data/models/alimento_model.dart';

import '../../data/repositories/alimento_repository.dart';

abstract class EditarAlimentoCasoUso {
  /// Interfaz del caso de uso para editar un alimento.
  Future<void> editar({required Alimento alimento});
}

class EditarAlimento implements EditarAlimentoCasoUso {
  final AlimentoRepository _repositorio;

  EditarAlimento({required AlimentoRepository repositorio})
      : _repositorio = repositorio;

  @override
  Future<void> editar({required Alimento alimento}) {
    return _repositorio.editarAlimento(alimento);
  }
}
