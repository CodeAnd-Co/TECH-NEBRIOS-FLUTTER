import 'package:flutter/material.dart';
import 'package:zuustento_tracker/domain/usuarioUseCases.dart';

class Usuarioviewmodel extends ChangeNotifier{
  UsuarioUseCasesImp usuarioUseCases = UsuarioUseCasesImp();

  bool _cargando = false;
  bool get cargando => _cargando;

  List _usuarios = [];
  List get usuarios => _usuarios;

  Future<void> obtenerUsuarios() async {
    try{
      _cargando = true;
      notifyListeners();
      var respuesta = await usuarioUseCases.obtenerUsuarios();
      _usuarios = respuesta['mensaje'];
      _cargando = false;
      notifyListeners();
      
    } catch (error){
      rethrow;
    }
  }

}