import 'ancestro_model.dart';

class HistorialAncestros {
  final DateTime fechaCreacion;
  final List<Ancestro> ancestros;

  HistorialAncestros({
    required this.fechaCreacion,
    required this.ancestros,
  });

  factory HistorialAncestros.fromJson(Map<String, dynamic> json) {
    return HistorialAncestros(
      fechaCreacion: DateTime.parse(json['fechaCreacion'] as String),
      ancestros: (json['ancestros'] as List<dynamic>)
          .map((e) => Ancestro.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fechaCreacion': fechaCreacion.toIso8601String(),
      'ancestros': ancestros.map((e) => e.toJson()).toList(),
    };
  }
}
