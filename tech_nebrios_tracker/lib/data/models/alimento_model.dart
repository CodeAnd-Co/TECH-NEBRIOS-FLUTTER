class Alimento {
  final int idAlimento;
  final String nombreAlimento;
  final String descripcionAlimento;

  Alimento({
    required this.idAlimento,
    required this.nombreAlimento,
    required this.descripcionAlimento,
  });

  factory Alimento.fromJson(Map<String, dynamic> json) => Alimento(
    idAlimento: json['idAlimento'],
    nombreAlimento: json['nombreAlimento'],
    descripcionAlimento: json['descripcionAlimento'],
  );
}
