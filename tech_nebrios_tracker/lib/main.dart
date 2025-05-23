import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';
import 'dart:io';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'framework/viewmodels/historialActividadViewmodel.dart';
import 'framework/viewmodels/reporteViewModel.dart';
import 'framework/viewmodels/charolaViewModel.dart';
import 'framework/navigation/app_router.dart';
import 'framework/viewmodels/loginViewModel.dart';
import 'framework/viewmodels/tamizarCharolaViewModel.dart';
import 'framework/viewmodels/editarCharolaViewModel.dart';
import 'framework/viewmodels/alimentacionViewModel.dart';

/// Punto de entrada principal para la aplicación Tech Nebrios Tracker.
///
/// Inicializa los bindings de Flutter y establece un tamaño mínimo de ventana
/// cuando se ejecuta en Windows, Linux o macOS. Luego ejecuta la aplicación.
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowMinSize(const Size(1000, 700)); // Tamaño mínimo deseado
    // setWindowMaxSize(const Size(1600, 1200)); // (opcional) Tamaño máximo
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => CharolaViewModel()),
        ChangeNotifierProvider(create: (_) => TamizadoViewModel()),
        ChangeNotifierProvider(create: (_) => ReporteViewModel()),
        ChangeNotifierProvider(create: (_) => HistorialActividadViewmodel()),
        ChangeNotifierProvider(create: (_) => EditarCharolaViewModel()),
        ChangeNotifierProvider(create: (_) => AlimentacionViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

/// Clase principal que define la estructura básica de la app.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zuustento Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      builder: (context, child) {
        return Router(
          routerDelegate: AppRouter(),
          backButtonDispatcher: RootBackButtonDispatcher(),
        );
      },
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', ''), // Español
      ],
      locale: const Locale('es', ''), // Establecer el idioma por defecto
    );
  }
}