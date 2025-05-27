import './charolaModel.dart';

class TamizadoMultiple {
  List<CharolaRegistro> charolas;
  DateTime fecha;

  TamizadoMultiple({
    required this.charolas,
    required this.fecha,
  });

  Map<String, dynamic> toJson() {
    return {
      'charolas': charolas,
      'fecha': fecha.toIso8601String(), // Muy importante
    };
  }
}
