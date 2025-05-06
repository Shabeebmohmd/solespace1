import 'package:flutter/material.dart';
import 'package:sole_space_user1/features/home/presentation/pages/home_main_page.dart';
import 'package:sole_space_user1/features/home/presentation/pages/home_page.dart';
import 'package:sole_space_user1/features/home/presentation/pages/tabs/favorite_page.dart';
import 'package:sole_space_user1/features/home/presentation/pages/tabs/notification_page.dart';
import 'package:sole_space_user1/features/home/presentation/pages/tabs/profile_page.dart';

class NavigationUtils {
  static final List<Widget> pages = [
    const HomePage(), // Tab 0
    const FavoritePage(), // Tab 1
    HomeMainPage(), // Tab 2 (main home screen)
    const NotificationPage(), // Tab 3
    const ProfilePage(), // Tab 4
  ];
}
