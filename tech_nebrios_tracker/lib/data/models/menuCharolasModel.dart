/// Modelo que representa una charola individual.
class Charola {
  /// ID único de la charola.
  final int charolaId;

  /// Nombre de la charola.
  final String nombreCharola;

  /// Fecha de creación de la charola.
  final DateTime fechaCreacion;

  Charola({
    required this.charolaId,
    required this.nombreCharola,
    required this.fechaCreacion,
  });

  /// Construye una instancia de Charola desde un JSON.
  factory Charola.fromJson(Map<String, dynamic> json) {
    return Charola(
      charolaId: json['charolaId'] as int,
      nombreCharola: json['nombreCharola'],
      fechaCreacion: DateTime.parse(json['fechaCreacion']),
    );
  }
}


/// Modelo que representa la respuesta paginada de la API para charolas.
class CharolaTarjeta {
  /// Total de elementos disponibles en la base de datos.
  final int total;

  /// Página actual.
  final int pag;

  /// Límite de elementos por página.
  final int limite;

  /// Total de páginas calculadas por la API.
  final int totalPags;

  /// Lista de charolas contenidas en esta página.
  final List<Charola> data;

  CharolaTarjeta({
    required this.total,
    required this.pag,
    required this.limite,
    required this.totalPags,
    required this.data,
  });

  /// Construye una instancia de CharolaTarjeta desde un JSON.
  factory CharolaTarjeta.fromJson(Map<String, dynamic> json) {
    return CharolaTarjeta(
      total: json['total'],
      pag: json['page'],
      limite: json['limit'],
      totalPags: json['totalPages'],
      data: (json['data'] as List)
          .map((item) => Charola.fromJson(item))
          .toList(),
    );
  }
}

