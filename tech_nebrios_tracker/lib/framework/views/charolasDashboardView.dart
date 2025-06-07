// RF16 Visualizar todas las charolas registradas en el sistema - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF16
// RF6 Buscar charolas por nombre - https://codeandco-wiki.netlify.app/docs/next/proyectos/larvas/documentacion/requisitos/RF6

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../viewmodels/charolaViewModel.dart';
import '../../data/models/charolaModel.dart' as modelo;
import './registrarCharolaView.dart';
import './components/header.dart';

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
class VistaCharolas extends StatefulWidget {
  final void Function(int charolaId) onVerDetalle;

  const VistaCharolas({super.key, required this.onVerDetalle});

  @override
  State<VistaCharolas> createState() => _VistaCharolasState();
}


class _VistaCharolasState extends State<VistaCharolas> {
  DateTimeRange? rangoFechas;
  final TextEditingController rangoController = TextEditingController();

  @override
  void dispose() {
    rangoController.dispose();
    super.dispose();
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xFFF5F7FA),
    body: SafeArea(
      child: Consumer<CharolaViewModel>(
        builder: (context, vm, _) {
          // Mostrar error fuera del ciclo de build
          if (vm.mensajeError != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(vm.mensajeError!),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 2),
                ),
              );
              vm.mostrarErrorSnackBar(""); // limpia después de mostrar
            });
          }

            return Column(
              children: [
                const Header(
                  titulo: 'Charolas',
                  showDivider: true,
                  subtitulo: null, // No usas subtítulo en esta pantalla
                ),
                // const SizedBox(height: 4),
                // Reemplaza el bloque que contiene el Row del buscador, filtro y registrar charola por este:
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Buscar Charola
                      Expanded(
                        flex: 2,
                        child: SizedBox(
                          height: 44,
                          child: TextField(
                            controller: vm.busquedaController,
                            onChanged: (value) {
                              vm.filtrarCharolas(value);
                              if (value.length == 20) {
                                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Máximo 20 caracteres permitidos.'),
                                    backgroundColor: Colors.red,
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              }
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\-]')),
                              LengthLimitingTextInputFormatter(20),
                            ],
                            decoration: InputDecoration(
                              hintText: 'Buscar Charola',
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Rango de fechas
                      Expanded(
                        flex: 2,
                        child: SizedBox(
                          height: 44,
                          child: TextFormField(
                            controller: rangoController,
                            readOnly: true,
                            decoration: InputDecoration(
                              hintText: 'Rango de fechas',
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              prefixIcon: const Icon(Icons.date_range),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.clear),
                                tooltip: 'Limpiar filtro',
                                onPressed: () {
                                  setState(() {
                                    rangoFechas = null;
                                    rangoController.clear();
                                  });
                                  context.read<CharolaViewModel>().cargarCharolas(reset: true);
                                },
                              ),
                              border: const OutlineInputBorder(),
                            ),
                            onTap: () async {
                              final DateTime now = DateTime.now();

                              final DateTime? fechaInicio = await showDatePicker(
                                context: context,
                                initialDate: now.subtract(const Duration(days: 7)),
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2050),
                                locale: const Locale('es', 'ES'),
                                cancelText: 'Cancelar',
                                confirmText: 'Aceptar',
                                helpText: 'Inicio',
                              );

                              if (fechaInicio == null) return;

                              final DateTime? fechaFin = await showDatePicker(
                                context: context,
                                initialDate: now,
                                firstDate: fechaInicio,
                                lastDate: DateTime(2050),
                                locale: const Locale('es', 'ES'),
                                cancelText: 'Cancelar',
                                confirmText: 'Aceptar',
                                helpText: 'Fin',
                              );

                              if (fechaFin == null) return;

                              setState(() {
                                rangoFechas = DateTimeRange(start: fechaInicio, end: fechaFin);
                                rangoController.text =
                                    "${fechaInicio.day}/${fechaInicio.month}/${fechaInicio.year} a ${fechaFin.day}/${fechaFin.month}/${fechaFin.year}";
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Botón Filtrar
                      SizedBox(
                        height: 44,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            if (rangoFechas != null) {
                              context.read<CharolaViewModel>().filtrarPorFechas(
                                    rangoFechas!.start,
                                    rangoFechas!.end,
                                  );
                            }
                          },
                          icon: const Icon(Icons.search),
                          label: const Text('Filtrar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE2387B),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Botón Registrar charola
                      SizedBox(
                        height: 44,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => RegistrarCharolaView(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Registrar charola'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0066FF),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),
                /// Toggle Activas / Pasadas
                ToggleButtons(
                  isSelected: [
                    vm.estadoActual == 'activa',
                    vm.estadoActual == 'pasada',
                  ],
                  onPressed: (index) {
                    final estado = index == 0 ? 'activa' : 'pasada';
                    vm.cambiarEstado(estado);
                    vm.busquedaController.clear();
                    vm.filtrarCharolas('');
                  },
                  borderRadius: BorderRadius.circular(10),
                  selectedColor: Colors.white,
                  fillColor: const Color(0xFF0066FF),
                  color: Colors.black87,
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  constraints: const BoxConstraints(
                    minHeight: 40,
                    minWidth: 150,
                  ),
                  children: const [Text('Activas'), Text('Pasadas')],
                ),
                const SizedBox(height: 10),

                /// Carga inicial
                if (vm.cargandoLista && vm.charolas.isEmpty)
                  const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  )
                /// Mensaje cuando no hay resultados
                else if (!vm.cargandoLista &&
                    vm.charolas.isEmpty &&
                    vm.busquedaController.text.isEmpty)
                  Expanded(
                    child: Center(
                      child: Text(
                        rangoFechas != null
                            ? 'No hay charolas registradas en esa fecha 🧺'
                            : 'No hay charolas registradas 🧺',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                /// Mensaje cuando la búsqueda no encuentra resultados
                else if (!vm.cargandoLista &&
                    vm.charolasFiltradas.isEmpty &&
                    vm.busquedaController.text.isNotEmpty)
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Charola no encontrada. Verifica el nombre ingresado.',
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
                        itemCount: vm.charolasFiltradas.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 5,
                              crossAxisSpacing: 4,
                              // mainAxisSpacing: 16,
                              childAspectRatio: 1.3,
                            ),
                        itemBuilder: (context, index) {
                          final modelo.CharolaTarjeta charola =
                              vm.charolasFiltradas[index];
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
                                  onTap: () async {
                                    final vmCharola =
                                        context.read<CharolaViewModel>();
                                    await vmCharola.cargarCharola(
                                      charola.charolaId,
                                    );

                                    if (vmCharola.charola != null) {
                                      widget.onVerDetalle(charola.charolaId);
                                    }
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
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
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
                                  vm.pagActual > 1
                                      ? vm.cargarPaginaAnterior
                                      : null,
                              icon: Icon(
                                Icons.arrow_back,
                                size: iconSize.clamp(26, 32),
                              ),
                              label: Text(
                                "Anterior",
                                style: TextStyle(
                                  fontSize: fontSize.clamp(19, 22),
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFE9EEF6),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 18,
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
                            ElevatedButton(
                              onPressed:
                                  vm.pagActual < vm.totalPags
                                      ? vm.cargarPaginaSiguiente
                                      : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFE9EEF6),
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
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Siguiente",
                                    style: TextStyle(
                                      fontSize: fontSize.clamp(19, 22),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Icon(
                                    Icons.arrow_forward,
                                    size: iconSize.clamp(26, 32),
                                  ),
                                ],
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
