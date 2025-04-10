import 'package:flutter/material.dart';
import 'package:sole_space_user1/config/routes/app_router.dart';

class Onboard1 extends StatelessWidget {
  const Onboard1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Image.asset(
            'assets/images/onboard1.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome to Sole Space!',
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Discover the best sneakers and streetwear in one place.',
                  style: TextStyle(fontSize: 18.0, color: Colors.white),
                ),
                const SizedBox(height: 32.0),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the next page or perform an action
                    Navigator.pushNamed(context, AppRouter.onboard2);
                  },
                  child: const Text('Next'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
