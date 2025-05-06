import 'package:tech_nebrios_tracker/data/repositories/usuarioRepository.dart';
import 'package:tech_nebrios_tracker/data/models/loginModel.dart';

///Clase que maneja los casos de uso relacionados con el usuario
class UserUseCases {
  final UserRepository _repository;
  
  UserUseCases({UserRepository? repository}) 
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
}