import 'package:flutter/material.dart';
import 'package:sole_space_user1/features/auth/presentation/pages/login_page.dart';
import 'package:sole_space_user1/features/auth/presentation/pages/register_page.dart';
import 'package:sole_space_user1/features/auth/presentation/pages/reset_password_page.dart';
import 'package:sole_space_user1/features/splash/presentation/pages/splash_page.dart';
import 'package:sole_space_user1/features/home/presentation/pages/home_page.dart';
import 'package:sole_space_user1/features/onboard/presentation/pages/onboard1.dart';
import 'package:sole_space_user1/features/onboard/presentation/pages/onboard2.dart';
import 'package:sole_space_user1/features/onboard/presentation/pages/onboard3.dart';

class AppRouter {
  //auth routes
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String resetPassword = '/reset-password';

  //onboarding routes
  static const String onboard1 = '/onboard1';
  static const String onboard2 = '/onboard2';
  static const String onboard3 = '/onboard3';

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
      case onboard1:
        return MaterialPageRoute(builder: (_) => const Onboard1());
      case onboard2:
        return MaterialPageRoute(builder: (_) => const Onboard2());
      case onboard3:
        return MaterialPageRoute(builder: (_) => const Onboard3());
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
