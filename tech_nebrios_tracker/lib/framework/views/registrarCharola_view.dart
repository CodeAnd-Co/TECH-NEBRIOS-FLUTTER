import 'package:flutter/material.dart';

class AlimentacionScreen extends StatefulWidget {
  const AlimentacionScreen({super.key});

  @override
  State<AlimentacionScreen> createState() => _AlimentacionScreenState();
}

class _AlimentacionScreenState extends State<AlimentacionScreen> {
  List<String> alimentos = ['ejemplo', 'ejemplo', 'ejemplo', 'ejemplo'];
  List<String> hidrataciones = ['ejemplo', 'ejemplo', 'ejemplo', 'ejemplo'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFA),
      body: Column(
        children: [
          const SizedBox(height: 40),
          const Text(
            "Modificar datos",
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 4.0),
            child: Divider(
              color: Color(0xFF385881),
              thickness: 2,
              height: 20,
            ),
          ),
          const Text(
            'Selecciona el dato a editar',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.pink,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  Expanded(
                    child: _buildColumnSection(
                      "Alimento",
                      alimentos,
                      onAdd: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            final TextEditingController _controller = TextEditingController();

                            return AlertDialog(
                              title: const Text('Nuevo alimento'),
                              content: TextField(
                                controller: _controller,
                                decoration: const InputDecoration(
                                  hintText: 'Ingrese el nombre del alimento',
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context), // cerrar sin guardar
                                  child: const Text('Cancelar'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    final nuevo = _controller.text.trim();
                                    if (nuevo.isNotEmpty) {
                                      setState(() {
                                        alimentos.add(nuevo);
                                      });
                                      Navigator.pop(context); // cerrar después de guardar
                                    }
                                  },
                                  child: const Text('Guardar'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildColumnSection(
                      "Hidratación",
                      hidrataciones,
                      onAdd: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            final TextEditingController _controller = TextEditingController();

                            return AlertDialog(
                              title: const Text('Nueva hidratación'),
                              content: TextField(
                                controller: _controller,
                                decoration: const InputDecoration(
                                  hintText: 'Ingrese el nombre de la nueva hidratación',
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context), // cerrar sin guardar
                                  child: const Text('Cancelar'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    final nuevo = _controller.text.trim();
                                    if (nuevo.isNotEmpty) {
                                      setState(() {
                                        alimentos.add(nuevo);
                                      });
                                      Navigator.pop(context); // cerrar después de guardar
                                    }
                                  },
                                  child: const Text('Guardar'),
                                ),
                              ],
                            );
                          },
                        );
                      },

                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColumnSection(
      String title, List<String> items, {required VoidCallback onAdd}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      // Encabezado con fondo verde y botón "+"
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: const BoxDecoration(
          color: Color(0xFF92D050),
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            IconButton(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      ),

      // Lista de filas (con fondo blanco solo en cada fila)
      ...items.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        return _buildRow(item, index);
      }).toList(),

    ],
  );

  }

  Widget _buildRow(String text, int index) {
    final bool isEven = index % 2 == 0;
    final Color backgroundColor = isEven ? Colors.white : Colors.grey.shade200;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      height: 48,
      color: backgroundColor,
      child: Row(
        children: [
          Expanded(child: Text(text)),
          IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {},
          ),
        ],
      ),
    );
  }


}
