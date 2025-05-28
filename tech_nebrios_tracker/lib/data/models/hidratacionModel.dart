//RF40: Editar hidratacion - https://codeandco-wiki.netlify.app/docs/next/proyectos/larvas/documentacion/requisitos/RF40
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