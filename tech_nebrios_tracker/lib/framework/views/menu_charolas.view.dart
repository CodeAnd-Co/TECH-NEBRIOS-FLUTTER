// RF16 Visualizar todas las charolas registradas en el sistema - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF16

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/menu_charolas.viewmodel.dart';
import '../../data/models/menu_charolas.model.dart';

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
        child: LayoutBuilder(
          builder: (context, constraints) {
            final ancho = constraints.maxWidth;
            final alto = constraints.maxHeight;

            // Tamaños dinámicos proporcionales
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

class VistaCharolas extends StatelessWidget {
  const VistaCharolas({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Consumer<CharolaVistaModelo>(
          builder: (context, vm, _) {
            return Column(
              children: [
                const SizedBox(height: 16),
                const Text(
                  'Charolas',
                  style: TextStyle(fontSize: 32),
                ),
                const SizedBox(height: 8),
                const Divider(color: Color(0xFF000000), thickness: 3),
                const SizedBox(height: 8),

                // 🔽 CONTENIDO CONDICIONAL 🔽
                if (vm.cargando && vm.charolas.isEmpty)
                  const Expanded(child: Center(child: CircularProgressIndicator()))
                else if (!vm.cargando && vm.charolas.isEmpty)
                  const Expanded(
                    child: Center(
                      child: Text(
                        'No hay charolas registradas 🧺',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: GridView.builder(
  itemCount: vm.charolas.length,
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 5, // Fijas el número de tarjetas por fila
    crossAxisSpacing: 16,
    mainAxisSpacing: 16,
    childAspectRatio: 1.3, // Controla forma horizontal/vertical
  ),
  itemBuilder: (context, index) {
    final Charola charola = vm.charolas[index];
    return LayoutBuilder(
      builder: (context, constraints) {
        return AspectRatio(
                aspectRatio: 1.3,
                child: CharolaCard(
                  fecha: "${charola.fechaCreacion.day}/${charola.fechaCreacion.month}/${charola.fechaCreacion.year}",
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
                ),
              );
            },
          );
        },
      ),
                    ),
                  ),

                // 🔽 Siempre mostrar paginación si hay datos
                if (vm.charolas.isNotEmpty) ...[
                  Text(
                    "Página ${vm.pagActual} de ${vm.totalPags}",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 0.5),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE9EEF6),
                            foregroundColor: const Color(0xFF385881),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          onPressed: vm.pagActual > 1 ? vm.cargarPaginaAnterior : null,
                          icon: const Icon(Icons.arrow_back, size: 30),
                          label: const Text("Anterior"),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE9EEF6),
                            foregroundColor: const Color(0xFF385881),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          onPressed: vm.pagActual < vm.totalPags ? vm.cargarPaginaSiguiente : null,
                          icon: const Icon(Icons.arrow_forward, size: 30),
                          label: const Text("Siguiente"),
                        ),
                      ],
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