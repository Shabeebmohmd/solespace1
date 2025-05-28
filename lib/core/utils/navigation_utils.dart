import 'package:sole_space_user1/features/home/presentation/pages/tabs/home_page.dart';
import 'package:sole_space_user1/features/home/presentation/pages/tabs/cart_page.dart';
import 'package:sole_space_user1/features/home/presentation/pages/tabs/favorite_page.dart';
import 'package:sole_space_user1/features/home/presentation/pages/tabs/profile_page.dart';

class NavigationUtils {
  static final pages = [
    const HomePage(),
    const CartPage(),
    const FavoritePage(),
    const ProfilePage(),
  ];
}
