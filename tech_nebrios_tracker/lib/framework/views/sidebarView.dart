import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zuustento_tracker/framework/viewmodels/tamizarCharolaViewModel.dart';
import 'package:zuustento_tracker/framework/views/charolasDashboardView.dart';
import 'package:zuustento_tracker/framework/views/reporteView.dart';
import 'package:zuustento_tracker/framework/views/alimentacionView.dart';
import 'package:zuustento_tracker/framework/views/seleccionarTamizadoView.dart';
import './detalleCharolaView.dart';
import './tamizarCharolaIndividualView.dart';

class SidebarView extends StatefulWidget {
  final VoidCallback? onLogout;
  final int initialIndex;
  final String? mensajeExito;

  const SidebarView({
    Key? key,
    this.onLogout,
    this.initialIndex = 0,
    this.mensajeExito,
  }) : super(key: key);

  @override
  State<SidebarView> createState() => _SidebarViewState();
}

class _SidebarViewState extends State<SidebarView> {
  int _currentIndex = 0;
  bool _mensajeMostrado = false;
  Widget? _detalleCharolaActual;
  Widget? _vistaTamizadoIndividual;

  void _mostrarDetalleCharola(int id) {
    setState(() {
      _detalleCharolaActual = PantallaCharola(
        charolaId: id,
        onRegresar: _cerrarDetalleCharola,
      );
    });
  }

  void _cerrarDetalleCharola() {
    setState(() {
      _detalleCharolaActual = null;
    });
  }

  void _mostrarVistaTamizadoIndividual() {
    setState(() {
      _vistaTamizadoIndividual = VistaTamizadoIndividual(
        onRegresar: _cerrarVistaTamizado,
      );
    });
  }

  void _cerrarVistaTamizado() {
    setState(() {
      _currentIndex = 1;
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.mensajeExito != null && !_mensajeMostrado) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.mensajeExito!),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      });
      _mensajeMostrado = true; // Limpiar el mensaje después de mostrarlo
    }
    _currentIndex = widget.initialIndex;
  }

  List<Widget> get _views {
    if (_detalleCharolaActual != null) {
      return [_detalleCharolaActual!];
    }

    if (_vistaTamizadoIndividual != null) {
      return [_vistaTamizadoIndividual!];
    }

    return [
      VistaCharolas(onVerDetalle: _mostrarDetalleCharola),
      VistaSeleccionarTamizado(),
      const Placeholder(),
      const AlimentacionScreen(),
      const VistaTablaCharolas(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 85,
            color: Colors.black,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  children: [
                    // Scrollable section
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            Image.asset(
                              'assets/images/zuustento.png',
                              width: 100,
                              height: 100,
                            ),
                            const SizedBox(height: 20),
                            _buildNavItem(
                              icon: Icons.inventory_2,
                              label: 'Charolas',
                              index: 0,
                            ),
                            const SizedBox(height: 20),
                            _buildNavItem(
                              icon: Icons.storage,
                              label: 'Tamizar',
                              index: 1,
                            ),
                            // const SizedBox(height: 20),
                            // _buildNavItem(icon: Icons.archive, label: 'Frass', index: 2),
                            const SizedBox(height: 20),
                            _buildNavItem(
                              icon: Icons.edit_note,
                              label: 'Nutrición',
                              index: 3,
                            ),
                            const SizedBox(height: 20),
                            _buildNavItem(
                              icon: Icons.download,
                              label: 'Excel',
                              index: 4,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Fixed logout button
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: IconButton(
                        icon: const Icon(Icons.logout, color: Colors.red),
                        onPressed:
                            widget.onLogout ??
                            () {}, // ✅ Si no se pasa, no hace nada
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // Vista activa
          Expanded(
            child: IndexedStack(
              index: 0, // Siempre 0 porque solo hay un widget visible
              children: [_views[_currentIndex]],
            ),
          ),
        ],
      ),
    );
  }

  /// Crea un botón de navegación con ícono y etiqueta opcional.
  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = _currentIndex == index && _detalleCharolaActual == null;

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.of(context).size.width;
        final sidebarWidth = constraints.maxWidth;

        final iconSize = sidebarWidth * 0.35;
        final fontSize = sidebarWidth * 0.18;
        final showLabel = screenWidth > 500;

        return InkWell(
          onTap: () {
            setState(() {
              _currentIndex = index;
              _detalleCharolaActual =
                  null; // ✅ Siempre cierra detalle si navegas
            });

            if (index == 1) {
              final viewModel = Provider.of<TamizadoViewModel>(
                context,
                listen: false,
              );
              viewModel.limpiarInformacion();
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: Colors.white, size: iconSize.clamp(18, 32)),
                const SizedBox(height: 4),
                if (showLabel)
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: fontSize.clamp(8, 13),
                      color: Colors.white.withOpacity(isSelected ? 1 : 0.6),
                    ),
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
