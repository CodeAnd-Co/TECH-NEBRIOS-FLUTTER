/// RF13 Registrar usuario https://codeandco-wiki.netlify.app/docs/next/proyectos/larvas/documentacion/requisitos/RF13
/// RF19 Editar usuario https://codeandco-wiki.netlify.app/docs/next/proyectos/larvas/documentacion/requisitos/RF19
/// RF14 Eliminar usuario https://codeandco-wiki.netlify.app/docs/next/proyectos/larvas/documentacion/requisitos/RF14
/// 
import 'package:zuustento_tracker/data/models/loginModel.dart';
import 'package:zuustento_tracker/data/models/usuarioModel.dart';

abstract class UserApiService{
  Future<LoginRespuesta?> iniciarSesion(String usuario, String contrasena);
  
  Future<Map<dynamic, dynamic>> obtenerUsuarios();

  Future<Map<dynamic, dynamic>> registrarUsuario(Usuario nuevoUsuario);

  Future<Map<dynamic, dynamic>> editarUsuario(int usuarioId, Usuario infoUsuario);

  Future<Map<dynamic, dynamic>> eliminarUsuario(int usuarioId);

  Future<Map<dynamic, dynamic>> recuperarUsuario(String nombre);
}