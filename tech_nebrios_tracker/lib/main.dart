import 'package:flutter/material.dart';
import 'package:tech_nebrios_tracker/framework/views/test_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tech Nebrios Tracker',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: TestView(), // aquí se carga tu vista personalizada
    );
  }
}
