import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'framework/views/menu_charolas.view.dart';
import 'framework/viewmodels/menu_charolas.viewmodel.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CharolaVistaModelo()..cargarCharolas()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Charolas App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        useMaterial3: true,
      ),
      home: const VistaCharolas(),
    );
  }
}
