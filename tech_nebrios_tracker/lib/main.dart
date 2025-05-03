import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './framework/viewmodels/tablaViewModel.dart';
import './domain/tablaUseCases.dart';
import 'package:tech_nebrios_tracker/framework/views/tabla.view.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create:
              (_) => TablaViewModel(
                TablaUseCasesImp(),
              ),
        ),
      ],
      child: MaterialApp(
        title: 'Zustento App',
        theme: ThemeData(primarySwatch: Colors.pink),
        home: const VistaTablaCharolas(),
      ),
    );
  }
}
