import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/loginViewModel.dart';

class LoginView extends StatefulWidget {
  final VoidCallback onLogin;

  const LoginView({Key? key, required this.onLogin}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 900,
            height: 500,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/images/zuustento_logo.png'),
                  Consumer<LoginViewModel>(
                    builder: (context, viewModel, child) {
                      return Column(
                        children: [
                          const Text(
                            'Usuario',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: 500,
                            child: TextField(
                              controller: viewModel.usuarioController,
                              decoration: InputDecoration(
                                hintText: 'Ingresa tu nombre de usuario aquí',
                                prefixIcon: const Icon(Icons.people_alt),
                                filled: true,
                                fillColor: Colors.grey[200],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.emailAddress,
                              autocorrect: false,
                              textCapitalization: TextCapitalization.none,
                            ),
                          ),
                          const SizedBox(height: 50),
                          const Text(
                            'Contraseña',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: 500,
                            child: TextField(
                              controller: viewModel.contrasenaController,
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                hintText: 'Ingresa tu contraseña aquí',
                                prefixIcon: const Icon(Icons.lock),
                                suffixIcon: IconButton(
                                  icon: Icon(_obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                                filled: true,
                                fillColor: Colors.grey[200],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.visiblePassword,
                              textInputAction: TextInputAction.done,
                              autocorrect: false,
                              textCapitalization: TextCapitalization.none,
                              onSubmitted: (_) async {
                                await viewModel.iniciarSesion();
                                if (!viewModel.hasError) {
                                  widget.onLogin();
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(viewModel.errorMessage),
                                      backgroundColor: Colors.red,
                                      behavior: SnackBarBehavior.floating,
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 15),
                  Consumer<LoginViewModel>(
                    builder: (context, viewModel, child) {
                      return SizedBox(
                        width: 150,
                        height: 50,
                        child: Center(
                          child: viewModel.cargando
                              ? const CircularProgressIndicator()
                              : ElevatedButton(
                                  onPressed: () async {
                                    await viewModel.iniciarSesion();
                                    if (!viewModel.hasError) {
                                      widget.onLogin();
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(viewModel.errorMessage),
                                          backgroundColor: Colors.red,
                                          behavior: SnackBarBehavior.floating,
                                          duration: const Duration(seconds: 2),
                                        ),
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blueAccent,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text(
                                    'Iniciar Sesión',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
