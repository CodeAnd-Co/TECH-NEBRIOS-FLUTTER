// RF10 https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF10

class Charola {
  // atributos de charola
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

  // constructor por defecto de charola
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
  final comidaData = json['comida'] ?? {};            // se instancia vacio si es que es nulo
  final hidratacionData = json['hidratacion'] ?? {};  // se instancia vacio si es que es nulo

  // función para transformar un valor a int y si es nulo lo retorna como 0
  int parseToInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }

  return Charola(
    charolaId: charolaData['charolaId'] as int,
    nombreCharola: charolaData['nombreCharola'] as String,
    comidaCiclo: parseToInt(charolaData['comidaCiclo']),
    hidratacionCiclo: parseToInt(charolaData['hidratacionCiclo']),
    fechaActualizacion: (charolaData['fechaActualizacion'] as String?) ?? 'desconocido',
    estado: (charolaData['estado'] as String?) ?? 'desconocido',
    densidadLarva: parseToInt(charolaData['densidadLarva']),
    fechaCreacion: (charolaData['fechaCreacion'] as String?) ?? 'desconocido',
    pesoCharola: parseToInt(charolaData['pesoCharola']),
    comidaNombre: (comidaData['nombre'] as String?) ?? 'desconocido',
    hidratacionNombre: (hidratacionData['nombre'] as String?) ?? 'desconocido',
    );
  }
}
