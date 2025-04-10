import 'package:http/http.dart' as http;

class ApiService {
  Future<String> getTest() async {
    final url = Uri.parse(
      'http://localhost:3000/api/test',
    ); // O usa localhost si emulas en web
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Fallo al conectar con backend');
    }
  }
}
