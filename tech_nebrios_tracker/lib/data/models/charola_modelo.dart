class Charola {
  final String nombreCharola;
  final DateTime fechaCreacion;

  Charola({
    required this.nombreCharola,
    required this.fechaCreacion,
  });

  factory Charola.fromJson(Map<String, dynamic> json) {
    return Charola(
      nombreCharola: json['nombreCharola'],
      fechaCreacion: DateTime.parse(json['fechaCreacion']),
    );
  }
}

class CharolaResponse {
  final int total;
  final int page;
  final int limit;
  final int totalPages;
  final List<Charola> data;

  CharolaResponse({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
    required this.data,
  });

  factory CharolaResponse.fromJson(Map<String, dynamic> json) {
    return CharolaResponse(
      total: json['total'],
      page: json['page'],
      limit: json['limit'],
      totalPages: json['totalPages'],
      data: (json['data'] as List)
          .map((item) => Charola.fromJson(item))
          .toList(),
    );
  }
}
