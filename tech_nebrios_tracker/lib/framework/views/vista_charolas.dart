// lib/views/vista_charolas.dart
import 'package:flutter/material.dart';

class CharolaCard extends StatelessWidget {
  final String fecha;
  final String nombreCharola;
  final Color color;
  final VoidCallback onTap;

  const CharolaCard({
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
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: SizedBox(
            width: 160,
            height: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    fecha,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      nombreCharola,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class VistaCharolas extends StatelessWidget {
  const VistaCharolas({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Color> colores = [
      const Color(0xFF22A63A),
      const Color(0xFF3CB3C8),
      const Color(0xFFE2387B),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            const Text(
              'Charolas',
              style: TextStyle(
                fontSize: 32, 
              ),
            ),
            const SizedBox(height: 8),
            const Divider( 
              color: Color(0xFF385881),
              thickness: 3,
              // indent: 32,
              // endIndent: 32,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GridView.builder(
                  itemCount: 16,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 220,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.3,
                  ),
                  itemBuilder: (context, index) {
                    return CharolaCard(
                      fecha: "12/11/2025",
                      nombreCharola: "C-111",
                      color: colores[index % colores.length],
                      onTap: () {
                        // Puedes cambiar esto por navegación u otro modal
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Charola seleccionada"),
                            content: Text("Has tocado la charola C-111 (índice $index)"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Cerrar"),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
