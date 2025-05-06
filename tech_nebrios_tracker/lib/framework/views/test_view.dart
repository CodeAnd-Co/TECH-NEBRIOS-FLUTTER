import 'package:flutter/material.dart';
import 'package:tech_nebrios_tracker/domain/usuarioUseCases.dart';
import 'package:tech_nebrios_tracker/framework/viewmodels/loginViewmodel.dart';
import 'package:jwt_decode/jwt_decode.dart';

class TestView extends StatefulWidget {
  const TestView({super.key});

  @override
  State<TestView> createState() => _TestViewState();
}

class _TestViewState extends State<TestView> {
  final UserUseCases _userUseCases = UserUseCases();
  final LoginViewModel _loginViewModel = LoginViewModel();

  String? _usuario;
  Map<String, dynamic>? _decodedToken;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final usuario = await _userUseCases.getCurrentUser();

    if (usuario != null && usuario.isNotEmpty) {
      final decoded = Jwt.parseJwt(usuario); // o usar decodeToken si modifica más cosas

      setState(() {
        _usuario = usuario;
        _decodedToken = decoded;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _usuario == null
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Usuario cargado correctamente'),
                  if (_decodedToken != null)
                    Text('Rol: ${_decodedToken!['rol'] ?? 'No definido'}'),
                ],
              ),
      ),
    );
  }
}
