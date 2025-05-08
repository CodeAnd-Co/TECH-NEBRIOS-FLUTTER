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
    final vistaModelo = Provider.of<TablaViewModel>(context, listen: false);
    vistaModelo.getTabla();
  }

  @override
  Widget build(BuildContext context) {
    final vistaModelo = Provider.of<TablaViewModel>(context);

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
          await vistaModelo.getTabla();
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
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () async {
                        await vistaModelo.postDescargarArchivo();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: vistaModelo.errorGet ? Colors.red : Colors.green,
                            content: Text(vistaModelo.estadoDescarga),
                            duration: const Duration(seconds: 5),
                          ),
                        );
                      },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                        child: const Text("Descargar Excel", style: TextStyle(fontSize: 20)),
                        
                      ),
                    ],
                  ),
                ),

                Text(
                  vistaModelo.mensajeGet,
                  style: const TextStyle(fontFamily: 'Courier', fontSize: 20),
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
                      if (vistaModelo.valoresTabla != null)
                        ...List.generate(vistaModelo.valoresTabla!.length, (i) {
                          final item = vistaModelo.valoresTabla![i];
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
  return TableCell(
    verticalAlignment: TableCellVerticalAlignment.middle,
    child: Container(
      color: const Color(0xFF95E446),
      padding: const EdgeInsets.all(8.0),
      height: 90,
      alignment: Alignment.center,
      child: Text(
        texto,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 18),
      ),
    ),
  );
}


  Widget _buildCell(String texto) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Text(texto),
    );
  }
}
