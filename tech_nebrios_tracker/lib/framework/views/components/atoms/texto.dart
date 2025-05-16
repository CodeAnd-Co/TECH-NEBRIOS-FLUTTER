import 'package:flutter/material.dart';

class Texto extends StatelessWidget {
  final String texto;
  final double tamanio;
  final Color color;
  final String fuente;
  final FontWeight grosor;
  final bool centrado;

  // Constructor privado
  const Texto._({
    super.key,
    required this.texto,
    required this.tamanio,
    required this.color,
    required this.fuente,
    required this.grosor,
    required this.centrado,
  });

  // Métodos factory para diferentes estilos
  factory Texto.texto({
    Key? key,
    required String texto,
    double tamanio = 12,
    Color color = Colors.black,
    String fuente = 'San Francisco',
    bool bold = false,
    bool centrado = false,
  }) {
    return Texto._(
      key: key,
      texto: texto,
      tamanio: tamanio,
      color: color,
      fuente: fuente,
      grosor: bold ? FontWeight.w400 : FontWeight.w300,
      centrado: centrado,
    );
  }

  factory Texto.titulo1({
    Key? key,
    required String texto,
    double tamanio = 32,
    Color color = Colors.black,
    String fuente = 'San Francisco',
    bool bold = false,
    bool centrado = false,
  }) {
    return Texto._(
      key: key,
      texto: texto,
      tamanio: tamanio,
      color: color,
      fuente: fuente,
      grosor: bold ? FontWeight.w700 : FontWeight.w600,
      centrado: centrado,
    );
  }

  factory Texto.titulo2({
    Key? key,
    required String texto,
    double tamanio = 24,
    Color color = Colors.black,
    String fuente = 'San Francisco',
    bool bold = false,
    bool centrado = false,
  }) {
    return Texto._(
      key: key,
      texto: texto,
      tamanio: tamanio,
      color: color,
      fuente: fuente,
      grosor: bold ? FontWeight.w700 : FontWeight.normal,
      centrado: centrado,
    );
  }

  factory Texto.titulo3({
    Key? key,
    required String texto,
    double tamanio = 24,
    Color color = Colors.black,
    String fuente = 'San Francisco',
    bool bold = false,
    bool centrado = false,
  }) {
    return Texto._(
      key: key,
      texto: texto,
      tamanio: tamanio,
      color: color,
      fuente: fuente,
      grosor: bold ? FontWeight.w600 : FontWeight.w500,
      centrado: centrado,
    );
  }

  factory Texto.titulo4({
    Key? key,
    required String texto,
    double tamanio = 20,
    Color color = Colors.black,
    String fuente = 'San Francisco',
    bool bold = false,
    bool centrado = false,
  }) {
    return Texto._(
      key: key,
      texto: texto,
      tamanio: tamanio,
      color: color,
      fuente: fuente,
      grosor: bold ? FontWeight.w600 : FontWeight.w500,
      centrado: centrado,
    );
  }

  factory Texto.titulo5({
    Key? key,
    required String texto,
    double tamanio = 17,
    Color color = Colors.black,
    String fuente = 'San Francisco',
    bool bold = false,
    bool centrado = false,
  }) {
    return Texto._(
      key: key,
      texto: texto,
      tamanio: tamanio,
      color: color,
      fuente: fuente,
      grosor: bold ? FontWeight.w500 : FontWeight.w400,
      centrado: centrado,
    );
  }

  factory Texto.titulo6({
    Key? key,
    required String texto,
    double tamanio = 14,
    Color color = Colors.black,
    String fuente = 'San Francisco',
    bool bold = false,
    bool centrado = false,
  }) {
    return Texto._(
      key: key,
      texto: texto,
      tamanio: tamanio,
      color: color,
      fuente: fuente,
      grosor: bold ? FontWeight.w500 : FontWeight.w400,
      centrado: centrado,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      texto,
      textAlign: centrado ? TextAlign.center : TextAlign.start,
      style: TextStyle(
        fontSize: tamanio,
        color: color,
        fontFamily: fuente,
        fontWeight: grosor,
      ),
    );
  }
}
