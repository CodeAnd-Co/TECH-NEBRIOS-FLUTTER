import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_nebrios_tracker/data/repositories/charola_repository.dart';
import 'package:tech_nebrios_tracker/domain/registrar_charola.dart';
import 'package:tech_nebrios_tracker/framework/viewmodels/registrar_charola_viewmodel.dart';
import 'package:tech_nebrios_tracker/framework/views/registrar_charola_view.dart';

void main() {
  runApp(const ZustentoApp());
}

class ZustentoApp extends StatelessWidget {
  const ZustentoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create:
              (_) => RegistrarCharolaViewModel(
                RegistrarCharola(CharolaRepository()),
              ),
        ),
      ],
      child: MaterialApp(
        title: 'Zustento App',
        theme: ThemeData(primarySwatch: Colors.pink),
        home: const RegistrarCharolaView(),
      ),
    );
  }
}
