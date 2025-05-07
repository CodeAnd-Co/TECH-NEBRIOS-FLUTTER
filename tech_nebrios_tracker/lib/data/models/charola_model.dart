class Charola {
  final int charolaId;
  final String nombreCharola;
  final int comidaCiclo;
  final int hidratacionCiclo;
  final String fechaActualizacion;
  final String estado;
  final int densidadLarva;
  final String fechaCreacion;
  final int pesoCharola;
  final String comidaNombre;
  final String hidratacionNombre;

  Charola({
    required this.charolaId,
    required this.nombreCharola,
    required this.comidaCiclo,
    required this.hidratacionCiclo,
    required this.fechaActualizacion,
    required this.estado,
    required this.densidadLarva,
    required this.fechaCreacion,
    required this.pesoCharola,
    required this.comidaNombre,
    required this.hidratacionNombre,
  });

  factory Charola.fromJson(Map<String, dynamic> json) {

    final charolaData = json['charola'];
    final comidaData = json['comida'];
    final hidratacionData = json['hidratacion'];

    return Charola(
      charolaId: charolaData['charolaId'] as int,
      nombreCharola: charolaData['nombreCharola'] as String,
      comidaCiclo: (charolaData['comidaCiclo'] as int?) ?? 0,
      hidratacionCiclo: (charolaData['hidratacionCiclo'] as int?) ?? 0,
      fechaActualizacion: (charolaData['fechaActualizacion'] as String?) ?? 'desconocido',
      estado: (charolaData['estado'] as String?) ?? 'desconocido',
      densidadLarva: (charolaData['densidadLarva'] as int?) ?? 0,
      fechaCreacion: (charolaData['fechaCreacion'] as String?) ?? 'desconocido',
      pesoCharola: (charolaData['pesoCharola'] as int?) ?? 0,
      comidaNombre: (comidaData['nombre'] as String?) ?? 'desconocido',
      hidratacionNombre: (hidratacionData['nombre'] as String?) ?? 'desconocido',
    );
  }
}
