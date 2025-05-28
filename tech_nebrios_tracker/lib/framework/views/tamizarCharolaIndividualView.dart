import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import './components/FormFields.dart';
import '../../utils/positive_number_formatter.dart';
import '../../data/models/charolaModel.dart' as modelo;
import '../viewmodels/tamizarCharolaViewModel.dart';
import '../viewmodels/charolaViewModel.dart';
import '../views/registrarCharolaView.dart';
import 'components/header.dart';

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
class VistaTamizadoIndividual extends StatefulWidget {
  final VoidCallback onRegresar;
  const VistaTamizadoIndividual({super.key, required this.onRegresar});

  @override
  State<VistaTamizadoIndividual> createState() => _VistaTamizadoIndividualState();
}

class _VistaTamizadoIndividualState extends State<VistaTamizadoIndividual> {
  final List<modelo.CharolaRegistro> nuevasCharolas = [];
  final formKey2 = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final charolaVM = Provider.of<CharolaViewModel>(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Consumer<TamizadoViewModel>(
          builder: (context, seleccionVM, _) {
            return SingleChildScrollView(
            child: 
            Column(
              children: [
                const Header(
                  titulo: 'Tamizado Individual',
                  subtitulo: null,
                  showDivider: true,
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Charola seleccionada',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                ),
                const SizedBox(height: 16),

                /// Grid de charolas
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: seleccionVM.charolasParaTamizar.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.3,
                    ),
                    itemBuilder: (context, index) {
                      final modelo.CharolaTarjeta charola = seleccionVM.charolasParaTamizar[index];
                      return LayoutBuilder(
                        builder: (context, constraints) {
                          return AspectRatio(
                            aspectRatio: 1.3,
                            child: CharolaTarjeta(
                              fecha: "${charola.fechaCreacion.day}/${charola.fechaCreacion.month}/${charola.fechaCreacion.year}",
                              nombreCharola: charola.nombreCharola,
                              color: obtenerColorPorNombre(charola.nombreCharola),
                              onTap: () {},
                            ),
                          );
                        },
                      );
                    },
                  ),
                ), 
                const SizedBox(height: 16),  
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16), 
                  child: Divider(height: 1),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16), 
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Datos del Tamizado',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),
                Form(
                  key: formKey2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: CustomTextFormField(
                                label: 'Fras (g)',
                                controller: seleccionVM.frasController,
                                keyboardType: TextInputType.numberWithOptions(decimal: true),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                                  PositiveNumberFormatter(),
                                ],
                                maxLength: 7,
                                validator: (v) => v == null || v.isEmpty ? 'Ingresa cantidad' : null,
                              )
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 2,
                              child: CustomDropdownFormField(
                                label: 'Alimento', 
                                items: seleccionVM.alimentos.map((a) => a.nombreAlimento).toList(),
                                value: seleccionVM.seleccionAlimentacion?.nombreAlimento,
                                onChanged: (value) {
                                  seleccionVM.seleccionAlimentacion = seleccionVM.alimentos.firstWhere((a) => a.nombreAlimento == value);
                                },
                                validator: (v) => v == null || v.isEmpty ? 'Selecciona un alimento' : null,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 2,
                              child: CustomTextFormField(
                                label: 'Cantidad (g)', 
                                controller: seleccionVM.alimentoCantidadController,
                                keyboardType: TextInputType.numberWithOptions(decimal: true),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                                  PositiveNumberFormatter(),
                                ],
                                maxLength: 7,
                                validator: (v) => v == null || v.isEmpty ? 'Ingresa cantidad' : null,
                              )
                            ),
                            const SizedBox(width: 16),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: CustomTextFormField(
                                label: 'Pupa (g)', 
                                controller: seleccionVM.pupaController,
                                keyboardType: TextInputType.numberWithOptions(decimal: true),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                                  PositiveNumberFormatter(),
                                ],
                                maxLength: 7,
                                validator: (v) => v == null || v.isEmpty ? 'Ingresa cantidad' : null,
                              )
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 2,
                              child: CustomDropdownFormField(
                                label: 'Hidratación', 
                                items: seleccionVM.hidratacion.map((a) => a.nombreHidratacion).toList(),
                                value: seleccionVM.seleccionHidratacion?.nombreHidratacion, 
                                onChanged: (value) {
                                  seleccionVM.seleccionHidratacion = seleccionVM.hidratacion.firstWhere((a) => a.nombreHidratacion == value);
                                },
                                validator: (v) => v == null || v.isEmpty ? 'Selecciona una hidratación' : null,
                              )
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 2,
                              child: CustomTextFormField(
                                label: 'Cantidad (g)', 
                                controller: seleccionVM.hidratacionCantidadController,
                                keyboardType: TextInputType.numberWithOptions(decimal: true),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                                  PositiveNumberFormatter(),
                                ],
                                maxLength: 7,
                                validator: (v) => v == null || v.isEmpty ? 'Ingresa cantidad' : null,
                              )
                            ),
                            const SizedBox(width: 16),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                seleccionVM.cargando ? CircularProgressIndicator() :
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                      Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: () async {
                              final nueva =
                                  await Navigator.push<modelo.CharolaRegistro>(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const RegistrarCharolaView(postOnSave: false),
                                    ),
                                  );
                              if (nueva != null) {
                                setState(() {
                                  nuevasCharolas.add(nueva);
                                });
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
                              if(formKey2.currentState!.validate()){
                                final exito = await seleccionVM.tamizarCharolaIndividual(nuevasCharolas);
                                if (exito) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(seleccionVM.mensajeExitoso),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                  charolaVM.cargarCharolas();
                                  widget.onRegresar();
                                }else{
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(seleccionVM.errorMessage),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
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
                  ),
                ),       
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      if (nuevasCharolas.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        Divider(height: 1),
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            'Nuevas charolas',
                            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                          ),
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
                            final modelo.CharolaRegistro nueva = nuevasCharolas[index];
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
                        const SizedBox(height: 24),
                      ],
                    ],
                  ),
                ),
              ],
            )
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