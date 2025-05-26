import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sole_space_user1/config/routes/app_router.dart';
import 'package:sole_space_user1/core/widgets/custom_button.dart';

class ConfirmationPage extends StatelessWidget {
  const ConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/lottie/confirmation.json',
                width: 200,
                height: 200,
                fit: BoxFit.contain,
                repeat: false,
              ),
              const SizedBox(height: 20),
              const Text(
                'Thank you for your order!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Your order has been successfully placed.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              CustomButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRouter.homeMain,
                    (route) => false,
                  );
                },
                text: 'Back to Home',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
