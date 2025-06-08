// RF30: Editar la información del Frass obtenido - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF30

import '../data/repositories/frasRepository.dart';

/// Caso de uso para visualizar la información del Frass obtenido.
/// Permite obtener una lista de Frass desde el repositorio.
/// Este caso de uso se encarga de la lógica de negocio relacionada con la visualización
class EditarFrasUseCase {
  final FrasRepository repositorio;

  EditarFrasUseCase({required this.repositorio});

  /// Edita un Fras en la base de datos.
  Future<void> editarFras(idCharola, nuevosGramos) {
    return repositorio.editarFras(idCharola, nuevosGramos);
  }
}