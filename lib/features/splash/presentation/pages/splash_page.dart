import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sole_space_user1/config/routes/app_router.dart';
import 'package:sole_space_user1/config/theme/app_color.dart';
import 'package:sole_space_user1/features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'package:sole_space_user1/features/auth/presentation/blocs/auth/auth_event.dart';
// import 'package:sole_space_user1/features/auth/presentation/bloc/auth_event.dart';
import 'package:sole_space_user1/features/auth/presentation/blocs/auth/auth_state.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  bool _splashFinished = false;
  AuthState? _pendingAuthState;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();

    // Start splash timer
    Future.delayed(const Duration(seconds: 3), () {
      _splashFinished = true;
      _tryNavigate();
    });

    // Start auth check
    context.read<AuthBloc>().add(CheckAuthStatus());
  }

  void _tryNavigate() {
    if (_navigated) return;
    if (_splashFinished && _pendingAuthState != null) {
      _navigated = true;
      final state = _pendingAuthState!;
      if (state is Authenticated) {
        log('Navigating to home');
        Navigator.pushReplacementNamed(context, AppRouter.homeMain);
      } else if (state is Unauthenticated) {
        log('Navigating to login');
        Navigator.pushReplacementNamed(context, AppRouter.login);
      } else if (state is AuthError) {
        log('Auth error: ${state.message}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.message),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        Navigator.pushReplacementNamed(context, AppRouter.login);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        log('SplashPage received state: $state');
        if (state is Authenticated ||
            state is Unauthenticated ||
            state is AuthError) {
          _pendingAuthState = state;
          _tryNavigate();
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Center(
            child: FadeTransition(
              opacity: _animation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/icon/icon.png', width: 300, height: 300),
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
          ),
        );
      },
    );
  }
}
