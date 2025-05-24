import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sole_space_user1/core/widgets/custom_app_bar.dart';
import 'package:sole_space_user1/core/widgets/custom_button.dart';
import 'package:sole_space_user1/features/home/models/cart_model.dart';
import 'package:sole_space_user1/features/home/models/product_model.dart';
import 'package:sole_space_user1/features/home/presentation/blocs/cart/cart_bloc.dart';
import 'package:sole_space_user1/features/home/presentation/blocs/product_detail/product_details_bloc.dart';

class ProductDetailsPage extends StatelessWidget {
  final Product product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductDetailsBloc(),
      child: Scaffold(
        appBar: CustomAppBar(title: Text(product.name), showBackButton: true),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              SizedBox(
                height: 300,
                child: PageView.builder(
                  itemCount: product.imageUrls.length,
                  itemBuilder: (context, index) {
                    return Image.network(
                      product.imageUrls[index],
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) =>
                              const Icon(Icons.error, size: 100),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Name and Price
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$${product.discountPrice?.toStringAsFixed(2) ?? product.price?.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Description
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(product.description),
                    const SizedBox(height: 24),
                    // Size Selection
                    const Text(
                      'Select Size',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
                      builder: (context, state) {
                        return Wrap(
                          spacing: 8,
                          children:
                              product.sizes.map((size) {
                                return ChoiceChip(
                                  label: Text(size),
                                  selected: state.selectedSize == size,
                                  onSelected: (selected) {
                                    if (selected) {
                                      context.read<ProductDetailsBloc>().add(
                                        SelectSize(size),
                                      );
                                    }
                                  },
                                );
                              }).toList(),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    // Color Selection
                    const Text(
                      'Select Color',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
                      builder: (context, state) {
                        return Wrap(
                          spacing: 8,
                          children:
                              product.colors.map((color) {
                                return ChoiceChip(
                                  label: Text(color),
                                  selected: state.selectedColor == color,
                                  onSelected: (selected) {
                                    if (selected) {
                                      context.read<ProductDetailsBloc>().add(
                                        SelectColor(color),
                                      );
                                    }
                                  },
                                );
                              }).toList(),
                        );
                      },
                    ),
                    const SizedBox(height: 32),
                    // Add to Cart Button
                    BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
                      builder: (context, productDetailsState) {
                        return BlocBuilder<CartBloc, CartState>(
                          builder: (context, cartState) {
                            return CustomButton(
                              onPressed: () {
                                if (productDetailsState.selectedSize != null &&
                                    productDetailsState.selectedColor != null) {
                                  final cartItem = CartItem(
                                    productId: product.id!,
                                    imageUrl: product.imageUrls.first,
                                    name: product.name,
                                    price:
                                        product.discountPrice ?? product.price!,
                                    quantity: productDetailsState.quantity,
                                    size: productDetailsState.selectedSize!,
                                    color: productDetailsState.selectedColor!,
                                  );
                                  context.read<CartBloc>().add(
                                    AddToCart(cartItem),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Added to cart'),
                                    ),
                                  );
                                }
                              },
                              text: 'Add to Cart',
                              isLoading: cartState is CartLoading,
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
