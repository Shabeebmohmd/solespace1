import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sole_space_user1/config/routes/app_router.dart';
import 'package:sole_space_user1/core/utils/utils.dart';
import 'package:sole_space_user1/core/widgets/custom_app_bar.dart';
import 'package:sole_space_user1/core/widgets/custom_button.dart';
import 'package:sole_space_user1/core/widgets/custom_text_field.dart';
import 'package:sole_space_user1/core/widgets/responsive_container.dart';
import 'package:sole_space_user1/core/utils/responsive_utils.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(
          email: _emailController.text.trim(),
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                'Password reset email sent. Please check your inbox.',
              ),
              backgroundColor: Theme.of(context).colorScheme.secondary,
            ),
          );
          Navigator.pushReplacementNamed(context, AppRouter.login);
        }
      } on FirebaseAuthException catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.message ?? 'An error occurred'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(),
      body: SafeArea(
        child: ResponsiveContainer(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWideScreen = ResponsiveUtils.isWideScreen(constraints);

              return Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: ResponsiveUtils.getSpacing(
                        isWideScreen,
                        SpacingType.top,
                      ),
                    ),
                    _buildMainText(context),
                    SizedBox(
                      height: ResponsiveUtils.getSpacing(
                        isWideScreen,
                        SpacingType.titleGap,
                      ),
                    ),
                    _buildSecondaryText(context),
                    SizedBox(
                      height: ResponsiveUtils.getSpacing(
                        isWideScreen,
                        SpacingType.contentGap,
                      ),
                    ),
                    _buildEmailField(),
                    SizedBox(
                      height: ResponsiveUtils.getSpacing(
                        isWideScreen,
                        SpacingType.contentGap,
                      ),
                    ),
                    _buildResetButton(),
                    const Spacer(),
                    _buildBackToLoginButton(context),
                    SizedBox(
                      height: ResponsiveUtils.getSpacing(
                        isWideScreen,
                        SpacingType.mediumGap,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Text _buildMainText(BuildContext context) {
    return Text(
      'Reset Password',
      style: Theme.of(
        context,
      ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    );
  }

  Text _buildSecondaryText(BuildContext context) {
    return Text(
      'Enter your email address to reset your password',
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      textAlign: TextAlign.center,
    );
  }

  CustomTextField _buildEmailField() {
    return CustomTextField(
      label: 'Email',
      hint: 'Enter your email',
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) => validateEmail(value),
    );
  }

  CustomButton _buildResetButton() {
    return CustomButton(
      text: _isLoading ? 'Sending...' : 'Reset Password',
      onPressed: _isLoading ? null : _resetPassword,
      isLoading: _isLoading,
    );
  }

  TextButton _buildBackToLoginButton(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.pushReplacementNamed(context, AppRouter.login),
      child: const Text('Back to Login'),
    );
  }
}
