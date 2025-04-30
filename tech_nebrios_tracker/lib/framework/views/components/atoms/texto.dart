import 'package:flutter/material.dart';

class Texto extends StatelessWidget {
  final String texto;
  final Color color;
  final double tamanio;
  final FontWeight grosor;  // FontWeight.w100 - FontWeight.w900
  final String fuente;      // Roboto, San Francisco

  // constructor por defecto
  const Texto({
    super.key,
    required this.texto,
    required this.tamanio,
    required this.color,
    required this.fuente,
    required this.grosor,
  });

  /*
  Markdown:
    Texto
    # Título 1
    ## Título 2
    ### Título 3
    #### Título 4
    ##### Título 5
    ###### Título 6
  */
  
  const Texto.texto({
    super.key,
    required this.texto,
    this.tamanio = 12,
    this.color = Colors.black,
    this.fuente = 'San Francisco',
    this.grosor = FontWeight.w300,
  });

  const Texto.textoB({ // bold
    super.key,
    required this.texto,
    this.tamanio = 12,
    this.color = Colors.black,
    this.fuente = 'San Francisco',
    this.grosor = FontWeight.w400,
  });

  const Texto.titulo1({
    super.key,
    required this.texto,
    this.tamanio = 32,
    this.color = Colors.black,
    this.fuente = 'San Francisco',
    this.grosor = FontWeight.w600,
  });

  const Texto.titulo1B({ // bold
    super.key,
    required this.texto,
    this.tamanio = 32,
    this.color = Colors.black,
    this.fuente = 'San Francisco',
    this.grosor = FontWeight.w700,
  });

  const Texto.titulo2({
    super.key,
    required this.texto,
    this.tamanio = 28,
    this.color = Colors.black,
    this.fuente = 'San Francisco',
    this.grosor = FontWeight.w600,
  });

  const Texto.titulo2B({ // bold
    super.key,
    required this.texto,
    this.tamanio = 28,
    this.color = Colors.black,
    this.fuente = 'San Francisco',
    this.grosor = FontWeight.w700,
  });

  const Texto.titulo3({
    super.key,
    required this.texto,
    this.tamanio = 24,
    this.color = Colors.black,
    this.fuente = 'San Francisco',
    this.grosor = FontWeight.w500,
  });

  const Texto.titulo3B({ // bold
    super.key,
    required this.texto,
    this.tamanio = 24,
    this.color = Colors.black,
    this.fuente = 'San Francisco',
    this.grosor = FontWeight.w600,
  });

  const Texto.titulo4({
    super.key,
    required this.texto,
    this.tamanio = 20,
    this.color = Colors.black,
    this.fuente = 'San Francisco',
    this.grosor = FontWeight.w500,
  });

  const Texto.titulo4B({ // bold
    super.key,
    required this.texto,
    this.tamanio = 20,
    this.color = Colors.black,
    this.fuente = 'San Francisco',
    this.grosor = FontWeight.w600,
  });

  const Texto.titulo5({
    super.key,
    required this.texto,
    this.tamanio = 17,
    this.color = Colors.black,
    this.fuente = 'San Francisco',
    this.grosor = FontWeight.w400,
  });

  const Texto.titulo5B({ // bold
    super.key,
    required this.texto,
    this.tamanio = 17,
    this.color = Colors.black,
    this.fuente = 'San Francisco',
    this.grosor = FontWeight.w500,
  });

  const Texto.titulo6({
    super.key,
    required this.texto,
    this.tamanio = 14,
    this.color = Colors.black,
    this.fuente = 'San Francisco',
    this.grosor = FontWeight.w400,
  });

  const Texto.titulo6B({ // bold
    super.key,
    required this.texto,
    this.tamanio = 14,
    this.color = Colors.black,
    this.fuente = 'San Francisco',
    this.grosor = FontWeight.w500,
  });

  // escritura del texto
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
