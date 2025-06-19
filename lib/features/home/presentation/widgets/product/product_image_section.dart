import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class ProductImageSection extends StatelessWidget {
  final List<String> imageUrls;
  final ValueNotifier<int> currentIndexNotifier;

  const ProductImageSection({
    super.key,
    required this.imageUrls,
    required this.currentIndexNotifier,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrls.isEmpty) {
      return const Icon(Icons.image_not_supported, size: 100);
    }

    return Column(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            // Set max width for web, use full width for mobile
            double carouselWidth =
                constraints.maxWidth > 600 ? 600 : constraints.maxWidth;
            double carouselHeight = constraints.maxWidth > 600 ? 400 : 300;

            return Center(
              child: SizedBox(
                width: carouselWidth,
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: carouselHeight,
                    enableInfiniteScroll: true,
                    enlargeCenterPage: true,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 3),
                    viewportFraction: 0.9,
                    onPageChanged:
                        (index, reason) => currentIndexNotifier.value = index,
                  ),
                  items:
                      imageUrls.map((imageUrl) {
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
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        _buildIndicators(context),
      ],
    );
  }

  Widget _buildIndicators(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: currentIndexNotifier,
      builder: (context, currentIndex, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:
              imageUrls.asMap().entries.map((entry) {
                final index = entry.key;
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 4.0,
                    vertical: 8.0,
                  ),
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
