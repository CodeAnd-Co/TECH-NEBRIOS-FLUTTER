/// Esta clase mapea el JSON de la respuesta del login
class TamizadoRespuesta {
  final bool exito;
  final String mensaje;

  TamizadoRespuesta({required this.exito, required this.mensaje});

  factory TamizadoRespuesta.fromJson(Map<String, dynamic> json) {
    return TamizadoRespuesta(
      exito: json['exito'],
      mensaje: json['mensaje'],
    );
  }
}