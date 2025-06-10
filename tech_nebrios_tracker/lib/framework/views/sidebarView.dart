import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zuustento_tracker/framework/viewmodels/tamizarCharolaViewModel.dart';
import 'package:zuustento_tracker/framework/views/charolasDashboardView.dart';
import 'package:zuustento_tracker/framework/views/reporteView.dart';
import 'package:zuustento_tracker/framework/views/alimentacionView.dart';
import 'package:zuustento_tracker/framework/views/seleccionarTamizadoView.dart';
import 'package:zuustento_tracker/framework/views/usuarioView.dart';
import './detalleCharolaView.dart';
import './tamizarCharolaIndividualView.dart';
import './frasView.dart';

class SidebarView extends StatefulWidget {
  /// Callback para cerrar sesión (se muestra popup en AppRouter)
  final VoidCallback? onLogout;

  /// Índice inicial (puede venir de un mensaje de éxito)
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

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;

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
      _mensajeMostrado = true;
    }
  }

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
      _vistaTamizadoIndividual = null;
      _currentIndex = 1;
    });
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
     FrasScreen(charolaId: _currentIndex,), 
      const AlimentacionScreen(),
      const VistaTablaCharolas(),
      VistaUsuario()
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // ─── Sidebar ──────────────────────────────────────────
          Container(
            width: 85,
            color: Colors.black,
            child: Column(
              children: [
                const SizedBox(height: 20),
                Image.asset(
                  'assets/images/zuustento.png',
                  width: 50,
                  height: 50,
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildNavItem(icon: Icons.inventory_2, label: 'Charolas', index: 0),
                        const SizedBox(height: 20),
                        _buildNavItem(icon: Icons.storage,     label: 'Tamizar', index: 1),
                        const SizedBox(height: 20),
                        _buildNavItem(icon: Icons.grass,       label: 'Fras',    index: 2),
                        const SizedBox(height: 20),
                        _buildNavItem(icon: Icons.edit_note,   label: 'Nutrición', index: 3),
                        const SizedBox(height: 20),
                        _buildNavItem(icon: Icons.download,    label: 'Excel',   index: 4),
                        const SizedBox(height: 20),
                        _buildNavItem(icon: Icons.person, label: 'Usuarios', index: 5)
                      ],
                    ),
                  ),
                ),
                // ─── Botón Cerrar Sesión ────────────────────────────
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: IconButton(
                    icon: const Icon(Icons.logout, color: Colors.red),
                    onPressed: widget.onLogout,
                    tooltip: 'Cerrar sesión',
                  ),
                ),
              ],
            ),
          ),

          // ─── Vista Activa ─────────────────────────────────────
          Expanded(
            child: IndexedStack(
              index: _currentIndex, // siempre 0 porque _views devuelve sólo un elemento
              children: _views,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = _currentIndex == index && _detalleCharolaActual == null;

    return InkWell(
      onTap: () {
        setState(() {
          _currentIndex = index;
          _detalleCharolaActual = null;
          _vistaTamizadoIndividual = null;
        });

        if (index == 1) {
          // limpia datos específicos de tamizado
          final viewModel = Provider.of<TamizadoViewModel>(context, listen: false);
          viewModel.limpiarInformacion();
        }
      },
      child: Column(
        children: [
          Icon(icon, color: Colors.white.withOpacity(isSelected ? 1 : 0.6), size: 28),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(isSelected ? 1 : 0.6),
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}