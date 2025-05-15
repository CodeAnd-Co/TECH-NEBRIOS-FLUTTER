// RF10 https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF10
// RF16 Visualizar todas las charolas registradas en el sistema - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF16

class CharolaDetalle {
  // atributos de charola
  final int charolaId;
  final String nombreCharola;
  final int comidaOtorgada;
  final int hidratacionOtorgada;
  final int comidaCiclo;
  final int hidratacionCiclo;
  final String fechaActualizacion;
  final String estado;
  final int densidadLarva;
  final String fechaCreacion;
  final int pesoCharola;
  final String comidaNombre;
  final String comidaDesc;
  final String hidratacionNombre;
  final String hidratacionDesc;

  // constructor por defecto de charola
  CharolaDetalle({
    required this.charolaId,
    required this.nombreCharola,
    required this.comidaOtorgada,
    required this.hidratacionOtorgada,
    required this.comidaCiclo,
    required this.hidratacionCiclo,
    required this.fechaActualizacion,
    required this.estado,
    required this.densidadLarva,
    required this.fechaCreacion,
    required this.pesoCharola,
    required this.comidaNombre,
    required this.comidaDesc,
    required this.hidratacionNombre,
    required this.hidratacionDesc,
  });

  factory CharolaDetalle.fromJson(Map<String, dynamic> json) {
    final charolaData = json['charola'];
    final comidaRelacion = json['relacionComida'];
    final hidratacionRelacion = json['relacionHidratacion'];
    final comidaData =
        json['comida'] ?? {}; // se instancia vacio si es que es nulo
    final hidratacionData =
        json['hidratacion'] ?? {}; // se instancia vacio si es que es nulo

    // función para transformar un valor a int y si es nulo lo retorna como 0
    int parseToInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is double) return value.toInt();
      return int.tryParse(value.toString()) ?? 0;
    }

    return CharolaDetalle(
      charolaId: charolaData['charolaId'] as int,
      nombreCharola: charolaData['nombreCharola'] as String,
      comidaOtorgada: parseToInt(comidaRelacion['cantidadOtorgada']),
      hidratacionOtorgada: parseToInt(hidratacionRelacion['cantidadOtorgada']),
      comidaCiclo: parseToInt(charolaData['comidaCiclo']),
      hidratacionCiclo: parseToInt(charolaData['hidratacionCiclo']),
      fechaActualizacion:
          (charolaData['fechaActualizacion'] as String?) ?? 'desconocido',
      estado: (charolaData['estado'] as String?) ?? 'desconocido',
      densidadLarva: parseToInt(charolaData['densidadLarva']),
      fechaCreacion: (charolaData['fechaCreacion'] as String?) ?? 'desconocido',
      pesoCharola: parseToInt(charolaData['pesoCharola']),
      comidaNombre: (comidaData['nombre'] as String?) ?? 'desconocido',
      comidaDesc: (comidaData['descripcion'] as String?) ?? 'desconocido',
      hidratacionNombre:
          (hidratacionData['nombre'] as String?) ?? 'desconocido',
      hidratacionDesc:
          (hidratacionData['descripcion'] as String?) ?? 'desconocido',
    );
  }
}

/// Modelo que representa una charola individual.
class CharolaTarjeta {
  /// ID único de la charola.
  final int charolaId;

  /// Nombre de la charola.
  final String nombreCharola;

  /// Fecha de creación de la charola.
  final DateTime fechaCreacion;

  CharolaTarjeta({
    required this.charolaId,
    required this.nombreCharola,
    required this.fechaCreacion,
  });

  /// Construye una instancia de Charola desde un JSON.
  factory CharolaTarjeta.fromJson(Map<String, dynamic> json) {
    return CharolaTarjeta(
      charolaId: json['charolaId'] as int,
      nombreCharola: json['nombreCharola'],
      fechaCreacion: DateTime.parse(json['fechaCreacion']),
    );
  }
}

/// Modelo que representa la respuesta paginada de la API para charolas.
class CharolaDashboard {
  /// Total de elementos disponibles en la base de datos.
  final int total;

  /// Página actual.
  final int pag;

  /// Límite de elementos por página.
  final int limite;

  /// Total de páginas calculadas por la API.
  final int totalPags;

  /// Lista de charolas contenidas en esta página.
  final List<CharolaTarjeta> data;

  CharolaDashboard({
    required this.total,
    required this.pag,
    required this.limite,
    required this.totalPags,
    required this.data,
  });

  /// Construye una instancia de CharolaTarjeta desde un JSON.
  factory CharolaDashboard.fromJson(Map<String, dynamic> json) {
    return CharolaDashboard(
      total: json['total'],
      pag: json['page'],
      limite: json['limit'],
      totalPags: json['totalPages'],
      data:
          (json['data'] as List)
              .map((item) => CharolaTarjeta.fromJson(item))
              .toList(),
    );
  }
}

class ComidaAsignada {
  final int comidaId;
  double cantidadOtorgada;

  ComidaAsignada({required this.comidaId, required this.cantidadOtorgada});

  Map<String, dynamic> toJson() => {
        'comidaId': comidaId,
        'cantidadOtorgada': cantidadOtorgada,
      };
}

class HidratacionAsignada {
  final int hidratacionId;
  double cantidadOtorgada;

  HidratacionAsignada({required this.hidratacionId, required this.cantidadOtorgada});

  Map<String, dynamic> toJson() => {
        'hidratacionId': hidratacionId,
        'cantidadOtorgada': cantidadOtorgada,
      };
}

class CharolaRegistro {
  final String nombreCharola;
  final DateTime fechaCreacion;
  final double densidadLarva;
  final double pesoCharola;
  final List<ComidaAsignada> comidas;
  final List<HidratacionAsignada> hidrataciones;

  CharolaRegistro({
    required this.nombreCharola,
    required this.fechaCreacion,
    required this.densidadLarva,
    required this.pesoCharola,
    required this.comidas,
    required this.hidrataciones,
  });

  Map<String, dynamic> toJson() => {
        'nombre': nombreCharola,
        'fechaCreacion': fechaCreacion.toIso8601String(),
        'densidadLarva': densidadLarva,
        'pesoCharola': pesoCharola,
        'comidas': comidas.map((comida) => comida.toJson()).toList(),
        'hidrataciones':
            hidrataciones.map((hidratacion) => hidratacion.toJson()).toList(),
      };
}
