import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../framework/viewmodels/charola_vista_modelo.dart';
import '../../data/models/charola_modelo.dart';

class CharolaCard extends StatelessWidget {
  final String fecha;
  final String nombreCharola;
  final Color color;
  final VoidCallback onTap;

  const CharolaCard({
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
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: SizedBox(
            width: 160,
            height: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    fecha,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      nombreCharola,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class VistaCharolas extends StatelessWidget {
  const VistaCharolas({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Consumer<CharolaVistaModelo>(
          builder: (context, vm, _) {
            if (vm.cargando && vm.charolas.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!vm.cargando && vm.charolas.isEmpty) {
              return const Center(
                child: Text(
                  'No hay charolas registradas 🧺',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              );
            }
            return Column(
              children: [
                const SizedBox(height: 16),
                const Text(
                  'Charolas',
                  style: TextStyle(fontSize: 32),
                ),
                const SizedBox(height: 8),
                const Divider(color: Color(0xFF385881), thickness: 3),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      _EtiquetaColor(color: Color(0xFF22A63A), label: 'C- (Tenebrios)'),
                      _EtiquetaColor(color: Color(0xFF3CB3C8), label: 'T1-T4 (Tamizado)'),
                      _EtiquetaColor(color: Color(0xFFE2387B), label: 'E- (Incubación)'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: GridView.builder(
                      itemCount: vm.charolas.length,
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 220,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 1.3,
                      ),
                      itemBuilder: (context, index) {
                        final Charola charola = vm.charolas[index];
                        return CharolaCard(
                          fecha:
                              "${charola.fechaCreacion.day}/${charola.fechaCreacion.month}/${charola.fechaCreacion.year}",
                          nombreCharola: charola.nombreCharola,
                          color: obtenerColorPorNombre(charola.nombreCharola),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Charola seleccionada"),
                                content: Text("Has tocado la charola ${charola.nombreCharola}"),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("Cerrar"),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
                Text(
                  "Página ${vm.pagActual - 1} de ${vm.totalPags}",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 0.5),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Consumer<CharolaVistaModelo>(
                    builder: (context, vm, _) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE9EEF6),
                              foregroundColor: const Color(0xFF385881),
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                              textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            onPressed: vm.pagActual > 1
                              ? () => vm.cargarPaginaAnterior()
                              : null,
                            icon: const Icon(Icons.arrow_back, size: 35),
                            label: const Text("Anterior"),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE9EEF6),
                              foregroundColor: const Color(0xFF385881),
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                              textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            onPressed: vm.pagActual < vm.totalPags
                              ? () => vm.cargarPaginaSiguiente()
                              : null,
                            icon: const Icon(Icons.arrow_forward, size: 35),
                            label: const Text("Siguiente"),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

Color obtenerColorPorNombre(String nombre) {
  if (nombre.startsWith('C-')) {
    return const Color(0xFF22A63A); // Verde
  } else if (nombre.startsWith('E-')) {
    return const Color(0xFFE2387B); // Rosa
  } else if (nombre.startsWith('T1-') ||
             nombre.startsWith('T2-') ||
             nombre.startsWith('T3-') ||
             nombre.startsWith('T4-')) {
    return const Color(0xFF3CB3C8); // Azul
  }
  return Colors.grey; // Color por defecto
}

class _EtiquetaColor extends StatelessWidget {
  final Color color;
  final String label;

  const _EtiquetaColor({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
