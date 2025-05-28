import './charolaModel.dart';

class TamizadoMultiple {
  List<CharolaRegistro> charolas;
  List<CharolaTarjeta> charolasParaTamizar;

  TamizadoMultiple({
    required this.charolas,
    required this.charolasParaTamizar
  });

  Map<String, dynamic> toJson() {
    return {
      'charolas': charolas,
      'charolasParaTamizar': charolasParaTamizar
    };
  }
}
