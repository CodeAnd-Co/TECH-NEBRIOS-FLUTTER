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

class CharolaTarjeta {
  final int total;
  final int pag;
  final int limite;
  final int totalPags;
  final List<Charola> data;

  CharolaTarjeta({
    required this.total,
    required this.pag,
    required this.limite,
    required this.totalPags,
    required this.data,
  });

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
