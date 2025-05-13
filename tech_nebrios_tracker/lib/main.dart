import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'framework/viewmodels/tamizarCharolaViewmodel.dart';
import 'framework/viewmodels/menuCharolasViewmodel.dart';
import 'framework/navigation/app_router.dart';
import 'framework/viewmodels/loginViewmodel.dart';
import 'framework/views/seleccionarTamizadoView.dart';
/// Punto de entrada de la aplicación.
void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

@override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers:[
        ChangeNotifierProvider(create: (_) => CharolaVistaModelo()),
        ChangeNotifierProvider(create: (_) => TamizadoViewModel()),
      ],
      child: MaterialApp(
        title: "Tamizar",
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
          useMaterial3: true,
        ),
        home: const VistaSeleccionarTamizado(),
      ),
    );
  }
}
/*void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => CharolaVistaModelo()),
        ChangeNotifierProvider(create: (_) => TamizadoViewModel()),
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
}*/