import 'package:flutter/material.dart';

class BotonIcono extends StatelessWidget {

  // atributos
  final double tamanio;
  final VoidCallback alPresionar;
  final String imagen;

  // constructor por defecto
  const BotonIcono({
    super.key,
    required this.tamanio,
    required this.alPresionar,
    required this.imagen
  });

  // creación del botón
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Image.asset(imagen),
      iconSize: tamanio,  // Ajustamos el tamaño del ícono
      onPressed: alPresionar
    );
  }
}
