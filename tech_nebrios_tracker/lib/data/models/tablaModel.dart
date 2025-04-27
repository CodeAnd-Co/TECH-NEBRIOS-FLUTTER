import 'dart:ffi';

class TablaModel {
  String nombreCharola;
  Float comidaCiclo;
  Float hidratacionCiclo;
  DateTime fechaActualizacion;
  String estado;
  String densidadLarva;
  DateTime fechaCreacion;
  Float pesoCharola;

  TablaModel({
    required this.nombreCharola,
    required this.comidaCiclo,
    required this.hidratacionCiclo,
    required this.fechaActualizacion,
    required this.estado,
    required this.densidadLarva,
    required this.fechaCreacion,
    required this.pesoCharola
  });
}