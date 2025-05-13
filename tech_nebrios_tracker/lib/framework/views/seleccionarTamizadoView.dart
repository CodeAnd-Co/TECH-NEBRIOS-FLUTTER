// RF16 Visualizar todas las charolas registradas en el sistema - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF16

import './consultar_charola_view.dart'; // Ajusta el path si es necesario
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/menuCharolasViewmodel.dart';
import '../../data/models/menuCharolasModel.dart';
import '../viewmodels/tamizarCharolaViewmodel.dart';

/// Widget que representa una tarjeta individual de charola con diseño responsivo.
class CharolaTarjeta extends StatelessWidget {
  /// Fecha de creación mostrada en la cabecera.
  final String fecha;

  /// Nombre de la charola.
  final String nombreCharola;

  /// Color de la cabecera de la tarjeta.
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
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
  State<VistaSeleccionarTamizado> createState() => _VistaSeleccionarTamizadoState();
}

class _VistaSeleccionarTamizadoState extends State<VistaSeleccionarTamizado> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Consumer2<CharolaVistaModelo, TamizadoViewModel>(
          builder: (context, vm, seleccionVM, _) {
            if (seleccionVM.hasError  && seleccionVM.errorMessage.isNotEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(seleccionVM.errorMessage),
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 3),
                  ),
                );
              });
            }
            return Column(
              children: [
                const SizedBox(height: 16),
                const Text('Tamizar', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Divider(color: Color(0xFF000000), thickness: 3),
                const SizedBox(height: 8),
                if (seleccionVM.charolasParaTamizar.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SizedBox(
                      height: 120,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: seleccionVM.charolasParaTamizar.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final charola = seleccionVM.charolasParaTamizar[index];
                          return SizedBox(
                            width: 180,
                            child: CharolaTarjeta(
                              fecha: "${charola.fechaCreacion.day}/${charola.fechaCreacion.month}/${charola.fechaCreacion.year}",
                              nombreCharola: charola.nombreCharola,
                              color: obtenerColorPorNombre(charola.nombreCharola),
                              onTap: () {
                                seleccionVM.quitarCharola(charola);
                              } // No hacer nada al tocar aquí arriba
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final screenWidth = constraints.maxWidth;

                      // Escalado responsivo
                      final fontSize = screenWidth * 0.012;
                      final iconSize = screenWidth * 0.015;

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Campo de búsqueda expandido
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Buscar',
                                prefixIcon: const Icon(Icons.search),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),                          
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),

                /// Carga inicial
                if (vm.cargando && vm.charolas.isEmpty)
                  const Expanded(child: Center(child: CircularProgressIndicator()))

                /// Mensaje cuando no hay resultados
                else if (!vm.cargando && vm.charolas.isEmpty)
                  const Expanded(
                    child: Center(
                      child: Text(
                        'No hay charolas registradas 🧺',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
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
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1.3,
                        ),
                        itemBuilder: (context, index) {
                          final Charola charola = vm.charolas[index];
                          return LayoutBuilder(
                            builder: (context, constraints) {
                              return AspectRatio(
                                aspectRatio: 1.3,
                                child: CharolaTarjeta(
                                  fecha: "${charola.fechaCreacion.day}/${charola.fechaCreacion.month}/${charola.fechaCreacion.year}",
                                  nombreCharola: charola.nombreCharola,
                                  color: obtenerColorPorNombre(charola.nombreCharola),
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
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
                              // Row centrado con los botones de paginación
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: vm.pagActual > 1 ? vm.cargarPaginaAnterior : null,
                                    icon: Icon(Icons.arrow_back, size: iconSize.clamp(18, 32)),
                                    label: Text(
                                      "Anterior",
                                      style: TextStyle(fontSize: fontSize.clamp(17, 22)),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
                                      minimumSize: Size(buttonWidth.clamp(80, 200), 48),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  ElevatedButton.icon(
                                    onPressed: vm.pagActual < vm.totalPags ? vm.cargarPaginaSiguiente : null,
                                    icon: Icon(Icons.arrow_forward, size: iconSize.clamp(18, 32)),
                                    label: Text(
                                      "Siguiente",
                                      style: TextStyle(fontSize: fontSize.clamp(17, 22)),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                      minimumSize: Size(buttonWidth.clamp(120, 200), 48),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              // Botón alineado a la derecha
                              Positioned(
                                right: 20,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    seleccionVM.siguienteInterfaz(context);
                                  },
                                  icon: Icon(Icons.done, size: iconSize.clamp(20, 30)),
                                  label: Text(
                                    'Finalizar Selección',
                                    style: TextStyle(
                                      fontSize: fontSize.clamp(15, 22),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
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