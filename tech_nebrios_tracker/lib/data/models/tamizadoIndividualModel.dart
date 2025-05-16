class TamizadoIndividual {
  List<String> charolas;
  String alimento;
  String hidratacion;
  double fras;
  double pupa;
  double alimentoCantidad;
  double hidratacionCantidad;
  DateTime fecha;

  TamizadoIndividual({
    required this.charolas,
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
      'charolas': charolas,
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