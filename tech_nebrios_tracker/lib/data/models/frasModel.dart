//  Modelo que representa un fras en la aplicación.
// 
//  Corresponde al JSON devuelto por la API:
//  {
//    "frasId": "1"
//    "gramosGenerados" :	"500"
//    "charolaId"	: "2"
// }


class Fras {
  /// Identificador único del fras.
  final int idFras;

  /// Gramos generados por el fras.
  final int gramosGenerados;

  /// Identificador de la charola asociada al fras.
  final int idCharola;

  Fras({
    required this.idFras,
    required this.gramosGenerados,
    required this.idCharola,
  });

  /// Crea una instancia de [Fras] a partir de un [json] Map.
  factory Fras.fromJson(Map<String, dynamic> json) {
    return Fras(
      idFras: json['frasId'] as int,
      gramosGenerados: json['gramosGenerados'] as int,
      idCharola: json['charolaId'] as int,
    );
  }
}