import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'framework/views/menu_charolas.view.dart';
import 'framework/viewmodels/menu_charolas.viewmodel.dart';

/// Punto de entrada de la aplicación.
void main() {
  runApp(
    MultiProvider(
      providers: [
        /// Proveedor global del ViewModel de charolas.
        ChangeNotifierProvider(create: (_) => CharolaVistaModelo()..cargarCharolas()),
      ],
      child: const MenuCharolas(),
    ),
  );
}

/// Clase principal que define la estructura básica de la app.
class MenuCharolas extends StatelessWidget {
  const MenuCharolas({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Charolas App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        useMaterial3: true,
      ),
      home: const VistaCharolas(), // Pantalla inicial
    );
  }
}
