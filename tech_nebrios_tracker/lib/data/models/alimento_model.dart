//RF23: Registrar un nuevo tipo de comida en el sistema - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF23
class Alimento {
  final int idAlimento;
  final String nombreAlimento;
  final String descripcionAlimento;

  Alimento({
    required this.idAlimento,
    required this.nombreAlimento,
    required this.descripcionAlimento,
  });

  factory Alimento.fromJson(Map<String, dynamic> json) {
    return Alimento(
      idAlimento: json['comidaId'] as int,
      nombreAlimento:    json['nombre']   as String,
      descripcionAlimento: json['descripcion'] as String,
    );
  }
}
