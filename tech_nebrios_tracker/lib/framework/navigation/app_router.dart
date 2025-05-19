import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../views/loginView.dart';
import '../views/sidebarView.dart'; // El contenedor con el Drawer

import '../../domain/cerrarSesionUseCase.dart';
import '../../data/repositories/usuarioRepository.dart';
import '../viewmodels/loginViewModel.dart';

final localStorage = UserRepository();
final cerrarSesionUseCase = CerrarSesionUseCaseImpl(localStorage);

enum AppRoute {
  login,
  main, // nombre general para toda la app después del login
}

class AppRouter extends RouterDelegate<AppRoute>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoute> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  AppRoute _currentRoute = AppRoute.login;

  AppRouter() : navigatorKey = GlobalKey<NavigatorState>() {
    _checkInitialRoute();
  }

  AppRoute get currentRoute => _currentRoute;

  Future<void> _checkInitialRoute() async {
    // Aquí puedes verificar si ya hay un token guardado y cambiar a .main automáticamente
    // Ejemplo: if (await UserUseCases().obtenerTokenActual() != null) navigateToMain();
  }

  void navigateToMain() {
    _currentRoute = AppRoute.main;
    notifyListeners();
  }

  void navigateToLogin() {
    _currentRoute = AppRoute.login;
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        if (_currentRoute == AppRoute.login)
          MaterialPage(
            key: const ValueKey('LoginPage'),
            child: LoginView(onLogin: navigateToMain),
          ),
        if (_currentRoute == AppRoute.main)
          MaterialPage(
            key: const ValueKey('SidebarMain'),
            child: SidebarView(
              onLogout: () async {
                await cerrarSesionUseCase.call();
                Provider.of<LoginViewModel>(
                  context,
                  listen: false,
                ).limpiarCampos();
                navigateToLogin();
              },
            ),
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
