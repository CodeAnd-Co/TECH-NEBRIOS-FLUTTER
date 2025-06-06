import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:zuustento_tracker/data/services/localStorageService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zuustento_tracker/data/services/usuarioApiService.dart';
import 'package:zuustento_tracker/data/models/loginModel.dart';
import 'package:zuustento_tracker/data/models/constantes.dart';

///Clase que implementa el repositorio de usuario y conecta con el servicio de APIs
/// y el servicio de almacenamiento local
class UserRepository implements LocalStorageService, UserApiService{
  ///Obtiene el token del usuario actual del almacenamiento local
  @override
  Future<String?> obtenerTokenActual() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('currentUser');
  }

  ///Guarda el token del usuario actual en el almacenamiento local
  @override
  Future<void> guardarToken(String usuario) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('currentUser', usuario);
  }

  ///Elimina el token del usuario actual del almacenamiento local, cerrando la sesión
  @override
  Future<void> eliminarToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('currentUser');
  }

  ///Intenta iniciar sesión con el usuario y contraseña proporcionados
  ///
  ///Si el inicio de sesión es exitoso, guarda el token en el almacenamiento local
  ///Envía un error si el inicio de sesión falla
  @override
  Future<LoginRespuesta?> iniciarSesion(String usuario, String contrasena) async {
    final url = Uri.parse('${APIRutas.USUARIO}/iniciarSesion');

    final respuesta = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'usuario': usuario, 'contrasena': contrasena}),
    );

    if (respuesta.statusCode == 200) {
      final data = jsonDecode(respuesta.body);
      return LoginRespuesta.fromJson(data);
    } else if (respuesta.statusCode == 401) {
      return null;
    } else {
      throw Exception('Error del servidor');
    }
  }

  @override
  Future<Map<dynamic, dynamic>> obtenerUsuarios() async {
    final url = Uri.parse('${APIRutas.USUARIO}/obtenerUsuarios');
    final token = await obtenerTokenActual();
    if (token == null) {
      throw Exception('Debe iniciar sesión para continuar');
    }

    try{
      final respuesta = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (respuesta.statusCode == 200) {
        var decodificacion = jsonDecode(respuesta.body);
        var usuarios = decodificacion['resultado'];

        return {'codigo': 200, 'mensaje': usuarios};
      }

      if (respuesta.statusCode == 401){
        return {'codigo': 200, 'mensaje': '❌ Por favor, vuelva a iniciar sesión. ❌'};
      }

      return {'codigo': 500, 'mensaje': '❌ Ocurrió un error en el servidor, favor de intentar mas tarde. ❌'};
    } catch (error) {
      return {'codigo': 500, 'mensaje': '❌ Ocurrió un error en el servidor, favor de intentar mas tarde. ❌'};
    }
  }

  @override
  Future<Map<dynamic, dynamic>> registrarUsuario(nuevoUsuario) async{
    final url = Uri.parse('${APIRutas.USUARIO}/registrarUsuario');
    final token = await obtenerTokenActual();
    if (token == null) {
      throw Exception('Debe iniciar sesión para continuar');
    }
    try{
      final respuesta = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(nuevoUsuario.toJson())
      );
      if (respuesta.statusCode == 200){
        return {'codigo': 200, 'mensaje': 'Usuario creado exitosamente.'};
      }

      if(respuesta.statusCode == 401){
        return {'codigo': 401, 'mensaje': '❌ Por favor, vuelva a iniciar sesión. ❌'};
      }

      return {'codigo': 500, 'mensaje': '❌ Ocurrió un error en el servidor, favor de intentar mas tarde. ❌'};
    } catch (error){
      return {'codigo': 500, 'mensaje': '❌ Ocurrió un error en el servidor, favor de intentar mas tarde. ❌'};
    }
  }
}