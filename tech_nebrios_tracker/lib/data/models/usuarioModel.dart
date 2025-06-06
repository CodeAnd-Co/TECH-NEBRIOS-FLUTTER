class Usuario {
  final int usuarioId;
  final String nombre;
  final String apellido_p;
  final String apellido_m;
  final String user;
  final String? tipo_usuario;

  Usuario({
    required this.usuarioId,
    required this.nombre,
    required this.apellido_m,
    required this.apellido_p,
    required this.user,
    this.tipo_usuario
  });

  /// Método para construir una instancia de un Json
  factory Usuario.fromJson(Map<String, dynamic> json){
    return Usuario(
      usuarioId: json['usuarioId'],
      nombre: json['nombre'],
      apellido_p: json['apellido_p'],
      apellido_m: json['apellido_m'],
      user: json['user'],
      tipo_usuario: json['tipo_usuario']
    );
  }

  static List<Usuario> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Usuario.fromJson(json)).toList();
  }
}