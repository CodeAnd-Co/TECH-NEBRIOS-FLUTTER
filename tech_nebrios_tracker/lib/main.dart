import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'framework/viewmodels/menu_charolas.viewmodel.dart';
import 'framework/navigation/app_router.dart';
import 'framework/viewmodels/loginViewmodel.dart';
import 'package:tech_nebrios_tracker/framework/views/historialActividadView.dart';
import './framework/viewmodels/historialActividadViewModel.dart';
import './domain/historialActividadUseCases.dart';

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
              (_) => HistorialActividadViewModel(
                HistorialActividadUseCasesImp(),
              ),
        ),
      ],
      child: MaterialApp(
        title: 'Zustento App',
        theme: ThemeData(primarySwatch: Colors.pink),
        home: const HistorialActvidadPopUp(),
      ),
    );
  }
}