// respuesta get
// [
//     {
//         "CHAROLA": {
//             "charolaId": 156,
//             "nombreCharola": "C-894"
//         },
//         "FRAS": {
//             "frasId": 153,
//             "fechaRegistro": "2025-06-06T00:00:00.000Z",
//             "gramosGenerados": 4
//         }
//     }
// ]

// respuesta editar
// {
//     "success": true,
//     "message": "Gramos actualizados exitosamente",
//     "data": [
//         {
//             "frasId": 153,
//             "gramosGenerados": 77,
//             "fechaRegistro": "2025-06-06T00:00:00.000Z",
//             "CHAROLA_FRAS": [
//                 {
//                     "charolaId": 156,
//                     "CHAROLA": {
//                         "nombreCharola": "C-894"
//                     }
//                 }
//             ]
//         }
//     ]
// }

class Fras {
  final int frasId;
  final double gramosGenerados;
  final DateTime fechaRegistro;
  final int charolaId;
  final String nombreCharola;

  Fras({
    required this.frasId,
    required this.gramosGenerados,
    required this.fechaRegistro,
    required this.charolaId,
    required this.nombreCharola,
  });

  factory Fras.fromJson(Map<String, dynamic> json) {
    return Fras(
      frasId: json['FRAS']['frasId'],
      gramosGenerados: json['FRAS']['gramosGenerados'].toDouble(),
      fechaRegistro: DateTime.parse(json['FRAS']['fechaRegistro']),
      charolaId: json['CHAROLA']['charolaId'],
      nombreCharola: json['CHAROLA']['nombreCharola'],
    );
  }

  factory Fras.fromEditedJson(Map<String, dynamic> json) {
  final cfList = json['CHAROLA_FRAS'];
  final List cf = (cfList is List) ? cfList : [];
  final charolaFras = cf.isNotEmpty ? cf[0] : null;
  return Fras(
    frasId: json['frasId'] is int
        ? json['frasId']
        : int.tryParse(json['frasId']?.toString() ?? '0') ?? 0,
    gramosGenerados: (json['gramosGenerados'] as num).toDouble(),
    fechaRegistro: DateTime.parse(json['fechaRegistro']),
    charolaId: (charolaFras != null && charolaFras['charolaId'] != null)
        ? (charolaFras['charolaId'] is int
            ? charolaFras['charolaId']
            : int.tryParse(charolaFras['charolaId'].toString()) ?? 0)
        : 0, // Si no hay, pon 0
    nombreCharola: (charolaFras != null &&
            charolaFras['CHAROLA'] != null &&
            charolaFras['CHAROLA']['nombreCharola'] != null)
        ? charolaFras['CHAROLA']['nombreCharola']
        : '',
  );
}

}