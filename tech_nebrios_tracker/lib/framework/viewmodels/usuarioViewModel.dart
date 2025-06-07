/// RF13 Registrar usuario https://codeandco-wiki.netlify.app/docs/next/proyectos/larvas/documentacion/requisitos/RF13
/// RF19 Editar usuario https://codeandco-wiki.netlify.app/docs/next/proyectos/larvas/documentacion/requisitos/RF19
/// RF14 Eliminar usuario https://codeandco-wiki.netlify.app/docs/next/proyectos/larvas/documentacion/requisitos/RF14
/// 
import 'package:flutter/material.dart';
import 'package:zuustento_tracker/data/models/usuarioModel.dart';
import 'package:zuustento_tracker/domain/usuarioUseCases.dart';
import 'package:jwt_decode/jwt_decode.dart';

class UsuarioViewModel extends ChangeNotifier{
  UsuarioUseCasesImp usuarioUseCases = UsuarioUseCasesImp();
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController apellidoPController = TextEditingController();
  final TextEditingController apellidoMController = TextEditingController();
  final TextEditingController usuarioController = TextEditingController();
  final TextEditingController contrasenaController = TextEditingController();

  bool _cargando = false;
  bool _cargandoRegistro = false;
  bool _error = false;
  String _mensaje = '';
  bool _esAdmin = false;
  int _idActual = 0;

  bool get cargando => _cargando;
  bool get cargandoRegistro => _cargandoRegistro;
  bool get error => _error;
  String get mensaje => _mensaje;
  bool get esAdmin => _esAdmin;
  int get idActual => _idActual;

  List _usuarios = [];
  List get usuarios => _usuarios;

  Future<void> obtenerUsuarios() async {
    _error = false;
    _mensaje = '';
    _cargando = true;
    notifyListeners();
    var respuesta = await usuarioUseCases.obtenerUsuarios();
    if (respuesta['codigo'] == 200){
      _usuarios = respuesta['mensaje'];
      _cargando = false;
    }else if (respuesta['codigo'] == 401){
      _error = true;
      _mensaje = respuesta['mensaje'];
      _cargando = false;
    }else if (respuesta['codigo'] == 500){
      _error = true;
      _mensaje = respuesta['mensaje'];
      _cargando = false;
    }

    notifyListeners();
  }

    /// Limpia todos los campos del formulario y selecciones.
  void resetForm() {
    nombreController.clear();
    apellidoPController.clear();
    apellidoMController.clear();
    usuarioController.clear();
    contrasenaController.clear();
    notifyListeners();
  }

  Future<void> registrarUsuario() async{
    _error = false;
    _mensaje = '';
    _cargandoRegistro = true;
    notifyListeners();
    var nuevoUsuario = Usuario(nombre: nombreController.text, apellido_m: apellidoMController.text, apellido_p: apellidoPController.text, user: usuarioController.text, contrasena: contrasenaController.text);
    var respuesta = await usuarioUseCases.registrarUsuario(nuevoUsuario);

    if (respuesta['codigo'] == 200){
      _mensaje = respuesta['mensaje'];
    }else if (respuesta['codigo'] == 401){
      _error = true;
      _mensaje = respuesta['mensaje'];
    }else if (respuesta['codigo'] == 500){
      _error = true;
      _mensaje = respuesta['mensaje'];
    }

    _cargandoRegistro = false;
    notifyListeners();
  }

  Future<void> esAdministrador() async {
    final token = await usuarioUseCases.obtenerTokenActual();
    Map<String, dynamic> sesion = Jwt.parseJwt(token!);
    _idActual = sesion['id'];
    if (sesion['rol'] == 'admin'){
      _esAdmin = true;
      notifyListeners();
    }
  }

  Future<void> editarUsuario(usuarioId) async{
    _error = false;
    _mensaje = '';
    _cargandoRegistro = true;
    notifyListeners();
  
    var nuevoUsuario = Usuario(nombre: nombreController.text, apellido_m: apellidoMController.text, apellido_p: apellidoPController.text, user: usuarioController.text, contrasena: contrasenaController.text);
    var respuesta = await usuarioUseCases.editarUsuario(usuarioId, nuevoUsuario);

    if (respuesta['codigo'] == 200){
      _mensaje = respuesta['mensaje'];
    }else if (respuesta['codigo'] == 401){
      _error = true;
      _mensaje = respuesta['mensaje'];
    }else if (respuesta['codigo'] == 500){
      _error = true;
      _mensaje = respuesta['mensaje'];
    }

    _cargandoRegistro = false;
    notifyListeners();
  }

  Future<void> eliminarUsuario(usuarioId) async {
    _error = false;
    _mensaje = '';
    _cargandoRegistro = true;
    notifyListeners();

    var respuesta = await usuarioUseCases.eliminarUsuario(usuarioId);

    if (respuesta['codigo'] == 200){
      _mensaje = respuesta['mensaje'];
    }else if (respuesta['codigo'] == 401){
      _error = true;
      _mensaje = respuesta['mensaje'];
    }else if (respuesta['codigo'] == 500){
      _error = true;
      _mensaje = respuesta['mensaje'];
    }

    _cargandoRegistro = false;
    notifyListeners();
  }
}