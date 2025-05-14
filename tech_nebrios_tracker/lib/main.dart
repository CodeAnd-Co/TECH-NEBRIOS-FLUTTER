import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';
import 'dart:io';

import 'framework/views/alimentacionView.dart';

/// Punto de entrada principal para la aplicación Tech Nebrios Tracker.
///
/// Inicializa los bindings de Flutter y establece un tamaño mínimo de ventana
/// cuando se ejecuta en Windows, Linux o macOS. Luego ejecuta la aplicación.
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Establece un tamaño mínimo de ventana en plataformas de escritorio
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowMinSize(const Size(800, 600));
  }

  runApp(const NebriosApp());
}

/// Clase principal de la aplicación Tech Nebrios Tracker.
///
/// Esta clase configura los proveedores y el tema general de la aplicación,
/// así como la pantalla inicial (`AlimentacionScreen`).
class NebriosApp extends StatelessWidget {
  /// Constructor constante para [NebriosApp].
  const NebriosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        /// Proveedor temporal para evitar errores de inicialización.
        Provider(create: (_) => 'dummy'),

        // Aquí puedes agregar tus proveedores reales como:
        // ChangeNotifierProvider(create: (_) => AlimentacionViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Tech Nebrios Tracker',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          useMaterial3: true,
        ),

        /// Pantalla inicial de la aplicación.
        home: const AlimentacionScreen(),

        // En producción puedes usar un enrutador personalizado como:
        // home: Router(
        //   routerDelegate: AppRouter(),
        //   backButtonDispatcher: RootBackButtonDispatcher(),
        // ),
      ),
    );
  }
}
