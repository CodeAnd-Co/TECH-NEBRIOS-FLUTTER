import 'package:flutter/material.dart';

import 'framework/views/components/organisms/pop_up.dart';
import 'framework/views/components/atoms/boton_texto.dart';

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
        child: BotonTexto.simple(
          texto: 'Mostrar Popup',
          alPresionar: () {
            Popup.show(
              context: context,
              title: '¡Hola!',
              content: 'Este es un popup funcional',
              onConfirm: () {
                print('Confirmado');
              },
            );
          },
        ),
      ),
    );
  }
}