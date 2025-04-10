// lib/views/test_view.dart
import 'package:flutter/material.dart';
import '../viewmodels/test_viewmodel.dart';

class TestView extends StatefulWidget {
  @override
  _TestViewState createState() => _TestViewState();
}

class _TestViewState extends State<TestView> {
  final TestViewModel viewModel = TestViewModel();
  String message = 'Esperando respuesta...';

  void getMessage() async {
    final result = await viewModel.fetchMessage();
    setState(() {
      message = result;
    });
  }

  @override
  void initState() {
    super.initState();
    getMessage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Prueba de API')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: getMessage,
                child: const Text('Hacer petición'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
