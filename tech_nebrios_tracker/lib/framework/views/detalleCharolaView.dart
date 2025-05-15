// RF10 Consultar información detallada de una charola https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF10
// RF8 Eliminar Charola https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF8

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../framework/viewmodels/charolaViewModel.dart';
import 'components/atoms/texto.dart';
import 'components/molecules/boton_texto.dart';
import 'components/organisms/pop_up.dart';
import 'charolasDashboardView.dart';

/// Pantalla que muestra el detalle de una charola específica.
class PantallaCharola extends StatefulWidget {
  final int charolaId; // ID de la charola que se va a mostrar
  const PantallaCharola({super.key, required this.charolaId});

  @override
  State<PantallaCharola> createState() => _PantallaCharolaState();
}

class _PantallaCharolaState extends State<PantallaCharola> {
  bool _initialized = false; // Controla si ya se inicializó la carga de datos

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;

      // Se carga la charola de forma asíncrona después del primer build
      Future.microtask(() {
        context.read<CharolaViewModel>().cargarCharola(widget.charolaId);
      });
    }
  }

  /// Formatea una fecha en formato ISO a formato dd/mm/yyyy
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
      return fecha; // Si falla el parseo, se retorna la fecha original
    }
  }

  /// Crea una fila de información con un label y un valor
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

  /// Crea un botón con texto personalizado y callback
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
        // Muestra indicador de carga mientras se obtiene el detalle
        if (viewModel.cargandoCharola) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final detalle = viewModel.charola;
        // Si no se encuentra la charola, se muestra un mensaje
        if (detalle == null) {
          return const Scaffold(
            body: Center(child: Text('Charola no encontrada')),
          );
        }

        final fechaFormateada = formatearFecha(detalle.fechaCreacion);

        // UI principal de la pantalla
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
                          // Título con el nombre de la charola
                          Texto.titulo1(
                            texto: detalle.nombreCharola,
                            bold: true,
                            tamanio: 64,
                            color: const Color(0xFF22A63A),
                          ),
                          // Fila con estado
                          _crearInfoFila('Estado:', detalle.estado),
                          // Fila con fecha
                          _crearInfoFila('Fecha:', fechaFormateada),
                          // Fila con peso
                          _crearInfoFila('Peso:', '${detalle.pesoCharola}g'),
                          // Fila con hidratación
                          _crearInfoFila(
                            'Hidratación:',
                            '${detalle.hidratacionNombre} ${detalle.hidratacionOtorgada}g',
                          ),
                          // Fila con alimento
                          _crearInfoFila(
                            'Alimento:',
                            '${detalle.comidaNombre} ${detalle.comidaOtorgada}g',
                          ),
                          const SizedBox(height: 20),
                          // Botones de acción: Eliminar, Historial, Editar
                          Wrap(
                            spacing: 150,
                            alignment: WrapAlignment.center,
                            children: [
                              // Botón Eliminar con confirmación
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
                              // Botón Historial (pendiente de implementar)
                              _crearBotonTexto(
                                'Historial',
                                const Color(0xFFE2387B),
                                () {
                                  // TODO: implementar navegación a Historial
                                },
                              ),
                              // Botón Editar (pendiente de implementar)
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
