import 'package:flutter/material.dart';
import 'package:sole_space_user1/features/home/models/product_model.dart';

class FavoriteProductItem extends StatelessWidget {
  final Product product;

  const FavoriteProductItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading:
          product.imageUrls.isNotEmpty
              ? Image.network(product.imageUrls[0], width: 50)
              : const Icon(Icons.image_not_supported),
      title: Text(product.name),
      subtitle: Text('\$${product.price!.toStringAsFixed(2)}'),
    );
  }
}
