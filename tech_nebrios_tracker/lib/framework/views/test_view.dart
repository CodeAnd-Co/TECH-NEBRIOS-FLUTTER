// lib/views/test_view.dart
import 'package:flutter/material.dart';
import '../viewmodels/test_viewmodel.dart';

class TestView extends StatefulWidget {
  @override
  _TestViewState createState() => _TestViewState();
}

class _TestViewState extends State<TestView> {
  final TestViewModel viewModel = TestViewModel();
  String messageGet = 'Esperando respuesta...';
  String messagePost = 'Esperando respuesta...';
  String nombreComida = '';
  String descripcionComida = '';

  void getMessage() async {
    final result = await viewModel.fetchMessage();
    setState(() {
      messageGet = result;
    });
  }

  void sendMessage() async {
    final result = await viewModel.sendMessage(nombreComida, descripcionComida);
    setState(() {
      messagePost = result;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Prueba de API')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  messageGet,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  messagePost,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: getMessage,
                  child: const Text('Hacer petición GET'),
                ),
                const SizedBox(height: 20),
                TextField(
                  onChanged: (value) {
                    nombreComida = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'Escribe el nombre de la comida',
                    border: OutlineInputBorder(),
                  ),
                ),
                TextField(
                  onChanged: (value) {
                    descripcionComida = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'Escribe la descripcion de la comida',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: sendMessage,
                  child: const Text('Hacer petición POST'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
