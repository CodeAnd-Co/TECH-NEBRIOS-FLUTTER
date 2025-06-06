import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../views/loginView.dart';
import '../views/sidebarView.dart';
import '../viewmodels/loginViewModel.dart';
import '../../domain/cerrarSesionUseCase.dart';
import '../../data/repositories/usuarioRepository.dart';

enum AppRoute { login, main }

class AppRouter extends RouterDelegate<AppRoute>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoute> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  AppRoute _currentRoute = AppRoute.login;

  final cerrarSesionUseCase = CerrarSesionUseCaseImpl(UserRepository());

  AppRouter() : navigatorKey = GlobalKey<NavigatorState>() {
    _checkInitialRoute();
  }

  AppRoute get currentConfiguration => _currentRoute;

  Future<void> _checkInitialRoute() async {
    // Si ya hay token: navigateToMain();
  }

  void navigateToMain() {
    _currentRoute = AppRoute.main;
    notifyListeners();
  }

  void navigateToLogin() {
    _currentRoute = AppRoute.login;
    notifyListeners();
  }

  /// Popup de confirmación con el mismo estilo que tu AlertDialog de “Editar Alimento”
  void _confirmLogout() {
    final ctx = navigatorKey.currentContext!;
    showDialog(
      context: ctx,
      builder: (dialogCtx) {
        return AlertDialog(
          title: const Center(
            child: Text(
              'Cerrar sesión',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Divider(height: 1),
                SizedBox(height: 30),
                Text(
                  '¿Estás seguro de que deseas cerrar sesión?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Botón Cancelar
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      minimumSize: const Size(150, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: () => Navigator.of(dialogCtx).pop(),
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                  const SizedBox(width: 20),
                  // Botón Confirmar
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: const Size(150, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: () async {
                      Navigator.of(dialogCtx).pop(); // cierra el diálogo
                      await cerrarSesionUseCase.call();
                      Provider.of<LoginViewModel>(ctx, listen: false)
                          .limpiarCampos();
                      navigateToLogin();
                    },
                    child: const Text(
                      'Cerrar sesión',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        if (_currentRoute == AppRoute.login)
          MaterialPage(
            key: const ValueKey('LoginPage'),
            child: ChangeNotifierProvider(
              create: (_) => LoginViewModel(),
              child: LoginView(onLogin: navigateToMain),
            ),
          ),
        if (_currentRoute == AppRoute.main)
          MaterialPage(
            key: const ValueKey('MainSidebar'),
            child: SidebarView(onLogout: _confirmLogout),
          ),
      ],
      onPopPage: (route, result) => route.didPop(result),
    );
  }

  @override
  Future<void> setNewRoutePath(AppRoute configuration) async {
    _currentRoute = configuration;
  }
}
