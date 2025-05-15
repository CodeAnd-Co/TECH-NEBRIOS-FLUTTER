import 'package:flutter/material.dart';
import '../atoms/texto.dart';
import '../molecules/boton_texto.dart';

class OrganismoPopUpConfirmacion extends StatelessWidget {
  final VoidCallback onConfirmar;
  final VoidCallback onCancelar;

  const OrganismoPopUpConfirmacion({
    super.key,
    required this.onConfirmar,
    required this.onCancelar,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        width: 500,
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Imagen centrada
            Image.asset(
              'assets/images/alert-icon.png',
              height: 60,
            ),
            const SizedBox(height: 10),
            // Texto centrado
            Texto.titulo3(
              texto: '¿Estás seguro que quieres continuar con esta acción?',
              bold: true,
              tamanio: 25,
              centrado: true,
            ),
            const SizedBox(height: 30),
            // Botones
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                BotonTexto.simple(
                  texto: Texto.titulo4(
                    texto: 'No',
                    bold: true,
                    color: Colors.white,
                  ),
                  alPresionar: onCancelar,
                  colorBg: const Color.fromARGB(255, 201, 45, 34),
                ),
                BotonTexto.simple(
                  texto: Texto.titulo4(
                    texto: 'Sí',
                    bold: true,
                    color: Colors.white,
                  ),
                  alPresionar: onConfirmar,
                  colorBg: const Color.fromARGB(255, 36, 66, 204),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
