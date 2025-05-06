import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'framework/viewmodels/menu_charolas.viewmodel.dart';
import 'framework/navigation/app_router.dart';
import 'framework/viewmodels/loginViewmodel.dart';

/// Punto de entrada de la aplicación.
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => CharolaVistaModelo()),
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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
        useMaterial3: true,
      ),
      home: Router(
        routerDelegate: AppRouter(),
        backButtonDispatcher: RootBackButtonDispatcher(),
      ),
    );
  }
}
