class HistorialactividadRespuesta {
  final String codigo;
  final Estado estado;
  final List<Alimentacion> alimentacion;
  final List<Hidratacion> hidratacion;

  HistorialactividadRespuesta({
    required this.codigo,
    required this.estado,
    required this.alimentacion,
    required this.hidratacion,
  });

  factory HistorialactividadRespuesta.fromJson(Map<String, dynamic> json) {
    return HistorialactividadRespuesta(
      codigo: json['codigo'],
      estado: Estado.fromJson(json['estado']),
      alimentacion: (json['alimentacion'] as List)
          .map((item) => Alimentacion.fromJson(item))
          .toList(),
      hidratacion: (json['hidratacion'] as List)
          .map((item) => Hidratacion.fromJson(item))
          .toList(),
    );
  }
}

class Estado {
  final String estado;
  final String fechaActualizacion;

  Estado({
    required this.estado,
    required this.fechaActualizacion,
  });

  factory Estado.fromJson(Map<String, dynamic> json) {
    return Estado(
      estado: json['estado'],
      fechaActualizacion: json['fechaActualizacion'],
    );
  }
}

class Alimentacion {
  final String cantidadOtorgada;
  final String fechaOtorgada;
  final String nombre;

  Alimentacion({
    required this.cantidadOtorgada,
    required this.fechaOtorgada,
    required this.nombre,
  });

  factory Alimentacion.fromJson(Map<String, dynamic> json) {
    return Alimentacion(
      cantidadOtorgada: json['cantidadOtorgada'],
      fechaOtorgada: json['fechaOtorgada'],
      nombre: json['nombre'],
    );
  }
}

class Hidratacion {
  final String cantidadOtorgada;
  final String fechaOtorgada;
  final String nombre;

  Hidratacion({
    required this.cantidadOtorgada,
    required this.fechaOtorgada,
    required this.nombre,
  });

  factory Hidratacion.fromJson(Map<String, dynamic> json) {
    return Hidratacion(
      cantidadOtorgada: json['cantidadOtorgada'],
      fechaOtorgada: json['fechaOtorgada'],
      nombre: json['nombre'],
    );
  }
}
