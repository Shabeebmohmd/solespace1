import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sole_space_user1/config/theme/app_color.dart';
import 'package:sole_space_user1/core/utils/snack_bar_utils.dart';
import 'package:sole_space_user1/core/utils/utils.dart';
import 'package:sole_space_user1/core/widgets/custom_app_bar.dart';
import 'package:sole_space_user1/core/widgets/custom_button.dart';
import 'package:sole_space_user1/features/home/models/cart_model.dart';
import 'package:sole_space_user1/features/home/models/product_model.dart';
import 'package:sole_space_user1/features/home/presentation/blocs/cart/cart_bloc.dart';

class ProductDetailsPage extends StatelessWidget {
  final Product product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final currentIndexNotifier = ValueNotifier<int>(0);
    return Scaffold(
      appBar: CustomAppBar(title: Text(product.name)),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                product.imageUrls.isNotEmpty
                    ? Column(
                      children: [
                        _buildImage(currentIndexNotifier),
                        mediumSpacing,
                        _buildIndicators(currentIndexNotifier),
                      ],
                    )
                    : _buildIcon(),
                mediumSpacing,
                _productName(),
                smallSpacing,
                _productPrice(),
                mediumSpacing,
                _productDescription(),
                mediumSpacing,
                _availableText(),
                smallSpacing,
                _buildSizes(context),
                mediumSpacing,
                _colorText(),
                smallSpacing,
                _buildColors(),
                mediumSpacing,
                _cartButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  CustomButton _cartButton(BuildContext context) {
    return CustomButton(
      onPressed: () {
        final cartItem = CartItem(
          productId: product.id!,
          imageUrl: product.imageUrls.isNotEmpty ? product.imageUrls[0] : '',
          name: product.name,
          price: product.price!,
          quantity: 1,
        );
        context.read<CartBloc>().add(AddToCart(cartItem));
        SnackbarUtils.showSnackbar(
          context: context,
          message: '${product.name} added to cart!',
        );
        // Add to cart or other action
      },
      text: 'Add to Cart',
    );
  }

  Wrap _buildColors() {
    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children:
          product.colors
              .map(
                (color) => Chip(
                  label: Text(color),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  backgroundColor: AppColors.smallTexts,
                ),
              )
              .toList(),
    );
  }

  Text _colorText() {
    return Text(
      'Available Colors:',
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  Wrap _buildSizes(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children:
          product.sizes
              .map(
                (size) => Chip(
                  label: Text(
                    size,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  backgroundColor:
                      Theme.of(context).colorScheme.secondaryContainer,
                ),
              )
              .toList(),
    );
  }

  Text _availableText() {
    return Text(
      'Available Sizes:',
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  Text _productDescription() =>
      Text(product.description, style: const TextStyle(fontSize: 16));

  Text _productPrice() {
    return Text(
      '\$${product.price!.toStringAsFixed(2)}',
      style: const TextStyle(
        fontSize: 20,
        color: Colors.green,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Text _productName() {
    return Text(
      product.name,
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }

  Icon _buildIcon() => const Icon(Icons.image_not_supported, size: 100);

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

  // New method to build carousel indicators
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
}
