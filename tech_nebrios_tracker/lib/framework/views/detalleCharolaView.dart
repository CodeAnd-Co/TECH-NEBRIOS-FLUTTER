// RF10 Consultar información detallada de una charola https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF10

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../framework/viewmodels/charolaViewModel.dart';
import './historialActividadView.dart';
import './historialAncestrosView.dart';
import './editarCharolaView.dart';
import 'components/atoms/texto.dart';
import '../views/alimentarCharolaView.dart';

/// Pantalla que muestra el detalle de una charola específica.
class PantallaCharola extends StatefulWidget {
  final int charolaId; // ID de la charola que se va a mostrar
  final VoidCallback onRegresar;
  const PantallaCharola({
    super.key,
    required this.charolaId,
    required this.onRegresar,
  });

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
  Widget _crearInfoFila(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Texto.titulo2(texto: '$label ', bold: true),
          Texto.titulo2(texto: value, color: color),
        ],
      ),
    );
  }

  /// Crea un botón con ícono y texto pequeño debajo
  Widget _crearBotonIcono({
    required IconData icono,
    required String texto,
    required VoidCallback alPresionar,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(icono, color: const Color(0xFFE2387B)),
          onPressed: alPresionar,
          iconSize: 40,
        ),
        Texto.titulo4(texto: texto, bold: true),
      ],
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
          // Volver al dashboard si no se encuentra la charola
          WidgetsBinding.instance.addPostFrameCallback((_) {
            widget.onRegresar(); // <- Llama a la función que cierra el detalle
          });
          return const SizedBox.shrink(); // No muestra nada mientras redirige
        }

        final fechaFormateada = formatearFecha(detalle.fechaCreacion);

        // UI principal de la pantalla
        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),
          body: SafeArea(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: SizedBox(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.black,
                                ),
                                tooltip: 'Regresar',
                                onPressed: widget.onRegresar,
                                iconSize: 35,
                              ),
                            ),

                            Texto.titulo1(
                              texto: 'Detalles de la charola',
                              bold: true,
                              tamanio: 35,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(color: Colors.black, thickness: 2),
                    const SizedBox(height: 20),
                    Container(
                      child: IntrinsicHeight(
                        child: Column(
                          children: [
                            SizedBox(
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Texto.titulo1(
                                    texto: detalle.nombreCharola,
                                    bold: true,
                                    tamanio: 50,
                                    color: Color(0xFF22A63A),
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 20),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                          borderRadius: BorderRadius.circular(
                                            50,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.2,
                                              ), // Color de la sombra
                                              spreadRadius:
                                                  1, // Qué tanto se expande
                                              blurRadius:
                                                  6, // Qué tan difusa es
                                              offset: Offset(
                                                2,
                                                3,
                                              ), // Desplazamiento (x, y)
                                            ),
                                          ],
                                        ),
                                        padding: const EdgeInsets.all(8),
                                        child: IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                            size: 35,
                                          ),
                                          tooltip: 'Eliminar',
                                          onPressed: () {
                                            mostrarPopUpEliminarCharola(
                                              context: context,
                                              charolaId: widget.charolaId,
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 40),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          _crearInfoFila(
                                            'Estado actual:',
                                            detalle.estado,
                                            detalle.estado == 'activa'
                                                ? Colors.green
                                                : Colors.red,
                                          ),
                                        ],
                                      ),
                                      _crearInfoFila(
                                        'Fecha de creación:',
                                        fechaFormateada,
                                        Colors.black,
                                      ),
                                      _crearInfoFila(
                                        'Ciclo de hidratación:',
                                        '${detalle.hidratacionCiclo} g',
                                        Colors.black,
                                      ),
                                      _crearInfoFila(
                                        'Densidad de larva:',
                                        '${detalle.densidadLarva} g',
                                        Colors.black,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 80),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _crearInfoFila(
                                        'Hidratación:',
                                        '${detalle.hidratacionNombre} ${detalle.hidratacionOtorgada} g',
                                        Colors.black,
                                      ),
                                      _crearInfoFila(
                                        'Alimento:',
                                        '${detalle.comidaNombre} ${detalle.comidaOtorgada} g',
                                        Colors.black,
                                      ),
                                      _crearInfoFila(
                                        'Ciclo de comida:',
                                        '${detalle.comidaCiclo} g',
                                        Colors.black,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 60),
                            // Parte inferior con botones
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 40,
                                vertical: 20,
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xFFEDEDED),
                                borderRadius: BorderRadius.circular(50),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    spreadRadius: 1,
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    "Menú de acciones rapidas",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Wrap(
                                    alignment: WrapAlignment.spaceAround,
                                    spacing: 50,
                                    runSpacing: 10,
                                    children: [
                                      _crearBotonIcono(
                                        icono: Icons.edit,
                                        texto: 'Editar',
                                        alPresionar: () {
                                          mostrarPopUpEditarCharola(
                                            context: context,
                                            charolaId: widget.charolaId,
                                            nombreCharola:
                                                detalle.nombreCharola,
                                            fechaCreacion: fechaFormateada,
                                            densidadLarva:
                                                detalle.densidadLarva,
                                            alimentoId: detalle.comidaId,
                                            alimento: detalle.comidaNombre,
                                            alimentoOtorgado:
                                                detalle.comidaOtorgada,
                                            hidratacionId:
                                                detalle.hidratacionId,
                                            hidratacion:
                                                detalle.hidratacionNombre,
                                            hidratacionOtorgado:
                                                detalle.hidratacionOtorgada,
                                            peso: detalle.pesoCharola,
                                          );
                                        },
                                      ),
                                      _crearBotonIcono(
                                        icono: Icons.bug_report,
                                        texto: 'Alimentar',
                                        alPresionar: () {
                                          mostrarDialogoAlimentar(
                                            context,
                                            viewModel.charola!.charolaId,
                                            Provider.of<CharolaViewModel>(
                                              context,
                                              listen: false,
                                            ),
                                          );
                                        },
                                      ),
                                      //    _crearBotonIcono(
                                      //      icono: Icons.water_drop,
                                      //      texto: 'Hidratar',
                                      //      alPresionar: () {}, // TODO MBI
                                      //    ),
                                      _crearBotonIcono(
                                        icono: Icons.device_hub,
                                        texto: 'Ancestros',
                                        alPresionar: () {
                                          mostrarPopUpHistorialAncestros(
                                            context: context,
                                            charolaId: widget.charolaId,
                                          );
                                        },
                                      ),
                                      _crearBotonIcono(
                                        icono: Icons.history,
                                        texto: 'Actividades',
                                        alPresionar: () {
                                          mostrarPopUpHistorialActividad(
                                            context: context,
                                            charolaId: widget.charolaId,
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void mostrarPopUpEliminarCharola({
    required BuildContext context,
    required int charolaId,
  }) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return Consumer<CharolaViewModel>(
          builder: (context, charolaViewModel, _) {
            return AlertDialog(
              title: Stack(
                alignment: Alignment.center,
                children: [
                  const Center(
                    child: Text(
                      'Eliminar Charola',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Positioned(
                    left: 0,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: () => Navigator.of(dialogContext).pop(),
                    ),
                  ),
                ],
              ),
              content: SizedBox(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Image.asset(
                        'assets/images/alert-icon.png',
                        height: 60,
                        color: Colors.amber[700],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "¿Estás seguro de querer continuar con esta acción?",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "(Una vez eliminado, no se puede recuperar.)",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15),
                      ),
                      const SizedBox(height: 30),
                      charolaViewModel.cargandoCharola
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              minimumSize: const Size(150, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            child: const Text(
                              'Eliminar',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            onPressed: () async {
                              await charolaViewModel.eliminarCharola(charolaId);
                              if (charolaViewModel.error) {
                                Navigator.of(dialogContext).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Ocurrió un error al eliminar la charola',
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              } else {
                                await charolaViewModel.cargarCharolas(
                                  reset: true,
                                );
                                Navigator.of(dialogContext).pop();
                                widget
                                    .onRegresar(); // Usa el callback para volver
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Charola eliminada con éxito',
                                    ),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              }
                            },
                          ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
