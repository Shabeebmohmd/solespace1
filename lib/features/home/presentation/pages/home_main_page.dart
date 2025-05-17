import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sole_space_user1/config/routes/app_router.dart';
import 'package:sole_space_user1/core/utils/navigation_utils.dart';
import 'package:sole_space_user1/features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'package:sole_space_user1/features/auth/presentation/blocs/auth/auth_state.dart';
import 'package:sole_space_user1/features/home/presentation/blocs/bottom/bottom_navigation_bloc.dart';

class HomeMainPage extends StatelessWidget {
  const HomeMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<BottomNavigationBloc>().add(TabSelected(index: 2));
    return BlocBuilder<BottomNavigationBloc, BottomNavigationState>(
      builder: (context, state) {
        return Scaffold(
          body: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is Unauthenticated) {
                Navigator.pushReplacementNamed(context, AppRouter.login);
              }
            },
            child: SafeArea(child: NavigationUtils.pages[state.selectedIndex]),
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
            onTap:
                (value) => context.read<BottomNavigationBloc>().add(
                  TabSelected(index: value),
                ),
          ),
        );
      },
    );
  }
}
