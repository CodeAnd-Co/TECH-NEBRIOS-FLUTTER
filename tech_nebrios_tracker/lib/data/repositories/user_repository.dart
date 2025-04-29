import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tech_nebrios_tracker/data/services/local_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tech_nebrios_tracker/data/models/loginModel.dart';
import 'package:tech_nebrios_tracker/data/services/user_api_service.dart';

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

  @override
  Future<LoginRespuesta?> postUsuario(String usuario, String contrasena) async {
    final url = Uri.parse('http://localhost:3000/iniciarSesion');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'usuario': usuario, 'contrasena': contrasena}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return LoginRespuesta.fromJson(data);
    } else if (response.statusCode == 401) {
      throw Exception('Usuario o contraseña incorrectos');
    } else {
      throw Exception('Error del servidor');
    }
  }
}