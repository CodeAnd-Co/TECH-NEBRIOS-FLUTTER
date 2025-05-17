//RF23: Registrar un nuevo tipo de comida en el sistema - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF23
//RF24: Editar un tipo de comida en el sistema - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF24
//RF26: Registrar la alimentación de la charola - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF26
/// Modelo que representa un alimento en la aplicación.
///
/// Corresponde al JSON devuelto por la API:
/// {
///   "comidaId": 1,
///   "nombre": "Manzana",
///   "descripcion": "Fruta roja y jugosa"
/// }
class Alimento {
  /// Identificador único del alimento.
  final int idAlimento;

  /// Nombre descriptivo del alimento.
  final String nombreAlimento;

  /// Descripción extendida o detalles del alimento.
  final String descripcionAlimento;

  Alimento({
    required this.idAlimento,
    required this.nombreAlimento,
    required this.descripcionAlimento,
  });

  /// Crea una instancia de [Alimento] a partir de un [json] Map.
  factory Alimento.fromJson(Map<String, dynamic> json) {
    return Alimento(
      idAlimento: json['comidaId'] as int,
      nombreAlimento: json['nombre'] as String,
      descripcionAlimento: json['descripcion'] as String,
    );
  }
}

class ComidaCharola {
  final int charolaId;
  final int comidaId;
  final int cantidadOtorgada;
  final String fechaOtorgada;

  ComidaCharola({
    required this.charolaId,
    required this.comidaId,
    required this.cantidadOtorgada,
    required this.fechaOtorgada,
  });

  Map<String, dynamic> toJson() => {
        'charolaId': charolaId,
        'comidaId': comidaId,
        'cantidadOtorgada': cantidadOtorgada,
        'fechaOtorgada': fechaOtorgada,
      };
}
