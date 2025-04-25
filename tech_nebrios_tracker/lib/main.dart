import 'package:flutter/material.dart';

import './framework/views/components/pop_up.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(), // Usa un widget separado
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Popup.show(
              context: context,
              title: '¡Hola!',
              content: 'Este es un popup funcional',
              onConfirm: () {
                print('Confirmado');
              },
            );
          },
          child: const Text('Mostrar Popup'),
        ),
      ),
    );
  }
}