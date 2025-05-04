class Ancestro {
  final int charolaAncestro;
  final String nombreCharola;

  Ancestro({
    required this.charolaAncestro,
    required this.nombreCharola,
  });

  factory Ancestro.fromJson(Map<String, dynamic> json) {
    return Ancestro(
      charolaAncestro: json['charolaAncestro'] as int,
      nombreCharola: json['nombreCharola'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'charolaAncestro': charolaAncestro,
      'nombreCharola': nombreCharola,
    };
  }
}
