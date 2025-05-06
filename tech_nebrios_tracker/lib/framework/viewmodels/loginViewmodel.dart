import 'package:flutter/material.dart';
import 'package:tech_nebrios_tracker/domain/usuarioUseCases.dart';
import 'package:tech_nebrios_tracker/data/models/loginModel.dart';
import 'package:jwt_decode/jwt_decode.dart';

class LoginViewModel extends ChangeNotifier {
  final usuarioController = TextEditingController();
  final contrasenaController = TextEditingController();
  final UserUseCases _userUseCases = UserUseCases();
  
  String _errorMessage = '';
  bool _hasError = false;
  
  String get errorMessage => _errorMessage;
  bool get hasError => _hasError;
  
  LoginViewModel() {
    //_checkCurrentUser();
  }

  ///Envía los datos de los campos de texto de la vista y trata de iniciar sesión con los mismos.
  ///
  ///Si el inicio de sesión es correcto, se guarda en el almacenamiento local y se establece como el usuario actual
  Future<void> iniciarSesion() async {
    final usuario = usuarioController.text.trim();
    final contrasena = contrasenaController.text.trim();

    if (usuario.isEmpty) {
      _errorMessage = 'Llena el campo de usuario';
      _hasError = true;
      notifyListeners();
          
      return;
    }

    if (contrasena.isEmpty) {
      _errorMessage = 'Llena el campo de contraseña';
      _hasError = true;
      notifyListeners();
      
      return;
    }

    try {
      final sesion = await _userUseCases.iniciarSesion(usuario, contrasena);

      if(sesion == null) {
        _errorMessage = 'Usuario o contraseña incorrectos';
        _hasError = true;
        notifyListeners();
        return;
      } 
      else {
        setCurrentUser(sesion.token);

        _hasError = false;
        notifyListeners();
        return;
      }
    }catch (e){
      _errorMessage = 'Error al iniciar sesión. Inténtalo de nuevo más tarde.';
      _hasError = true;
      notifyListeners();
    }
  }
  
  ///Verifica si hay un usuario actual en el almacenamiento local y lo establece en el controlador de texto
  void _checkCurrentUser() async {
    final usuario = await _userUseCases.getCurrentUser();
    if (usuario != null && usuario.isNotEmpty) {
      usuarioController.text = usuario;
    }
  }
  
  ///Establece el usuario actual en el almacenamiento local
  void setCurrentUser(String usuario) {
    _userUseCases.setCurrentUser(usuario);
    notifyListeners();
  }

  ///Decodifica un token JWT y obtiene el nombre de usuario
  String decodeToken(String token) {
  Map<String, dynamic> payload = Jwt.parseJwt(token);
  return payload['nombreDeUsuario'];
 
  }
  
  @override
  void dispose() {
    usuarioController.dispose();
    contrasenaController.dispose();
    super.dispose();
  }
}