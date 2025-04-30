import 'package:flutter/material.dart';

class Texto extends StatelessWidget {
  final String texto;
  final double tamanio;
  final Color color;
  final String fuente;
  final FontWeight grosor;

  // Constructor privado
  const Texto._({
    super.key,
    required this.texto,
    required this.tamanio,
    required this.color,
    required this.fuente,
    required this.grosor,
  });

  /// Constructores factory para diferentes estilos
  ///
  /// Los estilos se basaron en MarkDown:
  /// Texto, Título 1 ... Título 6
  /// 
  /// Forma de uso:
  /// Texto.titulo1(texto: 'Título 1', tamanio: 64)         Para cambiar el tamaño
  /// Texto.titulo2(texto: 'Título 2', color: Colors.red)   Para cambiar al color
  /// Texto.titulo3(texto: 'Título 3', bold: true)          Para resaltar el texto
  /// Texto.titulo4(texto: 'Título 4', fuente: 'Roboto')    Para cambiar la tipografía
  /// Texto.titulo5(texto: 'Título 5')                      Caso normal

  factory Texto.texto({
    Key? key,
    required String texto,
    double tamanio = 12,
    Color color = Colors.black,
    String fuente = 'San Francisco',
    bool bold = false,
  }) {
    return Texto._(
      key: key,
      texto: texto,
      tamanio: tamanio,
      color: color,
      fuente: fuente,
      grosor: bold ? FontWeight.w400 : FontWeight.w300,
    );
  }

  factory Texto.titulo1({
    Key? key,
    required String texto,
    double tamanio = 32,
    Color color = Colors.black,
    String fuente = 'San Francisco',
    bool bold = false,
  }) {
    return Texto._(
      key: key,
      texto: texto,
      tamanio: tamanio,
      color: color,
      fuente: fuente,
      grosor: bold ? FontWeight.w700 : FontWeight.w600,
    );
  }

  factory Texto.titulo2({
    Key? key,
    required String texto,
    double tamanio = 28,
    Color color = Colors.black,
    String fuente = 'San Francisco',
    bool bold = false,
  }) {
    return Texto._(
      key: key,
      texto: texto,
      tamanio: tamanio,
      color: color,
      fuente: fuente,
      grosor: bold ? FontWeight.w700 : FontWeight.w600,
    );
  }

  factory Texto.titulo3({
    Key? key,
    required String texto,
    double tamanio = 24,
    Color color = Colors.black,
    String fuente = 'San Francisco',
    bool bold = false,
  }) {
    return Texto._(
      key: key,
      texto: texto,
      tamanio: tamanio,
      color: color,
      fuente: fuente,
      grosor: bold ? FontWeight.w600 : FontWeight.w500,
    );
  }

  factory Texto.titulo4({
    Key? key,
    required String texto,
    double tamanio = 20,
    Color color = Colors.black,
    String fuente = 'San Francisco',
    bool bold = false,
  }) {
    return Texto._(
      key: key,
      texto: texto,
      tamanio: tamanio,
      color: color,
      fuente: fuente,
      grosor: bold ? FontWeight.w600 : FontWeight.w500,
    );
  }

  factory Texto.titulo5({
    Key? key,
    required String texto,
    double tamanio = 17,
    Color color = Colors.black,
    String fuente = 'San Francisco',
    bool bold = false,
  }) {
    return Texto._(
      key: key,
      texto: texto,
      tamanio: tamanio,
      color: color,
      fuente: fuente,
      grosor: bold ? FontWeight.w500 : FontWeight.w400,
    );
  }

  factory Texto.titulo6({
    Key? key,
    required String texto,
    double tamanio = 14,
    Color color = Colors.black,
    String fuente = 'San Francisco',
    bool bold = false,
  }) {
    return Texto._(
      key: key,
      texto: texto,
      tamanio: tamanio,
      color: color,
      fuente: fuente,
      grosor: bold ? FontWeight.w500 : FontWeight.w400,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      texto,
      style: TextStyle(
        fontSize: tamanio,
        color: color,
        fontFamily: fuente,
        fontWeight: grosor,
      ),
    );
  }
}