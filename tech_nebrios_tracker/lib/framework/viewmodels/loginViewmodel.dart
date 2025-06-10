import 'package:flutter/material.dart';
import 'package:zuustento_tracker/domain/usuarioUseCases.dart';
import 'package:jwt_decode/jwt_decode.dart';

class LoginViewModel extends ChangeNotifier {
  final usuarioController = TextEditingController();
  final contrasenaController = TextEditingController();
  final UsuarioUseCasesImp _userUseCases = UsuarioUseCasesImp();
  final TextEditingController nombreController = TextEditingController();
  
  String _errorMessage = '';
  bool _hasError = false;
  bool _cargando = false;
  bool _cargandoRegistro = false;
  
  String get errorMessage => _errorMessage;
  bool get hasError => _hasError;
  bool get cargando => _cargando;
  bool get cargandoRegistro => _cargandoRegistro;
  
  LoginViewModel() {
    //_checkCurrentUser();
  }

  ///Envía los datos de los campos de texto de la vista y trata de iniciar sesión con los mismos.
  ///
  ///Si el inicio de sesión es correcto, se guarda en el almacenamiento local y se establece como el usuario actual
  Future<void> iniciarSesion() async {
    final usuario = usuarioController.text.trim();
    final contrasena = contrasenaController.text.trim();
    _cargando = true;

    if (usuario.isEmpty) {
      _errorMessage = 'Llena el campo de usuario';
      _hasError = true;
      _cargando = false;
      notifyListeners();
          
      return;
    }

    if (contrasena.isEmpty) {
      _errorMessage = 'Llena el campo de contraseña';
      _hasError = true;
      _cargando = false;
      notifyListeners();
      
      return;
    }

    try {
      notifyListeners();
      final sesion = await _userUseCases.iniciarSesion(usuario, contrasena);

      if(sesion == null) {
        _errorMessage = 'Usuario o contraseña incorrectos';
        _hasError = true;
        _cargando = false;
        notifyListeners();
        return;
      } 
      else {
        guardarToken(sesion.token);
        _cargando = false;
        _hasError = false;
        notifyListeners();
        return;
      }
    }catch (e){
      _errorMessage = 'Error al iniciar sesión. Inténtalo de nuevo más tarde.';
      _cargando = false;
      _hasError = true;
      notifyListeners();
    }
  }

  Future<void> recuperarContrasena() async {
    _hasError = false;
    _errorMessage = '';
    _cargandoRegistro = true;
    notifyListeners();

    var respuesta = await _userUseCases.recuperarUsuario(nombreController.text);

    if (respuesta['codigo'] == 200){
      _errorMessage = respuesta['mensaje'];
      _cargandoRegistro = false;
    } else if (respuesta['codigo'] == 201){
      _hasError = true;
      _errorMessage = respuesta['mensaje'];
      _cargandoRegistro = false;
    }else {
      _hasError = true;
      _errorMessage = respuesta['mensaje'];
      _cargandoRegistro = false;
    }

    notifyListeners();
  }

  void limpiarCampos() {
    usuarioController.clear();
    contrasenaController.clear();
    notifyListeners();
  }
  
  ///Verifica si hay un usuario actual en el almacenamiento local y lo establece en el controlador de texto
  void _obtenerTokenActual() async {
    final usuario = await _userUseCases.obtenerTokenActual();
    if (usuario != null && usuario.isNotEmpty) {
      usuarioController.text = usuario;
    }
  }
  
  ///Establece el usuario actual en el almacenamiento local
  void guardarToken(String usuario) {
    _userUseCases.guardarToken(usuario);
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