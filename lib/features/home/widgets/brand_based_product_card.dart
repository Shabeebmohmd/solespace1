import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sole_space_user1/features/home/models/product_model.dart';
import 'package:sole_space_user1/features/home/presentation/blocs/product/product_bloc.dart';

class BrandBasedProductCard extends StatelessWidget {
  final Product product;
  const BrandBasedProductCard({super.key, required this.product});
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading:
            product.imageUrls[0].isNotEmpty
                ? Image.network(
                  product.imageUrls[0],
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                )
                : const Icon(Icons.image_not_supported, size: 50),
        title: Text(
          product.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Price: ${product.discountPrice}'),
        trailing: IconButton(
          icon: Icon(
            context.read<ProductBloc>().state is ProductLoaded &&
                    (context.read<ProductBloc>().state as ProductLoaded)
                        .favorites
                        .any((p) => p.id == product.id)
                ? Icons.favorite
                : Icons.favorite_border,
            color: Colors.red,
          ),
          onPressed: () {
            context.read<ProductBloc>().add(ToggleFavorite(product: product));
          },
        ),
      ),
    );
  }
}
