import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'framework/viewmodels/menu_charolas.viewmodel.dart';
import 'framework/views/menu_charolas.view.dart';
import 'framework/navigation/app_router.dart';
import 'framework/viewmodels/loginViewmodel.dart';

/// Punto de entrada de la aplicación.
void main() {
  runApp(
    MultiProvider(
      providers: [
        /// Proveedor global del ViewModel de charolas.
        ChangeNotifierProvider(create: (_) => CharolaVistaModelo()..cargarCharolas()),
      ],
      child: const MenuCharolas(),
    ),
  );
}

/// Clase principal que define la estructura básica de la app.
class MenuCharolas extends StatelessWidget {
  const MenuCharolas({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers:[
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
      ],
      child: MaterialApp(
        title: "Zuustento Tracker",
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
          useMaterial3: true,
        ),
        home: Router(
          routerDelegate: AppRouter(),
          backButtonDispatcher: RootBackButtonDispatcher(),
        ),
      ),
    );
  }
}