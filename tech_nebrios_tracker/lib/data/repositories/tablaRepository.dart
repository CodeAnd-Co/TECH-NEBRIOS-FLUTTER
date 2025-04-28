import '../models/tablaModel.dart';
import '../services/backendApiService.dart';
import 'package:tech_nebrios_tracker/data/models/constantes.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class TablaRepository {

    Future<List?> getTabla() async{
        // Construir la URL
        final url = Uri.parse('${APIRutas.TABLA}/getTablaCharolas');

        try{
            print("Entro al repository");
            // Esperar la respuesta de la llamada al backend
            final respuesta = await http.get(url);

            // Si la respuesta de la llamada salió bien
            if (respuesta.statusCode == 200){
                // Decodificar la respuesta
                //print(jsonDecode(respuesta.body));
                return jsonDecode(respuesta.body);
            }else {
              print('Error fetching pokemon list: ${respuesta.statusCode}');
              return null;
          }
        } catch (error){
            print('Error fetching pokemon list: ${error}');
            return null;
        }
    }

}