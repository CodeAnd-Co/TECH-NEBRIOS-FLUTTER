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
  final int cantidadOtorgada;
  final String fechaOtorgada;
  final Comida comida;

  Alimentacion({
    required this.cantidadOtorgada,
    required this.fechaOtorgada,
    required this.comida,
  });

  factory Alimentacion.fromJson(Map<String, dynamic> json) {
    return Alimentacion(
      cantidadOtorgada: json['cantidadOtorgada'],
      fechaOtorgada: json['fechaOtorgada'],
      comida: Comida.fromJson(json['COMIDA']),
    );
  }
}

class Comida {
  final String nombre;

  Comida({required this.nombre});

  factory Comida.fromJson(Map<String, dynamic> json) {
    return Comida(
      nombre: json['nombre'],
    );
  }
}

class Hidratacion {
  final int cantidadOtorgada;
  final String fechaOtrogada;
  final HidratacionInfo hidratacion;

  Hidratacion({
    required this.cantidadOtorgada,
    required this.fechaOtrogada,
    required this.hidratacion,
  });

  factory Hidratacion.fromJson(Map<String, dynamic> json) {
    return Hidratacion(
      cantidadOtorgada: json['cantidadOtorgada'],
      fechaOtrogada: json['fechaOtrogada'],
      hidratacion: HidratacionInfo.fromJson(json['HIDRATACION']),
    );
  }
}

class HidratacionInfo {
  final String nombre;

  HidratacionInfo({required this.nombre});

  factory HidratacionInfo.fromJson(Map<String, dynamic> json) {
    return HidratacionInfo(nombre: json['nombre']);
  }
}
