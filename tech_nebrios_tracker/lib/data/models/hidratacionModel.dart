// RF42 Registrar la hidratación de la charola - Documentación: https://codeandco-wiki.netlify.app/docs/next/proyectos/larvas/documentacion/requisitos/RF42

/// Modelo que representa una hidratación en la aplicación.
///
/// Corresponde al JSON devuelto por la API:
/// {
///   "hidratacionId": 1,
///   "nombre": "pepino",
///   "descripcion": "Fruta verde"
/// }

class Hidratacion {
  /// Identificador único de hidratación.
  final int idHidratacion;

  /// Nombre descriptivo de hidratación.
  final String nombreHidratacion;

  /// Descripción extendida o detalles de hidratación.
  final String descripcionHidratacion;

  Hidratacion({
    required this.idHidratacion,
    required this.nombreHidratacion,
    required this.descripcionHidratacion,
  });

  /// Crea una instancia de [Hidratacion] a partir de un [json] Map.
  factory Hidratacion.fromJson(Map<String, dynamic> json) {
    return Hidratacion(
      idHidratacion: json['hidratacionId'] as int,
      nombreHidratacion: json['nombre'] as String,
      descripcionHidratacion: json['descripcion'] as String,
    );
  }
}

/// Representa una relación de hidratación registrada para una charola.
///
/// Esta clase se utiliza para modelar la cantidad de hidratación otorgada a una
/// charola específica, junto con la fecha en la que se realizó.
///
/// Generalmente se utiliza para serializar o enviar los datos a través de una API.
class HidratarCharola {
  /// ID único de la charola que recibió la hidratación.
  final int charolaId;

  /// ID del tipo de hidratación otorgada.
  final int hidratacionId;

  /// Cantidad otorgada de hidratación, expresada en mililitros (u otra unidad definida).
  final int cantidadOtorgada;

  /// Fecha en la que se otorgó la hidratación, en formato ISO 8601.
  final String fechaOtorgada;

  /// Constructor de la clase [HidratacionCharola].
  ///
  /// Todos los parámetros son requeridos para asegurar la integridad de los datos.
  HidratarCharola({
    required this.charolaId,
    required this.hidratacionId,
    required this.cantidadOtorgada,
    required this.fechaOtorgada,
  });

  /// Convierte la instancia en un mapa JSON.
  ///
  /// Este método es útil para enviar la instancia como cuerpo de una solicitud HTTP.
  Map<String, dynamic> toJson() => {
        'charolaId': charolaId,
        'hidratacionId': hidratacionId,
        'cantidadOtorgada': cantidadOtorgada,
        'fechaOtorgada': fechaOtorgada,
      };
}


