//validations

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sole_space_user1/config/routes/app_router.dart';
import 'package:sole_space_user1/features/home/presentation/blocs/brand/brand_bloc.dart';
import 'package:sole_space_user1/features/home/presentation/blocs/cart/cart_bloc.dart';
import 'package:sole_space_user1/features/home/presentation/blocs/category/category_bloc.dart';
import 'package:sole_space_user1/features/home/presentation/blocs/product/product_bloc.dart';

String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your email';
  }
  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
  if (!emailRegex.hasMatch(value)) {
    return 'Please enter a valid email';
  }
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your password';
  }
  if (value.length < 6) {
    return 'Password must be at least 6 characters';
  }
  return null;
}

String? validateConfirmPassword(String? value, String text) {
  if (value == null || value.isEmpty) {
    return 'Please confirm your password';
  }
  if (value != text) {
    return 'Passwords do not match';
  }
  return null;
}

Future<void> showCustomAlertDialog({
  required BuildContext context,
  required String title,
  required String content,
  required VoidCallback onConfirm,
  String confirmText = 'OK',
  String cancelText = 'Cancel',
}) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () {
              onConfirm();
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text(confirmText),
          ),
        ],
      );
    },
  );
}

// Global SizedBox widgets
const SizedBox smallSpacing = SizedBox(height: 8);
const SizedBox mediumSpacing = SizedBox(height: 16);
const SizedBox extraMediumSpacing = SizedBox(height: 32);
const SizedBox largeSpacing = SizedBox(height: 48);

const List<String> routes = [
  AppRouter.cart, // Index 0
  AppRouter.favorite, // Index 1
  AppRouter.home, // Index 2
  AppRouter.notification, // Index 3
  AppRouter.profile, // Index 4
];

void refresh(BuildContext context) {
  context.read<ProductBloc>().add(FetchProducts());
  context.read<BrandBloc>().add(FetchBrands());
  context.read<CategoryBloc>().add(FetchCategory());
}

void refreshCart(BuildContext context) {
  context.read<CartBloc>().add(LoadCart());
}
