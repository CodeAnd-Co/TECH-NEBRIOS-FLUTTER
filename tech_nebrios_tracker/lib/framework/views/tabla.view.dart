import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/tablaViewModel.dart';

class VistaTablaCharolas extends StatelessWidget {
  const VistaTablaCharolas({super.key});

  @override
  Widget build(BuildContext context){
    final viewModel = Provider.of<TablaViewModel>(context);
    viewModel.getTabla();

    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Color(0xFFF5F7FA),
        title: const Text('Obtener Datos', style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 35,
          color: Colors.black,
          fontWeight: FontWeight.w400,
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
          children: [
            const Divider(
              color: Colors.black,
              thickness: 2,
            ),
            const Text("Datos de todas las charolas", style: TextStyle(fontSize: 24)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              alignment: Alignment.centerRight, 
              child: ElevatedButton(
                onPressed: () {},
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
            ),
            const SizedBox(height: 20),
          
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Table(
            border: TableBorder.all(),
            children: [
            TableRow(
              children: [
                Container(
                  color: Color(0xFF95E446),
                  padding: EdgeInsets.all(8.0),
                  child: Text('Charola'),
                  
                ),
                Container(
                  color: Color(0xFF95E446),
                  padding: EdgeInsets.all(8.0),
                  child: Text('Fecha de creación'),
                ),
                Container(
                  color: Color(0xFF95E446),
                  padding: EdgeInsets.all(8.0),
                  child: Text('Ultima actualización'),
                ),
                Container(
                  color: Color(0xFF95E446),
                  padding: EdgeInsets.all(8.0),
                  child: Text('Peso'),
                ),
                Container(
                  color: Color(0xFF95E446),
                  padding: EdgeInsets.all(8.0),
                  child: Text('Comida x Ciclo'),
                ),
                Container(
                  color: Color(0xFF95E446),
                  padding: EdgeInsets.all(8.0),
                  child: Text('Hidratación x Ciclo'),
                ),
                Container(
                  color: Color(0xFF95E446),
                  padding: EdgeInsets.all(8.0),
                  child: Text('Estado'),
                ),
                Container(
                  color: Color(0xFF95E446),
                  padding: EdgeInsets.all(8.0),
                  child: Text('Densidad de larva'),
                ),
                
              ],
            ),
            ...List.generate(viewModel.valoresTabla!.length, (i) {
              final item = viewModel.valoresTabla![i];
              return TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('${item['nombreCharola'] ?? ''}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('${item['fechaCreacion'] ?? ''}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('${item['fechaActualizacion'] ?? ''}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('${item['pesoCharola'] ?? ''}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('${item['comidaCiclo'] ?? ''}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('${item['hidratacionCiclo'] ?? ''}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('${item['estado'] ?? ''}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('${item['densidadLarva'] ?? ''}'),
                  ),
                ],
              );
            }),
            ]
          ),
          )
          ]
        )
      )
      )
    );
  }
}