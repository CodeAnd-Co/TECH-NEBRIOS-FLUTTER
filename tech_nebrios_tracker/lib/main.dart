import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './framework/viewmodels/reporteViewModel.dart';
import 'framework/viewmodels/charolaViewModel.dart';
import 'framework/navigation/app_router.dart';
import 'framework/viewmodels/loginViewModel.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => CharolaViewModel()),
        ChangeNotifierProvider(create: (_) => ReporteViewModel())
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
        useMaterial3: true,
      ),
      home: Router(
        routerDelegate: AppRouter(),
        backButtonDispatcher: RootBackButtonDispatcher(),
      ),
    );
  }
}