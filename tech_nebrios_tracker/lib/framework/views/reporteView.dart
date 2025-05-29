import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/reporteViewModel.dart';
import '../views/components/header.dart';

class VistaTablaCharolas extends StatefulWidget {
  const VistaTablaCharolas({super.key});

  @override
  State<VistaTablaCharolas> createState() => _VistaTablaCharolasState();
}

class _VistaTablaCharolasState extends State<VistaTablaCharolas> {
  final int _itemsPerPage = 20;
  int _currentMaxItems = 20;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
    final vistaModelo = Provider.of<ReporteViewModel>(context, listen: false);
    vistaModelo.getDatos();
  });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          _currentMaxItems += _itemsPerPage;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vistaModelo = Provider.of<ReporteViewModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: RefreshIndicator(
        onRefresh: () async {
          await vistaModelo.getDatos();
          setState(() {
            _currentMaxItems = _itemsPerPage;
          });
        },
        child: ListView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            const Header(
              titulo: 'Obtener Datos',
              showDivider: true,
              subtitulo: null, // No usamos subtítulo aquí
            ),

            const Text(
              "Datos de todas las charolas",
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),

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
                          backgroundColor:
                              vistaModelo.errorGet ? Colors.red : Colors.green,
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    child: const Text(
                      "Descargar Excel",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),

            Text(
              vistaModelo.mensajeGet,
              textAlign: TextAlign.center,
              style: const TextStyle(fontFamily: 'Courier', fontSize: 20),
            ),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Table(
                border: TableBorder.all(),
                children: [
                  TableRow(
                    children: [
                      _buildHeader('Charola'),
                      _buildHeader('Fecha de creación'),
                      _buildHeader('Ultima actualización'),
                      _buildHeader('Ancestros de la charola'),
                      _buildHeader('Comida x Ciclo (g)'),
                      _buildHeader('Hidratación x Ciclo (g)'),
                      _buildHeader('Estado'),
                      _buildHeader('Densidad de larva'),
                    ],
                  ),
                  if (vistaModelo.valoresTabla != null)
                    ...List.generate(
                      (vistaModelo.valoresTabla!.length < _currentMaxItems
                          ? vistaModelo.valoresTabla!.length
                          : _currentMaxItems),
                      (i) {
                        final item = vistaModelo.valoresTabla![i];
                        return TableRow(
                          children: [
                            _buildCell('${item['nombreCharola'] ?? ''}'),
                            _buildCell('${item['fechaCreacion'] ?? ''}'),
                            _buildCell('${item['fechaActualizacion'] ?? ''}'),
                            _buildCell((item['charolaAncestros'] as List<dynamic>?)?.join(', ') ?? ''),
                            _buildCell('${item['comidaCiclo'] ?? ''}'),
                            _buildCell('${item['hidratacionCiclo'] ?? ''}'),
                            _buildCell('${item['estado'] ?? ''}'),
                            _buildCell('${item['densidadLarva'] ?? ''}'),
                          ],
                        );
                      },
                    ),
                ],
              ),
            ),

            if (vistaModelo.valoresTabla != null &&
                _currentMaxItems < vistaModelo.valoresTabla!.length)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
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
    return Container(padding: const EdgeInsets.all(8.0), child: Text(texto));
  }
}
