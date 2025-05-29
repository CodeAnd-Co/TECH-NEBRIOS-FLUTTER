import './charolaModel.dart';

class TamizadoIndividual {
  List<CharolaRegistro> charolasNuevas;
  List<CharolaTarjeta> charolasParaTamizar;

  int alimento;
  int hidratacion;
  double fras;
  double pupa;
  double alimentoCantidad;
  double hidratacionCantidad;
  DateTime fecha;

  TamizadoIndividual({
    required this.charolasNuevas,
    required this.charolasParaTamizar,
    required this.alimento,
    required this.hidratacion,
    required this.fras,
    required this.pupa,
    required this.alimentoCantidad,
    required this.hidratacionCantidad,
    required this.fecha,
  });

  Map<String, dynamic> toJson() {
    return {
      'charolasNuevas': charolasNuevas,
      'charolasParaTamizar': charolasParaTamizar,
      'alimento': alimento,
      'hidratacion': hidratacion,
      'fras': fras,
      'pupa': pupa,
      'alimentoCantidad': alimentoCantidad,
      'hidratacionCantidad': hidratacionCantidad,
      'fecha': fecha.toIso8601String(), // Muy importante
    };
  }
}