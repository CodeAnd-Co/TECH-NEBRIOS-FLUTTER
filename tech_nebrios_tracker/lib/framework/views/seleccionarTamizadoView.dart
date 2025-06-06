// RF16 Visualizar todas las charolas registradas en el sistema - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF16

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zuustento_tracker/framework/views/tamizarCharolaIndividualView.dart';
import 'package:zuustento_tracker/framework/views/tamizarMultiplesCharolasView.dart';
import '../viewmodels/charolaViewModel.dart';
import '../../data/models/charolaModel.dart' as modelo;
import '../viewmodels/tamizarCharolaViewModel.dart';
import 'components/header.dart';

/// Widget que representa una tarjeta individual de charola con diseño responsivo.
class CharolaTarjeta extends StatelessWidget {
  final String fecha;
  final String nombreCharola;
  final Color color;

  /// Acción a ejecutar cuando se pulsa la tarjeta.
  final VoidCallback onTap;

  const CharolaTarjeta({
    super.key,
    required this.fecha,
    required this.nombreCharola,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final ancho = constraints.maxWidth;
            final alto = constraints.maxHeight;

            final fontSizeFecha = ancho * 0.08;
            final fontSizeNombre = ancho * 0.10;
            final paddingVertical = alto * 0.08;

            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(8),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(vertical: paddingVertical),
                    child: Text(
                      fecha,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: fontSizeFecha.clamp(12, 20),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        nombreCharola,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: fontSizeNombre.clamp(14, 28),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Vista principal que muestra todas las charolas en un grid paginado.
class VistaSeleccionarTamizado extends StatefulWidget {
  const VistaSeleccionarTamizado({super.key});

  @override
  State<VistaSeleccionarTamizado> createState() =>
      _VistaSeleccionarTamizadoState();
}

class _VistaSeleccionarTamizadoState extends State<VistaSeleccionarTamizado> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = Provider.of<CharolaViewModel>(context, listen: false);
      vm.cambiarEstado('activa');
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final seleccionVM = Provider.of<TamizadoViewModel>(
        context,
        listen: false,
      );
      seleccionVM.addListener(() {
        if (seleccionVM.hasError && seleccionVM.errorMessage.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(seleccionVM.errorMessage),
              backgroundColor: Colors.red,
            ),
          );
          seleccionVM.limpiarError();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Consumer2<CharolaViewModel, TamizadoViewModel>(
          builder: (context, vm, seleccionVM, _) {
            return Column(
              children: [
                const Header(
                  titulo: 'Tamizar',
                  showDivider: true,
                  subtitulo: null,
                ),
                const SizedBox(height: 8),
                if (seleccionVM.charolasParaTamizar.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            'Charolas seleccionadas',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                          height: 120,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: seleccionVM.charolasParaTamizar.length,
                            separatorBuilder:
                                (_, __) => const SizedBox(width: 12),
                            itemBuilder: (context, index) {
                              final charola =
                                  seleccionVM.charolasParaTamizar[index];
                              return SizedBox(
                                width: 180,
                                child: CharolaTarjeta(
                                  fecha:
                                      "${charola.fechaCreacion.day}/${charola.fechaCreacion.month}/${charola.fechaCreacion.year}",
                                  nombreCharola: charola.nombreCharola,
                                  color: obtenerColorPorNombre(
                                    charola.nombreCharola,
                                  ),
                                  onTap: () {
                                    seleccionVM.quitarCharola(charola);
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 10),
                        Divider(height: 1, thickness: 2),
                      ],
                    ),
                  ),
                const SizedBox(height: 10),
                if (vm.cargandoLista && vm.charolas.isEmpty)
                  const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (!vm.cargandoLista && vm.charolas.isEmpty)
                  const Expanded(
                    child: Center(
                      child: Text(
                        'No hay charolas registradas 🧺',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                /// Grid de charolas
                else
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: GridView.builder(
                        itemCount: vm.charolas.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 5,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 1.3,
                            ),
                        itemBuilder: (context, index) {
                          final modelo.CharolaTarjeta charola =
                              vm.charolas[index];
                          return LayoutBuilder(
                            builder: (context, constraints) {
                              return AspectRatio(
                                aspectRatio: 1.3,
                                child: CharolaTarjeta(
                                  fecha:
                                      "${charola.fechaCreacion.day}/${charola.fechaCreacion.month}/${charola.fechaCreacion.year}",
                                  nombreCharola: charola.nombreCharola,
                                  color: obtenerColorPorNombre(
                                    charola.nombreCharola,
                                  ),
                                  onTap: () {
                                    seleccionVM.agregarCharola(charola);
                                  },
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),

                /// Paginación
                if (vm.charolas.isNotEmpty) ...[
                  Text(
                    "Página ${vm.pagActual} de ${vm.totalPags}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final width = constraints.maxWidth;

                        final buttonWidth = width * 0.25;
                        final fontSize = width * 0.012;
                        final iconSize = width * 0.015;

                        return SizedBox(
                          width: double.infinity,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed:
                                        vm.pagActual > 1
                                            ? vm.cargarPaginaAnterior
                                            : null,
                                    icon: Icon(
                                      Icons.arrow_back,
                                      size: iconSize.clamp(18, 32),
                                    ),
                                    label: Text(
                                      "Anterior",
                                      style: TextStyle(
                                        fontSize: fontSize.clamp(17, 22),
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 22,
                                        vertical: 20,
                                      ),
                                      minimumSize: Size(
                                        buttonWidth.clamp(80, 200),
                                        48,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  ElevatedButton.icon(
                                    onPressed:
                                        vm.pagActual < vm.totalPags
                                            ? vm.cargarPaginaSiguiente
                                            : null,
                                    icon: Icon(
                                      Icons.arrow_forward,
                                      size: iconSize.clamp(18, 32),
                                    ),
                                    label: Text(
                                      "Siguiente",
                                      style: TextStyle(
                                        fontSize: fontSize.clamp(17, 22),
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 20,
                                      ),
                                      minimumSize: Size(
                                        buttonWidth.clamp(120, 200),
                                        48,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Positioned(
                                right: 20,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    if (seleccionVM.siguienteInterfaz(
                                      context,
                                    )) {
                                      if (seleccionVM
                                              .charolasParaTamizar
                                              .length ==
                                          1) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (_) => VistaTamizadoIndividual(
                                                  onRegresar: () {
                                                    Navigator.pop(context);
                                                    seleccionVM
                                                        .limpiarInformacion();
                                                  },
                                                ),
                                          ),
                                        );
                                      } else {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (_) => VistaTamizadoMultiple(
                                                  onRegresar: () {
                                                    Navigator.pop(context);
                                                    seleccionVM
                                                        .limpiarInformacion();
                                                  },
                                                ),
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  icon: Icon(
                                    Icons.done,
                                    size: iconSize.clamp(20, 30),
                                  ),
                                  label: Text(
                                    'Finalizar Selección',
                                    style: TextStyle(
                                      fontSize: fontSize.clamp(15, 22),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 18,
                                    ),
                                    backgroundColor: const Color(0xFF0066FF),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Asigna un color al encabezado de la tarjeta basado en el nombre.
Color obtenerColorPorNombre(String nombre) {
  if (nombre.startsWith('C-')) {
    return const Color(0xFF22A63A);
  } else if (nombre.startsWith('E-')) {
    return const Color(0xFFE2387B);
  } else if (nombre.startsWith('T1-') ||
      nombre.startsWith('T2-') ||
      nombre.startsWith('T3-') ||
      nombre.startsWith('T4-')) {
    return const Color(0xFF22A63A);
  }
  return Colors.grey; // Color por defecto
}
