import 'package:flutter/material.dart';
import 'package:sole_space_user1/core/utils/utils.dart';
import 'package:sole_space_user1/features/home/models/product_model.dart';

class ProductInfoSection extends StatelessWidget {
  final Product product;

  const ProductInfoSection({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.name,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        smallSpacing,
        Text(
          '\$${product.discountPrice?.toStringAsFixed(2) ?? product.price?.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        mediumSpacing,
        Text(product.description, style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}
