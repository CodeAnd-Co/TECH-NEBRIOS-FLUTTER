import 'package:flutter/material.dart';
import '../atoms/texto.dart';
import '../atoms/boton_icono.dart';
import '../molecules/boton_texto.dart';

class PopUpCharola extends StatelessWidget {

  // atributos
  final String charola;          // E-111-22   C-123   T1-111-22
  final String fecha;            // AAAA-MM-DD
  final String peso;             // pesoCharola
  final String frass;            // tabla frass
  final String hidratacion;      // tabla hidratación
  final String alimento;         // tabla alimento

  // constructo
  const PopUpCharola({
    super.key,
    required this.charola,
    required this.fecha,
    required this.peso,
    required this.frass,
    required this.hidratacion,
    required this.alimento
  });

  const PopUpCharola.prueba({
    super.key,
    this.charola = 'C-111',
    this.fecha = '12/11/2025',
    this.peso = '500',
    this.frass = '500',
    this.hidratacion = 'Zanahoria',
    this.alimento = 'Salvado'
  });

  factory PopUpCharola.fromJson(Map<String, dynamic> json) {
    return PopUpCharola(
      charola: json['charola'],
      fecha: json['fecha'],
      peso: json['peso'],
      frass: json['frass'],
      hidratacion: json['hidratacion'],
      alimento: json['alimento']
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        width: 700,
        height: 550,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.start,

              children: [
                BotonIcono(
                  imagen: 'lib/framework/views/components/atoms/icons/X.png',
                  tamanio: 35,
                  alPresionar: () {
                    Navigator.of(context).pop();
                    print('Botón con ícono presionado');
                  },
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Texto.titulo1B(texto: charola, tamanio: 64)
            ]),

            const SizedBox(height: 40),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Texto.titulo2B(texto: 'fecha: '),
              Texto.titulo2(texto: fecha)
            ]),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Texto.titulo2B(texto: 'peso: '),
              Texto.titulo2(texto: peso)
            ]),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Texto.titulo2B(texto: 'frass: '),
              Texto.titulo2(texto: frass)
            ]),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Texto.titulo2B(texto: 'hidratacion: '),
              Texto.titulo2(texto: hidratacion)
            ]),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Texto.titulo2B(texto: 'alimento: '),
              Texto.titulo2(texto: alimento)
            ]),

            const SizedBox(height: 50),

            Wrap(
              spacing: 80,
              alignment: WrapAlignment.center,

              children: [
                BotonTexto.simple(
                  texto: Texto.titulo5B(texto: 'Eliminar'),
                  alPresionar: () {
                    Navigator.of(context).pop();
                    print('Botón de Eliminar presionado');
                  },
                  colorBg: const Color.fromARGB(255, 201, 45, 34),
                ),

                BotonTexto.simple(
                  texto: Texto.titulo5B(texto: 'Historial'),
                  alPresionar: () {
                    Navigator.of(context).pop();
                    print('Botón de Historial presionado');
                  },
                  colorBg: const Color.fromARGB(255, 255, 57, 123),
                ),

                BotonTexto.simple(
                  texto: Texto.titulo5B(texto: 'Editar'),
                  alPresionar: () {
                    Navigator.of(context).pop();
                    print('Botón de Editar presionado');
                  },
                  colorBg: const Color.fromARGB(255, 48, 104, 224),
                ),
              ],
            ),

            

          ],
        ),
      )
    );
  }
}
