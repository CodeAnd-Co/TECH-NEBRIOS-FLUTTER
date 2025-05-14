import 'package:flutter/material.dart';
import '../atoms/texto.dart';
import '../atoms/boton_icono.dart';
import '../molecules/boton_texto.dart';

class PopUpCharola extends StatelessWidget {
  final String charola;
  final String fecha;
  final String peso;
  final String frass;
  final String hidratacion;
  final String alimento;

  const PopUpCharola({
    super.key,
    required this.charola,
    required this.fecha,
    required this.peso,
    required this.frass,
    required this.hidratacion,
    required this.alimento,
  });

  // Constructor de prueba como constante
  const PopUpCharola.prueba({
    super.key,
    this.charola = 'C-111',
    this.fecha = '12/11/2025',
    this.peso = '500',
    this.frass = '500',
    this.hidratacion = 'Zanahoria',
    this.alimento = 'Salvado',
  });

  factory PopUpCharola.fromJson(Map<String, dynamic> json) {
    return PopUpCharola(
      charola: json['charola'],
      fecha: json['fecha'],
      peso: json['peso'],
      frass: json['frass'],
      hidratacion: json['hidratacion'],
      alimento: json['alimento'],
    );
  }

  // Función Widget para generar la información de las filas del PopUp
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Texto.titulo2(texto: '$label ', bold: true),
          Texto.titulo2(texto: value),
        ],
      ),
    );
  }

  // Función Widget para generar los botones del PopUp
  Widget _buildActionButton(String text, Color color, VoidCallback onPressed) {
    return BotonTexto.simple(
      texto: Texto.titulo4(texto: text, bold: true, color: Colors.white,),
      alPresionar: onPressed,
      colorBg: color,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        width: 890,
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
                  },
                ),
              ],
            ),
            
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Texto.titulo1(texto: charola, bold: true, tamanio: 50),
            ),
            
            _buildInfoRow('fecha:', fecha),
            _buildInfoRow('peso:', peso),
            _buildInfoRow('frass:', frass),
            _buildInfoRow('hidratacion:', hidratacion),
            _buildInfoRow('alimento:', alimento),
            
            const SizedBox(height: 45),
            
            Wrap(
              spacing: 150,
              alignment: WrapAlignment.center,
              children: [
                _buildActionButton(
                  'Eliminar',
                  const Color.fromARGB(255, 201, 45, 34),
                  () {
                    Navigator.of(context).pop();
                  },
                ),
                _buildActionButton(
                  'Historial',
                  const Color.fromARGB(255, 255, 57, 123),
                  () {
                    Navigator.of(context).pop();
                  },
                ),
                _buildActionButton(
                  'Editar',
                  const Color.fromARGB(255, 48, 104, 224),
                  () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}