import 'package:flutter/material.dart';
import 'package:sole_space_user1/features/auth/presentation/pages/login_page.dart';
import 'package:sole_space_user1/features/auth/presentation/pages/register_page.dart';
import 'package:sole_space_user1/features/auth/presentation/pages/reset_password_page.dart';
import 'package:sole_space_user1/features/home/models/product_model.dart';
import 'package:sole_space_user1/features/home/presentation/pages/tabs/cart_page.dart';
import 'package:sole_space_user1/features/home/presentation/pages/tabs/favorite_page.dart';
import 'package:sole_space_user1/features/home/presentation/pages/tabs/notification_page.dart';
import 'package:sole_space_user1/features/home/presentation/pages/product_details_page.dart';
import 'package:sole_space_user1/features/home/presentation/pages/tabs/profile_page.dart';
import 'package:sole_space_user1/features/splash/presentation/pages/splash_page.dart';
import 'package:sole_space_user1/features/home/presentation/pages/home_page.dart';

class AppRouter {
  //auth routes
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String resetPassword = '/reset-password';

  static const String home = '/home';
  static const String cart = '/cart';
  static const String favorite = '/favorite';
  static const String notification = '/notification';
  static const String profile = '/profile';
  static const String productDetails = '/product-details';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case login:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case register:
        return MaterialPageRoute(builder: (_) => RegisterPage());
      case resetPassword:
        return MaterialPageRoute(builder: (_) => const ResetPasswordPage());
      case home:
        return MaterialPageRoute(builder: (_) => HomePage());
      case cart:
        return MaterialPageRoute(builder: (_) => CartPage());
      case favorite:
        return MaterialPageRoute(builder: (_) => FavoritePage());
      case notification:
        return MaterialPageRoute(builder: (_) => NotificationPage());
      case profile:
        return MaterialPageRoute(builder: (_) => ProfilePage());
      case productDetails:
        final product = settings.arguments as Product;
        return MaterialPageRoute(
          builder: (_) => ProductDetailsPage(product: product),
        );
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
