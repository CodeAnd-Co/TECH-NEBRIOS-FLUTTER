import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../framework/viewmodels/charolaViewModel.dart';
import 'components/atoms/texto.dart';
import 'components/molecules/boton_texto.dart';
import 'components/organisms/pop_up.dart';
import 'charolasDashboardView.dart';

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
      _initialized = true;

      // Ejecutar después del build actual
      Future.microtask(() {
        context.read<CharolaViewModel>().cargarCharola(widget.charolaId);
      });
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
                                    builder: (context) {
                                      return OrganismoPopUpConfirmacion(
                                        onCancelar:
                                            () => Navigator.of(context).pop(),
                                        onConfirmar: () async {
                                          await viewModel.eliminarCharola(
                                            viewModel.charola!.charolaId,
                                          );
                                          await viewModel.cargarCharolas(
                                            reset: true,
                                          );
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => ChangeNotifierProvider.value(
                                                value: viewModel,
                                                child: const VistaCharolas(),
                                              ),
                                            ),
                                          );
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Charola eliminada con éxito',
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
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
