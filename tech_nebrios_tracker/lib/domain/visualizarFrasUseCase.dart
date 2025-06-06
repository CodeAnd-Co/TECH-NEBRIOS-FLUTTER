// RF29: Visualizar la información del Frass obtenido - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF29

import '../data/models/frasModel.dart';
import '../data/repositories/frasRepository.dart';

/// Caso de uso para visualizar la información del Frass obtenido.
/// Permite obtener una lista de Frass desde el repositorio.
/// Este caso de uso se encarga de la lógica de negocio relacionada con la visualización
class VisualizarFrasUseCase {
  final FrasRepository repositorio;

  VisualizarFrasUseCase({required this.repositorio});

  /// Obtiene la lista de Frass.
  Future<List<Fras>> obtenerFras() {
    return repositorio.obtenerFras();
  }
}