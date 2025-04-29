import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sole_space_user1/config/routes/app_router.dart';
import 'package:sole_space_user1/core/utils/utils.dart';
import 'package:sole_space_user1/core/widgets/custom_button.dart';
import 'package:sole_space_user1/core/widgets/custom_text_field.dart';
import 'package:sole_space_user1/features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'package:sole_space_user1/features/auth/presentation/blocs/auth/auth_event.dart';
import 'package:sole_space_user1/features/auth/presentation/blocs/auth/auth_state.dart';
import 'package:sole_space_user1/features/auth/presentation/blocs/password/password_bloc.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Handle the login process
    void handleLogin() {
      if (_formKey.currentState?.validate() ?? false) {
        context.read<AuthBloc>().add(
          SignInWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          ),
        );
      }
    }

    // Handle Google Sign-In process
    void handleGoogleSignIn() {
      context.read<AuthBloc>().add(SignInWithGoogle());
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            Navigator.pushReplacementNamed(context, AppRouter.home);
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          largeSpacing,
                          _buildWelcomeText(context),
                          smallSpacing,
                          _buildContinueText(context),
                          largeSpacing,
                          _buildEmailField(),
                          mediumSpacing,
                          BlocBuilder<PasswordBloc, PasswordState>(
                            builder: (context, state) {
                              return _buildPasswordField(state, context);
                            },
                          ),
                          smallSpacing,
                          Align(
                            alignment: Alignment.centerRight,
                            child: _buildResetButton(context),
                          ),
                          mediumSpacing,
                          BlocBuilder<AuthBloc, AuthState>(
                            builder: (context, state) {
                              return _buildSignInButton(handleLogin, state);
                            },
                          ),
                          mediumSpacing,
                          Row(
                            children: [
                              const Expanded(child: Divider()),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: _orText(context),
                              ),
                              const Expanded(child: Divider()),
                            ],
                          ),
                          mediumSpacing,
                          _buildGoogleSignInButton(handleGoogleSignIn),
                        ],
                      ),
                    ),
                  ),
                ),
                // Sign Up row at the bottom
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account?',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    _buildSignUpButton(context),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextButton _buildSignUpButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pushReplacementNamed(context, AppRouter.register);
      },
      child: const Text('Sign Up'),
    );
  }

  CustomButton _buildGoogleSignInButton(void Function() handleGoogleSignIn) {
    return CustomButton(
      text: 'Sign in with Google',
      onPressed: handleGoogleSignIn,
      variant: CustomButtonVariant.outline,
      icon: Image.asset('assets/images/google_logo.png', height: 24),
    );
  }

  Text _orText(BuildContext context) {
    return Text(
      'OR',
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }

  CustomButton _buildSignInButton(
    void Function() handleLogin,
    AuthState state,
  ) {
    return CustomButton(
      text: 'Sign In',
      onPressed: handleLogin,
      isLoading: state is AuthLoading,
    );
  }

  TextButton _buildResetButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(context, AppRouter.resetPassword);
      },
      child: const Text('Forgot Password?'),
    );
  }

  CustomTextField _buildPasswordField(
    PasswordState state,
    BuildContext context,
  ) {
    return CustomTextField(
      label: 'Password',
      hint: 'Enter your password',
      controller: _passwordController,
      obscureText: state.isPasswordVisible,
      validator: (p0) => validatePassword(p0),
      suffixIcon: IconButton(
        icon: Icon(
          state.isPasswordVisible ? Icons.visibility_off : Icons.visibility,
        ),
        onPressed: () {
          context.read<PasswordBloc>().add(
            PasswordShow(isVisible: !state.isPasswordVisible),
          );
        },
      ),
    );
  }

  CustomTextField _buildEmailField() {
    return CustomTextField(
      label: 'Email',
      hint: 'Enter your email',
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (p0) => validateEmail(p0),
    );
  }

  Text _buildContinueText(BuildContext context) {
    return Text(
      'Sign in to continue',
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      textAlign: TextAlign.center,
    );
  }

  Text _buildWelcomeText(BuildContext context) {
    return Text(
      'Welcome Back',
      style: Theme.of(
        context,
      ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    );
  }
}
