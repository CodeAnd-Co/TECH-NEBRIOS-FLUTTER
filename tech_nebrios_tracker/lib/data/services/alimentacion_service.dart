//RF23: Registrar un nuevo tipo de comida en el sistema - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF23
import '../models/alimentacion_model.dart';

abstract class AlimentacionService {
  Future<List<Alimento>> obtenerAlimentos();
  Future<void> editarAlimento(Alimento alimento);
}
