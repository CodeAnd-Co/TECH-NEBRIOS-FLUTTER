import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  Future<String> getTest() async {
    final url = Uri.parse(
      'http://localhost:3000/test/get',
    ); // O usa localhost si emulas en web
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Fallo al conectar con backend');
    }
  }

  Future<String> postTest(String nombreComida, String descripcionComida) async {
    final url = Uri.parse('http://localhost:3000/test/post');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nombre': nombreComida,
        'descripcion': descripcionComida,
      }),
    );
    print('Status: ${response.statusCode}');
    print('Body: ${response.body}');

    if (response.statusCode == 201) {
      return response.body;
    } else {
      throw Exception('Fallo al enviar datos al backend');
    }
  }
}
