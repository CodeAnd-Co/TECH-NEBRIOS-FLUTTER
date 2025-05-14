import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../framework/viewmodels/charolaViewModel.dart';
import 'components/atoms/texto.dart';
import 'components/molecules/boton_texto.dart';

class PantallaCharola extends StatefulWidget {
  final int charolaId;
  const PantallaCharola({super.key, required this.charolaId});

  @override
  State<PantallaCharola> createState() => _PantallaCharolaState();
}

class _PantallaCharolaState extends State<PantallaCharola> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      // Solicita al ViewModel cargar el detalle
      context.read<CharolaViewModel>().cargarCharola(widget.charolaId);
      _initialized = true;
    }
  }

  String formatearFecha(String fecha) {
    try {
      final dateTime = DateTime.parse(fecha);
      if (fecha.contains('T')) {
        final dia = dateTime.day.toString().padLeft(2, '0');
        final mes = dateTime.month.toString().padLeft(2, '0');
        final anio = dateTime.year.toString();
        return '$dia/$mes/$anio';
      }
      return fecha;
    } catch (_) {
      return fecha;
    }
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
    return Consumer<CharolaViewModel>(
      builder: (context, viewModel, _) {
        // Cargando detalle
        if (viewModel.cargandoCharola) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final detalle = viewModel.charola;
        if (detalle == null) {
          return const Scaffold(
            body: Center(child: Text('Charola no encontrada')),
          );
        }

        final fechaFormateada = formatearFecha(detalle.fechaCreacion);

        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),
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
                            texto: detalle.nombreCharola,
                            bold: true,
                            tamanio: 64,
                            color: const Color(0xFF22A63A),
                          ),
                          _crearInfoFila('Estado:', detalle.estado),
                          _crearInfoFila('Fecha:', fechaFormateada),
                          _crearInfoFila('Peso:', '${detalle.pesoCharola}g'),
                          _crearInfoFila(
                            'Hidratación:',
                            '${detalle.hidratacionNombre} ${detalle.hidratacionOtorgada}g',
                          ),
                          _crearInfoFila(
                            'Alimento:',
                            '${detalle.comidaNombre} ${detalle.comidaOtorgada}g',
                          ),
                          const SizedBox(height: 20),
                          Wrap(
                            spacing: 150,
                            alignment: WrapAlignment.center,
                            children: [
                              _crearBotonTexto(
                                'Eliminar',
                                const Color(0xFFE43D3D),
                                () {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      titlePadding: const EdgeInsets.only(
                                          top: 20, left: 5, right: 60),
                                      title: Row(
                                        children: [
                                          IconButton(
                                            onPressed: () => Navigator.of(ctx).pop(),
                                            icon: const Icon(Icons.close, size: 35),
                                          ),
                                          Expanded(
                                            child: Center(
                                              child: Texto.titulo1(
                                                  texto: 'Eliminar', bold: true),
                                            ),
                                          ),
                                        ],
                                      ),
                                      content: Texto.titulo5(
                                          texto:
                                              '¿Estás seguro de eliminar la charola?'),
                                      actions: [
                                        Center(
                                          child: BotonTexto.simple(
                                            texto: Texto.titulo5(
                                                texto: 'Eliminar',
                                                color: Colors.white),
                                            alPresionar: () async {
                                              await viewModel
                                                  .eliminarCharola(
                                                      detalle.charolaId);
                                              Navigator.of(ctx).pop();
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      'Charola eliminada con éxito'),
                                                ),
                                              );
                                            },
                                            colorBg:
                                                const Color(0xFFE43D3D),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),
                              _crearBotonTexto(
                                'Historial',
                                const Color(0xFFE2387B),
                                () {
                                  // TODO: implementar navegación a Historial
                                },
                              ),
                              _crearBotonTexto(
                                'Editar',
                                const Color(0xFF2442CC),
                                () {
                                  // TODO: implementar edición
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
