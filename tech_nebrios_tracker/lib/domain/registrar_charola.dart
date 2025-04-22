import '../data/models/charola_model.dart';
import '../data/repositories/charola_repository.dart';

class RegistrarCharola {
  final CharolaRepository repository;

  RegistrarCharola(this.repository);

  void execute(CharolaModel charola) {
    repository.saveCharola(charola);
  }
}