class CharolaModel {
  String nombre;
  double densidadLarva;
  String fechaCreacion;
  String? comidaCiclo; // Permite valores nulos
  double cantidadComida;
  double pesoCharola;
  String? hidratacionCiclo; // Permite valores nulos
  double cantidadHidratacion;

  CharolaModel({
    required this.nombre,
    required this.densidadLarva,
    required this.fechaCreacion,
    this.comidaCiclo,
    required this.cantidadComida,
    required this.pesoCharola,
    this.hidratacionCiclo,
    required this.cantidadHidratacion,
  });
}
