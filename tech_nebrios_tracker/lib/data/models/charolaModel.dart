// RF16 Visualizar todas las charolas registradas en el sistema - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF16
// RF10 Consultar información detallada de una charola https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF10
// RF8 Eliminar Charola https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF8
// RF5 Registrar una nueva charola en el sistema - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF5

/// Modelo que representa el detalle completo de una charola,
/// incluyendo su relación con comida e hidratación.
class CharolaDetalle {
  // Atributos principales de la charola
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

  /// Constructor principal del modelo.
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

  /// Método para construir una instancia desde un JSON.
  factory CharolaDetalle.fromJson(Map<String, dynamic> json) {
    final charolaData = json['charola'];
    final comidaRelacion = json['relacionComida'];
    final hidratacionRelacion = json['relacionHidratacion'];
    final comidaData = json['comida'] ?? {}; // Previene errores si es null
    final hidratacionData = json['hidratacion'] ?? {};

    /// Función auxiliar para parsear valores a entero, con manejo de nulos.
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

/// Modelo que representa una charola en su forma resumida
/// para visualización tipo "tarjeta".
class CharolaTarjeta {
  /// ID único de la charola.
  final int charolaId;

  /// Nombre identificador de la charola.
  final String nombreCharola;

  /// Fecha de creación de la charola.
  final DateTime fechaCreacion;

  /// Constructor principal.
  CharolaTarjeta({
    required this.charolaId,
    required this.nombreCharola,
    required this.fechaCreacion,
  });

  /// Método para construir una instancia desde un JSON.
  factory CharolaTarjeta.fromJson(Map<String, dynamic> json) {
    return CharolaTarjeta(
      charolaId: json['charolaId'] as int,
      nombreCharola: json['nombreCharola'],
      fechaCreacion: DateTime.parse(json['fechaCreacion']),
    );
  }
}

/// Modelo que representa la respuesta paginada de la API
/// al consultar charolas.
class CharolaDashboard {
  /// Total de elementos encontrados en la base de datos.
  final int total;

  /// Número de página actual.
  final int pag;

  /// Número de elementos por página.
  final int limite;

  /// Número total de páginas disponibles.
  final int totalPags;

  /// Lista de charolas correspondientes a esta página.
  final List<CharolaTarjeta> data;

  /// Constructor principal.
  CharolaDashboard({
    required this.total,
    required this.pag,
    required this.limite,
    required this.totalPags,
    required this.data,
  });

  /// Método para construir una instancia desde un JSON.
  factory CharolaDashboard.fromJson(Map<String, dynamic> json) {
    return CharolaDashboard(
      total: json['total'],
      pag: json['page'],
      limite: json['limit'],
      totalPags: json['totalPages'],
      data: (json['data'] as List)
          .map((item) => CharolaTarjeta.fromJson(item))
          .toList(),
    );
  }
}

/// Modelos para representar la comida y la hidratación asignada a una charola.
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

/// Modelo que representa el registro de una nueva charola.
/// Incluye información sobre la comida e hidratación asignada.
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