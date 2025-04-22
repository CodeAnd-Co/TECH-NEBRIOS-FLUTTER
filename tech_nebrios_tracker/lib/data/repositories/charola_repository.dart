import '../models/charola_model.dart';

class CharolaRepository {
  final List<CharolaModel> _charolas = []; // Simulación de almacenamiento

  // Método para guardar una charola
  void saveCharola(CharolaModel charola) {
    _charolas.add(charola);
    print("Charola guardada: ${charola.nombre}");
  }
}