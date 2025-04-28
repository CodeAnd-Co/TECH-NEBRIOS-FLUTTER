import 'package:flutter/material.dart';
import '../atoms/texto.dart';

class BotonTexto extends StatelessWidget {

  // atributos
  final double borde;
  final double horizontal;
  final double vertical;
  final Texto texto;
  final VoidCallback alPresionar;
  final Color colorBg;

  // constructor por defecto
  const BotonTexto({
    super.key,
    required this.borde,            // curvatura de las esquinas del botón
    required this.horizontal,       // tamaño del botón horizontalmente
    required this.vertical,         // tamaño del botón verticalmente
    required this.texto,            // texto que está dentro del botón
    required this.alPresionar,      // acción que realiza el botón al ser presionado
    required this.colorBg,          // color del fondo del botón
  });

  const BotonTexto.simple({
    super.key,
    this.borde = 8,
    this.horizontal = 20,
    this.vertical = 10,
    required this.texto,
    required this.alPresionar,
    this.colorBg = Colors.white,
  });

  // creación del botón
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(

      // estilo del botón
      style: ElevatedButton.styleFrom(
        backgroundColor: colorBg, // se colorea el fondo
        padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical), // se establece lo horizontal y vertical
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borde), // se redondea el borde
        ),
      ),
      // acción del botón
      onPressed: alPresionar, // se asigna
      // texto del botón
      child: texto
    );
  }
}
