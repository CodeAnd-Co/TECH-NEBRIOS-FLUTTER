import 'package:flutter/material.dart';
import 'package:tech_nebrios_tracker/domain/user_usecases.dart';

class LoginViewModel extends ChangeNotifier {
  final usuarioController = TextEditingController();
  final UserUseCases _userUseCases = UserUseCases();
  
  String _errorMessage = '';
  bool _hasError = false;
  
  String get errorMessage => _errorMessage;
  bool get hasError => _hasError;
  
  LoginViewModel() {
    _checkCurrentUser();
  }
  
  void _checkCurrentUser() async {
    final usuario = await _userUseCases.getCurrentUser();
    if (usuario != null && usuario.isNotEmpty) {
      usuarioController.text = usuario;
    }
  }
  
  void setCurrentUser() {
    final usuario = usuarioController.text.trim();
    
    if (usuario.isEmpty) {
      _errorMessage = 'Correo inválido';
      _hasError = true;
      notifyListeners();
      
      return;
    }
    
    _userUseCases.setCurrentUser(usuario);
    _hasError = false;
    notifyListeners();
  }
  
  @override
  void dispose() {
    usuarioController.dispose();
    super.dispose();
  }
}