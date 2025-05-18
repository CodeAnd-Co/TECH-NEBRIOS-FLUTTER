// RF10 Consultar información detallada de una charola https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF10
// RF8 Eliminar Charola https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF8

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../framework/viewmodels/charolaViewModel.dart';
import './historialActividadView.dart';
import './historialAncestrosView.dart';
import '../../framework/viewmodels/historialCharolaViewModel.dart';
import '../../data/repositories/historialCharolaRepository.dart';
import 'components/atoms/texto.dart';
import 'components/organisms/pop_up.dart';
import '../viewmodels/alimentacionViewModel.dart';
import 'package:flutter/services.dart';

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

  void mostrarDialogoAlimentar(BuildContext context, int charolaId) async {
    final comidaCharolaVM = Provider.of<ComidaCharolaViewModel>(
      context,
      listen: false,
    );

    await comidaCharolaVM.cargarAlimentos();

    int? comidaIdSeleccionada;
    final TextEditingController cantidadController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Registrar alimentación'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<int>(
                value: comidaIdSeleccionada,
                items:
                    comidaCharolaVM.alimentos.map((alimento) {
                      return DropdownMenuItem<int>(
                        value: alimento.idAlimento,
                        child: Text(alimento.nombreAlimento),
                      );
                    }).toList(),
                onChanged: (value) {
                  comidaIdSeleccionada = value;
                },
                decoration: const InputDecoration(labelText: 'Tipo de comida'),
              ),
              TextField(
                controller: cantidadController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,         // Solo dígitos
                    LengthLimitingTextInputFormatter(4),             // Máximo 3 caracteres
                  ],
                decoration: const InputDecoration(
                  labelText: 'Cantidad otorgada (g)',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Texto.texto(
                texto: 'Cancelar',
                color: const Color(0xFFE2387B),
                bold: true,
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final cantidad = int.tryParse(cantidadController.text);
                if (cantidad == null ||
                    cantidad <= 0 ||
                    comidaIdSeleccionada == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Ingresa todos los campos correctamente'),
                    ),
                  );
                  return;
                }

                await comidaCharolaVM.registrarAlimentacion(
                  charolaId: charolaId,
                  comidaId: comidaIdSeleccionada!,
                  cantidadOtorgada: cantidad,
                  fechaOtorgada: DateTime.now().toIso8601String(),
                );

                Navigator.of(context).pop();

                if (comidaCharolaVM.error != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${comidaCharolaVM.error}')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Alimentación registrada con éxito'),
                    ),
                  );
                }
              },
              child: Texto.texto(
                texto: 'Alimnetar',
                color: const Color(0xFFE2387B),
                bold: true,
              ),
            ),
          ],
        );
      },
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
              child: Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: SizedBox(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Flecha alineada a la izquierda
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
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                          size: 40,
                                        ),
                                        tooltip: 'Eliminar',
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return OrganismoPopUpConfirmacion(
                                                onCancelar:
                                                    () =>
                                                        Navigator.of(
                                                          context,
                                                        ).pop(),
                                                onConfirmar: () async {
                                                  await viewModel
                                                      .eliminarCharola(
                                                        viewModel
                                                            .charola!
                                                            .charolaId,
                                                      );
                                                  await viewModel
                                                      .cargarCharolas(
                                                        reset: true,
                                                      );
                                                  widget
                                                      .onRegresar(); // <- Vuelve al dashboard limpiamente
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                        'Charola eliminada con éxito',
                                                      ),
                                                    ),
                                                  );
                                                  Navigator.of(context).pop();
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    const SnackBar(
                                                      backgroundColor:
                                                          Colors.green,
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
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 40),
                            Center(
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
                                          Text(
                                            "Estado actual: ",
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            detalle.estado,
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  detalle.estado == 'activa'
                                                      ? Colors.green
                                                      : Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                      _crearInfoFila(
                                        'Fecha de creación:',
                                        fechaFormateada,
                                      ),
                                      _crearInfoFila(
                                        'Peso:',
                                        '${detalle.pesoCharola}g',
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
                                        '${detalle.hidratacionNombre} ${detalle.hidratacionOtorgada}g',
                                      ),
                                      _crearInfoFila(
                                        'Alimento:',
                                        '${detalle.comidaNombre} ${detalle.comidaOtorgada}g',
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
                                        alPresionar: () {},
                                      ),
                                      _crearBotonIcono(
                                        icono: Icons.bug_report,
                                        texto: 'Alimentar',
                                        alPresionar: () {
                                          mostrarDialogoAlimentar(
                                            context,
                                            viewModel.charola!.charolaId,
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
                                        alPresionar: () async {
                                          final ancestrosVM =
                                              HistorialCharolaViewModel(
                                                HistorialCharolaRepository(),
                                              );
                                          // Carga datos
                                          await ancestrosVM.obtenerAncestros(
                                            viewModel.charola!.charolaId,
                                          );
                                          if (ancestrosVM
                                              .historialAncestros
                                              .isEmpty) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'No hay ancestros disponibles',
                                                ),
                                              ),
                                            );
                                            return;
                                          }
                                          showDialog(
                                            context: context,
                                            builder:
                                                (
                                                  _,
                                                ) => ChangeNotifierProvider.value(
                                                  value: ancestrosVM,
                                                  child: HistorialAncestrosDialog(
                                                    data:
                                                        ancestrosVM
                                                            .historialAncestros
                                                            .first,
                                                  ),
                                                ),
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
}
