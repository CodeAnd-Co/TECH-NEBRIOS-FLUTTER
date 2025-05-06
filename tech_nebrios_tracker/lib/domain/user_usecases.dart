import 'package:tech_nebrios_tracker/data/repositories/user_repository.dart';
import 'package:tech_nebrios_tracker/data/models/loginModel.dart';


class UserUseCases {
  final UserRepository _repository;
  
  UserUseCases({UserRepository? repository}) 
      : _repository = repository ?? UserRepository();
  
  ///Obtiene el usuario actual del almacenamiento local
  Future<String?> getCurrentUser() async {
    return await _repository.getCurrentUser();
  }
  
  ///Guarda el usuario actual en el almacenamiento local
  Future<void> setCurrentUser(String usuario) async {
    await _repository.setCurrentUser(usuario);
  }
  
  ///Elimina el usuario actual del almacenamiento local
  Future<void> removeCurrentUser() async {
    await _repository.removeCurrentUser();
  }

  ///Intenta iniciar sesión con el usuario y contraseña proporcionados
  Future<LoginRespuesta?> iniciarSesion(String usuario, String contrasena) async {
    return await _repository.iniciarSesion(usuario, contrasena);
  }
}