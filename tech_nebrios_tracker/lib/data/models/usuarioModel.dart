/// RF13 Registrar usuario https://codeandco-wiki.netlify.app/docs/next/proyectos/larvas/documentacion/requisitos/RF13
/// RF19 Editar usuario https://codeandco-wiki.netlify.app/docs/next/proyectos/larvas/documentacion/requisitos/RF19
/// RF14 Eliminar usuario https://codeandco-wiki.netlify.app/docs/next/proyectos/larvas/documentacion/requisitos/RF14
/// 
class Usuario {
  final int? usuarioId;
  final String nombre;
  final String apellido_p;
  final String apellido_m;
  final String user;
  final String? tipo_usuario;
  final String? contrasena;

  Usuario({
    this.usuarioId,
    required this.nombre,
    required this.apellido_m,
    required this.apellido_p,
    required this.user,
    this.tipo_usuario,
    this.contrasena
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

  Map<String, dynamic> toJson()=>{
    'usuario': user,
    'contrasena': contrasena,
    'nombre': nombre,
    'apellido_m': apellido_m,
    'apellido_p': apellido_p
  };
}