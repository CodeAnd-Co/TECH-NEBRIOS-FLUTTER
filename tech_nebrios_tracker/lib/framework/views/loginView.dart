import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/loginViewModel.dart';
import 'package:zuustento_tracker/framework/views/components/FormFields.dart';

class LoginView extends StatefulWidget {
  final VoidCallback onLogin;

  const LoginView({Key? key, required this.onLogin}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool _obscurePassword = true;
  final formKey4 = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 900,
            height: 600,
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
                              maxLength: 20,
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
                              maxLength: 20,
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
                              }
                            )
                          )
                            
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
                              child:
                                  viewModel.cargando
                                      ? const CircularProgressIndicator()
                                      : ElevatedButton(
                                        onPressed: () async {
                                          await viewModel.iniciarSesion();
                                          if (!viewModel.hasError) {
                                            widget.onLogin();
                                          } else {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  viewModel.errorMessage,
                                                ),
                                                backgroundColor: Colors.red,
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                duration: const Duration(
                                                  seconds: 2,
                                                ),
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
                    
              TextButton(
                onPressed: () {
                  mostrarPopUpRegistrarUsuario(context: context);
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.pink.shade400,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                ),
                child: const Text('¿Olvidaste tu contraseña?'),
              ),
                ]

        )
      )
    )
        )
      )
    );
  }

  void mostrarPopUpRegistrarUsuario({
    required BuildContext context
  }) {
    final loginViewModel = Provider.of<LoginViewModel>(context, listen: false);

    showDialog(
      context: context, 
      builder: (dialogContext) {
        return ChangeNotifierProvider.value(
          value: loginViewModel,
          child: Consumer<LoginViewModel>(
            builder: (context, loginViewModel, _) {
              return AlertDialog(
                title: const Text(
                  'Recuperar Contraseña',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                content: SizedBox(
                  width: 500,
                  child: Form(
                    key: formKey4,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Divider(),
                        const SizedBox(height: 8),
                        CustomTextFormField(
                          label: "Nombre de usuario", 
                          controller: loginViewModel.nombreController,
                          validator: (v) => v == null || v.isEmpty
                              ? 'Nombre de usuario obligatorio'
                              : null,
                          maxLength: 20,
                          width: 400,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Se mandará una contraseña diferente\npor correo electrónico',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Comuniquese con el administrador para\nsu nueva contraseña',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  )
                ),
                actionsAlignment: MainAxisAlignment.spaceEvenly,
                actions: [
                  loginViewModel.cargandoRegistro ? const CircularProgressIndicator() :
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        textStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        minimumSize: const Size(150, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Cancelar'),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if(formKey4.currentState!.validate()){
                          await loginViewModel.recuperarContrasena();

                          Navigator.of(context).pop();

                          ScaffoldMessenger.of(context)
                            .showSnackBar(
                              SnackBar(
                                content: Text(
                                    loginViewModel.errorMessage),
                                backgroundColor:
                                    loginViewModel.hasError
                                        ? Colors.red
                                        : Colors.green,
                              ),
                            );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        textStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        minimumSize: const Size(150, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Recuperar'),
                    ),

                  ],)
                  
                  )
                  
                ],
              );
            }
          )
        );
      }
    );
  }
}
