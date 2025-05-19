import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_nebrios_tracker/framework/views/seleccionarTamizadoView.dart';
import '../../data/models/charolaModel.dart' as modelo;
import '../viewmodels/tamizarCharolaViewmodel.dart';
import '../views/sidebarView.dart';
import '../views/registrarCharolaView.dart';

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

/// Vista principal que muestra todas las charolas en un ListView.
class VistaTamizadoIndividual extends StatefulWidget {
  const VistaTamizadoIndividual({super.key});

  @override
  State<VistaTamizadoIndividual> createState() =>
      _VistaTamizadoIndividualState();
}

class _VistaTamizadoIndividualState extends State<VistaTamizadoIndividual> {
  final List<modelo.CharolaTarjeta> nuevasCharolas = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Consumer<TamizadoViewModel>(
          builder: (context, seleccionVM, _) {
            if (seleccionVM.hasError && seleccionVM.errorMessage.isNotEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(seleccionVM.errorMessage),
                    backgroundColor: Colors.red,
                    duration: const Duration(seconds: 3),
                  ),
                );
              });
            }

            return ListView(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              children: [
                Center(
                  child: Text(
                    'Tamizar Charola',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Divider(color: Color(0xFF000000), thickness: 3),
                const SizedBox(height: 10),

                // ← Aquí envolvemos el botón "Regresar" en un Row para que no se expanda
                LayoutBuilder(
                  builder: (context, constraints) {
                    final fontSize = constraints.maxWidth * 0.012;
                    final iconSize = constraints.maxWidth * 0.015;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SidebarView(initialIndex: 1),
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            size: iconSize.clamp(20, 30),
                          ),
                          label: Text(
                            'Regresar',
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
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 16),
                const Text(
                  'Charolas Seleccionadas',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // Grid de charolas seleccionadas
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: seleccionVM.charolasParaTamizar.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.3,
                  ),
                  itemBuilder: (context, index) {
                    final modelo.CharolaTarjeta charola =
                        seleccionVM.charolasParaTamizar[index];
                    return AspectRatio(
                      aspectRatio: 1.3,
                      child: CharolaTarjeta(
                        fecha:
                            "${charola.fechaCreacion.day}/${charola.fechaCreacion.month}/${charola.fechaCreacion.year}",
                        nombreCharola: charola.nombreCharola,
                        color: obtenerColorPorNombre(charola.nombreCharola),
                        onTap: () {},
                      ),
                    );
                  },
                ),

                const SizedBox(height: 24),
                const Text(
                  'Datos del Tamizado',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                // FRAS & Alimento
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: seleccionVM.frasController,
                        decoration: const InputDecoration(
                          labelText: 'Fras (g)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Alimento',
                          border: OutlineInputBorder(),
                        ),
                        items:
                            seleccionVM.alimentos
                                .map(
                                  (tipo) => DropdownMenuItem(
                                    value: tipo,
                                    child: Text(tipo),
                                  ),
                                )
                                .toList(),
                        onChanged: (v) => seleccionVM.seleccionAlimentacion = v,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 1,
                      child: TextField(
                        controller: seleccionVM.alimentoCantidadController,
                        decoration: const InputDecoration(
                          labelText: 'Cantidad (g)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                // Pupa & Hidratación
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: seleccionVM.pupaController,
                        decoration: const InputDecoration(
                          labelText: 'Pupa (g)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Hidratación',
                          border: OutlineInputBorder(),
                        ),
                        items:
                            seleccionVM.hidratacion
                                .map(
                                  (tipo) => DropdownMenuItem(
                                    value: tipo,
                                    child: Text(tipo),
                                  ),
                                )
                                .toList(),
                        onChanged: (v) => seleccionVM.seleccionHidratacion = v,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 1,
                      child: TextField(
                        controller: seleccionVM.hidratacionCantidadController,
                        decoration: const InputDecoration(
                          labelText: 'Cantidad (g)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                      ),
                    ),
                  ],
                ),

                if (nuevasCharolas.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  const Text(
                    'Nuevas charolas',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: nuevasCharolas.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1.3,
                        ),
                    itemBuilder: (context, index) {
                      final modelo.CharolaTarjeta nueva = nuevasCharolas[index];
                      return AspectRatio(
                        aspectRatio: 1.3,
                        child: CharolaTarjeta(
                          fecha:
                              "${nueva.fechaCreacion.day}/${nueva.fechaCreacion.month}/${nueva.fechaCreacion.year}",
                          nombreCharola: nueva.nombreCharola,
                          color: obtenerColorPorNombre(nueva.nombreCharola),
                          onTap: () {},
                        ),
                      );
                    },
                  ),
                ],

                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () async {
                        final nueva =
                            await Navigator.push<modelo.CharolaTarjeta>(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const RegistrarCharolaView(),
                              ),
                            );
                        if (nueva != null) {
                          setState(() {
                            nuevasCharolas.add(nueva);
                          });
                          final ancestrosSeleccionados =
                              seleccionVM.charolasParaTamizar
                                  .map((c) => c.charolaId)
                                  .toList();
                          await seleccionVM.asignarAncestros(
                            charolaHijaId: nueva.charolaId,
                            ancestrosIds: ancestrosSeleccionados,
                          );
                        }
                      },
                      icon: const Icon(Icons.add, size: 24),
                      label: const Text('Registrar charola'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),
                        backgroundColor: Colors.pink,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: () async {
                        final exito =
                            await seleccionVM.tamizarCharolaIndividual();
                        if (exito) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => SidebarView(
                                    mensajeExito: 'Tamizado exitoso',
                                  ),
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.done, size: 24),
                      label: const Text('Finalizar Tamizado'),
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
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
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
  return Colors.grey;
}
