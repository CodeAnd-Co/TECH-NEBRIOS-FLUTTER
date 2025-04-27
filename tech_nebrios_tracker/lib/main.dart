import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:tech_nebrios_tracker/data/repositories/charola_repository.dart';
//import 'package:tech_nebrios_tracker/domain/registrar_charola.dart';
//import 'package:tech_nebrios_tracker/framework/viewmodels/registrar_charola_viewmodel.dart';
import 'package:tech_nebrios_tracker/framework/views/tabla.view.dart';


void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: MaterialApp(
            title: 'Zustento App',
            //theme: ThemeData(primarySwatch: Colors.pink),
            home: const VistaTablaCharolas(),
          ),
        ),
      ),
    );
  }
}
