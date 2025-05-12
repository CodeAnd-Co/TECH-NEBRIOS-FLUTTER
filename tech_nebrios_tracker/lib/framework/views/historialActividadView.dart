import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistorialActvidadPopUp extends StatelessWidget {
  const HistorialActvidadPopUp({super.key});

  void mostrarPopUpHistorialActividad(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Stack(
            alignment: Alignment.center,
            children: [
              const Center(
                child: Text(
                  'Historial de Actividad',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Positioned(
                left: 0,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),

          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              const Divider(color: Colors.grey, thickness: 1),

              const Text(
                'Estado de la charola:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                columns: [
                  buildDataColumn('Estado actual:'),
                  buildDataColumn('Fecha de actualización:'),
                ],
                rows: [
                  DataRow(cells: [
                    DataCell(
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Activa",
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green),
                        ),
                      ),
                    ),
                    buildDataCell('2/05/2025'),
                  ]),
                ],
              )
              ),

              const Divider(color: Colors.grey, thickness: 1),

              const Text(
                'Alimentación:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                columns: [
                  buildDataColumn('Tipo de alimento:'),
                  buildDataColumn('Cantidad otorgada:'),
                  buildDataColumn('Fecha de actualización:'),
                ],
                rows: [
                  DataRow(cells: [
                    buildDataCell('Manzana'),
                    buildDataCell('10gr'),
                    buildDataCell('2/05/2025'),
                  ]),
                  DataRow(cells: [
                    buildDataCell('Pera'),
                    buildDataCell('3gr'),
                    buildDataCell('6/05/2025'),
                  ]),
                  DataRow(cells: [
                    buildDataCell('Salvado'),
                    buildDataCell('15gr'),
                    buildDataCell('12/05/2025'),
                  ]),
                ],
              ),
              ),

              const Divider(color: Colors.grey, thickness: 1),

              const Text(
                'Hidratación:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                columns: [
                  buildDataColumn('Tipo de hidratacion:'),
                  buildDataColumn('Cantidad otorgada:'),
                  buildDataColumn('Fecha de actualización:'),
                ],
                rows: [
                  DataRow(cells: [
                    buildDataCell('Zanahoria'),
                    buildDataCell('25gr'),
                    buildDataCell('2/05/2025'),
                  ]),
                ],
                ),
              ),

              const Divider(color: Colors.grey, thickness: 1),
              ]
            )
          ),
        );
      },
    );
  }

  DataColumn buildDataColumn(String texto) {
    return DataColumn(
      label: Container(
        height: 56,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(
          texto,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  DataCell buildDataCell(String texto) {
    return DataCell(
      Container(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          texto,
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Demo del Pop-up de Historial de Actividad')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => mostrarPopUpHistorialActividad(context),
          child: const Text('Historial de actividad'),
        ),
      ),
    );
  }
}