class TamizadoMultiple {
  List<String> charolas;
  double fras;
  double pupa;
  DateTime fecha;

  TamizadoMultiple({
    required this.charolas,
    required this.fras,
    required this.pupa,
    required this.fecha,
  });

  Map<String, dynamic> toJson() {
    return {
      'charolas': charolas,
      'fras': fras,
      'pupa': pupa,
      'fecha': fecha.toIso8601String(), // Muy importante
    };
  }
}
