import 'package:flutter/material.dart';
import '../atoms/texto.dart';
import '../atoms/boton_icono.dart';
import '../molecules/boton_texto.dart';

class PopUpCharola extends StatelessWidget {

  // atributos
  // final List<Texto> textos;
  // final List<BotonTexto> botonesTxt;

  // constructor
  const PopUpCharola({
    super.key,
    // required this.textos,
    // required this.botonesTxt,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Texto.titulo1(texto:'Título del Pop-up'),

      content: Column(
        mainAxisSize: MainAxisSize.min,

        children: [
          const Texto.texto(texto: 'Este es un pop-up que utiliza botones personalizados.'),

          const SizedBox(height: 20), // Espacio entre los botones.
          
          // Botón con texto
          BotonTexto.simple(
            texto: Texto.texto(texto: 'Botón de Texto'),
            alPresionar: () {
              Navigator.of(context).pop();
              print('Botón de texto presionado');
            },
          ),

          const SizedBox(height: 10), // Espacio entre los botones.

          // Botón con ícono
          BotonIcono(
            imagen: 'lib/framework/views/components/atoms/icons/X.png',
            tamanio: 40,
            alPresionar: () {
              Navigator.of(context).pop();
              print('Botón con ícono presionado');
            },
          ),
        ],
      ),
    );
  }
}
