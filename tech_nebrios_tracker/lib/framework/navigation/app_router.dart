import 'package:flutter/material.dart';
import '../views/loginView.dart';
import '../views/test_view.dart';

enum AppRoute {
  login,
  test,
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
    _currentRoute = AppRoute.test;
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
          
        if (_currentRoute == AppRoute.test)
          MaterialPage(
            key: const ValueKey('TestPage'),
            child: TestView(
              //onLogout: navigateToLogin,
            ),
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