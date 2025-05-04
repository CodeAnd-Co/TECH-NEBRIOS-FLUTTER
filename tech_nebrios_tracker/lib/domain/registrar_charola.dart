import '../data/models/charola_model.dart';
import '../data/repositories/charola_repository.dart';

class RegistrarCharola {
  final CharolaRepository repository;

  RegistrarCharola(this.repository);

  Future<void> execute(CharolaModel charola) async {
    await repository.registrarCharola(charola);
  }
}
