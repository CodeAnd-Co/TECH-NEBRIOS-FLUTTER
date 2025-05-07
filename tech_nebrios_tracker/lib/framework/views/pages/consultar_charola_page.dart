import 'package:flutter/material.dart';
import '../../../domain/consular_charola.dart';
import '../../../data/models/charola_model.dart';
import '../../../data/services/charola_api.dart';
import '../../../data/repositories/consultar_charola_repository.dart';
import '../../viewmodels/consultar_charola_viewmodel.dart';
import '../components/atoms/texto.dart';
import '../components/molecules/boton_texto.dart';

class PantallaCharola extends StatefulWidget {
  final int charolaId;

  const PantallaCharola({super.key, required this.charolaId});

  @override
  State<PantallaCharola> createState() => _PantallaCharolaState();
}

class _PantallaCharolaState extends State<PantallaCharola> {
  late CharolaViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = CharolaViewModel(
      ObtenerCharolaUseCase(
        ConsultarCharolaRepository(
          CharolaApiService(baseUrl: 'http://localhost:3000'),
        ),
      ),
    );
    viewModel.cargarCharola(widget.charolaId);
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

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: viewModel,
      builder: (context, _) {
        if (viewModel.cargando) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final Charola? charola = viewModel.charola;

        if (charola == null) {
          return const Scaffold(
            body: Center(child: Text('Charola no encontrada')),
          );
        }

        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 245, 247, 250),
          body: Center(
            child: SizedBox(
              width: 900,
              height: 900,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Texto.titulo1(
                    texto: charola.nombreCharola,
                    bold: true,
                    tamanio: 64,
                    color: const Color.fromARGB(250, 34, 166, 58),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _crearInfoFila('fecha:', charola.fechaCreacion),
                        _crearInfoFila('peso:', '${charola.pesoCharola} g'),
                        _crearInfoFila('frass:', '${charola.densidadLarva} g'),
                        _crearInfoFila('hidratacion:', charola.hidratacionNombre),
                        _crearInfoFila('alimento:', charola.comidaNombre),
                      ],
                    ),
                  ),
                  Wrap(
                    spacing: 150,
                    alignment: WrapAlignment.center,
                    children: [
                      _crearBotonTexto(
                        'Eliminar',
                        const Color.fromARGB(255, 228, 61, 61),
                        () {
                          Navigator.of(context).pop();
                          print('Botón de Eliminar presionado');
                        },
                      ),
                      _crearBotonTexto(
                        'Historial',
                        const Color.fromARGB(255, 226, 56, 125),
                        () {
                          Navigator.of(context).pop();
                          print('Botón de Historial presionado');
                        },
                      ),
                      _crearBotonTexto(
                        'Editar',
                        const Color.fromARGB(255, 36, 66, 204),
                        () {
                          Navigator.of(context).pop();
                          print('Botón de Editar presionado');
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
