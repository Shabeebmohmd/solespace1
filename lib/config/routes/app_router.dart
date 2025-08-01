import 'package:flutter/material.dart';
import 'package:sole_space_user1/features/auth/data/model/user_model.dart';
import 'package:sole_space_user1/features/auth/presentation/pages/login_page.dart';
import 'package:sole_space_user1/features/auth/presentation/pages/register_page.dart';
import 'package:sole_space_user1/features/auth/presentation/pages/reset_password_page.dart';
import 'package:sole_space_user1/features/checkout/data/model/address_model.dart';
import 'package:sole_space_user1/features/checkout/presentation/pages/add_address_page.dart';
import 'package:sole_space_user1/features/checkout/presentation/pages/address_list_page.dart';
import 'package:sole_space_user1/features/checkout/presentation/pages/chekout_page.dart';
import 'package:sole_space_user1/features/checkout/presentation/pages/confirmation_page.dart';
import 'package:sole_space_user1/features/checkout/presentation/pages/edit_address_page.dart';
import 'package:sole_space_user1/features/home/models/product_model.dart';
import 'package:sole_space_user1/features/home/presentation/pages/product%20related/category_based_product.dart';
import 'package:sole_space_user1/features/home/presentation/pages/product%20related/product_details_page.dart';
import 'package:sole_space_user1/features/home/presentation/pages/profile/edit_profile_page.dart';
import 'package:sole_space_user1/features/home/presentation/pages/settings/settings.dart';
import 'package:sole_space_user1/features/home/presentation/pages/tabs/cart_page.dart';
import 'package:sole_space_user1/features/home/presentation/pages/tabs/favorite_page.dart';
import 'package:sole_space_user1/features/home/presentation/pages/home_main_page.dart';
import 'package:sole_space_user1/features/home/presentation/pages/product%20related/brand_based_product_list.dart';
import 'package:sole_space_user1/features/home/presentation/pages/tabs/profile_page.dart';
import 'package:sole_space_user1/features/home/presentation/pages/product%20related/see_all_product.dart';
import 'package:sole_space_user1/features/home/presentation/widgets/home/home_search_bar.dart';
import 'package:sole_space_user1/features/orders/model/order_model.dart';
import 'package:sole_space_user1/features/orders/presentation/pages/order_details_page.dart';
import 'package:sole_space_user1/features/orders/presentation/pages/orders_page.dart';
import 'package:sole_space_user1/features/splash/presentation/pages/splash_page.dart';
import 'package:sole_space_user1/features/home/presentation/pages/tabs/home_page.dart';

class AppRouter {
  //auth routes
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String resetPassword = '/reset-password';

  // home tabs
  static const String home = '/home';
  static const String homeMain = '/home-Main';
  static const String cart = '/cart';
  static const String favorite = '/favorite';
  static const String profile = '/profile';

  //product related pages
  static const String productDetails = '/product-details';
  static const String seeAllProducts = '/see-all-products';
  static const String brandBasedProducts = '/brand-based-products';
  static const String categoryBasedProducts = '/category-based-products';
  static const String searchProducts = '/search-products';

  // checkout related pages
  static const String checkOut = '/checkout';
  static const String address = '/address';
  static const String addressList = '/address-list';
  static const String confirmation = '/confirmation';
  static const String editAddress = '/edit-address';

  // user edit page
  static const String editUser = '/edit-user';

  // settings page
  static const String settingsPage = '/settings-page';
  static const String orderPage = '/order-page';
  static const String orderDetailsPage = '/order-details-page';

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
      case homeMain:
        return MaterialPageRoute(builder: (_) => HomeMainPage());
      case cart:
        return MaterialPageRoute(builder: (_) => const CartPage());
      case checkOut:
        return MaterialPageRoute(builder: (_) => CheckoutPage());
      case confirmation:
        return MaterialPageRoute(builder: (_) => ConfirmationPage());
      case address:
        return MaterialPageRoute(builder: (_) => const AddAddressPage());
      case addressList:
        return MaterialPageRoute(builder: (_) => AddressListPage());
      case editAddress:
        final addressModel = settings.arguments as AddressModel;
        return MaterialPageRoute(
          builder: (_) => EditAddressPage(addressModel: addressModel),
        );
      case favorite:
        return MaterialPageRoute(builder: (_) => const FavoritePage());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfilePage());
      case productDetails:
        final product = settings.arguments as Product;
        return MaterialPageRoute(
          builder: (_) => ProductDetailsPage(product: product),
        );
      case brandBasedProducts:
        return MaterialPageRoute(
          builder: (_) => BrandBasedProductListPage(),
          settings: settings,
        );
      case categoryBasedProducts:
        return MaterialPageRoute(
          builder: (_) => CategoryBasedProductListPage(),
          settings: settings,
        );
      case seeAllProducts:
        return MaterialPageRoute(builder: (_) => SeeAllProductPage());
      case searchProducts:
        return MaterialPageRoute(builder: (_) => HomeSearchBar());
      case editUser:
        final user = settings.arguments as UserModel;
        return MaterialPageRoute(builder: (_) => EditProfilePage(user: user));
      case settingsPage:
        return MaterialPageRoute(builder: (_) => SettingsPage());
      case orderPage:
        return MaterialPageRoute(builder: (_) => OrdersPage());
      case orderDetailsPage:
        final order = settings.arguments as Order;
        return MaterialPageRoute(
          builder: (_) => OrderDetailsPage(order: order),
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
