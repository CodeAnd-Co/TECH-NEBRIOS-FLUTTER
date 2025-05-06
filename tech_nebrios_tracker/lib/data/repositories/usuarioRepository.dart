import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tech_nebrios_tracker/data/services/localStorageService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tech_nebrios_tracker/data/models/loginModel.dart';
import 'package:tech_nebrios_tracker/data/services/usuarioApiService.dart';
import 'package:tech_nebrios_tracker/data/models/constantes.dart';

class UserRepository implements LocalStorageService {
  @override
  Future<String?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('currentUser');
  }

  @override
  Future<void> setCurrentUser(String usuario) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('currentUser', usuario);
  }

  @override
  Future<void> removeCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('currentUser');
  }

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
}