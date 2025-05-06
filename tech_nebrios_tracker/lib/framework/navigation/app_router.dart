import 'package:flutter/material.dart';
import '../views/loginView.dart';
import '../views/menu_charolas.view.dart';

enum AppRoute {
  login,
  menucharolas,
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
    // Aquí podríamos verificar si el usuario ya tiene sesión
    // y establecer la ruta inicial adecuada
  }
  
  void navigateToMain() {
    _currentRoute = AppRoute.menucharolas;
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
            child: LoginView(
              onLogin: navigateToMain,
            ),
          ),
          
        if (_currentRoute == AppRoute.menucharolas)
          MaterialPage(
            key: const ValueKey('MenuCharolas'),
            child: const VistaCharolas(),
          ),
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }
        return true;
      },
    );
  }
  
  @override
  Future<void> setNewRoutePath(AppRoute configuration) async {
    _currentRoute = configuration;
    return;
  }
}