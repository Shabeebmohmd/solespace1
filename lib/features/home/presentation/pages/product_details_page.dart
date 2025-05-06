import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:sole_space_user1/config/theme/app_color.dart';
import 'package:sole_space_user1/core/utils/utils.dart';
import 'package:sole_space_user1/core/widgets/custom_app_bar.dart';
import 'package:sole_space_user1/core/widgets/custom_button.dart';
import 'package:sole_space_user1/features/home/models/product_model.dart';

class ProductDetailsPage extends StatelessWidget {
  final Product product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: Text(product.name)),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                product.imageUrls.isNotEmpty ? _buildImage() : _buildIcon(),
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
                _cartButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  CustomButton _cartButton() {
    return CustomButton(
      onPressed: () {
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

  CarouselSlider _buildImage() {
    return CarouselSlider(
      options: CarouselOptions(
        height: 300,
        enableInfiniteScroll: true,
        enlargeCenterPage: true,
        autoPlay: false,
        autoPlayInterval: Duration(seconds: 3),
        viewportFraction: 0.9,
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
}
