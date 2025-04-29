class CharolaModel {
  String nombre;
  double densidadLarva;
  String fechaCreacion;
  String? nombreComida; // Permite valores nulos
  double comidaCiclo;
  double pesoCharola;
  String? nombreHidratacion; // Permite valores nulos
  double hidratacionCiclo;

  CharolaModel({
    required this.nombre,
    required this.densidadLarva,
    required this.fechaCreacion,
    this.nombreComida,
    required this.comidaCiclo,
    required this.pesoCharola,
    this.nombreHidratacion,
    required this.hidratacionCiclo,
  });
}
