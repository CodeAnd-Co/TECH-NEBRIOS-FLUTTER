import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/login_viewmodel.dart';

class LoginView extends StatelessWidget {
  final VoidCallback onLogin;

  const LoginView({Key? key, required this.onLogin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 900,
          height: 500,
          padding:EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
            Image.asset('assets/images/zuustento_logo.png'),
            Consumer<LoginViewModel>(builder: (context, viewModel, child) {
              return Column(
                //crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Usuario',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width:500,
                    child: TextField(
                      controller: viewModel.usuarioController,
                      decoration: InputDecoration(
                        hintText: 'Ingresa tu nombre de usuario aqui',
                        prefixIcon: Icon(Icons.people_alt),
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
                  const SizedBox(height:50),
                  const Text(
                    'Contraseña',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 500,
                    child: TextField(
                      controller: viewModel.contrasenaController,
                      decoration: InputDecoration(
                        hintText: 'Ingresa tu contraseña aqui',
                        prefixIcon: Icon(Icons.lock),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.visiblePassword,
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                    ),
                  ),
                ],
              );
            }),
            const SizedBox(height: 15),
            Consumer<LoginViewModel>(builder: (context, viewModel, child) {
              return SizedBox(
                width: 150,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    await viewModel.iniciarSesion();
                    if (!viewModel.hasError) {
                      onLogin();
                    }
                    else{
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(viewModel.errorMessage),
                          backgroundColor:Colors.red,
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
                    style: TextStyle(fontSize: 15)
                    ),
                ),
              );
            }),
            const SizedBox(height: 15),
          ],
          ),
        ),
      ),
    );
  }
}