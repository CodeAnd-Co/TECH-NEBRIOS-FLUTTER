// RF29: Visualizar la información del Frass obtenido - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF29

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/frasViewModel.dart';
import 'components/header.dart';
import '../../data/models/frasModel.dart';

class FrasScreen extends StatefulWidget {
  const FrasScreen({super.key});
  @override
  _FrasScreenState createState() => _FrasScreenState();
}

class _FrasScreenState extends State<FrasScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FrasViewModel>().cargarFras();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Column(
        children: [
          const Header(titulo: 'Fras', showDivider: true, subtitulo: null),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Consumer<FrasViewModel>(
                builder: (context, frasVM, child) {
                  if (frasVM.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (frasVM.error != null) {
                    return Center(
                      child: Text(
                        frasVM.error!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }
                  final List<Fras> lista = frasVM.frasList;
                  if (lista.isEmpty) {
                    return const Center(
                      child: Text('No hay registros de Fras para mostrar.'),
                    );
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 16.0,
                    ),
                    itemCount: lista.length,
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 300,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 12,
                          childAspectRatio: 1.0,
                        ),
                    itemBuilder: (context, index) {
                      final item = lista[index];
                      return _buildFrasCard(item);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Construye cada tarjeta. 
  Widget _buildFrasCard(Fras data) {
    // Formateamos la fecha a “dd/MM/yyyy”
    final fechaStr =
        '${data.fechaRegistro.day.toString().padLeft(2, '0')}/'
        '${data.fechaRegistro.month.toString().padLeft(2, '0')}/'
        '${data.fechaRegistro.year}';

    return Card(
      margin: const EdgeInsets.all(4.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Column(
        children: [
          // ─── 1. Cabecera verde ─────────────────────────────────────────
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF2E7D32),
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 14.0),
                    child: Center(
                      child: Text(
                        'Fras Generado',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18, 
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFF43A047),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14.0),
                      child: Center(
                        child: Text(
                          'Producción',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ─── 2. Sección central (Expanded) ───────────────────────────────
          //      “gramos” + “nombreCharola” 
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16.0,
              ),
              child: Row(
                children: [
                  // Izquierda: número + “gramos”
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '${data.gramosGenerados.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize:
                                36, 
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'gramos',
                          style: TextStyle(
                            fontSize: 16, 
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Derecha: nombre de la charola
                  Expanded(
                    child: Center(
                      child: Text(
                        data.nombreCharola,
                        style: const TextStyle(
                          fontSize:
                              18, 
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ─── 3. Línea divisoria ────────────────────────────────────────
          const Divider(height: 1, thickness: 1, color: Colors.grey),

          // ─── 4. Pie de tarjeta (fecha + “Editar”) ────
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 25.0,
            ),
            child: Row(
              children: [
                // Fecha centrada en la mitad izquierda
                Expanded(
                  child: Center(
                    child: Text(
                      fechaStr,
                      style: const TextStyle(
                        fontSize:
                            17, 
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),

                // Botón “Editar” centrado en la mitad derecha
                Expanded(
                  child: Center(
                    child: InkWell(
                      onTap: () {
                        // Lógica para editar (por ejemplo:)
                        // Navigator.pushNamed(context, '/editarFras', arguments: data);
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.edit, size: 18, color: Colors.pink),
                          SizedBox(width: 4),
                          Text(
                            'Editar',
                            style: TextStyle(
                              fontSize:
                                  17, 
                              fontWeight: FontWeight.w600,
                              color: Colors.pink,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
