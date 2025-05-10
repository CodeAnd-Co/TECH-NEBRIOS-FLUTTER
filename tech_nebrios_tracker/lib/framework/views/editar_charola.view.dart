import 'package:flutter/material.dart';
import 'package:tech_nebrios_tracker/framework/viewmodels/editar_charola_viewmodel.dart';
import './components/atoms/texto.dart';
import './components/molecules/boton_texto.dart';

class EditarCharola extends StatefulWidget {
  final int charolaId;

  const EditarCharola({super.key, required this.charolaId});

  @override
  State<EditarCharola> createState() => _EditarCharolaState();
}

class _EditarCharolaState extends State<EditarCharola> {
  late EditarCharolaViewmodel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = EditarCharolaViewmodel();
  }

  Widget _crearInfoFila(String label, String value) {
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

  Widget _crearBotonTexto(String texto, Color color, VoidCallback alPresionar) {
    return BotonTexto.simple(
      texto: Texto.titulo4(texto: texto, bold: true, color: Colors.white),
      alPresionar: alPresionar,
      colorBg: color,
    );
  }

  String formatearFecha(String fecha) {
    try {
      final dateTime = DateTime.parse(fecha);
      if (fecha.contains('T')) {
        final dia = dateTime.day.toString().padLeft(2, '0');
        final mes = dateTime.month.toString().padLeft(2, '0');
        final anio = dateTime.year.toString();
        return '$dia/$mes/$anio';
      } else {
        return fecha;
      }
    } catch (e) {
      return fecha;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: viewModel,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 245, 247, 250),
          body: Center(
            child: SizedBox(
              width: 900,
              height: 900,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Texto.titulo1(
                            texto: "xd",
                            bold: true,
                            tamanio: 64,
                            color: const Color.fromARGB(250, 34, 166, 58),
                          ),
                          _crearInfoFila('Estado:', "charola.estado"),
                          _crearInfoFila('Fecha:', "fechaFormateada"),
                          _crearInfoFila('Peso:', "g"),
                          _crearInfoFila('Hidratacion:', "xd"),
                          _crearInfoFila('Alimento:', "xd"),
                          Wrap(
                            spacing: 150,
                            alignment: WrapAlignment.center,
                            children: [
                              _crearBotonTexto(
                                'Cancelar',
                                const Color.fromARGB(255, 228, 61, 61),
                                () {
                                  Navigator.of(context).pop();
                                  print('Botón de Eliminar presionado');
                                },
                              ),
                              _crearBotonTexto(
                                'Confirmar',
                                const Color.fromARGB(250, 34, 166, 58),
                                () {
                                  Navigator.of(context).pop();
                                  print('Botón de Editar presionado');
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
