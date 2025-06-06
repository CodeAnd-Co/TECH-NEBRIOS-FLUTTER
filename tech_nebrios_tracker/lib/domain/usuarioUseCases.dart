import 'package:zuustento_tracker/data/repositories/usuarioRepository.dart';
import 'package:zuustento_tracker/data/models/loginModel.dart';
import 'package:zuustento_tracker/data/models/usuarioModel.dart';

abstract class UsuarioUseCases {
  Future<String?> obtenerTokenActual();

  Future<void> guardarToken(String usuario);

  Future<void> eliminarToken();

  Future<LoginRespuesta?> iniciarSesion(String usuario, String contrasena);

  Future<Map<dynamic, dynamic>> obtenerUsuarios();

  Future<Map<dynamic, dynamic>> registrarUsuario(Usuario nuevoUsuario);
}
///Clase que maneja los casos de uso relacionados con el usuario
class UsuarioUseCasesImp extends UsuarioUseCases {
  final UserRepository _repository;
  
  UsuarioUseCasesImp({UserRepository? repository}) 
      : _repository = repository ?? UserRepository();
  
  ///Obtiene el usuario actual del almacenamiento local
  Future<String?> obtenerTokenActual() async {
    return await _repository.obtenerTokenActual();
  }
  
  ///Guarda el usuario actual en el almacenamiento local
  Future<void> guardarToken(String usuario) async {
    await _repository.guardarToken(usuario);
  }
  
  ///Elimina el usuario actual del almacenamiento local
  Future<void> eliminarToken() async {
    await _repository.eliminarToken();
  }

  ///Intenta iniciar sesión con el usuario y contraseña proporcionados
  Future<LoginRespuesta?> iniciarSesion(String usuario, String contrasena) async {
    return await _repository.iniciarSesion(usuario, contrasena);
  }

  ///Obtener todos los usuarios de la plataforma
  Future<Map<dynamic, dynamic>> obtenerUsuarios() async {
    return await _repository.obtenerUsuarios();
  }
  
  Future<Map<dynamic, dynamic>> registrarUsuario(Usuario nuevoUsuario) async {
    return await _repository.registrarUsuario(nuevoUsuario);
  }
}