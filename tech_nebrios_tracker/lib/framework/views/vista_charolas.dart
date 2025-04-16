// lib/views/vista_charolas.dart

import 'package:flutter/material.dart';

class CharolaCard extends StatelessWidget {
  final String fecha;
  final String nombreCharola;
  final Color color;

  const CharolaCard({
    super.key,
    required this.fecha,
    required this.nombreCharola,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        mainAxisSize: MainAxisSize.min, // 🔧 Esto hace que se ajuste al contenido
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              fecha,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 24), // Puedes ajustar esto para centrar más si lo deseas
          Center(
            child: Text(
              nombreCharola,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 24), // Esto da espacio inferior y equilibra
        ],
      ),
    );
  }
}

class VistaCharolas extends StatelessWidget {
  const VistaCharolas({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Color> colores = [
      Colors.green,
      Colors.blue,
      Colors.pink,
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Charolas'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: 16,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemBuilder: (context, index) {
            return CharolaCard(
              fecha: "12/11/2025",
              nombreCharola: "C-111",
              color: colores[index % colores.length],
            );
          },
        ),
      ),
    );
  }
}
