import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'framework/navigation/app_router.dart';
import 'framework/viewmodels/login_viewmodel.dart';
import 'framework/views/login_view.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

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
