import 'detalleCharolaView.dart'; // Ajusta el path si es necesario
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/charolaViewModel.dart';
import '../../data/models/charolaModel.dart' as menuModel; // Alias para el modelo

/// Widget que representa una tarjeta individual de charola con diseño responsivo.
class CharolaTarjeta extends StatelessWidget {
  final String fecha;
  final String nombreCharola;
  final Color color;
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
class VistaCharolas extends StatelessWidget {
  const VistaCharolas({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Consumer<CharolaViewModel>(
          builder: (context, vm, _) {
            return Column(
              children: [
                const SizedBox(height: 16),
                const Text(
                  'Charolas',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Divider(color: Color(0xFF000000), thickness: 3),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final screenWidth = constraints.maxWidth;
                      final fontSize = screenWidth * 0.012;
                      final iconSize = screenWidth * 0.015;

                      return Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Buscar',
                                prefixIcon: const Icon(Icons.search),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                              ),
                              onChanged: (query) {
                                // TODO: filtrar vm.charolas según 'query'
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            onPressed: () {
                              // TODO: Navegar a registro de nueva charola
                            },
                            icon: Icon(Icons.add, size: iconSize.clamp(20, 30)),
                            label: Text(
                              'Registrar charola',
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
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),

                // Estado de carga
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
                          // Ahora CharolaTarjeta es el modelo, gracias al alias
                          final menuModel.CharolaTarjeta item =
                              vm.charolas[index];
                          return CharolaTarjeta(
                            fecha:
                                "${item.fechaCreacion.day}/${item.fechaCreacion.month}/${item.fechaCreacion.year}",
                            nombreCharola: item.nombreCharola,
                            color: obtenerColorPorNombre(item.nombreCharola),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      PantallaCharola(charolaId: item.charolaId),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),

                // Paginación
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

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              onPressed:
                                  vm.pagActual > 1 ? vm.cargarPaginaAnterior : null,
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
                                    horizontal: 22, vertical: 20),
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
                              onPressed: vm.pagActual < vm.totalPags
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
                                    horizontal: 20, vertical: 20),
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
