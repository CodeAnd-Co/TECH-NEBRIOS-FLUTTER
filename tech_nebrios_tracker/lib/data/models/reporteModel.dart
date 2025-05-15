class ReporteModel {
  String nombreCharola;
  double comidaCiclo;
  double hidratacionCiclo;
  DateTime fechaActualizacion;
  String estado;
  String densidadLarva;
  DateTime fechaCreacion;
  double pesoCharola;

  ReporteModel({
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