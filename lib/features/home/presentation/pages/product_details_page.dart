import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sole_space_user1/core/utils/utils.dart';
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
    final currentIndexNotifier = ValueNotifier<int>(0);
    return BlocProvider(
      create: (context) => ProductDetailsBloc(),
      child: Scaffold(
        appBar: CustomAppBar(title: Text(product.name), showBackButton: true),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              product.imageUrls.isNotEmpty
                  ? Column(
                    children: [
                      _buildImage(currentIndexNotifier),
                      mediumSpacing,
                      _buildIndicators(currentIndexNotifier),
                    ],
                  )
                  : _buildIcon(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Name and Price
                    _productName(),
                    smallSpacing,
                    _productPrice(),
                    mediumSpacing,
                    // Description
                    Text(product.description),
                    extraMediumSpacing,
                    // Size Selection
                    const Text(
                      'Select Size',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    smallSpacing,
                    BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
                      builder: (context, state) {
                        return _sizeChips(state, context);
                      },
                    ),
                    extraMediumSpacing,
                    // Color Selection
                    const Text(
                      'Select Color',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    smallSpacing,
                    BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
                      builder: (context, state) {
                        return _colorChips(state, context);
                      },
                    ),
                    extraMediumSpacing,
                    // Add to Cart Button
                    BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
                      builder: (context, productDetailsState) {
                        return BlocBuilder<CartBloc, CartState>(
                          builder: (context, cartState) {
                            return _cartButton(
                              productDetailsState,
                              context,
                              cartState,
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

  CustomButton _cartButton(
    ProductDetailsState productDetailsState,
    BuildContext context,
    CartState cartState,
  ) {
    return CustomButton(
      onPressed: () {
        if (productDetailsState.selectedSize != null &&
            productDetailsState.selectedColor != null) {
          final cartItem = CartItem(
            productId: product.id!,
            imageUrl: product.imageUrls.first,
            name: product.name,
            price: product.discountPrice ?? product.price!,
            quantity: productDetailsState.quantity,
            size: productDetailsState.selectedSize!,
            color: productDetailsState.selectedColor!,
          );
          context.read<CartBloc>().add(AddToCart(cartItem));
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Added to cart')));
        }
      },
      text: 'Add to Cart',
      isLoading: cartState is CartLoading,
    );
  }

  Wrap _colorChips(ProductDetailsState state, BuildContext context) {
    return Wrap(
      spacing: 8,
      children:
          product.colors.map((color) {
            return ChoiceChip(
              label: Text(color),
              selected: state.selectedColor == color,
              selectedColor: Theme.of(context).colorScheme.secondary,
              materialTapTargetSize:
                  MaterialTapTargetSize.padded, // Makes the chip larger
              visualDensity: VisualDensity.compact, // Adjusts the density
              labelStyle: const TextStyle(
                fontSize: 16,
              ), // Increases label font size
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              onSelected: (selected) {
                if (selected) {
                  context.read<ProductDetailsBloc>().add(SelectColor(color));
                }
              },
            );
          }).toList(),
    );
  }

  Wrap _sizeChips(ProductDetailsState state, BuildContext context) {
    return Wrap(
      spacing: 8,
      children:
          product.sizes.map((size) {
            return ChoiceChip(
              label: Text(size),
              selected: state.selectedSize == size,
              selectedColor: Theme.of(context).colorScheme.surfaceTint,
              materialTapTargetSize:
                  MaterialTapTargetSize.padded, // Makes the chip larger
              visualDensity: VisualDensity.compact, // Adjusts the density
              labelStyle: const TextStyle(
                fontSize: 16,
              ), // Increases label font size
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ), // Increases chip padding
              onSelected: (selected) {
                if (selected) {
                  context.read<ProductDetailsBloc>().add(SelectSize(size));
                }
              },
            );
          }).toList(),
    );
  }

  Text _productPrice() {
    return Text(
      '\$${product.discountPrice?.toStringAsFixed(2) ?? product.price?.toStringAsFixed(2)}',
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.green,
      ),
    );
  }

  Text _productName() {
    return Text(
      product.name,
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }

  CarouselSlider _buildImage(ValueNotifier<int> currentIndexNotifier) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 300,
        enableInfiniteScroll: true,
        enlargeCenterPage: true,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 3),
        viewportFraction: 0.9,
        onPageChanged: (index, reason) => currentIndexNotifier.value = index,
      ),
      items:
          product.imageUrls.map((imageUrl) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) =>
                        const Icon(Icons.broken_image, size: 100),
              ),
            );
          }).toList(),
    );
  }

  Widget _buildIndicators(ValueNotifier<int> currentIndexNotifier) {
    return ValueListenableBuilder<int>(
      valueListenable: currentIndexNotifier,
      builder: (context, currentIndex, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:
              product.imageUrls.asMap().entries.map((entry) {
                final index = entry.key;
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        currentIndex == index
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurface,
                  ),
                );
              }).toList(),
        );
      },
    );
  }

  Icon _buildIcon() => const Icon(Icons.image_not_supported, size: 100);
}
