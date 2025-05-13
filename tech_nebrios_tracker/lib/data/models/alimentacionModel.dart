//RF23: Registrar un nuevo tipo de comida en el sistema - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF23

/// Modelo que representa un alimento.
///
/// Contiene identificador, nombre y descripción del alimento.
class Alimento {
  /// ID del alimento.
  final int idAlimento;

  /// Nombre del alimento.
  final String nombreAlimento;

  /// Descripción del alimento.
  final String descripcionAlimento;

  /// Constructor para crear una instancia de [Alimento].
  Alimento({
    required this.idAlimento,
    required this.nombreAlimento,
    required this.descripcionAlimento,
  });
  
  /// Crea un objeto [Alimento] desde un mapa JSON.
  factory Alimento.fromJson(Map<String, dynamic> json) {
    return Alimento(
      idAlimento: json['comidaId'] as int,
      nombreAlimento:    json['nombre']   as String,
      descripcionAlimento: json['descripcion'] as String,
    );
  }
}
