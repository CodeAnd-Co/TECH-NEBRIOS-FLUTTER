import 'package:zuustento_tracker/data/models/loginModel.dart';
import 'package:zuustento_tracker/data/models/usuarioModel.dart';

abstract class UserApiService{
  Future<LoginRespuesta?> iniciarSesion(String usuario, String contrasena);
  
  Future<Map<dynamic, dynamic>> obtenerUsuarios();

  Future<Map<dynamic, dynamic>> registrarUsuario(Usuario nuevoUsuario);
}