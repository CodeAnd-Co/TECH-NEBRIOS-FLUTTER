// RF41 Eliminar un tipo de hidratación en el sistema - Documentación: https://codeandco-wiki.netlify.app/docs/next/proyectos/larvas/documentacion/requisitos/RF41
// RF42 Registrar la hidratación de la charola - Documentación: https://codeandco-wiki.netlify.app/docs/next/proyectos/larvas/documentacion/requisitos/RF42

/// Modelo que representa una hidratación en la aplicación.
///
/// Corresponde al JSON devuelto por la API:
/// ```json
/// {
///   "hidratacionId": 1,
///   "nombre": "pepino",
///   "descripcion": "Fruta verde"
/// }
/// ```
class Hidratacion {
  /// Identificador único de la hidratación.
  final int idHidratacion;

  /// Nombre asignado a la hidratación.
  final String nombreHidratacion;

  /// Descripción adicional o detalles sobre la hidratación.
  final String descripcionHidratacion;

  /// Constructor de la clase [Hidratacion].
  ///
  /// Requiere [idHidratacion], [nombreHidratacion] y [descripcionHidratacion].
  Hidratacion({
    required this.idHidratacion,
    required this.nombreHidratacion,
    required this.descripcionHidratacion,
  });

  /// Crea una instancia de [Hidratacion] a partir de un objeto JSON [json].
  ///
  /// Utiliza las claves `hidratacionId`, `nombre` y `descripcion` para mapear los valores.
  factory Hidratacion.fromJson(Map<String, dynamic> json) {
    return Hidratacion(
      idHidratacion: json['hidratacionId'] as int,
      nombreHidratacion: json['nombre'] as String,
      descripcionHidratacion: json['descripcion'] as String,
    );
  }
}

/// Modelo que representa el registro de hidratación aplicada a una charola.
class HidratacionCharola {
  /// ID de la charola a la que se aplicó la hidratación.
  final int charolaId;

  /// ID del tipo de hidratación aplicada.
  final int hidratacionId;

  /// Cantidad de hidratación otorgada, en unidades determinadas (por ejemplo, mililitros).
  final int cantidadOtorgada;

  /// Fecha en la que se otorgó la hidratación, como cadena en formato ISO 8601.
  final String fechaOtorgada;

  /// Constructor de [HidratacionCharola].
  ///
  /// Requiere [charolaId], [hidratacionId], [cantidadOtorgada] y [fechaOtorgada].
  HidratacionCharola({
    required this.charolaId,
    required this.hidratacionId,
    required this.cantidadOtorgada,
    required this.fechaOtorgada,
  });

  /// Convierte esta instancia de [HidratacionCharola] a un objeto JSON.
  ///
  /// Devuelve un [Map] con las claves `charolaId`, `hidratacionId`, `cantidadOtorgada` y `fechaOtorgada`.
  Map<String, dynamic> toJson() => {
        'charolaId': charolaId,
        'hidratacionId': hidratacionId,
        'cantidadOtorgada': cantidadOtorgada,
        'fechaOtorgada': fechaOtorgada,
      };
}
