import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sole_space_user1/config/routes/app_router.dart';
import 'package:sole_space_user1/config/theme/app_color.dart';
import 'package:sole_space_user1/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sole_space_user1/features/auth/presentation/bloc/auth_event.dart';
import 'package:sole_space_user1/features/auth/presentation/bloc/auth_state.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        print('SplashPage received state: $state');
        if (state is Authenticated) {
          print('Navigating to home');
          Navigator.pushReplacementNamed(context, AppRouter.home);
        } else if (state is Unauthenticated) {
          print('Navigating to login');
          Navigator.pushReplacementNamed(context, AppRouter.login);
        } else if (state is AuthError) {
          print('Auth error: ${state.message}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
          Navigator.pushReplacementNamed(context, AppRouter.login);
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/images/logo.svg',
                  width: 300,
                  height: 300,
                ),
                const SizedBox(height: 24),
                Text(
                  'Sole Space',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                if (state is AuthLoading)
                  const CircularProgressIndicator()
                else if (state is AuthError)
                  Text(
                    'Error: ${state.message}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
