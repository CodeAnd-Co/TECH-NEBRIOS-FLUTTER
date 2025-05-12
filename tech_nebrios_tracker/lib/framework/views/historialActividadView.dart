import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/historialActividadViewmodel.dart';

class HistorialActvidadPopUp extends StatelessWidget {
  const HistorialActvidadPopUp({super.key});

  void mostrarPopUpHistorialActividad(BuildContext context) async {
    final vistaModelo = Provider.of<HistorialActividadViewmodel>(context, listen: false);
    await vistaModelo.historialActividad(1);

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
          content: vistaModelo.error ? 
          Padding(
            padding: const EdgeInsets.only(left: 20, top:10, bottom: 10),
            child: Text(vistaModelo.mensajeError, style: TextStyle(fontSize: 18)) 
          )
          
           : SingleChildScrollView(
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
                          vistaModelo.estadoCharola,
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,  color: vistaModelo.estadoCharolaColor ? Colors.green : Colors.red),
                        ),
                      ),
                    ),
                    buildDataCell(vistaModelo.fechaActualizacion),
                  ]),
                ],
              )
              ),

              const Divider(color: Colors.grey, thickness: 1),

              const Text(
                'Alimentación:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),

              vistaModelo.alimentacion.isEmpty 
              ? Padding(
                  padding: const EdgeInsets.only(left: 20, top:10, bottom: 10),
                  child: Text(
                    "Aún no hay datos de alimentacion en esta charola",
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                ) :

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                  columns: [
                    buildDataColumn('Tipo de alimento:'),
                    buildDataColumn('Cantidad otorgada:'),
                    buildDataColumn('Fecha de actualización:'),
                  ],
                  rows: vistaModelo.alimentacion
                    .map(
                      (alimento) => DataRow(cells: [
                        buildDataCell(alimento.nombre),
                        buildDataCell(alimento.cantidadOtorgada + " gr"),
                        buildDataCell(alimento.fechaOtorgada),
                      ]),
                    )
                    .toList(),
                  ),
                ),

              const Divider(color: Colors.grey, thickness: 1),

              const Text(
                'Hidratación:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),

              vistaModelo.hidratacion.isEmpty 
              ? Padding(
                  padding: const EdgeInsets.only(left: 20, top:10, bottom: 10),
                  child: Text(
                    "Aún no hay datos de hidratación en esta charola",
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                ) :

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                  columns: [
                    buildDataColumn('Tipo de hidratacion:'),
                    buildDataColumn('Cantidad otorgada:'),
                    buildDataColumn('Fecha de actualización:'),
                  ],
                  rows: vistaModelo.hidratacion
                    .map(
                      (hidratacion) => DataRow(cells: [
                        buildDataCell(hidratacion.nombre),
                        buildDataCell(hidratacion.cantidadOtorgada + " gr"),
                        buildDataCell(hidratacion.fechaOtorgada),
                      ]),
                    )
                    .toList(),
                  ),
                ),  
              const Divider(color: Colors.grey, thickness: 1),
              ]
            )
          )
          
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
          onPressed: () {
            mostrarPopUpHistorialActividad(context);
          },
          child: const Text('Historial de actividad'),
        ),
      ),
    );
  }
}