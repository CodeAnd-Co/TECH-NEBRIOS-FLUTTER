import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_nebrios_tracker/framework/views/historial_ancestros_view.dart';

import 'framework/viewmodels/historial_ancestros_viewmodel.dart';

import 'data/services/historial_ancestros_service.dart';
import 'data/repositories/historial_ancestros_repository.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => HistorialAncestrosViewModel(
        HistorialAncestrosRepository(
          HistorialAncestrosService(),
        ),
      ),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Historial Charolas',
      theme: ThemeData(primarySwatch: Colors.blue),
      // Pasa el charolaId que quieras visualizar
      home: const HistorialAncestrosScreen(charolaId: 1),
    );
  }
}
