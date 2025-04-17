import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_nebrios_tracker/framework/viewmodels/registrar_charola_viewmodel.dart';
import 'package:tech_nebrios_tracker/framework/views/registrar_charola_view.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => RegistrarCharolaViewModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: const RegistrarCharolaView());
  }
}
