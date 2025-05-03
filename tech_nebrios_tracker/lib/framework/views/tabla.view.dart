import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/tablaViewModel.dart';

class VistaTablaCharolas extends StatefulWidget {
  const VistaTablaCharolas({super.key});

  @override
  State<VistaTablaCharolas> createState() => _VistaTablaCharolasState();
}

class _VistaTablaCharolasState extends State<VistaTablaCharolas> {
  @override
  void initState() {
    super.initState();
    final viewModel = Provider.of<TablaViewModel>(context, listen: false);
    viewModel.getTabla();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<TablaViewModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F7FA),
        title: const Text('Obtener Datos', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 35,
          color: Colors.black,
          fontWeight: FontWeight.w400,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await viewModel.getTabla();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(), 
          child: Center(
            child: Column(
              children: [
                const Divider(color: Colors.black, thickness: 2),
                const Text("Datos de todas las charolas", style: TextStyle(fontSize: 24)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        viewModel.estadoDescarga,
                        style: const TextStyle(fontFamily: 'Courier'),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: viewModel.postDescargarArchivo,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                        child: const Text("Descargar Excel"),
                      ),
                    ],
                  ),
                ),

                Text(
                  viewModel.mensajeGet,
                  style: const TextStyle(fontFamily: 'Courier'),
                ),

                const SizedBox(height: 20),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: 
                  
                  Table(
                    border: TableBorder.all(),
                    children: [
                      TableRow(
                        children: [
                          _buildHeader('Charola'),
                          _buildHeader('Fecha de creación'),
                          _buildHeader('Ultima actualización'),
                          _buildHeader('Peso (gr)'),
                          _buildHeader('Comida x Ciclo (gr)'),
                          _buildHeader('Hidratación x Ciclo(gr)'),
                          _buildHeader('Estado'),
                          _buildHeader('Densidad de larva'),
                        ],
                      ),
                      if (viewModel.valoresTabla != null)
                        ...List.generate(viewModel.valoresTabla!.length, (i) {
                          final item = viewModel.valoresTabla![i];
                          return TableRow(
                            children: [
                              _buildCell('${item['nombreCharola'] ?? ''}'),
                              _buildCell('${item['fechaCreacion'] ?? ''}'),
                              _buildCell('${item['fechaActualizacion'] ?? ''}'),
                              _buildCell('${item['pesoCharola'] ?? ''}'),
                              _buildCell('${item['comidaCiclo'] ?? ''}'),
                              _buildCell('${item['hidratacionCiclo'] ?? ''}'),
                              _buildCell('${item['estado'] ?? ''}'),
                              _buildCell('${item['densidadLarva'] ?? ''}'),
                            ],
                          );
                        }),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String texto) {
    return Container(
      color: const Color(0xFF95E446),
      padding: const EdgeInsets.all(8.0),
      child: Text(texto),
    );
  }

  Widget _buildCell(String texto) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Text(texto),
    );
  }
}
