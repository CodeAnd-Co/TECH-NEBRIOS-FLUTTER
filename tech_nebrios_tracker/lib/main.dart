import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
// Aquí puedes importar tus viewmodels reales cuando estén listos
// import 'framework/viewmodels/alimentacion_viewmodel.dart';

import 'framework/views/registrarCharola_view.dart'; // Asegúrate de importar bien tu pantalla

void main() {
  runApp(const NebriosApp());
}

class NebriosApp extends StatelessWidget {
  const NebriosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => 'dummy'), // temporal para evitar crash
        // Aquí irán tus ViewModels
        // ChangeNotifierProvider(create: (_) => AlimentacionViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Tech Nebrios Tracker',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          useMaterial3: true,
        ),
        // Para pruebas iniciales, colocamos directamente la pantalla
        home: const AlimentacionScreen(),

        // En producción lo cambiarás por tu router
        // home: Router(
        //   routerDelegate: AppRouter(),
        //   backButtonDispatcher: RootBackButtonDispatcher(),
        // ),
      ),
    );
  }
}
