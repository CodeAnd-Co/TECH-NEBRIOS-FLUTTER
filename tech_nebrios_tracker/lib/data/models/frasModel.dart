// RF29: Visualizar la información del Frass obtenido - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF29

//  Modelo que representa un fras en la aplicación.
// 
//  Corresponde al JSON devuelto por la API:
// [
//     {
//         "CHAROLA": {
//             "nombreCharola": "Charola_A"
//         },
//         "FRAS": {
//             "fechaRegistro": "2025-06-04T00:00:00.000Z",
//             "gramosGenerados": 12
//         }
//     },
//     {
//         "CHAROLA": {
//             "nombreCharola": "Charola_B"
//         },
//         "FRAS": {
//             "fechaRegistro": "2025-06-05T00:00:00.000Z",
//             "gramosGenerados": 1
//         }
//     },
// ]


class Fras {
  final String nombreCharola;
  final DateTime fechaRegistro;
  final double gramosGenerados;

  Fras({
    required this.nombreCharola,
    required this.fechaRegistro,
    required this.gramosGenerados,
  });

  factory Fras.fromJson(Map<String, dynamic> json) {
    return Fras(
      nombreCharola: json['CHAROLA']['nombreCharola'],
      fechaRegistro: DateTime.parse(json['FRAS']['fechaRegistro']),
      gramosGenerados: json['FRAS']['gramosGenerados'].toDouble(),
    );
  }
}