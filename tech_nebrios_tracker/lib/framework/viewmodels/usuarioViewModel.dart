import 'package:flutter/material.dart';
import 'package:zuustento_tracker/domain/usuarioUseCases.dart';

class Usuarioviewmodel extends ChangeNotifier{
  UsuarioUseCasesImp usuarioUseCases = UsuarioUseCasesImp();

  bool _cargando = false;
  bool _error = false;
  String _mensaje = '';
  bool get cargando => _cargando;
  bool get error => _error;
  String get mensaje => _mensaje;

  List _usuarios = [];
  List get usuarios => _usuarios;

  Future<void> obtenerUsuarios() async {
    try{
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
      
    } catch (error){
      rethrow;
    }
  }

}