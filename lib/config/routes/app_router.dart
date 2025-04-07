import 'package:flutter/material.dart';
import 'package:sole_space_user1/features/auth/presentation/pages/login_page.dart';
import 'package:sole_space_user1/features/auth/presentation/pages/register_page.dart';
import 'package:sole_space_user1/features/auth/presentation/pages/reset_password_page.dart';
import 'package:sole_space_user1/features/splash/presentation/pages/splash_page.dart';
import 'package:sole_space_user1/features/home/presentation/pages/home_page.dart';

class AppRouter {
  //auth routes
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String resetPassword = '/reset-password';
  static const String home = '/home';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      case resetPassword:
        return MaterialPageRoute(builder: (_) => const ResetPasswordPage());
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      default:
        return MaterialPageRoute(
          builder:
              (_) => Scaffold(
                body: Center(
                  child: Text('No route defined for ${settings.name}'),
                ),
              ),
        );
    }
  }
}
