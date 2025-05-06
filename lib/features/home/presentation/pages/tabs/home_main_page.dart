import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sole_space_user1/core/utils/Navigation_utils.dart';
import 'package:sole_space_user1/features/home/presentation/blocs/bottom/bottom_navigation_bloc.dart';

class HomeMainPage extends StatelessWidget {
  HomeMainPage({super.key});

  final PageController _pageController = PageController(initialPage: 2);

  void _onPageChanged(BuildContext context, int index) {
    context.read<BottomNavigationBloc>().add(TabSelected(index: index));
  }

  void _onTabTapped(BuildContext context, int index) {
    _pageController.jumpToPage(index);
    context.read<BottomNavigationBloc>().add(TabSelected(index: index));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavigationBloc, BottomNavigationState>(
      builder: (context, state) {
        return Scaffold(
          body: PageView(
            controller: _pageController,
            onPageChanged: (index) => _onPageChanged(context, index),
            physics: const NeverScrollableScrollPhysics(),
            children: NavigationUtils.pages, // optional to disable swipe
          ),
          bottomNavigationBar: CurvedNavigationBar(
            backgroundColor: Colors.transparent,
            color: Theme.of(context).colorScheme.surface,
            buttonBackgroundColor: Colors.blue,
            height: 60,
            index: state.selectedIndex,
            animationDuration: const Duration(milliseconds: 300),
            items: const [
              Icon(Icons.shopping_bag_outlined),
              Icon(Icons.favorite_border),
              Icon(Icons.home_outlined),
              Icon(Icons.notifications_none_outlined),
              Icon(Icons.person_outline),
            ],
            onTap: (value) => _onTabTapped(context, value),
          ),
          // bottomNavigationBar: BottomNavigationBar(
          //   currentIndex: state.selectedIndex,
          //   onTap: (index) => _onTabTapped(context, index),
          //   items: const [
          //     BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Tab 0'),
          //     BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Tab 1'),
          //     BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          //     BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Tab 3'),
          //     BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Tab 4'),
          //   ],
          //   selectedItemColor: Colors.blue,
          //   unselectedItemColor: Colors.grey,
          // ),
        );
      },
    );
  }
}
