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

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Handle the registration process
    void handleRegister() async {
      if (_formKey.currentState?.validate() ?? false) {
        context.read<AuthBloc>().add(
          RegisterWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text,
            name: _nameController.text.trim(),
          ),
        );
      }
    }

    return Scaffold(
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
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    // padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          largeSpacing,
                          _buildMainText(context),
                          smallSpacing,
                          _buildSecondaryText(context),
                          largeSpacing,
                          _buildNameField(),
                          mediumSpacing,
                          _buildEmailField(),
                          mediumSpacing,
                          BlocBuilder<PasswordBloc, PasswordState>(
                            builder: (context, state) {
                              return _buildPasswordField(state, context);
                            },
                          ),
                          mediumSpacing,
                          BlocBuilder<PasswordBloc, PasswordState>(
                            builder: (context, state) {
                              return _buildConfirmPassField(state, context);
                            },
                          ),
                          extraMediumSpacing,
                          BlocBuilder<AuthBloc, AuthState>(
                            builder: (context, state) {
                              return _buildCreateButton(handleRegister, state);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    _buildSingInButton(context),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  CustomTextField _buildNameField() {
    return CustomTextField(
      label: 'Name',
      hint: 'Enter your name',
      controller: _nameController,
      keyboardType: TextInputType.name,
    );
  }

  TextButton _buildSingInButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pushReplacementNamed(context, AppRouter.login);
      },
      child: const Text('Sign In'),
    );
  }

  CustomButton _buildCreateButton(
    void Function() handleRegister,
    AuthState state,
  ) {
    return CustomButton(
      text: 'Create Account',
      onPressed: handleRegister,
      isLoading: state is AuthLoading,
    );
  }

  CustomTextField _buildConfirmPassField(
    PasswordState state,
    BuildContext context,
  ) {
    return CustomTextField(
      label: 'Confirm Password',
      hint: 'Confirm your password',
      controller: _confirmPasswordController,
      obscureText: state.isPasswordVisible,
      validator:
          (p0) => validateConfirmPassword(p0, _confirmPasswordController.text),
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

  Text _buildSecondaryText(BuildContext context) {
    return Text(
      'Create an account to get started',
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      textAlign: TextAlign.center,
    );
  }

  Text _buildMainText(BuildContext context) {
    return Text(
      'Join Sole Space',
      style: Theme.of(
        context,
      ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    );
  }
}
