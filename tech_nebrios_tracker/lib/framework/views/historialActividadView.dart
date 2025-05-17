import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/historialActividadViewmodel.dart';

void mostrarPopUpHistorialActividad({
  required BuildContext context,
  required int charolaId,
}) {
  showDialog(
    context: context,
    builder: (dialogContext) {
      return FutureBuilder(
        future: Provider.of<HistorialActividadViewmodel>(dialogContext, listen: false)
            .historialActividad(charolaId),
        builder: (context, snapshot) {
          final vistaModelo = Provider.of<HistorialActividadViewmodel>(context);

          if (snapshot.connectionState != ConnectionState.done) {
            return const AlertDialog(
              content: SizedBox(
                height: 100,
                child: Center(child: CircularProgressIndicator()),
              ),
            );
          }

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
            content: vistaModelo.error
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      vistaModelo.mensajeError,
                      style: const TextStyle(fontSize: 18, color: Colors.red),
                    ),
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
                                  Text(
                                    vistaModelo.estadoCharola,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: vistaModelo.estadoCharolaColor
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  ),
                                ),
                                buildDataCell(vistaModelo.fechaActualizacion),
                              ]),
                            ],
                          ),
                        ),
                        const Divider(color: Colors.grey, thickness: 1),
                        const Text(
                          'Alimentación:',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        vistaModelo.alimentacion.isEmpty
                            ? const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "Aún no hay datos de alimentación en esta charola",
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.red),
                                ),
                              )
                            : SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  columns: [
                                    buildDataColumn('Tipo de alimento:'),
                                    buildDataColumn('Cantidad otorgada:'),
                                    buildDataColumn('Fecha de actualización:'),
                                  ],
                                  rows: vistaModelo.alimentacion
                                      .map(
                                        (a) => DataRow(cells: [
                                          buildDataCell(a.nombre),
                                          buildDataCell('${a.cantidadOtorgada} gr'),
                                          buildDataCell(a.fechaOtorgada),
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
                            ? const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "Aún no hay datos de hidratación en esta charola",
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.red),
                                ),
                              )
                            : SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  columns: [
                                    buildDataColumn('Tipo de hidratación:'),
                                    buildDataColumn('Cantidad otorgada:'),
                                    buildDataColumn('Fecha de actualización:'),
                                  ],
                                  rows: vistaModelo.hidratacion
                                      .map(
                                        (h) => DataRow(cells: [
                                          buildDataCell(h.nombre),
                                          buildDataCell('${h.cantidadOtorgada} gr'),
                                          buildDataCell(h.fechaOtorgada),
                                        ]),
                                      )
                                      .toList(),
                                ),
                              ),
                        const Divider(color: Colors.grey, thickness: 1),
                      ],
                    ),
                  ),
          );
        },
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
