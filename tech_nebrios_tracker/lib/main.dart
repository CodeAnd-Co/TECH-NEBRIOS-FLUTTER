import 'package:flutter/material.dart';
import './framework/views/components/organisms/pop_up_charola.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Builder(
            builder: (context) => IconButton(
              icon: Image.asset('lib/framework/views/components/atoms/icons/X.png'),
              iconSize: 40,
              color: Colors.red,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => const PopUpCharola.prueba(),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
