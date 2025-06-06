import 'package:zuustento_tracker/data/models/loginModel.dart';

abstract class UserApiService{
  Future<LoginRespuesta?> iniciarSesion(String usuario, String contrasena);
  
  Future<Map<dynamic, dynamic>> obtenerUsuarios();
}